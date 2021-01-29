local garagePos = vector3(994.5925, -3002.594, -39.64699)
local garageLeavePos = vector3(994.5925, -3002.594, -39.64699)
local oldPlayerPos = vector3(0.0, 0.0, 0.0)
local oldPlayerHeading = 100.0
local garageIpl = "imp_impexp_interior_placement_interior_1_impexp_intwaremed_milo_"
local garageType = {
    {
        label = "basic",
        set = "basic_style_set",
    }
}
local garageIntId = 252673
local loadedVehs = {}
local possibleVehiclePos = {
    vector4(986.53436279297, -2994.7592773438, -40.180736541748, 180.57884216309),
    vector4(990.27337646484, -2994.6000976562, -40.1806640625, 179.7218170166),
    vector4(993.82098388672, -2994.654296875, -40.180881500244, 180.34567260742),
    vector4(998.06579589844, -2994.4748535156, -40.18074798584, 179.83241271973),
    vector4(1002.4139404297, -2994.9313964844, -40.180877685547, 180.80435180664),
    vector4(984.39544677734, -3008.8666992188, -40.180866241455, 0.2387777119875),
    vector4(988.12677001953, -3009.0581054688, -40.180835723877, 359.3486328125),
    vector4(991.70318603516, -3009.0034179688, -40.180828094482, 2.252685546875),
    vector4(994.96527099609, -3009.115234375, -40.180698394775, 1.3043919801712),
    vector4(999.48272705078, -3008.9880371094, -40.180740356445, 358.78091430664),
    vector4(978.18792724609, -3009.3693847656, -39.824279785156, 1.6103336811066),
    vector4(978.04455566406, -2994.4460449219, -39.824951171875, 176.74298095703),
    vector4(956.02215576172, -3018.4799804688, -39.824211120605, 270.47592163086),
    vector4(956.2919921875, -3023.5727539062, -39.825080871582, 268.72515869141),
    vector4(956.61688232422, -3028.7248535156, -39.824531555176, 268.62292480469),
    vector4(959.37365722656, -3033.8525390625, -39.824836730957, 358.74801635742),
    vector4(963.36785888672, -3034.2321777344, -39.824630737305, 358.33154296875),
    vector4(967.66955566406, -3033.9787597656, -39.824829101562, 0.94597911834717),
    vector4(971.71612548828, -3034.9597167969, -39.824573516846, 0.95339286327362),
    vector4(993.27825927734, -3025.5119628906, -39.824546813965, 359.68673706055),
    vector4(998.50646972656, -3025.7192382812, -39.8244972229, 0.96935778856277),
    vector4(1003.8359375, -3025.6508789062, -39.824810028076, 0.35601550340652),
    vector4(1009.2272949219, -3025.7185058594, -39.824771881104, 1.5316141843796),
    vector4(973.25988769531, -3006.7116699219, -39.824779510498, 302.6591796875),
    vector4(972.98608398438, -3002.0825195312, -39.825004577637, 271.38256835938),
    vector4(973.37091064453, -2998.5563964844, -39.824424743652, 234.14663696289),
}

function JoinGarage()
    if p:IsInGarage() then
        LeaveGarage()
        return
    end
    if p:isInVeh() then
        DeleteEntity(p:currentVeh())
    end
    TriggerServerEvent("drift:ChangeServerInstance", GetPlayerServerId(p:index())) 
    RequestIpl(garageIpl)
    while not IsIplActive(garageIpl) do ShowLoadingMessageTimed(150, "Loading garage ...", 1) Wait(1) end
    DisableInteriorProp(garageIntId, "basic_style_set")
    EnableInteriorProp(garageIntId, "branded_style_set")
    RefreshInterior(garageIntId)
    p:setInGarage(true)
    --p:SetMap("garage")
    oldPlayerPos = p:pos()
    oldPlayerHeading = p:heading()
    p:Teleport(garagePos)
    InitGarageFunction()
    TriggerEvent("InteractSound_CL:PlayOnOne", "garage", 0.05)
end

function LeaveGarage(veh, tp)
    TriggerServerEvent("drift:ChangeServerInstance", 1) 
    p:setInGarage(false)
    
    for k,v in pairs(loadedVehs) do
        DeleteEntity(v.entity:getEntityId())
    end
    loadedVehs = {}

    TriggerEvent("InteractSound_CL:Stop")
    if tp ~= false then
        p:Teleport(oldPlayerPos)
    end
    --p:SetMap("LS")

    if veh ~= nil and veh ~= false then
        local nameToSpawn = veh.model
        local pVeh = p:GetCars()
        for k,v in pairs(pVeh) do
            if nameToSpawn == v.model then
                local veh = entity:CreateVehicle(v.model, p:pos(), p:heading())
                SetVehProps(veh:getEntityId(), v.props)
                lastSpawned = veh:getNetId()
                TaskWarpPedIntoVehicle(p:ped(), veh:getEntityId(), -1)
            end
        end
    end
    ResetMulti(0.1)
end

local function LoadCarsinGarage()
    local pVeh = p:GetCars()
    for k,v in pairs(pVeh) do
        if possibleVehiclePos[k] ~= nil then
            local veh = entity:CreateVehicleLocal(v.model, possibleVehiclePos[k].xyz, possibleVehiclePos[k].w)
            SetVehProps(veh:getEntityId(), v.props)
            SetVehicleOnGroundProperly(veh:getEntityId())
            FreezeEntityPosition(veh:getEntityId(), true)
            SetVehicleDirtLevel(veh:getEntityId(), 0.0)
            table.insert(loadedVehs, 
            {
                pos = possibleVehiclePos[k], 
                entity = veh,
                name = GetDisplayNameFromVehicleModel(veh:getModel()),
                model = v.model,
            })
        end
    end
end

function InitGarageFunction()
    LoadCarsinGarage()
    Citizen.CreateThread(function()
        while p:IsInGarage() do
            for k,v in pairs(loadedVehs) do
                Draw3DText(v.pos.x, v.pos.y, v.pos.z, v.name, 2, 0.2, 0.2)
            end


            Wait(1)
        end
    end)

    local closetCar = nil
    local closetDst = 0.0
    Citizen.CreateThread(function()
        while p:IsInGarage() do
            closetDst = 1000
            closetCar = {}
            for k,v in pairs(loadedVehs) do
                if GetDistanceBetweenCoords(v.pos.xyz, p:pos(), true) < closetDst then
                    closetDst = #(v.pos.xyz - p:pos())
                    closetCar = v
                end
            end


            Wait(500)
        end
    end)

    Citizen.CreateThread(function()
        while p:IsInGarage() do
            if closetDst <= 3.0 then
                if not p:isInVeh() then
                    ShowHelpNotification("Press ~INPUT_CONTEXT~ to change vehicle customs")
                    if IsControlJustReleased(0, 38) then
                        OpenCustomMenu(closetCar.entity:getEntityId(), closetCar.model)
                    end
                end
                Wait(1)
            else
                Wait(500)
            end
        end
    end)


    -- Leave 
    Citizen.CreateThread(function()
        while p:IsInGarage() do
            if p:isInVeh() then
                ShowHelpNotification("Presse ~INPUT_CONTEXT~ to leave your garage")
                if IsControlJustReleased(0, 38) then
                    LeaveGarage(closetCar)
                end 
                Wait(1)
            else
                Wait(500)
            end
        end
    end)
end
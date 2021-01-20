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
}

function JoinGarage()
    TriggerServerEvent("drift:ChangeServerInstance", GetPlayerServerId(p:index())) 
    RequestIpl(garageIpl)
    while not IsIplActive(garageIpl) do ShowLoadingMessageTimed(150, "Loading garage ...", 1) Wait(1) end
    DisableInteriorProp(garageIntId, "basic_style_set")
    EnableInteriorProp(garageIntId, "urban_style_set")
    RefreshInterior(garageIntId)
    p:setInGarage(true)
    oldPlayerPos = p:pos()
    oldPlayerHeading = p:heading()
    p:Teleport(garagePos)
    InitGarageFunction()
end

function LeaveGarage(veh)
    TriggerServerEvent("drift:ChangeServerInstance", 0) 
    p:setInGarage(false)
    
    for k, v in pairs(loadedVehs) do
        DeleteEntity(v:getEntityId())
    end
    loadedVehs = {}


    p:Teleport(oldPlayerPos)

    local nameToSpawn = veh.name
    
end

local function LoadCarsinGarage()
    local pVeh = p:GetCars()
    for k,v in pairs(pVeh) do
        if possibleVehiclePos[k] ~= nil then
            local veh = entity:CreateVehicleLocal(v.model, possibleVehiclePos[k].xyz, possibleVehiclePos[k].w)
            SetVehicleOnGroundProperly(veh:getEntityId())
            FreezeEntityPosition(veh:getEntityId(), true)
            table.insert(loadedVehs, 
            {
                pos = possibleVehiclePos[k], 
                entity = veh,
                name = GetDisplayNameFromVehicleModel(veh:getModel())
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
                ShowHelpNotification("Press ~INPUT_CONTEXT~ to change vehicle customs")
                if IsControlJustReleased(0, 38) then
                    OpenCustomMenu(closetCar.entity:getEntityId())
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
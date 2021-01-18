local garagePos = vector3()
local garageLeavePos = vector3()
local oldPlayerPos = vector3(0.0, 0.0, 0.0)
local oldPlayerHeading = 100.0
local garageIpl = ""
local loadedVehs = {}
local possibleVehiclePos = {
    vector4(),
}

function JoinGarage()
    p:setInGarage(true)
    oldPlayerPos = p:pos()
    oldPlayerHeading = p:heading()
    TeleportPlayer(garagePos)
    InitGarageFunction()
end

function LeaveGarage()
    p:setInGarage(false)
    
    for k, v in pairs(loadedVehs) do
        DeleteEntity(v:getEntityId())
    end

    loadedVehs = {}
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

local function GetNearestGarageCar()
    local nearest = nil
    local nearestDst = 100.0
    local pPos = p:pos()
    for k,v in pairs(loadedVehs) do
        local dst = #(pPos - v.pos)
        if dst < nearestDst then
            nearestDst = dst
            nearest = v
        end
    end

    return nearest, nearestDst
end

function InitGarageFunction()
    LoadCarsinGarage()
    Citizen.CreateThread(function()
        while p:IsInGarage() do
            for k,v in pairs(loadedVehs) do
                Draw3DText(v.pos.x, v.pox.y, v.pos.z, v.name, 1, 1.0, 1.0)
            end


            Wait(1)
        end
    end)
end
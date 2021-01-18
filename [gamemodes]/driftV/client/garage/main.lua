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
    

    loadedVehs = {}
end

local function LoadCarsinGarage()
    local pVeh = p:GetCars()
    for k,v in pairs(pVeh) do
        if possibleVehiclePos[k] ~= nil then
            local veh = entity:CreateVehicleLocal(v.model, possibleVehiclePos[k].xyz, possibleVehiclePos[k].w)
            SetVehicleOnGroundProperly(veh:getEntityId())
            FreezeEntityPosition(veh:getEntityId(), true)
            table.insert(loadedVehs, veh)
        end
    end
end

function InitGarageFunction()
    LoadCarsinGarage()
    Citizen.CreateThread(function()
        while p:IsInGarage() do
            
            Wait(1)
        end
    end)
end
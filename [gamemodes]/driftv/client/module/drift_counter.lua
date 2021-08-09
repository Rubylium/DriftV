local Drift = {}
Drift.multiplicatorLoop = false
Drift.multiplicator = 0
Drift.currentPoints = 0
Drift.tandemCurrentPoints = 0

function Drift.GetCurrentAngle()
    local pPed = PlayerPedId()
    local pIsInVeh = IsPedInAnyVehicle(pPed, false)
    if pIsInVeh then
        local veh = GetVehiclePedIsIn(pPed, false)
        local vx,vy,_ = table.unpack(GetEntityVelocity(veh))
        local modV = math.sqrt(vx*vx + vy*vy)
    
    
        local _,_,rz = table.unpack(GetEntityRotation(veh,0))
        local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
    
        if GetEntitySpeed(veh)* 3.6 < 25 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 25 km/h
    
        local cosX = (sn*vx + cs*vy)/modV
        return math.deg(math.acos(cosX))*0.5, modV
    else
        return 0
    end
end

function Drift.GetCurrentSpeed()
    local pPed = PlayerPedId()
    local pIsInVeh = IsPedInAnyVehicle(pPed, false)
    if pIsInVeh then
        local veh = GetVehiclePedIsIn(pPed, false)
        return GetEntitySpeed(veh) * 3.6
    else
        return 0
    end
end

function Drift.IsPlayerDrifting()
    if Drift.GetCurrentAngle() > 10 then
        return true
    else
        return false
    end
end

function Drift.ResetDriftCounter()
    Drift.multiplicatorLoop = false
    Drift.multiplicator = 0
    Drift.currentPoints = 0
    Drift.tandemCurrentPoints = 0
end

function Drift.CalculateDriftPoint(speed, angle)
    if angle > 10 and speed > 25 then
        if angle > 40 then
            angle = 40 -- To avoid cheated bonus
        end
    
        local basePointToAddForAngle = 1
        local points = 0.25 * (basePointToAddForAngle + angle) * basePointToAddForAngle
    
        local basePointToAddForSpeed = 1
        local points = points + (0.25 * (basePointToAddForSpeed + speed) * basePointToAddForSpeed)
        return points * Drift.multiplicator
    else
        return 0
    end
end

function Drift.StartMultiplicatorLoop()
    Citizen.CreateThread(function()
        while Drift.multiplicatorLoop do
            local angle = Drift.GetCurrentAngle()
            if angle < 10 or Drift.GetCurrentSpeed() < 25 then
                Drift.multiplicator = Drift.multiplicator - 0.05
                if Drift.multiplicator <= 1.0 then
                    Drift.multiplicator = 1.0
                end
            else
                Drift.multiplicator = Drift.multiplicator + 0.0007
                if Drift.multiplicator > 10.0 then
                    Drift.multiplicator = 10.0
                end
            end

            RealWait(100)
        end
    end)
end
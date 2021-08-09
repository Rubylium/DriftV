Drift = {}
Drift.multiplicatorLoop = false
Drift.multiplicator = 1.0
Drift.currentPoints = 0
Drift.tandemCurrentPoints = 0
Drift.inRace = false

function Drift.SetInRace(status)
    Drift.inRace = status
end

function Drift.GetCurrentDriftPoint()
    return math.floor(Drift.currentPoints)
end

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
    local pPed = PlayerPedId()
    if IsPedInAnyVehicle(pPed, false) then
        local pVeh = GetVehiclePedIsIn(pPed, false)
        if GetEntityHeightAboveGround(pVeh) <= 1.5 then
            if pPed == GetPedInVehicleSeat(pVeh, -1) then
                if Drift.GetCurrentAngle() > 10 then
                    return true
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end

end

function Drift.ResetDriftCounter()
    Drift.multiplicatorLoop = false
    Drift.multiplicator = 1.0
    Drift.currentPoints = 0
    Drift.tandemCurrentPoints = 0
    Drift.SendDriftDataToNui()
end

function Drift.CalculateDriftPoint(speed, angle)
    if angle > 10 and speed > 25 then
        if angle > 40 then
            angle = 40 -- To avoid cheated bonus
        end
    
        local basePointToAddForAngle = 1.5
        local points = 0.25 * (basePointToAddForAngle + angle) * basePointToAddForAngle
    
        local basePointToAddForSpeed = 1
        local points = points + (0.25 * (basePointToAddForSpeed + speed) * basePointToAddForSpeed)
        return points * Drift.multiplicator
    else
        return 0
    end
end

function Drift.SendDriftDataToNui()
    SendNUIMessage(
        {
            ShowHud = true,
            driftPoints = math.floor(Drift.currentPoints),
            driftDisplayMulti = "x"..Utils.Round(Drift.multiplicator, 1),
        }
    )
end

function Drift.RefreshAngleFromHud()
    TriggerEvent("driftv:SetAngle", Drift.GetCurrentAngle()) -- worst way of sending data, but whatever, old code
end

function Drift.StartMultiplicatorLoop()
    Citizen.CreateThread(function()
        Drift.multiplicatorLoop = true
        while Drift.multiplicatorLoop do
            --print("Looping multiplier", Drift.multiplicator )
            local angle = Drift.GetCurrentAngle()
            if angle < 10 or Drift.GetCurrentSpeed() < 25 then
                Drift.multiplicator = Drift.multiplicator - 0.025
                if Drift.multiplicator <= 1.0 then
                    Drift.multiplicator = 1.0
                end
            else
                Drift.multiplicator = Drift.multiplicator + 0.01
                if Drift.multiplicator > 10.0 then
                    Drift.multiplicator = 10.0
                end
            end

            Drift.SendDriftDataToNui()
            Utils.RealWait(100)
        end
    end)
end



Citizen.CreateThread(function()
    local Counter = {}
    Counter.cooldown = 0
    while true do
        if Drift.IsPlayerDrifting() then
            Counter.cooldown = 150
            if Drift.multiplicatorLoop == false then
                Drift.StartMultiplicatorLoop()
            end

            if Drift.GetCurrentAngle() > 10 then
                Drift.currentPoints = Drift.currentPoints + Drift.CalculateDriftPoint(Drift.GetCurrentSpeed(), Drift.GetCurrentAngle())
            end

            Drift.SendDriftDataToNui()
            Drift.RefreshAngleFromHud()
        else
            if not Drift.inRace then
                Counter.cooldown = Counter.cooldown - 1
                if Counter.cooldown == 0 then
                    SendNUIMessage({HideHud = true})
    
                    p:SubmitDriftScore(Drift.currentPoints, Drift.multiplicator)
                    Drift.ResetDriftCounter()
                    Drift.multiplicatorLoop = false
                end
            end

        end
        Wait(0)
    end
end)
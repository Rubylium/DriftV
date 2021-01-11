local score = 0
local tablemultiplier = {350,1400,4200,11200}
local mult = 0.1
local waiting = 0
local inRace = false

function DrawDriftText(text,colour,coordsx,coordsy,scalex,scaley)
    SetTextFont(7)
    SetTextProportional(7)
    SetTextScale(scalex, scaley)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(0, 0, 0, 0, coloura)
    SetTextEdge(1, 0, 0, 0, coloura)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    EndTextCommandDisplayText(coordsx,coordsy)
end


function calculateBonus(previous)
    local points = previous
    local points = math.floor(points)
    return points or 0
end
function math.precentage(a,b)
    return (a*100)/b
end

function angle(veh)
    if not veh then return false end
    local vx,vy,vz = table.unpack(GetEntityVelocity(veh))
    local modV = math.sqrt(vx*vx + vy*vy)
    
    
    local rx,ry,rz = table.unpack(GetEntityRotation(veh,0))
    local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
    
    if GetEntitySpeed(veh)* 3.6 < 30 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 30 km/h
    
    local cosX = (sn*vx + cs*vy)/modV
    if cosX > 0.966 or cosX < 0 then return 0,modV end
    return math.deg(math.acos(cosX))*0.5, modV
end

local function round2(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function SetMulti()
    local multi = round2((score / 100000) / 10, 1)
    if multi > 10.0 then
        multi = 10.0
    end
    if multi < 0.1 then
        mult = 0.1
    else
        mult = multi
    end
end

local function GetMultiColor()
    if mult > 0.0 and mult < 2.0 then
        return {59, 255, 95, 200}
    elseif mult > 2.0 and mult < 3.0 then
        return  {88, 255, 59, 200}
    elseif mult > 3.0 and mult < 4.0 then
        return  {150, 255, 59, 200}
    elseif mult > 4.0 and mult < 5.0 then
        return  {245, 255, 59, 200}
    elseif mult > 5.0 and mult < 6.0 then
        return  {255, 213, 59, 200}
    elseif mult > 6.0 and mult < 7.0 then
        return  {255, 186, 59, 200}
    elseif mult > 7.0 and mult < 8.0 then
        return  {255, 147, 59, 200}
    elseif mult > 8.0 and mult < 9.0 then
        return  {255, 101, 59, 200}
    elseif mult > 9.0 and mult < 10.0 then
        return  {255, 59, 59, 200}
    else
        return  {255, 59, 59, 200}
    end
end

function ResetDriftPoint()
    score = 0
end

function SetPlayerInRace(status)
    inRace = status
end

function GetCurrentDriftPoint()
    return score
end

Citizen.CreateThread(function()
    while not loaded do Wait(1) end
    while true do
        --DrawDriftText("86546854646541", {3, 252, 182, 200},0.50,0.9, 0.8, 0.9)
        if p:isInVeh() then
            Wait(50)

            score = 0
            while p:isInVeh() do
                local angle, velocity = angle(p:currentVeh())
                local newScore = score + math.floor(angle * velocity) * mult
                if p:speed() <= 4 and score ~= 0 and not inRace then
                    p:SubmitDriftScore(score)
                    score = 0
                    waiting = 0
                    SendNUIMessage({ShowHud = false})
                else
                    if newScore ~= score and p:speed() >= 10.0 then
                        waiting = 0
                        score = newScore
                    else
                        waiting = waiting + 1
                        if waiting >= 300 and score ~= 0 and not inRace then
                            p:SubmitDriftScore(score)
                            score = 0
                            waiting = 0
                            SendNUIMessage({ShowHud = false})
                        end
                    end
                end

                if score ~= 0 then
                    SetMulti()
                    -- DrawDriftText(tostring(math.floor(score)), {3, 252, 182, 200},0.50,0.9, 0.8, 0.9)
                    -- DrawDriftText("x"..tostring(mult), GetMultiColor(),0.50,0.95, 0.8, 0.7)

                    SendNUIMessage(
                        {
                            ShowHud = true,
                            driftPoints = math.floor(score),
                            driftDisplayMulti = tostring(mult),
                        }
                    )
                end
                Wait(1)
            end

        else
            SendNUIMessage({ShowHud = false})
            Wait(500)
        end
    end
end)
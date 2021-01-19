score = 0
local tablemultiplier = {350,1400,4200,11200}
local mult = 0.1
local waiting = 0
local inRace = false
local bonusCops = 0

local inAerorport = false
Citizen.CreateThread(function()
    --Name: aeroport | 2021-01-17T16:19:19Z
    while PolyZone == nil do Wait(100) end
    local aeroport = PolyZone:Create({
        vector2(-883.20074462891, -2519.7609863281),
        vector2(-948.49163818359, -2339.0808105469),
        vector2(-1022.8463134766, -2324.392578125),
        vector2(-1213.7489013672, -2213.55859375),
        vector2(-1229.2888183594, -2177.7319335938),
        vector2(-1228.8903808594, -2118.3488769531),
        vector2(-1249.7570800781, -2103.8825683594),
        vector2(-1260.7379150391, -2112.6394042969),
        vector2(-1273.2924804688, -2118.142578125),
        vector2(-1295.2432861328, -2113.2390136719),
        vector2(-1374.7094726562, -2154.1450195312),
        vector2(-1420.1635742188, -2222.7099609375),
        vector2(-1699.29296875, -2693.3354492188),
        vector2(-1784.2448730469, -2655.17578125),
        vector2(-2103.0695800781, -3103.2258300781),
        vector2(-1035.3957519531, -3805.1008300781),
        vector2(-675.06365966797, -3233.6828613281),
        vector2(-868.56384277344, -3110.2600097656),
        vector2(-700.37896728516, -2827.9965820312)
    }, {
      name="aeroport",
      --minZ = 17.846054077148,
      --maxZ = 123.04996490479
    })
  
  
    aeroport:onPlayerInOut(function(isPointInside, point)
        inAerorport = isPointInside
        if inAerorport then
            Visual.Subtitle("You have entered a forbidden drift zone, the police will not come. Bonus disabled", 10000)
        end
    end)
    
end)


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
        if p:isInVeh() then
            Wait(50)

            score = 0
            while p:isInVeh() do
                local angle, velocity = angle(p:currentVeh())
                local bonus = 0
                if angle ~= 0 and p:GetMap() == "LS" then
                    bonus = math.floor(score * GetCopLimitByScore()) / 3000
                end
                if bonus > 30000 then
                    bonus = 30000
                end

                local newScore = (score + math.floor(angle * velocity) * mult) + bonus
                if p:speed() <= 4 and score ~= 0 and not inRace then
                    p:SubmitDriftScore(score)
                    p:GiveMoney(bonusCops)
                    bonusCops = 0
                    score = 0
                    waiting = 0
                    SendNUIMessage({HideHud = true})
                else
                    if newScore ~= score and p:speed() >= 10.0 then
                        waiting = 0
                        score = newScore
                    else
                        waiting = waiting + 1
                        if waiting >= 300 and score ~= 0 and not inRace then
                            p:SubmitDriftScore(score)
                            p:GiveMoney(bonusCops)
                            bonusCops = 0
                            score = 0
                            waiting = 0
                            SendNUIMessage({HideHud = true})
                        end
                    end
                end

                if score ~= 0 then
                    SetMulti()

                    SendNUIMessage(
                        {
                            ShowHud = true,
                            driftPoints = math.floor(score),
                            driftDisplayMulti = "x"..tostring(mult),
                        }
                    )
                end
                Wait(1)
            end

        else
            SendNUIMessage({HideHud = true})
            Wait(500)
        end
    end
end)

local policeCarss = {
    [GetHashKey("polamggtr")] = "polamggtr",
    [GetHashKey("polgs350")] = "polgs350",
    [GetHashKey("polmp4")] = "polmp4",
}

local policeCars = {
    "polamggtr",
    "polgs350",
    "polmp4",
}

local policePed = {
    "s_m_y_cop_01"
}
local possibleSirenes = {
    "VEHICLES_HORNS_SIREN_1",
    "VEHICLES_HORNS_SIREN_2",
    "VEHICLES_HORNS_AMBULANCE_WARNING",
    "VEHICLES_HORNS_POLICE_WARNING",
}
local spawnedPolice = {}

function GetCopLimitByScore()
    if score > 100000 and score < 200000 then
        return 1
    elseif score < 350000 then
        return 2
    elseif score < 600000 then
        return 3
    elseif score < 1200000 then
        return 4
    elseif score >= 5000000 then
        return 5
    end
    return 1
end

function SpawnCop()
    local get, pos, id = GetClosestVehicleNodeWithHeading(p:pos().x + math.random(-50, 50), p:pos().y + math.random(-50, 50), p:pos().z, 0, 3, 0)
                
    local ped = policePed[math.random(1, #policePed)]
    local veh = policeCars[math.random(1, 3)]

    LoadModel(ped)
    if #(pos - p:pos()) > 20.0 and not inAerorport then
        local vehicle = entity:CreateVehicle(veh, pos, p:heading())
        local peds = CreatePedInsideVehicle(vehicle:getEntityId(), 1, GetHashKey(ped), -1, 1, 0)
        SetVehicleSiren(vehicle:getEntityId(), true)
        SetVehicleHasMutedSirens(vehicle:getEntityId(), false)
        SetVehicleDoorsLocked(vehicle:getEntityId(), 4)
        SetPedCombatAttributes(peds, 3, false)
        PlaySoundFromEntity(GetSoundId(), possibleSirenes[math.random(1,#possibleSirenes)], vehicle:getEntityId(), 0, 0, 0)

        TaskVehicleChase(peds, p:ped())
        SetTaskVehicleChaseBehaviorFlag(peds, 1, true)
        SetTaskVehicleChaseIdealPursuitDistance(peds, 1.0)


        -- * Flag 8: Medium-aggressive boxing tactic with a bit of PIT
        -- * Flag 1: Aggressive ramming of suspect
        -- * Flag 2: Ram attempts
        -- * Flag 32: Stay back from suspect, no tactical contact. Convoy-like.
        -- * Flag 16: Ramming, seems to be slightly less aggressive than 1-2.

        
        SetDriverAggressiveness(peds, 1.0)
        SetDriverAbility(peds, 1.0)
        AddBlipForEntity(peds)
        SetVehicleForwardSpeed(vehicle:getEntityId(), 50.0)
        
        table.insert(spawnedPolice, {veh = vehicle, ped = peds, netPed = NetworkGetNetworkIdFromEntity(peds), netVeh = vehicle:getNetId()})
    end
end


Citizen.CreateThread(function()
    local timeBar = NativeUI.TimerBarPool()
    local time = NativeUI.CreateTimerBar("Cops:")
    local bonuss = NativeUI.CreateTimerBar("Bonus:")
    timeBar:Add(time)
    timeBar:Add(bonuss)
    while true do
        if #spawnedPolice ~= 0 then
            time:SetTextTimerBar(tostring(#spawnedPolice))
            bonuss:SetTextTimerBar(tostring(bonusCops).."$")
            timeBar:Draw()
            Wait(1)
        else
            Wait(500)
        end
    end
end)

local cooldownSpeed = false
Citizen.CreateThread(function()
    while not loaded do Wait(500) end
    while true do
        if score > 100000 and p:GetMap() == "LS" and p:getTime() == "night" then
            if #spawnedPolice < GetCopLimitByScore() then
                SpawnCop()
            end
        end

        if p:speed() >= 100 and p:GetMap() == "LS" and p:getTime() == "night" then
            if #spawnedPolice < 5 and not cooldownSpeed then
                SpawnCop()
                Citizen.CreateThread(function()
                    cooldownSpeed = true
                    Wait(1000)
                    cooldownSpeed = false
                end)
            end
        end

        local near = 0
        for k,v in pairs(spawnedPolice) do
            local dst = #(GetEntityCoords(v.ped) - p:pos())
            if dst > 230 then
                TriggerServerEvent("DeleteEntity", v.netPed)
                TriggerServerEvent("DeleteEntity", v.netVeh)
                if spawnedPolice[k] ~= nil then
                    table.remove(spawnedPolice, k)

                    Citizen.CreateThread(function()
                        SendNUIMessage( {
                            ShowSucces = true,
                            label = "Police: Escape!",
                        })
                        if not inAerorport then
                            p:SetSucces("Police: Escape!")
                            p:addExp(10000)
                            bonusCops = bonusCops + 2500
                            Wait(3000)
                            SendNUIMessage( {
                                HideSucces = true,
                            })
                        end
                    end)
                else
                    break
                end
            else
                local mod = math.random(-1,0)
                TaskVehicleChase(v.ped, p:currentVeh())
                SetTaskVehicleChaseBehaviorFlag(v.ped, 1, true)
                SetTaskVehicleChaseIdealPursuitDistance(v.ped, 1.0)
            end

            while dst <= 15.0 and p:speed() <= 20.0 and near < 100 do
                dst = #(GetEntityCoords(v.ped) - p:pos())
                near = near + 1

                Visual.Subtitle("You are being arrested ! You need to move ! ("..near.."/100)", 20)

                if near == 100 then
                    ArrestPlayer(spawnedPolice)
                    spawnedPolice = {}
                    p:GiveMoney(bonusCops)
                    bonusCops = 0
                    break
                end
                Wait(15)
            end

        end

        -- SetPlayerWantedLevelNoDrop(p:index(), #spawnedPolice, 1)
        -- SetPlayerWantedLevelNow(p:index(), 1)
        ClearAreaOfCops(p:pos().xyz, 400.0)
        ClearPlayerWantedLevel(p:index())
        Wait(2000)
    end
end)




function ArrestPlayer(spawned)
    local veh = VehToNet(p:currentVeh())
    DisplayRadar(false)

    SetPlayerControl(p:index(), false, 1)

    local campos1 = GetOffsetFromEntityInWorldCoords(p:ped(), 5.0, 7.0, 3.0)
    local campos2 = GetOffsetFromEntityInWorldCoords(p:ped(), 9.0, 8.0, 10.0)

    cam.create("WASTED")
    cam.setPos("WASTED", campos1)
    cam.lookAtCoords("WASTED", p:pos())
    cam.setFov("WASTED", 50.0)
    cam.setActive("WASTED", true)
    cam.render("WASTED", true, false, 1)

    cam.create("WASTED_2")
    cam.setPos("WASTED_2", campos2)
    cam.lookAtCoords("WASTED_2", p:pos())
    cam.setFov("WASTED_2", 40.0)
    cam.setActive("WASTED_2", true)
    cam.switchToCam("WASTED", "WASTED_2", 10000)

    TaskLeaveAnyVehicle(p:ped(), 1, 1)
    while IsPedInAnyVehicle(p:ped(), false) do Wait(1) end


    for k,v in pairs(spawned) do
        ClearPedTasksImmediately(v.ped)
        TaskLeaveAnyVehicle(v.ped, 1, 1)
        GiveWeaponToPed(v.ped, GetHashKey("weapon_combatpistol"), 255, 0, 1)
        TaskAimGunAtEntity(v.ped, p:ped(), -1, 1)
    end

    p:PlayAnim("random@arrests", "idle_2_hands_up", 1)
    Wait(GetAnimDuration("random@arrests", "idle_2_hands_up") * 1000)
    p:PlayAnim("random@arrests@busted", "enter", 2)
    Wait(GetAnimDuration("random@arrests@busted", "enter") * 1000)

    Wait(2000)




    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(1) end

    p:PlayAnim("mp_arresting", "arrest_on_floor_front_left_b", 2)
    LoadModel("s_m_y_cop_01")
    local ped = CreatePed(1, GetHashKey("s_m_y_cop_01"), GetOffsetFromEntityInWorldCoords(p:ped(), 0.0, -0.8, -1.0), p:heading() + 30.0, 1, 0)
    TaskSetBlockingOfNonTemporaryEvents(ped, true)


    campos2 = GetOffsetFromEntityInWorldCoords(p:ped(), -1.5, -5.0, 3.0)
    cam.setPos("WASTED", campos2)
    cam.lookAtCoords("WASTED", p:pos())
    cam.setActive("WASTED", true)
    cam.render("WASTED", true, false, 0)


    DoScreenFadeIn(500)




    ClearPedTasksImmediately(ped)
    p:PlayAnimOnPed(ped, "mp_arresting", "arrest_on_floor_front_left_a", 2)
    Wait(GetAnimDuration("mp_arresting", "arrest_on_floor_front_left_a") * 1000)


    TriggerServerEvent("drift:GotBusted", #spawned)

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(1) end

    for k,v in pairs(spawned) do
        ClearPedTasksImmediately(v.ped)
        SetEntityAsNoLongerNeeded(v.ped)
        SetEntityAsNoLongerNeeded(v.veh:getEntityId())
        RemoveWeaponFromPed(v.ped, GetHashKey("weapon_combatpistol"))
        TriggerServerEvent("DeleteEntity", v.netPed)
        TriggerServerEvent("DeleteEntity", v.netVeh)
        table.remove(spawned, k)
    end
    TriggerServerEvent("DeleteEntity", PedToNet(ped))

    for k,v in pairs(GetGamePool("CPed")) do
        if GetEntityModel(v) == GetHashKey("s_m_y_cop_01") then
            SetEntityAsNoLongerNeeded(v)
            DeleteEntity(v)
        end
    end

    for k,v in pairs(GetGamePool("CVehicle")) do
        if policeCarss[GetEntityModel(v)] ~= nil then
            SetEntityAsNoLongerNeeded(v)
            DeleteEntity(v)
        end
    end



    TeleportPlayer(vector3(439.21105957031, -981.87091064453, 30.689611434937))
    ClearPedTasksImmediately(p:ped())
    TaskGoStraightToCoord(p:ped(), 431.31030273438, -982.06469726562, 30.710628509521, 1.0, -1, 100, 1.0)

    
    TriggerServerEvent("DeleteEntity", veh)
    spawnedPolice = {}

    DoScreenFadeIn(2500)
    cam.setActive("WASTED", false)
    cam.delete("WASTED")
    cam.delete("WASTED_2")

    ClearPlayerWantedLevel(p:index())
    ResetDriftPoint()
    DisplayRadar(true)
    SetPlayerControl(p:index(), true, 1)

    SendNUIMessage( {
        ShowSucces = true,
        label = "BUSTED",
    })
    p:SetSucces("Police: BUSTED!")
    p:removeExp(300000)
    Wait(5000)
    SendNUIMessage( {
        HideSucces = true,
    })
end
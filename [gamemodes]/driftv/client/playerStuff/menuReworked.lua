local keepCleanVeh = false
local autoRepair = false
playersIdInPassive = {} -- Global
local open = false
local passive = false
local voicechat = true
lastSpawned = nil
local activeCamName
local cachedEntity = {}
local playersInPassiveVeh = {}
local playerInstances = {}
local selectedCrewMember = {}
local selectedCrewKey = 0
local garageTag = "Lobby"
local garageTagState = {
    "→    " .. garageTag .. "       ←",
    "→    " .. garageTag .. "      ←",
    "→    " .. garageTag .. "     ←",
    "→    " .. garageTag .. "    ←",
    "→    " .. garageTag .. "   ←",
    "→    " .. garageTag .. "  ←",
    "→    " .. garageTag .. "  ←",
    "→    " .. garageTag .. "  ←",
    "→    " .. garageTag .. "  ←",
    "→    " .. garageTag .. "  ←",
    "→    " .. garageTag .. "  ←",
    "→    " .. garageTag .. "  ←",
    "→    " .. garageTag .. "   ←",
    "→    " .. garageTag .. "    ←",
    "→    " .. garageTag .. "     ←",
    "→    " .. garageTag .. "      ←",
    "→    " .. garageTag .. "       ←",
}
local animatedTag = "→"
local animatedTagState = {
    "→",
    "→ ",
    "→  ",
    "→   ",
    "→    ",
    "→    ",
    "→    ",
    "→    ",
    "→   ",
    "→  ",
    "→ ",
    "→",
}

mapsArea = {
    {animated = false, tag = "", map = "Harugahara", label = "Harugahara", pos = vector3(2789.40, 4572.52, 546.86)},
    {animated = true, tag = "POPULAR", map = "Ebisu", label = "Ebisu Minami", pos = vector3(948.99768066406, 1054.1428222656, 458.58303833008)},
    {animated = false, tag = "", map = "Haruna", label = "Haruna", pos = vector3(2227.2080078125, -1895.2564697266, 587.02075195312)},
    {animated = false, tag = "", map = "Ohiradai", label = "Hakone Ohiradai", pos = vector3(-4331.8, -4626.4, 149.7)},
    {animated = false, tag = "", map = "West", label = "West Zao S", pos = vector3(-5293.8, 2466.95, 533.29)},
    {animated = false, tag = "", map = "Nanamagari", label = "Hakone Nanamagari", pos = vector3(-3330.8244628906, 132.70896911621, 136.05108642578)},
    {animated = false, tag = "", map = "Irohazaka", label = "Irohazaka", pos = vector3(-5375.103515625, 4325.025390625, 754.67639160156)},
    {animated = false, tag = "", map = "HuntePark", label = "Hunter Park", pos = vector3(1232.69, 7378.71, 80.22)},
    {animated = false, tag = "", map = "Katsuoji", label = "Route 4 Katsuoji Minoo", pos = vector3(6383.56, 3657.9, 255.96)},
    {animated = false, tag = "", map = "Tsukurimono", label = "Tsukurimono Touge", pos = vector3(-1077.5308837891, 2408.6586914062, 728.42279052734)},
    {animated = true, tag = "NEW", map = "maxdrift", label = "MaxDrift", pos = vector3(-3049.3159179688, 2596.5817871094, 634.01617431641)},
}

local hours = {
    {desc = "The night is agitated! From 100k points, the police will come for you and won't let you go! Vehicle repairs will be very limited, but the night rewards are much better! Participate in illegal activities and dominate the city!", name = "night", label = "Midnight", hours = 23, minutes = 0},
    {desc = "The day is calm, train yourself to drift in the middle of the city without fearing anything, participate in legal activities with your drift vehicles.", name = "day", label = "Day", hours = 12, minutes = 0},
}


local main = RageUI.CreateMenu("DriftV", "Welcome to the drift paradise")
local information =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
local vehicle =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
local vehicleOptions =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
local vehicleOptionsExtra =  RageUI.CreateSubMenu(vehicleOptions, "DriftV", "Welcome to the drift paradise")
local vehicleOptionsLivery =  RageUI.CreateSubMenu(vehicleOptions, "DriftV", "Welcome to the drift paradise")
local maps =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
local camera =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
local instance =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
local succes =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
-- local time =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
local crew =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
local crewSub =  RageUI.CreateSubMenu(crew, "DriftV", "Welcome to the drift paradise")
local crewRankings =  RageUI.CreateSubMenu(crew, "DriftV", "Welcome to the drift paradise")
local settings =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")

main.WidthOffset = 100.0
information.WidthOffset = 100.0
vehicle.WidthOffset = 100.0
vehicleOptions.WidthOffset = 100.0
vehicleOptionsExtra.WidthOffset = 100.0
vehicleOptionsLivery.WidthOffset = 100.0
maps.WidthOffset = 100.0
camera.WidthOffset = 100.0
instance.WidthOffset = 100.0
succes.WidthOffset = 100.0
-- time.WidthOffset = 100.0
settings.WidthOffset = 100.0
crew.WidthOffset = 100.0
crewSub.WidthOffset = 100.0
crewRankings.WidthOffset = 100.0

main.Closed = function()
    open = false
    RageUI.CloseAll()
    RageUI.Visible(main, false)
end


function OpenMainMenu()
    if open then
        open = false
        RageUI.CloseAll()
        RageUI.Visible(main, false)
    else
        open = true
        RageUI.Visible(main, true)
        StartLoopAnimation()

        Citizen.CreateThread(function()
            while open do

                RageUI.IsVisible(main, function()
                    if not p:IsInGarage() then
                        RageUI.Button(garageTag, "Return to the lobby", {RightLabel = ""}, true, {
                        onSelected = function()
                            
                            open = false
                            RageUI.CloseAll()
                            EnableLobby()
                        end,
                        });
                    else
                        RageUI.Button("Leave garage", "Return to the lobby", {RightLabel = ""}, true, {
                        onSelected = function()
                            open = false
                            RageUI.CloseAll()
                            LeaveGarage(nil, false)
                            EnableLobby()
                        end,
                        });
                        
                    end
                    RageUI.Button('→    My Vehicles', nil, {RightLabel = ">"}, not p:IsInGarage(), {}, vehicle);
                    RageUI.Button('→    Vehicle options', "Available only inside a vehicle", {RightLabel = ">"}, p:isInVeh(), {}, vehicleOptions);
                    RageUI.Button('→    My information/stats', nil, {RightLabel = ">"}, true, {}, information);
                    RageUI.Button('→    Teleports', nil, {RightLabel = ">"}, not p:IsInGarage(), {}, maps);
                    RageUI.Button('→    Camera', "Available only inside a vehicle", {RightLabel = ">"}, p:isInVeh(), {}, camera);
                    RageUI.Button('→    Settings', nil, {RightLabel = ">"}, true, {}, settings);
                    RageUI.Button('→    Achievements', "Your completed achievements", {RightLabel = ">"}, true, {}, succes);
                    -- RageUI.Button('→    Time Of Day', "Change your time", {RightLabel = ">"}, not p:IsInGarage(), {}, time);
                    RageUI.Button('→    Manage your crew', "Change your time", {RightLabel = animatedTag.."  ~y~NEW!"}, true, {}, crew);
                    RageUI.Button("→    Toggle freecam", "", {}, not p:IsInGarage(), {
                        onSelected = function()
                            ToogleNoClip()
                        end,
                    });
                end)

                RageUI.IsVisible(crew, function()
                    RageUI.Button("Crew Ranking", nil, {}, true, {}, crewRankings);
                    if p:getCrew() == "None" then
                        RageUI.Button("Create", "Do you want to be famous? Make yourself known as a leader? Create your own crew now!", {}, true, {
                            onSelected = function()
                                local name = KeyboardInput("Crew full name", 20)
                                if name ~= nil or name ~= "" then
                                    local tag = KeyboardInput("Crew tag (4 char max)", 4)
                                    if tag ~= nil or tag ~= "" then
                                        TriggerServerEvent("driftV:CreateCrew", tag, name)
                                    end
                                end
                            end,
                        });
                    else
                        RageUI.Separator(p:getCrew())
                        RageUI.Button("Crew Points: ~g~".. GroupDigits(Crew[p:getCrew()].totalPoints), nil, {}, true, {});
                        RageUI.Button("Members: ~g~"..Crew[p:getCrew()].memberCount.. "~s~/"..Config.MaxMembers, nil, {}, true, {});
                        RageUI.Button("Win / Loose: ~g~"..Crew[p:getCrew()].win .."~s~/~r~"..Crew[p:getCrew()].loose, nil, {}, true, {});
                        RageUI.Button("Crew War Elo: ~g~"..Crew[p:getCrew()].elo, nil, {}, true, {});
                        RageUI.Button("Start/stop crew war matchmaking", "The crew war system is a competitive mode where 2 crews compete in a drift race. The team with the highest score wins the crew war. The crew with the best Elo will have a crown displayed above their nickname.", {}, true, {
                            onSelected = function()
                                TriggerServerEvent("driftV:StartMatchmaking")
                                ShowNotification("Matchmaking started !")
                            end,
                        });
                        RageUI.Button("Leave", "Your crew doesn't interest you anymore? You prefer to leave it? Click here and your wish will be granted.", {}, true, {
                            onSelected = function()
                                TriggerServerEvent("driftV:LeaveCrew")
                                RageUI.GoBack()
                            end,
                        });
                        RageUI.Button("Invite (Leader only)", "Allows you to invite the player closest to you in your crew!", {}, p:isPlayerCrewOwner(), {
                            onSelected = function()
                                RecruiteNearestPlayer()
                            end,
                            onActive = function()
                                DisplayClosetPlayer()
                            end
                        });
                        RageUI.Separator("↓ Crew Members ↓")
                        if Crew[p:getCrew()] ~= nil then
                            for k,v in pairs(Crew[p:getCrew()].members) do
                                RageUI.Button(v.name, "", {RightLabel = "~g~"..GroupDigits(v.points).." Crew Points"}, true, {
                                    onSelected = function()
                                        selectedCrewMember = Crew[p:getCrew()].members[k]
                                        selectedCrewKey = k
                                    end,
                                }, crewSub);
                            end
                        end
                    end
                end)

                RageUI.IsVisible(crewSub, function()
                    RageUI.Separator("Name: "..selectedCrewMember.name)
                    RageUI.Separator("↓ Stats ↓")
                    RageUI.Button("Crew Points: ~g~"..GroupDigits(selectedCrewMember.points), nil, {}, true, {});
                    RageUI.Separator("↓ Management ↓")
                    RageUI.Button("Kick", nil, {}, p:isPlayerCrewOwner(), {
                        onSelected = function()
                            TriggerServerEvent("driftV:KickFromCrew", selectedCrewKey)
                            RageUI.GoBack()
                        end,
                    });

                end)

                RageUI.IsVisible(crewRankings, function()
                    for k,v in pairs(CrewRanking) do
                        RageUI.Button("[#~b~"..k.."~s~] - "..v.name.." ~g~"..v.members.."~s~"..Config.MaxMembers.." | ~b~"..v.elo, "Crew points: "..v.points.." -  Win/Loose: "..v.win.."/"..v.loose, {}, true, {});
                    end
                end)
                

                RageUI.IsVisible(information, function()
                    RageUI.Button("Money: "..GroupDigits(tostring(p:GetMoney())) .. "$", nil, {}, true, {});
                    RageUI.Button("Drift: "..GroupDigits(tostring(math.floor(p:GetDrift()))) .. " point(s)", nil, {}, true, {});
                end)

                RageUI.IsVisible(vehicle, function()
                    RageUI.Button("Vehicle shop", nil, {}, true, {
                        onSelected = function()
                            open = false
                            RageUI.CloseAll()
                            OpenVehShopMenu()
                        end,
                    });
                    for _,v in pairs(p:GetCars()) do
                        RageUI.Button(v.label, nil, {}, true, {
                            onSelected = function()
                                if lastSpawned ~= nil then
                                    TriggerServerEvent("DeleteEntity", lastSpawned)
                                    while DoesEntityExist(NetworkGetEntityFromNetworkId(lastSpawned)) do
                                        Wait(100)
                                    end
                                end
                                local veh = entity:CreateVehicle(v.model, p:pos(), p:heading())
                                SetVehProps(veh:getEntityId(), v.props)
                                lastSpawned = veh:getNetId()
                                TaskWarpPedIntoVehicle(p:ped(), veh:getEntityId(), -1)
                                
                            end,
                        });
                    end
                end)


                RageUI.IsVisible(vehicleOptions, function()
                    -- RageUI.Button("Random mods", "Apply randoms mods to your vehicle (Will max out perf)", {}, true, {
                    --     onSelected = function()
                    --         RandomUpgrade(p:currentVeh())
                    --     end,
                    -- });
                    RageUI.Button("Repair", "Not available at night", {}, true, {
                        onSelected = function()
                            if p:getTime() ~= "night" then
                                SetVehicleFixed(p:currentVeh())
                            else
                                ShowNotification("Sorry, repairs are Not available at night. Go to a repair station !")
                            end
                        end,
                    });
                    RageUI.Button("Clean", nil, {}, true, {
                        onSelected = function()
                            SetVehicleDirtLevel(p:currentVeh(), 0.0)
                        end,
                    });
                    RageUI.Button("Keep clean", nil, {}, true, {
                        onSelected = function()
                            keepCleanVeh = not keepCleanVeh
                            if keepCleanVeh then
                                ShowNotification("Auto Clean activated !")
                            else
                                ShowNotification("Auto clean removed")
                            end
                        end,
                    });
                    RageUI.Button("Auto Repair", "Not available at night", {}, true, {
                        onSelected = function()
                            autoRepair = not autoRepair
                            if autoRepair then
                                ShowNotification("Auto repair activated !")
                            else
                                ShowNotification("Auto repair removed")
                            end
                        end,
                    });

                end)


                RageUI.IsVisible(vehicleOptionsLivery, function()
                    for i = 1, GetVehicleLiveryCount(p:currentVeh()) do
                        RageUI.Button("Livery #"..i, nil, {}, true, {
                            onSelected = function()
                                SetVehicleLivery(p:currentVeh(), i)
                            end,
                        });
                    end
                end)

                RageUI.IsVisible(maps, function()

                    for _,v in pairs(mapsArea) do
                        if v.animated then
                            RageUI.Button(v.label, nil, {RightLabel = animatedTag.." ~y~"..v.tag}, true, {
                                onSelected = function()
                                    p:SetMap(v.map)
                                    open = false
                                    RageUI.CloseAll()
                                    ResetMulti(0.1)
                                    p:Teleport(v.pos.xyz)
                                    ExtendWorldBoundaryForPlayer(-9000.0,-11000.0,30.0)
                                    ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)
                                end,
                            });
                        else
                            RageUI.Button(v.label, nil, {RightLabel = v.tag}, true, {
                                onSelected = function()
                                    p:SetMap(v.map)
                                    ResetMulti(0.1)
                                    open = false
                                    RageUI.CloseAll()
                                    p:Teleport(v.pos.xyz)
                                    ExtendWorldBoundaryForPlayer(-9000.0,-11000.0,30.0)
                                    ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)
                                end,
                            });
                        end
                    end
                end)

                RageUI.IsVisible(camera, function()
                    RageUI.Button("Default cam", nil, {}, true, {
                        onSelected = function()
                            if activeCamName ~= nil then
                                cam.delete(activeCamName)
                                activeCamName = nil
                            end
                        end,
                    });
                    RageUI.Button("Drift cam #1", nil, {}, true, {
                        onSelected = function()
                            if activeCamName ~= nil then
                                cam.delete(activeCamName)
                            end
                            cam.create("DRIFT_CAM_1")
                            cam.attachToVehicleBone("DRIFT_CAM_1", p:currentVeh(), GetEntityBoneIndexByName(p:currentVeh(), "chassis"), true, 0.0, 0.0, 0.0, 0.0, -2.0, 1.5, true)
                            cam.setActive("DRIFT_CAM_1", true)
                            cam.render("DRIFT_CAM_1", true, true, 500)
                            activeCamName = "DRIFT_CAM_1" 
                        end,
                    });
                    RageUI.Button("Drift cam #2", nil, {}, true, {
                        onSelected = function()
                            if activeCamName ~= nil then
                                cam.delete(activeCamName)
                            end
                            cam.create("DRIFT_CAM_1")
                            cam.attachToVehicleBone("DRIFT_CAM_1", p:currentVeh(), GetEntityBoneIndexByName(p:currentVeh(), "chassis"), true, 0.0, 0.0, 0.0, 0.0, -3.0, 2.0, true)
                            cam.setActive("DRIFT_CAM_1", true)
                            cam.render("DRIFT_CAM_1", true, true, 500)
                            activeCamName = "DRIFT_CAM_1"
                        end,
                    });
                end)

                RageUI.IsVisible(settings, function()
                    if not passive then
                        RageUI.Button('Toggle ~g~ON~s~ passive mod', "Enables or disables the passive mod. This allows to disable collisions with other players/player vehicles, the best anti troll!", {}, true, {
                            onSelected = function()
                                passive = true
                                p:setPassive(passive)
                                TriggerServerEvent(Events.setPassive, passive)
                            end,
                        });
                    else
                        RageUI.Button('Toggle ~r~OFF~s~ passive mod', "Enables or disables the passive mod. This allows to disable collisions with other players/player vehicles, the best anti troll!", {}, true, {
                            onSelected = function()
                                passive = false
                                p:setPassive(passive)
                                TriggerServerEvent(Events.setPassive, passive)
                            end,
                        });
                    end

                    RageUI.Button('Toggle voice chat', "This allows you to enable or disable voice chat. By default, it is enabled", {}, true, {
                        onSelected = function()
                            voicechat = not voicechat
                            NetworkSetVoiceActive(voicechat)
                            if voicechat then
                                NetworkClearVoiceChannel()
                                ShowNotification("Voice chat enabled !")
                            else
                                NetworkSetVoiceChannel(math.random(1,99999999))
                                ShowNotification("Voice chat disabled !")
                            end
                        end,
                    });
                end)

                RageUI.IsVisible(instance, function()
                    for k,v in pairs(playerInstances) do
                        RageUI.Button("Instance #"..tostring(k - 1), nil, {RightLabel = "Players: ~b~"..v}, true, {
                            onSelected = function()
                                TriggerServerEvent("drift:ChangeServerInstance", k)
                            end,
                        });
                    end
                end)

                RageUI.IsVisible(succes, function()
                    for k,v in pairs(p:GetSucces()) do
                        RageUI.Button(k, nil, {RightLabel = "x~b~"..v}, true, {});
                    end
                end)

                RageUI.IsVisible(time, function()
                    for _,v in pairs(hours) do
                        RageUI.Button(v.label, v.desc, {}, true, {
                            onSelected = function()
                                cam.create("TIME")
                                cam.setPos("TIME", GetOffsetFromEntityInWorldCoords(p:ped(), 0.0, -2.0, 0.0))
                                cam.setFov("TIME", 150.0)
                                cam.setActive("TIME", true)
                                cam.render("TIME", true, true, 3000)
                                cam.rotation("TIME", 0.0, 70.0, 0.0)

                                if p:getTime() == "day" then
                                    TriggerServerEvent("drift:ChangeServerInstance", 2)
                                else
                                    TriggerServerEvent("drift:ChangeServerInstance", 1)
                                end

                                changeTime(v.hours, v.minutes)
                                p:setTime(v.name)
                                Wait(2500)
                                cam.render("TIME", false, true, 1000)
                                Wait(1000)
                                cam.delete("TIME")

                                
                            end,
                        });
                    end
                end)

                Wait(1)
            end
        end)
    end
end

Keys.Register('F1', 'F1', 'Open main menu', function()
    if p:GetCrewWarStatus() or inLobby then
        return
    end
    OpenMainMenu()
end)



Citizen.CreateThread(function()
    while not loaded do Wait(1) end
    while true do
        if p:isInVeh() then
            if keepCleanVeh then
                SetVehicleDirtLevel(p:currentVeh(), 0.0)
            end

            if autoRepair and p:getTime() ~= "night" then
                if IsVehicleDamaged(p:currentVeh()) then
                    SetVehicleFixed(p:currentVeh())
                end
            end
        end


        if IsPedDeadOrDying(p:ped(), 1) then
            NetworkResurrectLocalPlayer(p:pos(), p:heading(), 1, 0)
            
        end
        Wait(100)
    end
end)

Citizen.CreateThread(function()
    while not loaded do Wait(1) end
    while true do
        local pPed = p:ped()
        local pVeh = p:currentVeh()
        if p:isPassive() then

            for _,v in pairs(GetActivePlayers()) do
                local ped = GetPlayerPed(v)
                if ped ~= pPed then

                    SetEntityAlpha(ped, 200, false)
                    SetEntityNoCollisionEntity(pPed, ped, true)
                    SetEntityNoCollisionEntity(ped, pPed, true)

                    if IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) ~= pVeh then
                        local veh = GetVehiclePedIsIn(ped, false)

                        SetEntityNoCollisionEntity(pPed, veh, true)
                        SetEntityNoCollisionEntity(veh, pPed, true)

                        SetEntityNoCollisionEntity(pVeh, veh, true)
                        SetEntityNoCollisionEntity(veh, pVeh, true)

                        --SetEntityCollision(veh, false, true)
                        SetEntityAlpha(veh, 200, false)

                    end

                end
            end
        else

            --print(json.encode(playersIdInPassive))

            for _,v in pairs(GetActivePlayers()) do

                local ped = GetPlayerPed(v)
                local sID = GetPlayerServerId(v)
                if ped ~= pPed then

                    if playersIdInPassive[sID] ~= nil then
                        SetEntityAlpha(ped, 200, false)
                        SetEntityNoCollisionEntity(pPed, ped, true)
                        SetEntityNoCollisionEntity(ped, pPed, true)

                        if IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) ~= pVeh then
                            local veh = GetVehiclePedIsIn(ped, false)
    
                            SetEntityNoCollisionEntity(pPed, veh, true)
                            SetEntityNoCollisionEntity(veh, pPed, true)
    
                            SetEntityNoCollisionEntity(pVeh, veh, true)
                            SetEntityNoCollisionEntity(veh, pVeh, true)
    
                           -- SetEntityCollision(veh, false, true)
                            SetEntityAlpha(veh, 200, false)
    
                        end
                    else
                        ResetEntityAlpha(ped)
                        if IsPedInAnyVehicle(ped, false) and GetVehiclePedIsIn(ped, false) ~= pVeh then
                            ResetEntityAlpha(GetVehiclePedIsIn(ped, false))
                        end
                    end
                    
                    
                end


            end
        end
        Wait(1)
    end
end)

Citizen.CreateThread(function()
    while Events == nil do Wait(1) end
    RegisterSecuredNetEvent(Events.setPassive, function(list)
        playersIdInPassive = list
        for k, _ in pairs(playersIdInPassive) do
            if playersInPassiveVeh[k] == nil then
                playersInPassiveVeh[k] = {}
            end
        end
    end)
end)


RegisterNetEvent("drift:GetServerInstance")
AddEventHandler("drift:GetServerInstance", function(info)
    playerInstances = info
end)


function StartLoopAnimation()
    Citizen.CreateThread(function()
        while open do
            for k,v in pairs(garageTagState) do
                garageTag = garageTagState[k]
                if not open then
                    break
                end
                Wait(50)
            end
            Wait(1)
        end
    end)
    
    Citizen.CreateThread(function()
        while open do
            for k,v in pairs(animatedTagState) do
                animatedTag = animatedTagState[k]
                if not open then
                    break
                end
                Wait(50)
            end
            Wait(1)
        end
    end)
end

function TogglePasive(status)
    passive = status
    p:setPassive(passive)
    TriggerServerEvent("dirft:SetInPassive", passive)
end
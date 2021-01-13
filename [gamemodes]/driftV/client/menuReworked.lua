local keepCleanVeh = false
local autoRepair = false
playersIdInPassive = {} -- Global
local open = false
local passive = false
local voicechat = true
local lastSpawned = nil
local activeCamName = nil
local cachedEntity = {}
local playersInPassiveVeh = {}
local playerInstances = {}

local mapsArea = {
    {map = "LS", label = "LS: The hub", pos = vector3(229.73329162598, -885.22637939453, 30.949995040894)},
    {map = "LS", label = "LS: Vehicle Shop", pos = vector3(-51.129165649414, -1110.4876708984, 27.4358253479)},
    {map = "Harugahara", label = "Addon: Harugahara", pos = vector3(2789.40, 4572.52, 546.86)},
    {map = "Ebisu", label = "Addon: Ebisu Minami", pos = vector3(948.99768066406, 1054.1428222656, 458.58303833008)},
    {map = "Haruna", label = "Addon: Haruna", pos = vector3(2227.2080078125, -1895.2564697266, 587.02075195312)},
    {map = "Ohiradai", label = "Addon: Hakone Ohiradai", pos = vector3(-4331.8, -4626.4, 149.7)},
    {map = "West", label = "Addon: West Zao S", pos = vector3(-5293.8, 2466.95, 533.29)},
    {map = "Nanamagari", label = "Addon: Hakone Nanamagari", pos = vector3(-3330.8244628906, 132.70896911621, 136.05108642578)},
    {map = "Irohazaka", label = "Addon: Irohazaka", pos = vector3(-5375.103515625, 4325.025390625, 754.67639160156)},
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
local settings =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")

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

        Citizen.CreateThread(function()
            while open do

                RageUI.IsVisible(main, function()
                    RageUI.Button('My Vehicles', nil, {RightLabel = ">"}, true, {}, vehicle);
                    RageUI.Button('Vehicle option', "Unlocked when inside a vehicle", {RightLabel = ">"}, p:isInVeh(), {}, vehicleOptions);
                    RageUI.Button('My informations / stats', nil, {RightLabel = ">"}, true, {}, information);
                    RageUI.Button('Teleporations', nil, {RightLabel = ">"}, true, {}, maps);
                    RageUI.Button('Camera', "Unlocked when inside a vehicle", {}, p:isInVeh(), {}, camera);
                    RageUI.Button('Server instance', "Someone is getting on your nerves or there are just too many players on a circuit? Change instance!", {}, true, {
                        onSelected = function()
                            TriggerServerEvent("drift:GetServerInstance")
                        end,
                    }, instance);
                    RageUI.Button('Settings', nil, {RightLabel = ">"}, true, {}, settings);
                    RageUI.Button('Succes', "See all your succes", {}, true, {}, succes);
                    RageUI.Button("Toggle freecam", "", {}, true, {
                        onSelected = function()
                            ToogleNoClip()
                        end,
                    });
                end)

                RageUI.IsVisible(information, function()
                    RageUI.Button("Money: "..GroupDigits(tostring(p:GetMoney())) .. "$", nil, {}, true, {});
                    RageUI.Button("Drift: "..GroupDigits(tostring(math.floor(p:GetDrift()))) .. " point(s)", nil, {}, true, {});
                end)

                RageUI.IsVisible(vehicle, function()
                    for k,v in pairs(p:GetCars()) do
                        RageUI.Button(v.label, nil, {}, true, {
                            onSelected = function()
                                if lastSpawned ~= nil then
                                    TriggerServerEvent("DeleteEntity", lastSpawned)
                                    while DoesEntityExist(NetworkGetEntityFromNetworkId(lastSpawned)) do
                                        Wait(100)
                                    end
                                end
                                local veh = entity:CreateVehicle(v.model, p:pos(), p:heading())
                                lastSpawned = veh:getNetId()
                                TaskWarpPedIntoVehicle(p:ped(), veh:getEntityId(), -1)
                                
                            end,
                        });
                    end
                end)


                RageUI.IsVisible(vehicleOptions, function()
                    RageUI.Button("Random mods", "Apply randoms mods to your vehicle (Will max out perf)", {}, true, {
                        onSelected = function()
                            RandomUpgrade(p:currentVeh())
                        end,
                    });
                    RageUI.Button("Repair", nil, {}, true, {
                        onSelected = function()
                            SetVehicleFixed(p:currentVeh())
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
                    RageUI.Button("Auto Repair", nil, {}, true, {
                        onSelected = function()
                            autoRepair = not autoRepair
                            if autoRepair then
                                ShowNotification("Auto repair activated !")
                            else
                                ShowNotification("Auto repair removed")
                            end
                        end,
                    });

                    -- Submenu
                    RageUI.Button('Vehicle Extra', nil, {RightLabel = ">"}, true, {}, vehicleOptionsExtra);
                    RageUI.Button('Vehicle Liverys', nil, {RightLabel = ">"}, true, {}, vehicleOptionsLivery);
                end)

                RageUI.IsVisible(vehicleOptionsExtra, function()
                    for i = 1,9 do
                        if DoesExtraExist(p:currentVeh(), i) then
                            if IsVehicleExtraTurnedOn(p:currentVeh(), i) then
                                RageUI.Button('Turn Extra #'..i..' - ~r~off', nil, {}, true, {
                                    onSelected = function()
                                        SetVehicleExtra(p:currentVeh(), i, true)
                                    end,
                                }); 
                            else
                                RageUI.Button('Turn Extra #'..i..' ~g~on', nil, {}, true, {
                                    onSelected = function()
                                        SetVehicleExtra(p:currentVeh(), i, false)
                                    end,
                                }); 
                            end
                        end
                    end
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
                    for k,v in pairs(mapsArea) do
                        RageUI.Button(v.label, nil, {}, true, {
                            onSelected = function()
                                p:SetMap(v.map)
                                open = false
                                RageUI.CloseAll()
                                p:Teleport(v.pos.xyz)
                                ExtendWorldBoundaryForPlayer(-9000.0,-11000.0,30.0)
                                ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)
                            end,
                        });
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
                                passive = not passive
                                p:setPassive(passive)
                                TriggerServerEvent("dirft:SetInPassive", passive)
                            end,
                        });
                    else
                        RageUI.Button('Toggle ~r~OFF~s~ passive mod', "Enables or disables the passive mod. This allows to disable collisions with other players/player vehicles, the best anti troll!", {}, true, {
                            onSelected = function()
                                passive = not passive
                                p:setPassive(passive)
                                TriggerServerEvent("dirft:SetInPassive", passive)
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

                Wait(1)
            end
        end)
    end
end

Keys.Register('F1', 'F1', 'Open main menu', function()
    OpenMainMenu()
end)



Citizen.CreateThread(function()
    while not loaded do Wait(1) end
    while true do
        if p:isInVeh() then
            if keepCleanVeh then
                SetVehicleDirtLevel(p:currentVeh(), 0.0)
            end

            if autoRepair then
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
        if p:isPassive() then
            for k,v in pairs(GetActivePlayers()) do
                local pPed = GetPlayerPed(v)
                if pPed ~= p:ped() then
                    --SetEntityAlpha(pPed, 200, 200)
                    SetEntityNoCollisionEntity(p:ped(), pPed, false)

                    if IsPedInAnyVehicle(pPed, false) then
                        local veh = GetVehiclePedIsIn(pPed, false)
                        SetEntityNoCollisionEntity(p:ped(), veh, false)

                        --SetEntityNoCollisionEntity(p:currentVeh(), veh, false)
                        SetEntityCollision(veh, false, true)
                        SetEntityAlpha(veh, 200, 200)
                        cachedEntity[veh] = veh
                    end

                    cachedEntity[pPed] = pPed
                end
            end
        else
            for k,v in pairs(cachedEntity) do
                SetEntityNoCollisionEntity(p:ped(), v, true)
                SetEntityNoCollisionEntity(p:currentVeh(), v, true)
                SetEntityCollision(v, true, true)
                ResetEntityAlpha(v)
                cachedEntity[v] = nil
            end
        end

        for k,v in pairs(playersIdInPassive) do
            local pPed = GetPlayerPed(GetPlayerFromServerId(k))
            if pPed ~= p:ped() then
                print(pPed)
                if IsPedInAnyVehicle(pPed, false) then
                    local veh = GetVehiclePedIsIn(pPed, false)
                    SetEntityNoCollisionEntity(p:ped(), veh, false)
                    SetEntityNoCollisionEntity(p:currentVeh(), veh, false)
                    SetEntityCollision(veh, false, true)
                    SetEntityAlpha(veh, 200, 200)
                    if playersInPassiveVeh[k][veh] == nil then
                        playersInPassiveVeh[k][veh] = veh
                    end

                else
                    for i,j in pairs(playersInPassiveVeh[k]) do
                        ResetEntityAlpha(j)
                        SetEntityNoCollisionEntity(p:ped(), j, true)
                        SetEntityNoCollisionEntity(p:currentVeh(), j, true)
                        SetEntityCollision(j, true, true)
                        playersInPassiveVeh[k][i] = nil 
                    end
                    
                end
            end
        end

        for k,v in pairs(GetActivePlayers()) do
            local pPed = GetPlayerPed(v)
            if playersIdInPassive[GetPlayerServerId(v)] == nil and pPed ~= p:ped() then
                if playersInPassiveVeh[GetPlayerServerId(v)] ~= nil then
                    for i,j in pairs(playersInPassiveVeh[GetPlayerServerId(v)]) do
                        ResetEntityAlpha(j)
                        SetEntityNoCollisionEntity(p:ped(), j, true)
                        SetEntityNoCollisionEntity(p:currentVeh(), j, true)
                        SetEntityCollision(j, true, true)
                    end
                    playersInPassiveVeh[GetPlayerServerId(v)] = nil
                end
            end
        end

        Wait(500)
    end
end)

RegisterNetEvent("dirft:SetInPassive")
AddEventHandler("dirft:SetInPassive", function(list)
    playersIdInPassive = list
    for k,v in pairs(playersIdInPassive) do
        if playersInPassiveVeh[k] == nil then
            playersInPassiveVeh[k] = {}
        end
    end
end)

RegisterNetEvent("drift:GetServerInstance")
AddEventHandler("drift:GetServerInstance", function(info)
    playerInstances = info
end)
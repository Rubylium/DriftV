loaded = false
local first = true
local waitingSpawn = true
Citizen.CreateThread(function()
    TriggerServerEvent("driftV:InitPlayer")
    TriggerServerEvent("drift:GetRaceData")
    player:new()
    loaded = true

    startCinematic()


    SetPlayerInvincible(GetPlayerIndex(), true) 
    RequestIpl('shr_int')
end)

RegisterNetEvent("driftV:RefreshData")
AddEventHandler("driftV:RefreshData", function(data)
    p:SetCars(data.cars)
    p:SetDriftPoint(data.driftPoint)
    p:SetMoney(data.money)
    p:InitSucces(data.succes)
    if first then
        XNL_SetInitialXPLevels(data.xp, true, true)
        first = false
    end
end)

local possibleCam = {
    {
        cam1 = vector3(156.96385192871, -969.41082763672, 30.239265441895),
        cam1fov = 40.0,
        cam1LookTo = vector3(199.42459106445, -975.50848388672, 39.429107666016),

        cam2 = vector3(161.66789245605, -958.15118408203, 30.913440704346),
        cam2fov = 40.0,
        cam2LookTo = vector3(172.57289123535, -952.85040283203, 31.260131835938),
    },

    {
        cam1 = vector3(312.1428527832, -1075.8326416016, 35.809329986572),
        cam1fov = 40.0,
        cam1LookTo = vector3(283.27182006836, -1064.3026123047, 40.848453521729),

        cam2 = vector3(303.07290649414, -1057.5874023438, 37.20724105835),
        cam2fov = 25.0,
        cam2LookTo = vector3(278.88958740234, -1061.4992675781, 40.438632965088),
    },
}

local possibleMusic = {
    "https://cdn.discordapp.com/attachments/582120765923524619/800115108511481896/forza-horizon-4-main-menu-theme-song_1.mp3",
    "https://cdn.discordapp.com/attachments/582120765923524619/800123105620000818/forza-horizon-2-soundtrack-music-menu.mp3",
}

function startCinematic()

    Citizen.CreateThread(function()
        exports.spawnmanager.spawnPlayer()
        cam.create("CAM_1")
        cam.create("CAM_2")

        while waitingSpawn do
            for k,v in pairs(possibleCam) do
                if not waitingSpawn then break end
                DoScreenFadeIn(2000)
                cam.setPos("CAM_1", v.cam1)
                cam.setFov("CAM_1", v.cam1fov)
                cam.lookAtCoords("CAM_1", v.cam1LookTo)
                cam.setActive("CAM_1")
                cam.render("CAM_1", true, false, 0)

                cam.setPos("CAM_2", v.cam2)
                cam.setFov("CAM_2", v.cam2fov)
                cam.lookAtCoords("CAM_2", v.cam2LookTo)

                
                

                cam.setActive("CAM_2")
                cam.switchToCam("CAM_2", "CAM_1", 15000)
                local timer = GetGameTimer() + 10000
                while GetGameTimer() < timer do
                    Wait(1)
                end


                if not waitingSpawn then break end
                DoScreenFadeOut(2000)
                Wait(2100)
            end
            Wait(0)
        end
    end)


    DisplayRadar(false)
    SetNuiFocus(true, true)

    SendNUIMessage({
        containerJoins = true,
        music = possibleMusic[math.random(1,#possibleMusic)]
    })


    
end

RegisterNUICallback('joinServer', function(data)
    waitingSpawn = false
    
    SendNUIMessage({
        joinClick = true
    })

    DoScreenFadeOut(1500)
    Wait(1500)
    DoScreenFadeIn(2000)

    RenderScriptCams(false, false, false, 0, 0)
    SetNuiFocus(false, false)

    cam.delete("CAM_1")
    cam.delete("CAM_2")
    DisplayRadar(true)
    TriggerEvent("FeedM:showNotification", "Welcome back! Press F1 to use the main menu! Have fun on DriftV !", 15000, "info")
end)
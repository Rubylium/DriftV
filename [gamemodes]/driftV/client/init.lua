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
        cam1 = vector3(312.1428527832, -1075.8326416016, 35.809329986572),
        cam1fov = 40.0,
        cam1LookTo = vector3(283.27182006836, -1064.3026123047, 40.848453521729),

        cam2 = vector3(303.07290649414, -1057.5874023438, 37.20724105835),
        cam2fov = 25.0,
        cam2LookTo = vector3(278.88958740234, -1061.4992675781, 40.438632965088),
    },

    {
        cam1 = vector3(148.16539001465, -966.02642822266, 30.458120346069),
        cam1fov = 40.0,
        cam1LookTo = vector3(157.89326477051, -965.76934814453, 26.668348312378),

        cam2 = vector3(155.78352355957, -961.77777099609, 29.756620407104),
        cam2fov = 40.0,
        cam2LookTo = vector3(164.00163269043, -964.53918457031, 31.078117370605),

        entity = {
            model = "gallardosuperlb",
            pos = vector4(159.7520904541, -963.78344726562, 29.609693527222, 120.87365722656),
        },
    },

    
}

-- local possibleMusic = {
--     "https://cdn.discordapp.com/attachments/582120765923524619/800115108511481896/forza-horizon-4-main-menu-theme-song_1.mp3",
--     "https://cdn.discordapp.com/attachments/582120765923524619/800123105620000818/forza-horizon-2-soundtrack-music-menu.mp3",
-- }


local possibleMusic = {
    "forza4",
}

function startCinematic()

    Citizen.CreateThread(function()
        exports.spawnmanager.spawnPlayer()
        cam.create("CAM_1")
        cam.create("CAM_2")

        while waitingSpawn do
            for k,v in pairs(possibleCam) do
                if not waitingSpawn then break end
                local entity = nil
                if v.entity ~= nil then
                    LoadModel(v.entity.model)
                    entity = CreateVehicle(GetHashKey(v.entity.model), v.entity.pos, 0, 1)
                    SetVehicleOnGroundProperly(entity)
                end

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
                if entity ~= nil then
                    DeleteEntity(entity)
                end
            end
            Wait(0)
        end
    end)


    DisplayRadar(false)
    SetNuiFocus(true, true)

    SendNUIMessage({
        containerJoins = true,
        -- music = possibleMusic[math.random(1,#possibleMusic)]
    })
    TriggerEvent("InteractSound_CL:PlayOnOne", possibleMusic[math.random(1,#possibleMusic)], 0.1)


    
end

RegisterNUICallback('joinServer', function(data)
    waitingSpawn = false
    
    SendNUIMessage({
        joinClick = true
    })
    TriggerEvent("InteractSound_CL:Stop")

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
Events = nil
loaded = false
local first = true
local waitingSpawn = true
PlayersCrew = {}
Crew = {}
KingDriftCrew = {
    name = "Nothing",
    elo = 5,
}
CrewRanking = {}

Citizen.CreateThread(function()
    TriggerServerEvent("driftV:InitPlayer")
    TriggerServerEvent("drift:GetRaceData")
    player:new()
    loaded = true

    startCinematic()


    SetPlayerInvincible(GetPlayerIndex(), true) 
    RequestIpl('shr_int')
end)

RegisterNetEvent("syncEvents")
AddEventHandler("syncEvents", function(ev)
    Events = ev
end)

RegisterNetEvent("driftV:RefreshData")
AddEventHandler("driftV:RefreshData", function(data)
    p:SetCars(data.cars)
    p:SetDriftPoint(data.driftPoint)
    p:SetMoney(data.money)
    p:InitSucces(data.succes)
    p:setExp(data.exp)
    p:setCrew(data.crew)
    p:setCrewOwner(data.crewOwner)
end)

RegisterNetEvent("driftV:RefreshOtherPlayerData")
AddEventHandler("driftV:RefreshOtherPlayerData", function(crew, pCrews, king, ranking)
    PlayersCrew = pCrews
    Crew = crew
    KingDriftCrew = king
    CrewRanking = ranking
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


    {
        cam1 = vector3(192.95159912109, -836.13739013672, 31.089879989624),
        cam1fov = 40.0,
        cam1LookTo = vector3(206.22041320801, -848.85394287109, 40.686096191406),

        cam2 = vector3(197.71852111816, -836.44244384766, 31.338581085205),
        cam2fov = 40.0,
        cam2LookTo = vector3(208.77725219727, -835.74896240234, 30.484485626221),

        entity = {
            model = "MGT",
            pos = vector4(204.36486816406, -836.13897705078, 30.082794189453, 106.61936950684),
        },
    },

    {
        cam1 = vector3(10.129093170166, -1039.2365722656, 40.194507598877),
        cam1fov = 40.0,
        cam1LookTo = vector3(51.31010055542, -1060.7592773438, 42.395439147949),

        cam2 = vector3(16.206436157227, -1032.8468017578, 38.448574066162),
        cam2fov = 15.0,
        cam2LookTo = vector3(42.028846740723, -1044.5616455078, 29.974588394165),

        entity = {
            model = "civicek9rb",
            pos = vector4(44.152702331543, -1045.0297851562, 29.271499633789, 35.5514793396),
        },
    },

    {
        cam1 = vector3(3.3169457912445, -1098.3217773438, 37.447479248047),
        cam1fov = 40.0,
        cam1LookTo = vector3(1.9109898805618, -1091.5941162109, 41.841613769531),

        cam2 = vector3(0.42559587955475, -1099.4879150391, 37.477561950684),
        cam2fov = 35.0,
        cam2LookTo = vector3(-1.1451488733292, -1098.0169677734, 37.779384613037),

        entity = {
            model = "FD",
            pos = vector4(-2.7889626026154, -1096.8220214844, 37.849876403809, 68.590965270996),
        },
    },

    {
        cam1 = vector3(-60.137535095215, -1111.6331787109, 28.331649780273),
        cam1fov = 40.0,
        cam1LookTo = vector3(-66.277770996094, -1113.6544189453, 30.822368621826),

        cam2 = vector3(-65.160697937012, -1107.6329345703, 26.849964141846),
        cam2fov = 35.0,
        cam2LookTo = vector3(-73.790664672852, -1106.6363525391, 25.570594787598),

        entity = {
            model = "gtr",
            pos = vector4(-72.35034942627, -1107.6314697266, 25.253856658936, 106.37840270996),
        },
    },

    
}

local possibleMusic = {
    "forza4",
    "forza2",
    "forza4-2",
    "forza4-3",
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
                    SetVehicleDirtLevel(entity, 0.0)
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


                if not waitingSpawn then DeleteEntity(entity) break end
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
    local music = possibleMusic[math.random(1,#possibleMusic)]
    TriggerEvent("InteractSound_CL:PlayOnOne", music, 0.07)


    
end

RegisterNUICallback('joinServer', function(data)
    if not waitingSpawn then
        return
    end
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
    --TriggerEvent("FeedM:showNotification", "Welcome back! Press F1 to use the main menu! Have fun on DriftV !", 15000, "info")
    SetAudioFlag("LoadMPData", true)
    SetBigmapActive(false, false)
    EnableLobby()
end)
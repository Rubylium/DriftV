local loadingMusic = {
    "crewWarLoadingMap_1",
    "crewWarLoadingMap_2"
}
local startingMusic = {
    --"crewWarStart_1",
    "crewWarStart_3"
    --"crewWarStart_2", -- Need intro change
}
local crewWarMaps = {
    {
        label = "Ebisu Drift race",
        start =  vector4(963.13128662109, 1062.2911376953, 459.47320556641, 279.91229248047),
        price = 10000,
        pointPerSec = 750,
        speedLimit = 40,
        voted = false,
        points = {
            {pos = vector4(1030.7563476562, 1117.5638427734, 458.73199462891, 65.086318969727), passed = false},
            {pos = vector4(970.18060302734, 1128.7644042969, 460.21350097656, 354.3141784668), passed = false},
            {pos = vector4(823.22985839844, 1244.6904296875, 460.45593261719, 60.095832824707), passed = false},
            {pos = vector4(786.90765380859, 1208.9810791016, 463.76522827148, 50.014312744141), passed = false},
            {pos = vector4(967.17517089844, 1072.5148925781, 458.39178466797, 261.29092407227), passed = false},
        },

        camCinematic = {
            {
                cam1 = vector3(701.47882080078, 1281.3470458984, 490.5205078125),
                cam1fov = 40.0,
                cam1LookTo = vector3(709.77319335938, 1275.9268798828, 474.48480224609),
        
                cam2 = vector3(752.69177246094, 1244.7911376953, 476.33471679688),
                cam2fov = 35.0,
                cam2LookTo = vector3(817.79528808594, 1195.453125, 470.01055908203),
            },
            {
                cam1 = vector3(956.39971923828, 1067.9061279297, 463.07516479492),
                cam1fov = 40.0,
                cam1LookTo = vector3(908.70178222656, 1130.1066894531, 460.48919677734),
        
                cam2 = vector3(941.69622802734, 1083.7308349609, 460.6741027832),
                cam2fov = 35.0,
                cam2LookTo = vector3(908.70178222656, 1130.1066894531, 460.48919677734),
            },
            {
                cam1 = vector3(862.87774658203, 1124.0187988281, 469.32223510742),
                cam1fov = 40.0,
                cam1LookTo = vector3(964.13861083984, 1119.5717773438, 460.560546875),
        
                cam2 = vector3(868.06677246094, 1130.2045898438, 469.82220458984),
                cam2fov = 35.0,
                cam2LookTo = vector3(964.13861083984, 1119.5717773438, 460.560546875),
            },
        }
    },
    {
        label = "Haruna Drift Race",
        price = 15000,
        pointPerSec = 3000,
        speedLimit = 55,
        start =  vector4(2207.2216796875, -1905.7115478516, 585.87384033203, 181.34503173828),
        points = {
            {pos = vector4(2205.0871582031, -2020.2974853516, 577.94848632812, 165.34571838379), passed = false},
            {pos = vector4(2141.7658691406, -2171.6223144531, 571.142578125, 191.59320068359), passed = false},
            {pos = vector4(2337.7790527344, -2244.7087402344, 561.29846191406, 215.27554321289), passed = false},
            {pos = vector4(2290.6772460938, -2401.6247558594, 546.73114013672, 38.461730957031), passed = false},
            {pos = vector4(2164.3366699219, -2243.2141113281, 528.45782470703, 40.442783355713), passed = false},
            {pos = vector4(2145.2712402344, -2308.1735839844, 517.30572509766, 214.21351623535), passed = false},
            {pos = vector4(2190.3349609375, -2525.943359375, 497.30453491211, 191.55278015137), passed = false},
            {pos = vector4(2153.2905273438, -2521.9033203125, 489.39840698242, 335.50405883789), passed = false},
            {pos = vector4(2114.3662109375, -2521.357421875, 480.96377563477, 181.55335998535), passed = false},
            {pos = vector4(1953.7915039062, -2667.486328125, 472.62411499023, 94.786346435547), passed = false},
            {pos = vector4(1976.9323730469, -2737.7243652344, 464.35833740234, 91.227806091309), passed = false},
            {pos = vector4(1989.1262207031, -2800.2355957031, 456.03741455078, 97.961044311523), passed = false},
            {pos = vector4(1754.5462646484, -2950.4006347656, 444.82266235352, 156.30958557129), passed = false},
            {pos = vector4(1946.0216064453, -3007.1142578125, 428.74313354492, 296.05410766602), passed = false},
            {pos = vector4(2202.0407714844, -2937.4582519531, 411.19351196289, 266.79861450195), passed = false},
            {pos = vector4(2295.5231933594, -2886.9582519531, 394.14147949219, 151.33538818359), passed = false},
            {pos = vector4(1958.8792724609, -3106.41015625, 367.9697265625, 118.49903869629), passed = false},
            {pos = vector4(1667.9271240234, -3118.4602050781, 358.21978759766, 68.622505187988), passed = false},
            {pos = vector4(1686.8492431641, -3187.4653320312, 346.81802368164, 263.66915893555), passed = false},
            {pos = vector4(1876.7957763672, -3287.7309570312, 327.89926147461, 236.68955993652), passed = false},
            {pos = vector4(2088.74609375, -3381.8364257812, 319.07901000977, 201.40000915527), passed = false},
            {pos = vector4(2101.6103515625, -3632.1293945312, 304.8010559082, 163.16390991211), passed = false},
            {pos = vector4(1997.8986816406, -3676.8547363281, 296.03057861328, 95.959030151367), passed = false},
            {pos = vector4(2039.1984863281, -3828.5383300781, 281.69732666016, 271.16058349609), passed = false},
            {pos = vector4(2000.3018798828, -3897.9001464844, 264.0732421875, 98.487823486328), passed = false},
            {pos = vector4(1745.4826660156, -3795.7080078125, 229.02404785156, 324.69934082031), passed = false},
            {pos = vector4(1604.5797119141, -3765.826171875, 215.2425994873, 155.35623168945), passed = false},
            {pos = vector4(1441.17578125, -3709.9890136719, 202.99952697754, 17.348400115967), passed = false},
            {pos = vector4(1386.9359130859, -3819.2919921875, 191.69519042969, 185.72958374023), passed = false},
            {pos = vector4(1230.5216064453, -3905.8764648438, 181.70294189453, 40.59302520752), passed = false},
            {pos = vector4(1081.1395263672, -3960.2990722656, 169.47979736328, 186.30921936035), passed = false},
            {pos = vector4(931.72888183594, -4183.8403320312, 151.26002502441, 147.89660644531), passed = false},
            {pos = vector4(842.40710449219, -4525.7485351562, 123.97175598145, 188.77043151855), passed = false},
        },
        camCinematic = {
            {
                cam1 = vector3(2380.8908691406, -2203.5341796875, 602.6044921875),
                cam1fov = 40.0,
                cam1LookTo = vector3(2201.4768066406, -2229.2041015625, 571.43646240234),
        
                cam2 = vector3(2358.1032714844, -2206.7209472656, 594.04797363281),
                cam2fov = 35.0,
                cam2LookTo = vector3(2201.4768066406, -2229.2041015625, 571.43646240234),
            },
            {
                cam1 = vector3(1710.8853759766, -4024.5168457031, 279.98907470703),
                cam1fov = 40.0,
                cam1LookTo = vector3(1701.2313232422, -4018.9089355469, 284.12942504883),
        
                cam2 = vector3(1724.4012451172, -4032.361328125, 274.19323730469),
                cam2fov = 35.0,
                cam2LookTo = vector3(1701.2313232422, -4018.9089355469, 284.12942504883),
            },
            {
                cam1 = vector3(1073.98828125, -4060.0087890625, 168.28031921387),
                cam1fov = 40.0,
                cam1LookTo = vector3(1048.8935546875, -4013.5478515625, 173.7041015625),
        
                cam2 = vector3(1084.7036132812, -4032.8857421875, 166.87252807617),
                cam2fov = 35.0,
                cam2LookTo = vector3(1083.7735595703, -3984.4045410156, 169.47267150879),
            },
        }
    },
    {
        label = "Hakone Ohiradai",
        price = 15000,
        pointPerSec = 1500,
        speedLimit = 49,
        start =  vector4(-4330.0463867188, -4615.9516601562, 150.9341583252, 351.76547241211),
        points = {
            {pos = vector4(-4370.8544921875, -4236.6669921875, 156.77291870117, 307.23013305664), passed = false},
            {pos = vector4(-4337.1616210938, -4135.1987304688, 155.56088256836, 32.008346557617), passed = false},
            {pos = vector4(-4293.556640625, -3965.9389648438, 154.45910644531, 292.59219360352), passed = false},
            {pos = vector4(-4376.7534179688, -3767.2392578125, 145.20780944824, 16.220779418945), passed = false},
            {pos = vector4(-4307.7124023438, -3650.3283691406, 141.69039916992, 10.491148948669), passed = false},
            {pos = vector4(-4491.5571289062, -3535.6274414062, 133.88722229004, 102.83293914795), passed = false},
        },
        camCinematic = {
            {
                cam1 = vector3(-4332.5200195312, -4470.1196289062, 155.41302490234),
                cam1fov = 40.0,
                cam1LookTo = vector3(-4357.7158203125, -4353.3994140625, 156.7844543457),
        
                cam2 = vector3(-4347.8984375, -4407.5366210938, 156.07177734375),
                cam2fov = 35.0,
                cam2LookTo = vector3(-4357.7158203125, -4353.3994140625, 156.7844543457),
            },
            {
                cam1 = vector3(-4245.9028320312, -3949.3225097656, 156.0704498291),
                cam1fov = 40.0,
                cam1LookTo = vector3(-4245.2958984375, -3925.9655761719, 156.06732177734),
        
                cam2 = vector3(-4231.2309570312, -3942.5634765625, 156.05462646484),
                cam2fov = 35.0,
                cam2LookTo = vector3(-4245.2958984375, -3925.9655761719, 156.06732177734),
            },
            {
                cam1 = vector3(-4291.1826171875, -3617.0961914062, 149.07235717773),
                cam1fov = 40.0,
                cam1LookTo = vector3(-4348.1264648438, -3568.9152832031, 139.67498779297),
        
                cam2 = vector3(-4314.5620117188, -3597.365234375, 145.23533630371),
                cam2fov = 35.0,
                cam2LookTo = vector3(-4348.1264648438, -3568.9152832031, 139.67498779297),
            },
        }
    },
    {
        label = "Hakone Nanamagari",
        price = 10000,
        pointPerSec = 750,
        speedLimit = 30,
        start =  vector4(-3315.5678710938, 106.1442489624, 133.66456604004, 166.84454345703),
        points = {
            {pos = vector4(-3348.3273925781, 20.953716278076, 124.79309082031, 2.0219919681549), passed = false},
            {pos = vector4(-3359.953125, 104.76797485352, 119.0277557373, 128.85185241699), passed = false},
            {pos = vector4(-3405.53515625, 123.92734527588, 103.20555877686, 114.98023223877), passed = false},
            {pos = vector4(-3435.9731445312, 19.809186935425, 93.895538330078, 69.338043212891), passed = false},
            {pos = vector4(-3474.9020996094, 97.70059967041, 80.163208007812, 183.88726806641), passed = false},
            {pos = vector4(-3519.7687988281, 23.791673660278, 70.536140441895, 330.82345581055), passed = false},
            {pos = vector4(-3558.1000976562, 78.191139221191, 60.505268096924, 219.40840148926), passed = false},
            {pos = vector4(-3554.66015625, -10.606527328491, 53.495666503906, 27.373497009277), passed = false},
            {pos = vector4(-3627.7741699219, -12.655278205872, 30.566467285156, 232.22280883789), passed = false},
            {pos = vector4(-3668.3010253906, -36.083034515381, 19.026634216309, 220.3563079834), passed = false},
        
        },
        camCinematic = {
            {
                cam1 = vector3(-3356.4621582031, 35.896385192871, 126.72998809814),
                cam1fov = 40.0,
                cam1LookTo = vector3(-3348.9541015625, 95.373901367188, 121.15419006348),
        
                cam2 = vector3(-3358.5651855469, 16.61537361145, 134.68630981445),
                cam2fov = 35.0,
                cam2LookTo = vector3(-3348.9541015625, 95.373901367188, 121.15419006348),
            },
            {
                cam1 = vector3(-3399.4045410156, 58.078052520752, 113.77875518799),
                cam1fov = 40.0,
                cam1LookTo = vector3(-3397.3493652344, 91.261947631836, 109.0728225708),
        
                cam2 = vector3(-3394.3735351562, 27.943910598755, 119.94821166992),
                cam2fov = 35.0,
                cam2LookTo = vector3(-3397.3493652344, 91.261947631836, 109.0728225708),
            },
            {
                cam1 = vector3(-3535.9758300781, -39.200572967529, 63.853160858154),
                cam1fov = 40.0,
                cam1LookTo = vector3(-3528.8605957031, -4.3119902610779, 59.478179931641),
        
                cam2 = vector3(-3534.1137695312, -22.647605895996, 60.689563751221),
                cam2fov = 35.0,
                cam2LookTo = vector3(-3528.8605957031, -4.3119902610779, 59.478179931641),
            },
        }
    },
    {
        label = "Tsukurimono Touge",
        price = 25000,
        pointPerSec = 350,
        speedLimit = 30,
        start =  vector4(-1098.2868652344, 2427.6655273438, 727.99432373047, 46.58423614502),
        points = {
            {pos = vector4(-1208.0072021484, 2495.30859375, 728.87322998047, 195.54058837891), passed = false},
            {pos = vector4(-1218.2220458984, 2218.3908691406, 719.84051513672, 195.54058837891), passed = false},
            {pos = vector4(-1236.0985107422, 2158.5764160156, 712.78332519531, 195.54058837891), passed = false},
            {pos = vector4(-1210.5649414062, 2063.4372558594, 705.06323242188, 195.54058837891), passed = false},
            {pos = vector4(-1144.0485839844, 1954.1268310547, 696.13226318359, 195.54058837891), passed = false},
            {pos = vector4(-1205.4399414062, 1835.8336181641, 681.95349121094, 195.54058837891), passed = false},
            {pos = vector4(-1257.9351806641, 1934.5750732422, 679.65264892578, 195.54058837891), passed = false},
            {pos = vector4(-1304.5349121094, 1824.9946289062, 669.87390136719, 195.54058837891), passed = false},
            {pos = vector4(-1315.3598632812, 1677.9663085938, 667.44213867188, 195.54058837891), passed = false},
            {pos = vector4(-1385.0775146484, 1647.8972167969, 664.13269042969, 195.54058837891), passed = false},
            {pos = vector4(-1414.9454345703, 1789.1306152344, 661.56805419922, 195.54058837891), passed = false},
            {pos = vector4(-1518.3214111328, 1735.7098388672, 658.10699462891, 195.54058837891), passed = false},
            {pos = vector4(-1585.5703125, 1606.3151855469, 656.32727050781, 195.54058837891), passed = false},
            {pos = vector4(-1575.0268554688, 1550.2543945312, 658.5986328125, 195.54058837891), passed = false},
            {pos = vector4(-1444.8648681641, 1525.1784667969, 661.80773925781, 195.54058837891), passed = false},
            {pos = vector4(-1377.1483154297, 1515.8287353516, 663.67175292969, 195.54058837891), passed = false},
            {pos = vector4(-1284.9569091797, 1557.0389404297, 666.9248046875, 195.54058837891), passed = false},
            {pos = vector4(-1324.5838623047, 1435.3096923828, 661.38195800781, 195.54058837891), passed = false},
            {pos = vector4(-1260.7028808594, 1281.2862548828, 656.05407714844, 195.54058837891), passed = false},

        
        },
        camCinematic = {
            {
                cam1 = vector3(-1227.9432373047, 2452.052734375, 736.85485839844),
                cam1fov = 40.0,
                cam1LookTo = vector3(-1223.7800292969, 2272.0888671875, 722.15600585938),
        
                cam2 = vector3(-1227.2655029297, 2401.6403808594, 728.90008544922),
                cam2fov = 35.0,
                cam2LookTo = vector3(-1223.7800292969, 2272.0888671875, 722.15600585938),
            },
            {
                cam1 = vector3(-1201.5134277344, 1909.8729248047, 696.84802246094),
                cam1fov = 40.0,
                cam1LookTo = vector3(-1176.5866699219, 1968.7086181641, 695.88500976562),
        
                cam2 = vector3(-1196.5328369141, 1949.2639160156, 696.88702392578),
                cam2fov = 35.0,
                cam2LookTo = vector3(-1206.5650634766, 1999.5201416016, 699.59545898438),
            },
            {
                cam1 = vector3(-1393.9434814453, 1741.2365722656, 677.30828857422),
                cam1fov = 40.0,
                cam1LookTo = vector3(-1396.7902832031, 1696.1325683594, 666.95782470703),
        
                cam2 = vector3(-1374.7348632812, 1738.7664794922, 675.85070800781),
                cam2fov = 35.0,
                cam2LookTo = vector3(-1359.5610351562, 1717.4990234375, 669.01025390625),
            },
        }
    },
}

local warInfo = {}
local lobby = vector3(1107.04, -3157.399, -37.51859)
local warEndLobby = vector3(229.73329162598, -885.22637939453, 30.949995040894)
local lobbyIpl = "bkr_biker_interior_placement_interior_0_biker_dlc_int_01_milo"
local fightAgainst = ""
local warID = 0
local votedMap = nil
local inMapVote = false
local voted = false
local choosenMap = {}
local maps = RageUI.CreateMenu("DriftV", "Welcome to the drift paradise")
maps.Closable = false
local inMapLoad = false
local inVehLoad = false
local veh = RageUI.CreateMenu("DriftV", "Welcome to the drift paradise")
veh.Closable = false
local displayScoreBoard = false
local displayTempScoreboard = false

-- Step 1
function JoinCrewWarLobby()

    if p:isInVeh() then
        DeleteEntity(p:currentVeh())
    end

    RequestIpl(lobbyIpl)
    TriggerEvent("InteractSound_CL:PlayOnOne", startingMusic[math.random(1,#startingMusic)], 0.07)
    p:Teleport(lobby)
    TogglePasive(true)
end


-- Step 2
function StartMapVote()

    local timer = 30
    local timeBar = NativeUI.TimerBarPool()
    local time = NativeUI.CreateTimerBar("Map vote:")
    time:SetTextTimerBar(timer.."s")
    timeBar:Add(time)


    Citizen.CreateThread(function()
        while inMapVote do
            timer = timer - 1
            time:SetTextTimerBar(timer.."s")
            Wait(1000)
        end
    end)

    Citizen.CreateThread(function()
        while inMapVote do
            timeBar:Draw()
            Wait(1)
        end
    end)

    RageUI.Visible(maps, true)
    while inMapVote do
        RageUI.IsVisible(maps, function()
            RageUI.Separator("Vote for the war map!")
            for k,v in pairs(crewWarMaps) do
                if not voted then
                    RageUI.Button(v.label, nil, {RightLabel = ">"}, true, {
                        onSelected = function()
                            TriggerServerEvent("crew:CrewWarsVoteForMap", v.label, warID)
                            ShowNotification("You voted for ~o~"..v.label)
                            voted = true
                            v.voted = true
                        end,
                    });
                else
                    if v.voted then
                        RageUI.Button(v.label, nil, {RightLabel = "~g~VOTED"}, false, {});
                    else
                        RageUI.Button(v.label, nil, {}, false, {});
                    end
                end
            end
        end)
        Wait(0)
    end
    RageUI.Visible(maps, false)
end

-- Step 3
function StartMapLoad(name)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do Wait(1) end
    TriggerEvent("InteractSound_CL:Stop")
    TriggerEvent("InteractSound_CL:PlayOnOne", loadingMusic[math.random(1,#loadingMusic)], 0.07)
    local map
    for k,v in pairs(crewWarMaps) do
        if v.label == name then
            map = v
            break
        end
    end
    choosenMap = map

    FreezeEntityPosition(p:ped(), true)
    SetEntityCoordsNoOffset(p:ped(), map.start.xyz, 0.0, 0.0, 0.0)

    local timer = 30
    local timeBar = NativeUI.TimerBarPool()
    local time = NativeUI.CreateTimerBar("Loading map:")
    time:SetTextTimerBar(timer.."s")
    timeBar:Add(time)


    Citizen.CreateThread(function()
        while inMapLoad do
            timer = timer - 1
            time:SetTextTimerBar(timer.."s")
            Wait(1000)
        end
    end)

    Citizen.CreateThread(function()
        while inMapLoad do
            timeBar:Draw()
            Wait(1)
        end
    end)

    Citizen.CreateThread(function()
        while inMapLoad do
            local baseX = 0.3 -- gauche / droite ( plus grand = droite )
            local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.3 -- Longueur
            local baseHeight = 0.03 -- Epaisseur
            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
            DrawTexts(baseX, baseY - (0.043) - 0.013, warInfo.crew1.name, true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
    
            DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
            DrawTexts(baseX - 0.140, baseY - 0.013, "name", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX - 0.060, baseY - 0.013, "level", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title

            local i = 1
            for k,v in pairs(warInfo.crew1.members) do
                DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                DrawTexts(baseX - 0.140, baseY + (0.032 * i) - 0.013, v.name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
                DrawTexts(baseX - 0.060, baseY + (0.032 * i) - 0.013, GetPlayerLevelFromXp(v.exp), false, 0.35, {255, 255, 255, 255}, 6, 0) -- drift score
                i = i + 1
            end
    
            local baseX = 0.7 -- gauche / droite ( plus grand = droite )
            local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.3 -- Longueur
            local baseHeight = 0.03 -- Epaisseur
    
            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
            DrawTexts(baseX, baseY - (0.043) - 0.013, warInfo.crew2.name, true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
    
            DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
            DrawTexts(baseX - 0.140, baseY - 0.013, "name", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX - 0.060, baseY - 0.013, "level", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title

            local i = 1
            for k,v in pairs(warInfo.crew2.members) do
                DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                DrawTexts(baseX - 0.140, baseY + (0.032 * i) - 0.013, v.name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
                DrawTexts(baseX - 0.060, baseY + (0.032 * i) - 0.013, GetPlayerLevelFromXp(v.exp), false, 0.35, {255, 255, 255, 255}, 6, 0) -- drift score
                i = i + 1
            end
            Wait(1)
        end
    end)


    -- Cam animation

    cam.create("CAM_1")
    cam.create("CAM_2")

    while inMapLoad do
        for k,v in pairs(map.camCinematic) do
            if not inMapLoad then break end

            DoScreenFadeIn(1000)
            cam.setPos("CAM_1", v.cam1)
            cam.setFov("CAM_1", v.cam1fov)
            cam.lookAtCoords("CAM_1", v.cam1LookTo)
            cam.setActive("CAM_1")
            cam.render("CAM_1", true, false, 0)
            cam.setPos("CAM_2", v.cam2)
            cam.setFov("CAM_2", v.cam2fov)
            cam.lookAtCoords("CAM_2", v.cam2LookTo)
            
            
            cam.setActive("CAM_2")
            cam.switchToCam("CAM_2", "CAM_1", 13000)
            local timer = GetGameTimer() + 10000
            while GetGameTimer() < timer do
                if not inMapLoad then
                    break 
                end
                Wait(1)
            end

            if not inMapLoad then
                break 
            end
            DoScreenFadeOut(1000)
            Wait(1100)
        end
        Wait(0)
    end

    FreezeEntityPosition(p:ped(), false)
    cam.delete("CAM_1")
    cam.delete("CAM_2")
end


-- Step 4
function StartVehLoad()

    local timer = 15
    local timeBar = NativeUI.TimerBarPool()
    local time = NativeUI.CreateTimerBar("Choose your vehicle:")
    time:SetTextTimerBar(timer.."s")
    timeBar:Add(time)


    Citizen.CreateThread(function()
        while inVehLoad do
            timer = timer - 1
            time:SetTextTimerBar(timer.."s")
            Wait(1000)
        end
    end)

    Citizen.CreateThread(function()
        while inVehLoad do
            timeBar:Draw()
            Wait(1)
        end
    end)

    RageUI.Visible(veh, true)
    while inVehLoad do
        RageUI.IsVisible(veh, function()
            RageUI.Separator("Choose your vehicle")
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
        Wait(0)
    end
    RageUI.Visible(veh, false)
end


-- Step 5
function StartCrewWarRace(data)
    inRace = true
    ResetDriftPoint()
    SetPlayerInRace(true)
    local raceStopped = false

    SetPedCoordsKeepVehicle(p:ped(), data.start.xyz)
    SetEntityHeading(p:currentVeh(), data.start.w)
    FreezeEntityPosition(p:currentVeh(), true)
    ChangeSpeedLimit(data.speedLimit)
    TogglePasive(true)

    cam.create("CAM_1")
    cam.create("CAM_2")


    local countDown = 3
    local posToGo = {
       {pos = GetOffsetFromEntityInWorldCoords(p:currentVeh(), 0.0, 0.0, 8.0)}, -- up
       {pos = GetOffsetFromEntityInWorldCoords(p:currentVeh(), 0.0, 8.0, 0.0)}, -- front
       {pos = GetOffsetFromEntityInWorldCoords(p:currentVeh(), 0.0, -8.0, 5.0)}, -- back
    }

    for i = 1,3 do
        Subtitle("Drift race in ~b~"..countDown, 1000)
        PlaySoundFrontend(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 1)

        local rPos = vector3(0.0, 0.0, 0.0)
        if i ~= 3 then
            rPos = vector3(posToGo[i].pos.x + math.random(-1,1), posToGo[i].pos.y + math.random(-1,1), posToGo[i].pos.z + math.random(1,2))
        else
            rPos = vector3(posToGo[i].pos.x, posToGo[i].pos.y, posToGo[i].pos.z - 2)
        end

        cam.setPos("CAM_1", posToGo[i].pos)
        cam.setFov("CAM_1", 60.0)
        cam.lookAtCoords("CAM_1", p:pos())
        cam.setActive("CAM_1")
        cam.render("CAM_1", true, false, 0)

        cam.setPos("CAM_2", rPos)
        cam.setFov("CAM_2", 45.0)
        cam.lookAtCoords("CAM_2", p:pos())
        

        cam.setActive("CAM_2")
        cam.switchToCam("CAM_2", "CAM_1", 1500)

        Wait(1000)
        countDown = countDown - 1
    end

    Citizen.CreateThread(function()
        SetGameplayCamRelativeHeading(0.0)
        cam.render("CAM_2", false, true, 1000)
        Wait(1000)
        cam.delete("CAM_1")
        cam.delete("CAM_2")
    end)


    local startTime = GetGameTimer()
    PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 1)
    FreezeEntityPosition(p:currentVeh(), false)

    local blip = AddBlipForCoord(data.start.xyz)


    timeBar = NativeUI.TimerBarPool()

    local time = NativeUI.CreateTimerBar("Time:")
    time:SetTextTimerBar("20s")
    timeBar:Add(time)

    local checkpoints = NativeUI.CreateTimerBar("Checkpoints:")
    checkpoints:SetTextTimerBar("??/??")
    timeBar:Add(checkpoints)

    local distance = NativeUI.CreateTimerBar("Distance:")
    distance:SetTextTimerBar("??m")
    timeBar:Add(distance)

    for k,v in pairs(data.points) do
        SetBlipCoords(blip, v.pos.xyz)
        local timer = GetGameTimer() + 20000
        checkpoints:SetTextTimerBar(k.."/"..#data.points)
        local dst = #(v.pos.xyz - p:pos())
        while dst > 10.0 and not raceStopped do
            dst = math.floor(#(v.pos.xyz - p:pos()))
            DrawMarker(5, v.pos.xyz, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 235, 229, 52, 170, 0, 1, 2, 0, nil, nil, 0)
            DrawMarker(0, v.pos.x, v.pos.y, v.pos.z + 1.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 30.0, 66, 245, 111, 170, 0, 1, 2, 0, nil, nil, 0)

            if GetGameTimer() >= timer then
                raceStopped = true
            end

            time:SetTextTimerBar(tostring(math.floor((timer - GetGameTimer()) / 1000)))
            distance:SetTextTimerBar(tostring(dst).."m")

            timeBar:Draw()
            Wait(1)
        end
        if not raceStopped then
            PlaySoundFrontend(-1, "RACE_PLACED", "HUD_AWARDS")
        end

    end
    PlaySoundFrontend(-1, "ScreenFlash", "WastedSounds")
    RemoveBlip(blip)

    local endPoints = GetCurrentDriftPoint()
    if raceStopped then
        endPoints = 0
    end
    
    local endTime = GetGameTimer()
    local raceTime = endTime - startTime
    local raceSecond = math.floor(raceTime / 1000)

    local driftScore = endPoints
    endPoints = (endPoints - raceSecond * data.pointPerSec)

    if endPoints < 0 then
        endPoints = 0
    end

    TriggerServerEvent("crew:CrewCarsAddScore", warID, p:getCrew(), endPoints, driftScore, raceSecond)
    DeleteEntity(p:currentVeh())
    displayTempScoreboard = true

    TeleportPlayer(lobby)
    AnimpostfxPlay("MP_Celeb_Win", -1, true)
    Citizen.CreateThread(function()
        while displayTempScoreboard do
            local baseX = 0.3 -- gauche / droite ( plus grand = droite )
            local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.3 -- Longueur
            local baseHeight = 0.03 -- Epaisseur
            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
            DrawTexts(baseX, baseY - (0.043) - 0.013, p:getCrew() .. " CREW", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, "Total: ", true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
    
            DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
            DrawTexts(baseX - 0.140, baseY - 0.013, "crew members", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX - 0.060, baseY - 0.013, "drift score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.020, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.080, baseY - 0.013, "final score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title

            local i = 1
            for k,v in pairs(warInfo.indiScores[p:getCrew()]) do
                DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                DrawTexts(baseX - 0.140, baseY + (0.032 * i) - 0.013, v.name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
                DrawTexts(baseX - 0.060, baseY + (0.032 * i) - 0.013, GroupDigits(v.driftScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- drift score
                DrawTexts(baseX + 0.020, baseY + (0.032 * i) - 0.013, v.time, false, 0.35, {255, 255, 255, 255}, 6, 0) -- time
                DrawTexts(baseX + 0.080, baseY + (0.032 * i) - 0.013, GroupDigits(v.finalScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- final score

                i = i + 1
            end
    
            local baseX = 0.7 -- gauche / droite ( plus grand = droite )
            local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.3 -- Longueur
            local baseHeight = 0.03 -- Epaisseur
    
            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
            DrawTexts(baseX, baseY - (0.043) - 0.013, fightAgainst .. " CREW", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, "Total: ", true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
    
            DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
            DrawTexts(baseX - 0.140, baseY - 0.013, "crew members", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX - 0.060, baseY - 0.013, "drift score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.020, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.080, baseY - 0.013, "final score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title

            local i = 1
            for k,v in pairs(warInfo.indiScores[fightAgainst]) do
                DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                DrawTexts(baseX - 0.140, baseY + (0.032 * i) - 0.013, v.name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
                DrawTexts(baseX - 0.060, baseY + (0.032 * i) - 0.013, GroupDigits(v.driftScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- drift score
                DrawTexts(baseX + 0.020, baseY + (0.032 * i) - 0.013, v.time, false, 0.35, {255, 255, 255, 255}, 6, 0) -- time
                DrawTexts(baseX + 0.080, baseY + (0.032 * i) - 0.013, GroupDigits(v.finalScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- final score

                i = i + 1
            end
            Wait(0)
        end
        AnimpostfxStopAll()
    end)


    SetPlayerInRace(false)
end


-- Step 6
function DisplayCrewWarScoreboard()
    TeleportPlayer(warEndLobby)

    AnimpostfxPlay("MP_Celeb_Win", -1, true)

    Citizen.CreateThread(function()
        while displayScoreBoard do


            local baseX = 0.3 -- gauche / droite ( plus grand = droite )
            local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.3 -- Longueur
            local baseHeight = 0.03 -- Epaisseur
            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
            DrawTexts(baseX, baseY - (0.043) - 0.013, p:getCrew() .. " CREW", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, "Total: ", true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
    
            DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
            DrawTexts(baseX - 0.140, baseY - 0.013, "crew members", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX - 0.060, baseY - 0.013, "drift score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.020, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.080, baseY - 0.013, "final score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title

            local i = 1
            for k,v in pairs(warInfo.indiScores[p:getCrew()]) do
                DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                DrawTexts(baseX - 0.140, baseY + (0.032 * i) - 0.013, v.name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
                DrawTexts(baseX - 0.060, baseY + (0.032 * i) - 0.013, GroupDigits(v.driftScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- drift score
                DrawTexts(baseX + 0.020, baseY + (0.032 * i) - 0.013, v.time, false, 0.35, {255, 255, 255, 255}, 6, 0) -- time
                DrawTexts(baseX + 0.080, baseY + (0.032 * i) - 0.013, GroupDigits(v.finalScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- final score

                i = i + 1
            end
    
            local baseX = 0.7 -- gauche / droite ( plus grand = droite )
            local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.3 -- Longueur
            local baseHeight = 0.03 -- Epaisseur
    
            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
            DrawTexts(baseX, baseY - (0.043) - 0.013, fightAgainst .. " CREW", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, "Total: ", true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
    
            DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
            DrawTexts(baseX - 0.140, baseY - 0.013, "crew members", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX - 0.060, baseY - 0.013, "drift score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.020, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.080, baseY - 0.013, "final score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title

            local i = 1
            for k,v in pairs(warInfo.indiScores[fightAgainst]) do
                DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                DrawTexts(baseX - 0.140, baseY + (0.032 * i) - 0.013, v.name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
                DrawTexts(baseX - 0.060, baseY + (0.032 * i) - 0.013, GroupDigits(v.driftScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- drift score
                DrawTexts(baseX + 0.020, baseY + (0.032 * i) - 0.013, v.time, false, 0.35, {255, 255, 255, 255}, 6, 0) -- time
                DrawTexts(baseX + 0.080, baseY + (0.032 * i) - 0.013, GroupDigits(v.finalScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- final score

                i = i + 1
            end


            ShowHelpNotification("Press ~INPUT_CELLPHONE_CANCEL~ to close result")
            DisableAllControlActions(0)
            if IsDisabledControlJustPressed(0, 177) then
                displayScoreBoard = false
            end
    
            if IsDisabledControlJustPressed(0, 176) then
                displayScoreBoard = false
            end
    
            if IsDisabledControlJustPressed(0, 179) then
                displayScoreBoard = false
            end
            Wait(0)
        end
        AnimpostfxStopAll()
    end)



end


-- Step 1
RegisterNetEvent("crew:CrewWarAboutToStart")
AddEventHandler("crew:CrewWarAboutToStart", function(crew2, warid)
    LeaveGarage(false, false)
    DisplayLittleSucces("crew war against ~b~"..crew2, false, 6000)
    fightAgainst = crew2
    warID = warid
    p:setCrewWarStatus(true)
    TriggerEvent("InteractSound_CL:PlayOnOne", "crewWarStart", 0.07)
    JoinCrewWarLobby()
end)

-- Step 2
RegisterNetEvent("crew:CrewWarStartMapVote")
AddEventHandler("crew:CrewWarStartMapVote", function()
    DisplayLittleSucces("Vote for the map you want", false, 15000)
    inMapVote = true
    votedMap = nil
    voted = false
    for k,v in pairs(crewWarMaps) do
        v.voted = false
    end
    StartMapVote()
end)

-- Step 3
RegisterNetEvent("crew:CrewWarLoadMap")
AddEventHandler("crew:CrewWarLoadMap", function(map)
    DisplayLittleSucces(map, false, 25*1000)
    inMapVote = false
    inMapLoad = true
    TriggerEvent("InteractSound_CL:Stop")
    StartMapLoad(map)
end)


-- Step 4
RegisterNetEvent("crew:CrewWarLoadVeh")
AddEventHandler("crew:CrewWarLoadVeh", function()
    DisplayLittleSucces("Choose your vehicle", false, 15*1000)
    inMapLoad = false
    inVehLoad = true
    StartVehLoad()
end)

-- Step 5
RegisterNetEvent("crew:CrewWarStartRace")
AddEventHandler("crew:CrewWarStartRace", function()
    inVehLoad = false
    TriggerEvent("InteractSound_CL:Stop")
    StartCrewWarRace(choosenMap)
end)


-- Step 6
RegisterNetEvent("crew:CrewWarEndLobby")
AddEventHandler("crew:CrewWarEndLobby", function()
    displayScoreBoard = true
    displayTempScoreboard = false
    DisplayCrewWarScoreboard()

    p:setCrewWarStatus(false)
end)

-- Extra step
RegisterNetEvent("crew:CrewWar60s")
AddEventHandler("crew:CrewWar60s", function()
    local timer = 60
    local timeBar = NativeUI.TimerBarPool()
    local time = NativeUI.CreateTimerBar("Race ending in:")
    time:SetTextTimerBar(timer.."s")
    timeBar:Add(time)


    Citizen.CreateThread(function()
        while timer >= 0 and p:GetCrewWarStatus() do
            timer = timer - 1
            time:SetTextTimerBar(timer.."s")
            Wait(1000)
        end
    end)  

    Citizen.CreateThread(function()
        while timer >= 0 and p:GetCrewWarStatus() do
            timeBar:Draw()
            Wait(1)
        end
    end)
end)

-- Missing map
RegisterNetEvent("crew:CrewWarNoMapSelected")
AddEventHandler("crew:CrewWarNoMapSelected", function()
    inMapVote = false
    displayScoreBoard = false
    displayTempScoreboard = false
    TeleportPlayer(warEndLobby)
    ShowNotification("No map selected. War cancelled")

    p:setCrewWarStatus(false)
end)

-- Kicked, too many player
RegisterNetEvent("crew:CrewWarNoMapSelected")
AddEventHandler("crew:CrewWarNoMapSelected", function()
    inMapVote = false
    displayScoreBoard = false
    displayTempScoreboard = false
    ShowNotification("You got kicked out of the crew war. Too many player.")

    p:setCrewWarStatus(false)
end)

RegisterNetEvent("crew:CrewWarRefreshData")
AddEventHandler("crew:CrewWarRefreshData", function(data)
    warInfo = data
    warInfo.myCrewScoreCount = 0
    for k,v in pairs(warInfo.indiScores[p:getCrew()]) do
        warInfo.myCrewScoreCount = warInfo.myCrewScoreCount + 1
    end

    warInfo.otherCrewScoreCount = 0
    for k,v in pairs(warInfo.indiScores[fightAgainst]) do
        warInfo.otherCrewScoreCount = warInfo.otherCrewScoreCount + 1
    end
end)




-- local exempleTable = {
--     {
--         name = "Toahsaka",
--         score = 78678,
--     },
--     {
--         name = "Rubylium",
--         score = 7867,
--     },
--     {
--         name = "NightSharekou",
--         score = 157867860,
--     },
--     {
--         name = "NightSharekou",
--         score = 7863,
--     },
-- }

-- Citizen.CreateThread(function()
--     AnimpostfxPlay("MP_Celeb_Win", -1, true)
--     while true do

--         local baseX = 0.3 -- gauche / droite ( plus grand = droite )
--         local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
--         local baseWidth = 0.3 -- Longueur
--         local baseHeight = 0.03 -- Epaisseur
--         DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
--         DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
--         DrawTexts(baseX, baseY - (0.043) - 0.013, "CATALACLUS" .. " CREW", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, "Total: ", true, 0.35, {0, 0, 0, 255}, 6, 0) -- title

--         DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
--         DrawTexts(baseX - 0.140, baseY - 0.013, "crew members", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX - 0.060, baseY - 0.013, "drift score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX + 0.020, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX + 0.080, baseY - 0.013, "final score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         for i = 1,#exempleTable do
--             DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
--             DrawTexts(baseX - 0.140, baseY + (0.032 * i) - 0.013, exempleTable[i].name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
--             DrawTexts(baseX - 0.060, baseY + (0.032 * i) - 0.013, GroupDigits(exempleTable[i].score), false, 0.35, {255, 255, 255, 255}, 6, 0) -- drift score
--             DrawTexts(baseX + 0.020, baseY + (0.032 * i) - 0.013, "124s", false, 0.35, {255, 255, 255, 255}, 6, 0) -- time
--             DrawTexts(baseX + 0.080, baseY + (0.032 * i) - 0.013, "124s", false, 0.35, {255, 255, 255, 255}, 6, 0) -- final score
--         end

--         local baseX = 0.7 -- gauche / droite ( plus grand = droite )
--         local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
--         local baseWidth = 0.3 -- Longueur
--         local baseHeight = 0.03 -- Epaisseur

--         DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
--         DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
--         DrawTexts(baseX, baseY - (0.043) - 0.013, "SUPER SUN" .. " CREW", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, "Total: ", true, 0.35, {0, 0, 0, 255}, 6, 0) -- title

--         DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
--         DrawTexts(baseX - 0.140, baseY - 0.013, "crew members", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX - 0.060, baseY - 0.013, "drift score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX + 0.020, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX + 0.080, baseY - 0.013, "final score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         for i = 1,#exempleTable do
--             DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
--             DrawTexts(baseX - 0.140, baseY + (0.032 * i) - 0.013, exempleTable[i].name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
--             DrawTexts(baseX - 0.060, baseY + (0.032 * i) - 0.013, GroupDigits(exempleTable[i].score), false, 0.35, {255, 255, 255, 255}, 6, 0) -- drift score
--             DrawTexts(baseX + 0.020, baseY + (0.032 * i) - 0.013, "124s", false, 0.35, {255, 255, 255, 255}, 6, 0) -- time
--             DrawTexts(baseX + 0.080, baseY + (0.032 * i) - 0.013, "124s", false, 0.35, {255, 255, 255, 255}, 6, 0) -- final score
--         end
--         Wait(0)
--     end
--     AnimpostfxStopAll()
-- end)
local racesScores = {}
local inRace = false
local race = {
    {
        label = "Harugahara",
        price = 22500,
        baseScore = 400000,
        pointPerSec = 550,
        speedLimit = 15,
        start =  vector4(2790.1643066406, 4603.8330078125, 549.78204345703, 11.473360061646),
        points = {
            {pos = vector4(2895.3637695312, 4700.2138671875, 557.28295898438, 11.473360061646), passed = false},
            {pos = vector4(3005.810546875, 4746.5927734375, 564.55670166016, 11.473360061646), passed = false},
            {pos = vector4(2913.2482910156, 4741.0219726562, 568.68658447266, 11.473360061646), passed = false},
            {pos = vector4(2959.4829101562, 4961.26171875, 578.26715087891, 11.473360061646), passed = false},
            {pos = vector4(3041.2670898438, 4947.7319335938, 584.74652099609, 11.473360061646), passed = false},
            {pos = vector4(3038.8315429688, 4862.525390625, 592.52130126953, 11.473360061646), passed = false},
            {pos = vector4(3162.4702148438, 4866.5229492188, 597.55114746094, 11.473360061646), passed = false},
            {pos = vector4(3137.1943359375, 4813.9135742188, 605.3037109375, 11.473360061646), passed = false},
            {pos = vector4(3261.3872070312, 4795.65234375, 602.66442871094, 11.473360061646), passed = false},
            {pos = vector4(3182.564453125, 4828.9018554688, 593.26495361328, 11.473360061646), passed = false},
            {pos = vector4(3327.9685058594, 4764.2915039062, 585.28082275391, 11.473360061646), passed = false},
            {pos = vector4(3415.7429199219, 4720.0825195312, 575.76495361328, 11.473360061646), passed = false},
            {pos = vector4(3478.0578613281, 4734.5029296875, 568.66076660156, 11.473360061646), passed = false},
            {pos = vector4(3489.0485839844, 4784.7573242188, 558.88629150391, 11.473360061646), passed = false},
            {pos = vector4(3647.3796386719, 4802.6782226562, 547.58099365234, 11.473360061646), passed = false},
            {pos = vector4(3706.408203125, 4731.8984375, 541.37933349609, 11.473360061646), passed = false},
            {pos = vector4(3812.08203125, 4741.4536132812, 533.68713378906, 11.473360061646), passed = false},
            {pos = vector4(3875.5627441406, 4740.650390625, 527.24395751953, 11.473360061646), passed = false},
            {pos = vector4(3969.8576660156, 4760.1123046875, 518.04888916016, 11.473360061646), passed = false},
            {pos = vector4(4072.2626953125, 4851.8315429688, 514.08544921875, 11.473360061646), passed = false},
            {pos = vector4(4239.728515625, 4747.8159179688, 524.60577392578, 11.473360061646), passed = false},
            {pos = vector4(4298.5078125, 4683.431640625, 532.65808105469, 11.473360061646), passed = false},
            {pos = vector4(4387.9614257812, 4611.9008789062, 541.5009765625, 11.473360061646), passed = false},
            {pos = vector4(4378.552734375, 4484.7290039062, 547.42340087891, 11.473360061646), passed = false},
            {pos = vector4(4400.3002929688, 4442.1513671875, 553.38232421875, 11.473360061646), passed = false},
            {pos = vector4(4373.595703125, 4307.7016601562, 560.87377929688, 11.473360061646), passed = false},
            {pos = vector4(4334.533203125, 4275.021484375, 566.26654052734, 11.473360061646), passed = false},
            {pos = vector4(4283.1772460938, 4259.1987304688, 571.41131591797, 11.473360061646), passed = false},
            {pos = vector4(4231.865234375, 4228.2143554688, 578.24822998047, 11.473360061646), passed = false},
        
        },
    },
    {
        label = "Ebisu Drift race",
        start =  vector4(963.13128662109, 1062.2911376953, 459.47320556641, 279.91229248047),
        price = 4250,
        baseScore = 200000,
        pointPerSec = 750,
        speedLimit = 20,
        points = {
            {pos = vector4(1030.7563476562, 1117.5638427734, 458.73199462891, 65.086318969727), passed = false},
            --{pos = vector4(920.74230957031, 1125.4340820312, 460.48587036133, 298.26525878906), passed = false},
            {pos = vector4(970.18060302734, 1128.7644042969, 460.21350097656, 354.3141784668), passed = false},
            {pos = vector4(823.22985839844, 1244.6904296875, 460.45593261719, 60.095832824707), passed = false},
            {pos = vector4(786.90765380859, 1208.9810791016, 463.76522827148, 50.014312744141), passed = false},
            --{pos = vector4(825.95599365234, 1215.7095947266, 460.04913330078, 201.3935546875), passed = false},
            --{pos = vector4(890.11956787109, 1126.2111816406, 460.30383300781, 228.1328125), passed = false},
            {pos = vector4(967.17517089844, 1072.5148925781, 458.39178466797, 261.29092407227), passed = false},
        }
    },
    {
        label = "Haruna Drift Race",
        price = 26750,
        baseScore = 450000,
        pointPerSec = 3000,
        speedLimit = 35,
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
        }
    },
    {
        label = "Iro Drift Race",
        price = 23200,
        baseScore = 150000,
        pointPerSec = 250,
        speedLimit = 10,
        start =  vector4(-5356.0327148438, 4325.556640625, 754.83813476562, 287.53540039062),
        points = {
            {pos = vector4(-5090.6884765625, 4394.7895507812, 749.99359130859, 276.93649291992), passed = false},
            {pos = vector4(-4922.9633789062, 4434.7470703125, 738.38854980469, 292.50164794922), passed = false},
            {pos = vector4(-4745.4155273438, 4436.787109375, 718.21282958984, 291.70050048828), passed = false},
            {pos = vector4(-4789.8774414062, 4413.716796875, 709.91705322266, 138.48352050781), passed = false},
            {pos = vector4(-4810.5048828125, 4384.1030273438, 701.47418212891, 264.8244934082), passed = false},
            {pos = vector4(-4648.6284179688, 4396.66015625, 685.75427246094, 287.25909423828), passed = false},
            {pos = vector4(-4566.7006835938, 4413.6123046875, 674.63134765625, 245.90594482422), passed = false},
            {pos = vector4(-4581.9448242188, 4406.1440429688, 666.42651367188, 90.09447479248), passed = false},
            {pos = vector4(-4590.259765625, 4392.9111328125, 657.39831542969, 286.55490112305), passed = false},
            {pos = vector4(-4471.8051757812, 4371.306640625, 646.70550537109, 256.94793701172), passed = false},
            {pos = vector4(-4537.5180664062, 4368.6186523438, 642.09466552734, 90.650260925293), passed = false},
            {pos = vector4(-4450.1909179688, 4340.1591796875, 631.64135742188, 255.71423339844), passed = false},
            {pos = vector4(-4512.9208984375, 4331.93359375, 625.8916015625, 88.336456298828), passed = false},
            {pos = vector4(-4455.4077148438, 4307.8256835938, 620.07409667969, 244.97686767578), passed = false},
            {pos = vector4(-4495.0556640625, 4297.837890625, 612.021484375, 78.566612243652), passed = false},
            {pos = vector4(-4507.0698242188, 4286.7055664062, 605.06640625, 242.2575378418), passed = false},
            {pos = vector4(-4508.5791015625, 4252.779296875, 592.11968994141, 111.48323822021), passed = false},
            {pos = vector4(-4458.4399414062, 4226.62890625, 575.35626220703, 250.86512756348), passed = false},
            {pos = vector4(-4424.3046875, 4215.9194335938, 565.60784912109, 120.0938873291), passed = false},
            {pos = vector4(-4449.9375, 4203.0278320312, 556.33752441406, 257.68914794922), passed = false},
            {pos = vector4(-4463.7690429688, 4184.376953125, 546.28344726562, 285.95767211914), passed = false},
            {pos = vector4(-4469.1630859375, 4160.5908203125, 538.28015136719, 297.65139770508), passed = false},
            {pos = vector4(-4513.9682617188, 4108.2001953125, 525.13568115234, 215.62933349609), passed = false},
            {pos = vector4(-4449.4716796875, 3947.6481933594, 509.26110839844, 218.68884277344), passed = false},
            {pos = vector4(-4414.9296875, 3921.9853515625, 494.26831054688, 344.55590820312), passed = false},
            {pos = vector4(-4385.8076171875, 3947.2019042969, 482.75619506836, 344.52178955078), passed = false},
            {pos = vector4(-4364.884765625, 3935.0539550781, 471.14273071289, 331.06741333008), passed = false},
            {pos = vector4(-4340.6586914062, 3871.9733886719, 463.04681396484, 222.15196228027), passed = false},
            {pos = vector4(-4225.8588867188, 3715.0085449219, 452.53656005859, 170.86181640625), passed = false},
            {pos = vector4(-4207.5004882812, 3550.3041992188, 448.59201049805, 180.91749572754), passed = false},
        }
    },
    {
        label = "Hakone Ohiradai",
        price = 7100,
        baseScore = 150000,
        pointPerSec = 1500,
        speedLimit = 25,
        start =  vector4(-4330.0463867188, -4615.9516601562, 150.9341583252, 351.76547241211),
        points = {
            {pos = vector4(-4370.8544921875, -4236.6669921875, 156.77291870117, 307.23013305664), passed = false},
            {pos = vector4(-4337.1616210938, -4135.1987304688, 155.56088256836, 32.008346557617), passed = false},
            {pos = vector4(-4293.556640625, -3965.9389648438, 154.45910644531, 292.59219360352), passed = false},
            {pos = vector4(-4376.7534179688, -3767.2392578125, 145.20780944824, 16.220779418945), passed = false},
            {pos = vector4(-4307.7124023438, -3650.3283691406, 141.69039916992, 10.491148948669), passed = false},
            {pos = vector4(-4491.5571289062, -3535.6274414062, 133.88722229004, 102.83293914795), passed = false},
        }
    },
    {
        label = "Hakone Nanamagari",
        price = 7450,
        baseScore = 200000,
        pointPerSec = 750,
        speedLimit = 15,
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
    },
    {
        label = "Route 4 Katsuoji Minoo",
        price = 2950,
        baseScore = 55000,
        pointPerSec = 150,
        speedLimit = 15,
        start =  vector4(6382.7104492188, 3655.3237304688, 255.19998168945, 150.31907653809),
        points = {
            {pos = vector4(6246.5981445312, 3591.7233886719, 249.77912902832, 103.29760742188), passed = false},
            {pos = vector4(6229.9018554688, 3456.7458496094, 241.04014587402, 225.55639648438), passed = false},
            {pos = vector4(6233.5307617188, 3323.0173339844, 234.63354492188, 219.99467468262), passed = false},
            {pos = vector4(6356.6538085938, 3275.3293457031, 229.38348388672, 248.79943847656), passed = false},
        
        },
    },
    {
        label = "Tsukurimono Touge",
        price = 16600,
        baseScore = 190000,
        pointPerSec = 1000,
        speedLimit = 15,
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
    },
}

local baseX = 0.2 -- gauche / droite ( plus grand = droite )
local baseY = 0.2 -- Hauteur ( Plus petit = plus haut )
local baseWidth = 0.3 -- Longueur
local baseHeight = 0.03 -- Epaisseur

Citizen.CreateThread(function()
    while not loaded do Wait(1) end

    while true do
        if not inRace and not p:GetCrewWarStatus() then
            local pPed = p:ped()
            local pCoords = p:pos()
            for k,v in pairs(race) do
                if #(v.start.xyz - pCoords) <= 7.0 then
                    if racesScores[v.label] ~= nil then

                        while #(v.start.xyz - p:pos()) <= 7.0 and not inRace and not p:GetCrewWarStatus() do


                            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 110, 255, 168, 255) -- Liseret
                            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
                            DrawTexts(baseX - 0.148, baseY - (0.043) - 0.013, v.label, false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                            DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, tostring(#racesScores[v.label].scores), true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
                    
                            DrawRect(baseX, baseY, baseWidth, baseHeight, 110, 255, 168, 255)
                
                            DrawTexts(baseX - 0.145, baseY - 0.013, "player", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                            DrawTexts(baseX + 0.005, baseY - 0.013, "score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                            DrawTexts(baseX + 0.085, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title

                            for i = 1,#racesScores[v.label].scores do
                                DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                                DrawTexts(baseX - 0.14, baseY + (0.032 * i) - 0.013, "#"..i, true, 0.35, {255, 255, 255, 255}, 6, 0) -- place
                                DrawTexts(baseX - 0.13, baseY + (0.032 * i) - 0.013, racesScores[v.label].scores[i].name .. " - " .. racesScores[v.label].scores[i].veh, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name + veh
                                DrawTexts(baseX + 0.005, baseY + (0.032 * i) - 0.013, GroupDigits(math.floor(racesScores[v.label].scores[i].points)), false, 0.35, {255, 255, 255, 255}, 6, 1) -- score
                                DrawTexts(baseX + 0.085, baseY + (0.032 * i) - 0.013, racesScores[v.label].scores[i].time.."s", false, 0.35, {255, 255, 255, 255}, 6, 1) -- score

                            end


                            Wait(1)
                        end
                    else
                        while #(v.start.xyz - p:pos()) <= 7.0 and not inRace and not player:GetCrewWarStatus() do
                            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 110, 255, 168, 255) -- Liseret
                            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
                            DrawTexts(baseX - 0.148, baseY - (0.043) - 0.013, v.label, false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                            DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, tostring(0), true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
                            
                            DrawRect(baseX, baseY, baseWidth, baseHeight, 110, 255, 168, 255)
                            DrawTexts(baseX + 0.025, baseY - 0.013, "score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                            DrawTexts(baseX - 0.145, baseY - 0.013, "player", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                            Wait(1)
                        end
                    end
                end
            end
        end
        Wait(500)
    end
end)


Citizen.CreateThread(function()
    while not loaded do Wait(1) end

    for k,v in pairs(race) do
        zone.addZone(v.label, v.start.xyz, "Press ~INPUT_CONTEXT~ to start the race", function() StartRace(v, k) end, true, 5, 1.0, {255, 255, 255}, 170, "markers", "finish", 0.0, 0.0, 0.0)

        AddBlip(v.start.xyz, 38, 2, 0.85, 44, v.label)
    end
end)

local blip = 0
local timeBar = nil

function StartRace(data, raceKey)
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
       {pos = GetOffsetFromEntityInWorldCoords(p:ped(), 0.0, 0.0, 8.0)}, -- up
       {pos = GetOffsetFromEntityInWorldCoords(p:ped(), 0.0, 8.0, 0.0)}, -- front
       {pos = GetOffsetFromEntityInWorldCoords(p:ped(), 0.0, -8.0, 5.0)}, -- back
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

    blip = AddBlipForCoord(data.start.xyz)


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
        while dst > 10.0 and not raceStopped and not p:GetCrewWarStatus() do
            dst = math.floor(#(v.pos.xyz - p:pos()))
            DrawMarker(5, v.pos.xyz, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 5.0, 5.0, 5.0, 235, 229, 52, 170, 0, 1, 2, 0, nil, nil, 0)
            DrawMarker(0, v.pos.x, v.pos.y, v.pos.z + 1.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 30.0, 66, 245, 111, 170, 0, 1, 2, 0, nil, nil, 0)

            if GetGameTimer() >= timer then
                raceStopped = true
            end

            ShowHelpNotification("Press ~INPUT_CELLPHONE_CANCEL~ to cancel the drift race")
            if IsControlJustReleased(0, 177) then
                raceStopped = true

                SetPedCoordsKeepVehicle(p:ped(), data.start.xyz)
                SetEntityHeading(p:currentVeh(), data.start.w)
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
    SetPlayerInRace(false)


    if not raceStopped and not p:GetCrewWarStatus() then
        

        local endTime = GetGameTimer()
        local raceTime = endTime - startTime
        local raceSecond = math.floor(raceTime / 1000)

        local driftScore = endPoints
        -- endPoints = (endPoints - raceSecond * data.pointPerSec)

        -- if endPoints < 0 then
        --     endPoints = 0
        -- end

        -- endPoints = math.floor(endPoints  + (driftScore / raceSecond))
        endPoints = math.floor(driftScore/raceSecond)




        local pVeh = p:currentVeh()
        local model = GetEntityModel(pVeh)

        TriggerServerEvent(Events.raceEnd, data.label, endPoints, GetDisplayNameFromVehicleModel(model), raceSecond)

        SetPedCoordsKeepVehicle(p:ped(), data.start.xyz)
        SetEntityHeading(p:currentVeh(), data.start.w)

        local displayResult = true
        AnimpostfxPlay("MP_Celeb_Win", -1, true)

        p:GiveMoney(endPoints / 2500 * data.price)

        local baseX = 0.5 -- gauche / droite ( plus grand = droite )
        local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
        local baseWidth = 0.3 -- Longueur
        local baseHeight = 0.03 -- Epaisseur

        while displayResult do
        
            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 110, 255, 168, 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
            DrawTexts(baseX - 0.148, baseY - (0.043) - 0.013, "FINAL SCORE", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, "#1", true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
    
            DrawRect(baseX, baseY, baseWidth, baseHeight, 110, 255, 168, 255)
            DrawTexts(baseX - 0.145, baseY - 0.013, "drift score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX - 0.060, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawTexts(baseX + 0.025, baseY - 0.013, "final score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            DrawRect(baseX, baseY + (0.032), baseWidth, baseHeight, 0, 0, 0, 210)
    
            DrawTexts(baseX - 0.145, baseY + (0.032) - 0.013, GroupDigits(driftScore), false, 0.35, {255, 255, 255, 255}, 6, 0) -- name + veh
            DrawTexts(baseX - 0.060, baseY + (0.032) - 0.013, raceSecond.."s", false, 0.35, {255, 255, 255, 255}, 6, 0) -- name + veh
            DrawTexts(baseX + 0.025, baseY + (0.032) - 0.013, GroupDigits(endPoints), false, 0.35, {255, 255, 255, 255}, 6, 1) -- score
    
            DrawRect(baseX, baseY + 0.058 + 0.035, baseWidth, baseHeight - 0.025, 110, 255, 168, 200) -- Liseret
            DrawRect(baseX, baseY + 0.043 + 0.035, baseWidth, baseHeight, 0, 0, 0, 200) -- Bannière
    
            DrawTexts(baseX, baseY + (0.065), "Final score is your drift score minus time used", true, 0.35, {255, 255, 255, 255}, 6, 1) -- score

            ShowHelpNotification("Press ~INPUT_CELLPHONE_CANCEL~ to close")
            DisableAllControlActions(0)
            if IsDisabledControlJustPressed(0, 177) then
                displayResult = false
            end
    
            if IsDisabledControlJustPressed(0, 176) then
                displayResult = false
            end
    
            if IsDisabledControlJustPressed(0, 179) then
                displayResult = false
            end
            Wait(1)
        end

        AnimpostfxStopAll()
        p:addExp(math.floor(endPoints / 130))
        p:SetSucces(data.label)
        SendNUIMessage( {
            ShowSucces = true,
            label = "Race: "..data.label,
        })

        
        SendNUIMessage( {
            HideSucces = true,
        })
    else
        ShowNotification("Race cancelled ! You need to go faster !")
    end

    ChangeSpeedLimit(39)
    Citizen.CreateThread(function()
        Wait(3000)
        if not inRace then
            TogglePasive(false)
        end
    end)
    TogglePasive(false)
    inRace = false
end


RegisterNetEvent("drift:RefreshRacesScores")
AddEventHandler("drift:RefreshRacesScores", function(scores)
    racesScores = scores
end)



-- Citizen.CreateThread(function()
--     local displayResult = true


--     local baseX = 0.5 -- gauche / droite ( plus grand = droite )
--     local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
--     local baseWidth = 0.3 -- Longueur
--     local baseHeight = 0.03 -- Epaisseur

--     AnimpostfxPlay("MP_race_crash", -1, true)

--     local score = 85041
--     local sec = 54
--     local endPoints = (score - sec * 350)

    

--     while displayResult do
        
--         DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 110, 255, 168, 255) -- Liseret
--         DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
--         DrawTexts(baseX - 0.148, baseY - (0.043) - 0.013, "FINAL SCORE", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, "#1", true, 0.35, {0, 0, 0, 255}, 6, 0) -- title

--         DrawRect(baseX, baseY, baseWidth, baseHeight, 110, 255, 168, 255)
--         DrawTexts(baseX - 0.145, baseY - 0.013, "drift score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX - 0.060, baseY - 0.013, "time", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX + 0.025, baseY - 0.013, "final score", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawRect(baseX, baseY + (0.032), baseWidth, baseHeight, 0, 0, 0, 210)

--         DrawTexts(baseX - 0.145, baseY + (0.032) - 0.013, GroupDigits(score), false, 0.35, {255, 255, 255, 255}, 6, 0) -- name + veh
--         DrawTexts(baseX - 0.060, baseY + (0.032) - 0.013, sec.."s", false, 0.35, {255, 255, 255, 255}, 6, 0) -- name + veh
--         DrawTexts(baseX + 0.025, baseY + (0.032) - 0.013, GroupDigits(endPoints), false, 0.35, {255, 255, 255, 255}, 6, 1) -- score

--         DrawRect(baseX, baseY + 0.058 + 0.035, baseWidth, baseHeight - 0.025, 110, 255, 168, 200) -- Liseret
--         DrawRect(baseX, baseY + 0.043 + 0.035, baseWidth, baseHeight, 0, 0, 0, 200) -- Bannière

--         DrawTexts(baseX, baseY + (0.065), "Final score is your drift score minus time used", true, 0.35, {255, 255, 255, 255}, 6, 1) -- score
        
--         ShowHelpNotification("Press ~INPUT_CELLPHONE_CANCEL~ to close")

--         DisableAllControlActions(0)
--         if IsDisabledControlJustPressed(0, 177) then
--             displayResult = false
--         end

--         if IsDisabledControlJustPressed(0, 176) then
--             displayResult = false
--         end

--         if IsDisabledControlJustPressed(0, 179) then
--             displayResult = false
--         end
--         Wait(1)
--     end
--     AnimpostfxStopAll()
    
-- end)
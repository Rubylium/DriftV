local players = {}

RegisterNetEvent("drift:SyncPlayer")
AddEventHandler("drift:SyncPlayer", function(plays)
    players = plays

    for k,v in pairs(players) do
        v.level = GetPlayerLevelFromXp(v.exp)
    end

end)

Citizen.CreateThread(function()
    TriggerServerEvent("drift:RequestSync")
    while true do
        
        if IsControlJustPressed(0, 20) then

            local baseX = 0.2 -- gauche / droite ( plus grand = droite )
            local baseY = 0.2 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.3 -- Longueur
            local baseHeight = 0.03 -- Epaisseur

            while IsControlPressed(0, 20) do
                
                DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 194, 13, 255) -- Liseret
                DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
                DrawTexts(baseX - 0.125, baseY - (0.043) - 0.013, "player list", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, tostring(#players), true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
        
                DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 194, 13, 255)
                DrawTexts(baseX + 0.030, baseY - 0.013, "Crew", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                DrawTexts(baseX - 0.138, baseY - 0.013, "level", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                for i = 1,#players do
                    DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                    DrawTexts(baseX - 0.14, baseY + (0.032 * i) - 0.013, players[i].level, true, 0.35, {255, 255, 255, 255}, 6, 0) -- level
                    DrawTexts(baseX - 0.13, baseY + (0.032 * i) - 0.013, players[i].name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
                    DrawTexts(baseX + 0.01, baseY + (0.032 * i) - 0.013, players[i].crew, false, 0.35, {255, 255, 255, 255}, 6, 1) -- crew
                end

                Wait(1)
            end
        end
        Wait(1)
    end
end)

Citizen.CreateThread(function()
while not loaded do Wait(1) end
    DecorRegister("LEVEL", 3)
    while true do
        TriggerServerEvent("drift:RequestSync")
        DecorSetInt(p:ped(), "LEVEL", p:getLevel())

        Wait(3000)
    end
end)

-- local exempleTable = {
--     {
--         name = "Toahsaka",
--         level = 15,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "Rubylium",
--         level = 54,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NightSharekou",
--         level = 150,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NightSharekou",
--         level = 76,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NightShsefarekou",
--         level = 46,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NigqzfgffhtSharekou",
--         level = 75,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NightShzqsfgarekou",
--         level = 96,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NigzzqfhtSharekou",
--         level = 85,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NightSharedrgrdkou",
--         level = 45,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NightSharedrgrdkou",
--         level = 854,
--         crew = "Speed Hunters"
--     },
--     {
--         name = "NightSharedrgrdkou",
--         level = 1000,
--         crew = "Speed Hunters"
--     },
-- }

-- Citizen.CreateThread(function()
--     while true do
--         DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 194, 13, 255) -- Liseret
--         DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
--         DrawTexts(baseX - 0.125, baseY - (0.043) - 0.013, "player list", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, tostring(#exempleTable), true, 0.35, {0, 0, 0, 255}, 6, 0) -- title

--         DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 194, 13, 255)
--         DrawTexts(baseX + 0.030, baseY - 0.013, "Crew", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         DrawTexts(baseX - 0.138, baseY - 0.013, "level", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
--         for i = 1,#exempleTable do
--             DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
--             DrawTexts(baseX - 0.14, baseY + (0.032 * i) - 0.013, exempleTable[i].level, true, 0.35, {255, 255, 255, 255}, 6, 0) -- level
--             DrawTexts(baseX - 0.13, baseY + (0.032 * i) - 0.013, exempleTable[i].name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
--             DrawTexts(baseX + 0.01, baseY + (0.032 * i) - 0.013, exempleTable[i].crew, false, 0.35, {255, 255, 255, 255}, 6, 1) -- crew
--         end
--         Wait(0)
--     end
-- end)
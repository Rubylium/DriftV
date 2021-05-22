local mathmakingData = {}
local inMatchmaking = false

function SetPlayerInCrewWarMatchemking()
    local baseX = 0.9 -- gauche / droite ( plus grand = droite )
    local baseY = 0.2 -- Hauteur ( Plus petit = plus haut )
    local baseWidth = 0.15 -- Longueur
    local baseHeight = 0.03 -- Epaisseur


    Citizen.CreateThread(function()
        while inMatchmaking do
            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, 255, 103, 92, 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
            DrawTexts(baseX - 0.068, baseY - (0.043) - 0.013, "crew war matchmaking", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            --DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, tostring(#exempleTable), true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
    
            DrawRect(baseX, baseY, baseWidth, baseHeight, 255, 103, 92, 255)
            DrawTexts(baseX - 0.058, baseY - 0.013, "player", false, 0.35, {0, 0, 0, 255}, 2, 0) -- title
            for i = 1,#mathmakingData do
                DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 0, 0, 0, 210)
                DrawTexts(baseX - 0.067, baseY + (0.032 * i) - 0.013, mathmakingData[i].level, true, 0.35, {255, 255, 255, 255}, 6, 0) -- level
                DrawTexts(baseX - 0.058, baseY + (0.032 * i) - 0.013, mathmakingData[i].name, false, 0.35, {255, 255, 255, 255}, 6, 0) -- name
            end   
            Wait(1)
        end
    end)
end


RegisterNetEvent("crew:CrewWarRefreshCrewData")
AddEventHandler("crew:CrewWarRefreshCrewData", function(data, status)
    mathmakingData = data
    for k,v in pairs(mathmakingData) do
        v.level = GetPlayerLevelFromXp(v.exp)
    end
    local oldStatus = inMatchmaking
    inMatchmaking = status
    if not oldStatus then
        SetPlayerInCrewWarMatchemking()
    end
end)
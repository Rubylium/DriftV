inLobby = false
local lobbyVeh = nil
function EnableLobby()
    if inLobby then
        return
    end

    local lobbyVehPos = vector4(33.487171173096, -2648.2048339844, 5.5173211097717, 28.943622589111)
    local lobbyCharPos = vector4(34.782615661621, -2645.9855957031, 6.0122184753418, 62.16764831543)
    local camPos = vector3(20.251071929932, -2641.2807617188, 6.8467087745667)
    local camLookAt = vector3(35.487899780273, -2646.4672851562, 6.0110878944397)
    inLobby = true
    local inLobbyMap = false

    local function SpawnRandomPlayerVeh()
        local vehs = p:GetCars()

        if #vehs > 0 then
            local rVeh = vehs[math.random(1,#vehs)]
            ClearAreaOfEverything(lobbyVehPos.xy, 50.0, 1, 1, 1, 1)
            local veh = entity:CreateVehicleLocal(rVeh.model, lobbyVehPos.xyz, lobbyVehPos.w)
            SetVehProps(veh:getEntityId(), rVeh.props)
            FreezeEntityPosition(veh:getEntityId(), true)
            lobbyVeh = veh:getEntityId()
        else
            ClearAreaOfEverything(lobbyVehPos.xy, 50.0, 1, 1, 1, 1)
            local veh = entity:CreateVehicleLocal("350zrb", lobbyVehPos.xyz, lobbyVehPos.w)
            FreezeEntityPosition(veh:getEntityId(), true)
            lobbyVeh = veh:getEntityId()
        end
    end


    Citizen.CreateThread(function()
        TriggerEvent("InteractSound_CL:PlayOnOne", "lobby", 0.07)
        cam.create("lobby")
        cam.setPos("lobby", camPos)
        cam.lookAtCoords("lobby", camLookAt)
        cam.setFov("lobby", 20.0)
        cam.setActive("lobby", true)
        cam.render("lobby", true, false, 0)
        DisplayRadar(false)
        SpawnRandomPlayerVeh()
        SetEntityCoordsNoOffset(p:ped(), lobbyCharPos.xyz, 0.0, 0.0, 0.0)
        SetEntityHeading(p:ped(), lobbyCharPos.w)
        TaskStartScenarioInPlace(p:ped(), "WORLD_HUMAN_STAND_IMPATIENT", 0, 0)
        
        local pMoney = GroupDigits(p:GetMoney())
        local pLevel = p:getLevel()
        SetNuiFocus(true, true)
        SetNuiFocusKeepInput(true)

        p:setInstance(GetPlayerServerId(GetPlayerIndex()))

        local LiseretColor = {191, 66, 245}
        local cursorPos = {0.5, 0.5}
        local cursorPosCalc = cursorPos[1] - cursorPos[2]

        local function RefreshCursorPos()
            cursorPos[1], cursorPos[2] = GetNuiCursorPosition()
            cursorPosCalc = cursorPos[1] - cursorPos[2]
        end

        SetCursorLocation(cursorPos[1], cursorPos[2])
        SetMouseCursorSprite(0)

        local buttons = {
            [1] = {
                selected = true,
                button = { baseX = -0.3, baseY = -0.2, baseWidth = 0, baseHeight = 0},
                text = { baseX = 0.0, baseY = - 0.03, center = true, scale = 1.0, text = "GARAGE", police = 2},
                sprite = {name = "garage", baseX = 0.055, baseY = -0.035, width = 0.03, height = 0.05, heading = 0.0, r = 255, g = 255, b = 255, alpha = 100},
                action = function()
                    inLobby = false
                    DeleteEntity(lobbyVeh)
                    TriggerEvent("InteractSound_CL:Stop")
                    JoinGarage(true)
                    SetNuiFocus(false, false)
                    cam.render("lobby", false, false, 0)
                end,
            },
            [2] = {
                selected = false,
                button = { baseX = -0.3, baseY = - 0.05, baseWidth = 0, baseHeight = 0},
                text = { baseX = 0.0, baseY = - 0.04 + 0.01, center = true, scale = 1.0, text = "MAPS", police = 2},
                sprite = {name = "drifting", baseX = 0.055, baseY = -0.035, width = 0.03, height = 0.05, heading = 0.0, r = 255, g = 255, b = 255, alpha = 100},
                action = function()
                    cam.create("lobby_map")
                    cam.setPos("lobby_map", camPos)
                    cam.lookAtCoords("lobby_map", lobbyVehPos)
                    cam.setFov("lobby_map", 10.0)
                    cam.setActive("lobby_map", true)
                    cam.switchToCam("lobby_map", "lobby", 1500)

                    inLobbyMap = true
                end,
            },
            [3] = {
                selected = false,
                button = { baseX = -0.3, baseY = 0.1, baseWidth = 0, baseHeight = 0},
                text = { baseX = 0.0, baseY = -0.04 + 0.01, center = true, scale = 1.0, text = "SHOP", police = 2},
                sprite = {name = "car", baseX = 0.055, baseY = -0.035, width = 0.03, height = 0.05, heading = 0.0, r = 255, g = 255, b = 255, alpha = 100},
                action = function()
                    inLobby = false
                    DeleteEntity(lobbyVeh)
                    SetNuiFocus(false, false)
                    cam.render("lobby", false, false, 0)
                    OpenVehShopMenu(true)
                end,
            },
        }
        local actualSelected = 1
        local selectedMapIndex = 1

        local cooldown = 0
        while inLobby do

--
--
--
--                        LEVELS + MONEY
--
--
--

            local baseX = 0.85 -- gauche / droite ( plus grand = droite )
            local baseY = 0.15 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.15 -- Longueur
            local baseHeight = 0.03 -- Epaisseur

            DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 0, 0, 0, 170) -- Bannière
            DrawTexts(baseX - 0.073, baseY - (0.043) - 0.013, " "..pMoney.."~g~ $", false, 0.35, {255, 255, 255, 255}, 0, 0) -- title
            DrawTexts(baseX + 0.040, baseY - (0.043) - 0.013, "lvl "..pLevel, false, 0.35, {255, 255, 255, 255}, 0, 0) -- title

--
--
--
--                        FOOTER
--
--
--


            local baseX = 0.5 -- gauche / droite ( plus grand = droite )
            local baseY = 0.95 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.35 -- Longueur
            local baseHeight = 0.10 -- Epaisseur

            DrawRect(baseX, baseY - 0.095, baseWidth, 0.010, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255) -- Liseret
            DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 28, 28, 28, 180) -- Bannière
            DrawTexts(baseX, baseY - (0.040) - 0.013, "Use ~b~arrow~s~ key to navigate", true, 0.35, {255, 255, 255, 255}, 0, 0) -- title
            DrawTexts(baseX, baseY - (0.040) - 0.033, "Use ~b~enter~s~ key to select", true, 0.35, {255, 255, 255, 255}, 0, 0) -- title


--
--
--
--                        BUTTONS
--
--
--
            if not inLobbyMap then

            local baseX = 0.5 -- gauche / droite ( plus grand = droite )
            local baseY = 0.5 -- Hauteur ( Plus petit = plus haut )
            local baseWidth = 0.14 -- Longueur
            local baseHeight = 0.13 -- Epaisseur

            for k,v in pairs(buttons) do
                if not v.selected then
                    
                    DrawRect(baseX + v.button.baseX, baseY + v.button.baseY, baseWidth + v.button.baseWidth, baseHeight + v.button.baseHeight, 28, 28, 28, 180) -- Button Garage
                    if v.sprite ~= nil then
                        while not HasStreamedTextureDictLoaded("sprite") do
                            RequestStreamedTextureDict("sprite", 1)
                            Wait(1)
                        end

                        DrawSprite("sprite", v.sprite.name, baseX + v.button.baseX + v.sprite.baseX - 0.005, baseY + v.button.baseY + v.sprite.baseY, v.sprite.width, v.sprite.height, v.sprite.heading, v.sprite.r, v.sprite.g, v.sprite.b, v.sprite.alpha)
                    end
                    DrawTexts(baseX + v.button.baseX + v.text.baseX, baseY + v.button.baseY + v.text.baseY, v.text.text, v.text.center, v.text.scale, {255, 255, 255, 255}, v.text.police, 0) -- title
                else
                    DrawRect(baseX + v.button.baseX, baseY + v.button.baseY, baseWidth + v.button.baseWidth + 0.015, baseHeight + v.button.baseHeight + 0.015, LiseretColor[1], LiseretColor[2], LiseretColor[3], 180) -- Button Garage

                    DrawRect(baseX + v.button.baseX, baseY + v.button.baseY, baseWidth + v.button.baseWidth + 0.01, baseHeight + v.button.baseHeight + 0.01, 28, 28, 28, 230) -- Button Garage
                    if v.sprite ~= nil then
                        while not HasStreamedTextureDictLoaded("sprite") do
                            RequestStreamedTextureDict("sprite", 1)
                            Wait(1)
                        end

                        DrawSprite("sprite", v.sprite.name, baseX + v.button.baseX + v.sprite.baseX, baseY + v.button.baseY + v.sprite.baseY, v.sprite.width, v.sprite.height, v.sprite.heading, v.sprite.r, v.sprite.g, v.sprite.b, v.sprite.alpha)
                    end
                    DrawTexts(baseX + v.button.baseX + v.text.baseX, baseY + v.button.baseY + v.text.baseY, v.text.text, v.text.center, v.text.scale + 0.1, {255, 255, 255, 255}, v.text.police, 0) -- title
                end
            end
            

            if IsDisabledControlJustReleased(0, 172) then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                if buttons[actualSelected - 1] ~= nil then
                    buttons[actualSelected].selected = false
                    actualSelected = actualSelected - 1
                    buttons[actualSelected].selected = true
                end
            end

            if IsDisabledControlJustReleased(0, 173) then
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                if buttons[actualSelected + 1] ~= nil then
                    buttons[actualSelected].selected = false
                    actualSelected = actualSelected + 1
                    buttons[actualSelected].selected = true
                end
            end

            if IsDisabledControlJustReleased(0, 191) and cooldown > 50 then
                PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                buttons[actualSelected].action()
            end

            
--
--
--
--                        BUTTONS - MAPS
--
--
--

            else
                
                local baseX = 0.15 -- gauche / droite ( plus grand = droite )
                local baseY = 0.15 -- Hauteur ( Plus petit = plus haut )
                local baseWidth = 0.15 -- Longueur
                local baseHeight = 0.03 -- Epaisseur

                DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255) -- Liseret
                DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 0, 0, 0, 170) -- Bannière

                while not HasStreamedTextureDictLoaded("sprite") do
                    RequestStreamedTextureDict("sprite", 1)
                    Wait(1)
                end

                DrawSprite("sprite", "undo", (baseY - 0.063) + 0.0, (baseY - 0.043) + 0.0, 0.010, 0.015, 0.0, 255, 255, 255, 255)

                DrawTexts(baseX - 0.053, baseY - (0.043) - 0.013, "Go Back", false, 0.35, {255, 255, 255, 255}, 0, 0) -- title


                local baseX = 0.5 -- gauche / droite ( plus grand = droite )
                local baseY = 0.35 -- Hauteur ( Plus petit = plus haut )
                local baseWidth = 0.3 -- Longueur
                local baseHeight = 0.03 -- Epaisseur

                DrawRect(baseX, baseY - 0.058, baseWidth, baseHeight - 0.02, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255) -- Liseret
                DrawRect(baseX, baseY - 0.043, baseWidth, baseHeight, 255, 255, 255, 255) -- Bannière
               -- DrawSprite("sprite", "drifting_b", (baseY + 0.05) + 0.0, (baseY - 0.043) + 0.0, 0.010, 0.015, 0.0, 255, 255, 255, 255)

                DrawTexts(baseX - 0.125, baseY - (0.043) - 0.013, "maps", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title
                DrawTexts(baseX + 0.135, baseY - (0.043) - 0.013, tostring(#mapsArea), true, 0.35, {0, 0, 0, 255}, 6, 0) -- title
        
                DrawRect(baseX, baseY, baseWidth, baseHeight, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255)
                DrawTexts(baseX, baseY - 0.013, "Maps name", true, 0.35, {0, 0, 0, 255}, 2, 0) -- title

                for i = 1,#mapsArea do
                    if selectedMapIndex == i then

                        DrawRect(baseX, baseY + (0.032 * i), baseWidth + 0.001, baseHeight + 0.001, LiseretColor[1], LiseretColor[2], LiseretColor[3], 255)
                        DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 28, 28, 28, 180)
                        DrawTexts(baseX, baseY + (0.032 * i) - 0.013, mapsArea[i].label, true, 0.35, {255, 255, 255, 255}, 6, 0) -- level
                        
                        if mapsArea[i].tag ~= "" then
                            DrawRect(baseX + 0.11, baseY + (0.032 * i), 0.03, 0.015, 255, 31, 31, 220)
                            DrawTexts(baseX + 0.11, baseY + (0.032 * i) - 0.012, mapsArea[i].tag, true, 0.30, {255, 255, 255, 255}, 6, 0) -- level
                        end
                    else
                        DrawRect(baseX, baseY + (0.032 * i), baseWidth, baseHeight, 28, 28, 28, 180)
                        DrawTexts(baseX, baseY + (0.032 * i) - 0.013, mapsArea[i].label, true, 0.35, {255, 255, 255, 255}, 6, 0) -- level

                        if mapsArea[i].tag ~= "" then
                            DrawRect(baseX + 0.11, baseY + (0.032 * i), 0.03, 0.015, 255, 31, 31, 220)
                            DrawTexts(baseX + 0.11, baseY + (0.032 * i) - 0.012, mapsArea[i].tag, true, 0.30, {255, 255, 255, 255}, 6, 0) -- level
                        end
                    end
                end



                if IsDisabledControlJustReleased(0, 177) then
                    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

                    cam.setActive("lobby", true)
                    cam.switchToCam("lobby", "lobby_map", 1500)

                    inLobbyMap = false
                end


                if IsDisabledControlJustReleased(0, 172) then
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    if mapsArea[selectedMapIndex - 1] ~= nil then
                        selectedMapIndex = selectedMapIndex - 1
                    end
                end
    
                if IsDisabledControlJustReleased(0, 173) then
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    if mapsArea[selectedMapIndex + 1] ~= nil then
                        selectedMapIndex = selectedMapIndex + 1
                    end 
                end
    
                if IsDisabledControlJustReleased(0, 191) and cooldown > 50 then
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)

                    inLobby = false
                    DeleteEntity(lobbyVeh)
                    TriggerEvent("InteractSound_CL:Stop")
                    SetNuiFocus(false, false)
                    cam.render("lobby", false, false, 0)

                    p:SetMap(mapsArea[selectedMapIndex].map)
                    inLobbyMap = false
                    ResetMulti(0.1)
                    p:Teleport(mapsArea[selectedMapIndex].pos.xyz)
                    ExtendWorldBoundaryForPlayer(-9000.0,-11000.0,30.0)
                    ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)

                end
            end



            cooldown = cooldown + 1
            DisableAllControlActions(0)
            RefreshCursorPos()
            Wait(1)
        end
        DisplayRadar(true)

    end)
end


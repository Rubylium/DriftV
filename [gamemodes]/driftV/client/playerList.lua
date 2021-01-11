local players = {}

RegisterNetEvent("drift:SyncPlayer")
AddEventHandler("drift:SyncPlayer", function(plays)
    players = plays
end)

Citizen.CreateThread(function()
    TriggerServerEvent("drift:RequestSync")
    while true do
        
        if IsControlJustPressed(0, 20) then

            local scaleform = RequestScaleformMovie("MP_MM_CARD_FREEMODE")
            while not HasScaleformMovieLoaded(scaleform) do
                Citizen.Wait(0)
            end
        
            PushScaleformMovieFunction(scaleform, "SET_ICON")
            PushScaleformMovieFunctionParameterInt(100)
            PushScaleformMovieFunctionParameterInt(7)
            PushScaleformMovieFunctionParameterInt(66)
            PopScaleformMovieFunctionVoid()
        
            PushScaleformMovieFunction(scaleform, "SET_TITLE")
            PushScaleformMovieFunctionParameterString("DriftV")
            PushScaleformMovieFunctionParameterString("Welcome to the drift paradise")
            PushScaleformMovieFunctionParameterInt(14)  -- Icon ID
            PopScaleformMovieFunctionVoid()
        
            local count = 0
            for k,v in pairs(players) do
                PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
                PushScaleformMovieFunctionParameterInt(count)
                PushScaleformMovieFunctionParameterInt(v.ping) -- Right Side Number
                PushScaleformMovieFunctionParameterString(v.name) -- Player Name
                PushScaleformMovieFunctionParameterInt(200) -- Color Of Item
                PushScaleformMovieFunctionParameterInt(2000)
                PushScaleformMovieFunctionParameterInt(v.servID) -- Left Side Number
                PushScaleformMovieFunctionParameterInt(XNL_GetLevelFromXP(v.xp)) -- Amount Of JP
                PushScaleformMovieFunctionParameterString("") -- Clan Tag , Needs 3 Characters Before To Display
                PushScaleformMovieFunctionParameterInt(1) -- 0 = display no JP icon, 1 = display JP icon, 2+ = display nothing,
                PopScaleformMovieFunctionVoid()
                count = count + 1
            end
        
            PushScaleformMovieFunction(scaleform, "DISPLAY_VIEW")
            PopScaleformMovieFunctionVoid()
            

            while IsControlPressed(0, 20) do
                DrawScaleformMovie(scaleform, 0.12,0.35, 0.27, 0.55, 255, 255, 255, 255)
                Wait(1)
            end
            SetScaleformMovieAsNoLongerNeeded(scaleform)
        end
        Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        TriggerServerEvent("drift:RequestSync")
        Wait(3000)
    end
end)
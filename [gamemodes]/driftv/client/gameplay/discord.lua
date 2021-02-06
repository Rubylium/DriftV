Citizen.CreateThread(function()
while not loaded do Wait(500) end
    

    while true do
        SetDiscordAppId(805364840854978581)
        SetDiscordRichPresenceAsset("logo")
        SetDiscordRichPresenceAssetText("discord.gg/Z486cyeM78")
        if inLobby then
            SetRichPresence("Idling in the lobby")
        elseif p:IsInGarage() then
            SetRichPresence("Looking at his vehicles in his garage")
        else
            SetRichPresence("Drifting in "..p:GetMap())
        end
        Wait(1000)
    end
end)
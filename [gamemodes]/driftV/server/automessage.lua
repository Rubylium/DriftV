local message = Config.serverAutoMessage


Citizen.CreateThread(function()
    while true do
        for _,v in pairs(message) do

            SetConvarReplicated("sv_hostname", string.format(Config.serverName, tostring(pCount), Config.discordLink))
            
            SetConvarServerInfo("Players", tostring(GetNumPlayerIndices()))
            SetConvarServerInfo("Type", "Drift")
            SetConvarServerInfo("Framework", "Custom")
            SetConvarServerInfo("Discord", Config.discordLink)

            Wait(1*60000)
        end
    end
end)
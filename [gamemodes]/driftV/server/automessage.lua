local message = {
    "DriftV staff is happy to see you around !",
    "Want to go somewhere ? Press F1 and go to the teleportation menu !",
    "Don't hesitate to invite your friends! The more we are the more fun we have!",
    "You want to suggest an addition on the server? Go to our discord!",
    "You want to compare your level to the other? Try to beat their score on the leaderboards!",
    "Want to see the list of players? Hold Z! ( W for azerty keyboards )",
}


Citizen.CreateThread(function()
    while true do
        for _,v in pairs(message) do
            TriggerClientEvent("FeedM:showNotification", -1, v, 15000, "info")

            SetConvarReplicated("sv_hostname", "🌍 ^3Drift^1V ^9| ^6 Drift server ^9| ^6Custom framework ^9| ^6"..tostring(pCount).." new player(s) today ^9|                        ^6████████████ New Season every week ████████████ ")
            SetConvarServerInfo("Players", tostring(GetNumPlayerIndices()))
            SetConvarServerInfo("Type", "Drift")
            SetConvarServerInfo("Framework", "Custom")
            debugPrint("Hostname changed to: 🌍 ^3Drift^1V ^9| ^6 drift server ^9| ^6Custom framework ^9| ^6"..tostring(pCount).." new player(s) today ^9|                        ^6████████████ New Season every week ████████████ ")

            Wait(1*60000)
        end
    end
end)
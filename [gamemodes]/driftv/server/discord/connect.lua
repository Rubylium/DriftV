local id = "797634628155736105"
local function OnPlayerConnecting(name, setKickReason, deferrals)
    deferrals.defer()
    deferrals.update("Checking discord roles ...")
    local ids = GetDiscord(source)
    if ids == nil then
        deferrals.done("Discord was not found. Please link discord to your FiveM account to play on DriftV")
    end

    local roles = GetDiscordRoles(source)

    for k,v in pairs(roles) do
        if v == id then
            deferrals.done()
        end
    end

    deferrals.done("It is required to join the DriftV discord to play on the server. Please join at the following address:  http://discord.gg/Z486cyeM78")
end

AddEventHandler("playerConnecting", OnPlayerConnecting)
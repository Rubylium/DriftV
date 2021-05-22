local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local idFound
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format(Config.CheckingIdentifierMessage, name, Config.UseIdentifierAsKey))

    for _, v in pairs(identifiers) do
        if string.find(v, Config.UseIdentifierAsKey) then
            idFound = v
            break
        end
    end

    -- mandatory wait!
    Wait(0)

    if not idFound then
        deferrals.done(string.format(Config.IdentifierNotFoundMessage, Config.UseIdentifierAsKey))
    else
        deferrals.done()
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)
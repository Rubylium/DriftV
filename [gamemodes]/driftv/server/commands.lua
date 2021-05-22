RegisterCommand("give", function(source, args, rawCommand)
    if source == 0 then
        source = tonumber(args[1])
        money = tonumber(args[2])
        player[source].money = math.floor(player[source].money + money)
        RefreshPlayerData(source)
        player[source].needSave = true
    end
end, false)
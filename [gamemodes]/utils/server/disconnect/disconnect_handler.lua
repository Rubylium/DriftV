
ESX = nil
local cached_players = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


AddEventHandler('playerDropped', function (reason)
    local pCoords = GetEntityCoords(GetPlayerPed(source))
    cached_players[source] = {res = reason, name = GetPlayerName(source), coords = pCoords}
    TriggerClientEvent("utils:playerDisconnect", -1, source, {res = reason, name = GetPlayerName(source), pos = pCoords})
end)

--[[
RegisterCommand("fake", function(source, args, rawCommand)
    local pCoords = GetEntityCoords(GetPlayerPed(source))
    cached_players[source] = {res = "Exemple de raison de deco", name = GetPlayerName(source), coords = pCoords}
    TriggerClientEvent("utils:playerDisconnect", -1, source, {res = "Exemple de raison de deco", name = GetPlayerName(source), pos = pCoords})
end, false)
]]

RegisterCommand("quitban", function(source, args, rawCommand)
    if args[1] == nil then
        
        return
    end

    if args[2] == nil then

        return
    end
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= "user" then
        -- Need to do ban logic later
    end
end, false)

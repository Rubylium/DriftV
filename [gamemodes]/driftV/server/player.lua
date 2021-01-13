local player = {}
saison = "_testServer19xw"
pCount = 1

function InitPlayer(source)
    pCount = pCount + 1
    local source = tonumber(source)
    local license = GetLicense(source)

    local db = rockdb:new()
    local data = db:GetTable("player_"..tostring(license)..saison)
    if data == nil then
        data = {
            license = license,
            money = 50000,
            driftPoint = 0,
            xp = 0,
            cars = {},
            succes = {},
            needSave = false
        }
        player[source] = data
        SavePlayer(source)
        debugPrint("Player created into database")
    else
        if data.succes == nil then
            data.succes = {}
        end
        player[source] = data
        debugPrint("Loaded player for database ("..data.money .. " " .. data.driftPoint ..")")
    end

    SetPlayerInstance(source, 1)
    RefreshPlayerData(source)
end

function RefreshPlayerData(source)
    TriggerClientEvent("driftV:RefreshData", source, player[source])
end

function SavePlayer(source)
    local db = rockdb:new()
    local license = GetLicense(source)
    db:SaveTable("player_"..tostring(license)..saison, player[source])
    debugPrint("Player ("..source..") saved")
    player[source].needSave = false
end

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(player) do

            if GetPlayerPing(k) == 0 then
                player[source] = nil
            else
                if v.needSave then
                    SavePlayer(k)
                end
            end
        end
        Wait(10*1000)
    end
end)

RegisterNetEvent("driftV:InitPlayer")
AddEventHandler("driftV:InitPlayer", function()
    local source = source
    InitPlayer(source)
end)

AddEventHandler('playerDropped', function (reason)
    local source = source
    if player[source] ~= nil then
        SavePlayer(source)
        player[source] = nil
    end
end)

RegisterNetEvent("driftV:SubmitDriftPoint")
AddEventHandler("driftV:SubmitDriftPoint", function(point)
    local source = source
    player[source].driftPoint = player[source].driftPoint + point
    player[source].money = math.floor(player[source].money + point / 200)
    TriggerClientEvent("FeedM:showNotification", source, "+ ~g~"..tostring(math.floor(point / 200)).."~s~$", 2000, "success")

    RefreshPlayerData(source)
    player[source].needSave = true

end)

RegisterNetEvent("driftV:SubmitExpPoints")
AddEventHandler("driftV:SubmitExpPoints", function(point)
    local source = source
    player[source].xp = point

    RefreshPlayerData(source)
    player[source].needSave = true

end)

RegisterNetEvent("driftV:SetPlayerArchivement")
AddEventHandler("driftV:SetPlayerArchivement", function(arch)
    player[source].succes = arch
    player[source].needSave = true
end)

RegisterNetEvent("drift:RequestSync")
AddEventHandler("drift:RequestSync", function()
    local players = {}
    for k,v in player do
        table.insert(players, {name = GetPlayerName(k), xp = v.xp, servID = k, ping = GetPlayerPing(k)})
    end

    TriggerClientEvent('drift:SyncPlayer', source, players)
end)

local inPassive = {}
RegisterNetEvent("dirft:SetInPassive")
AddEventHandler("dirft:SetInPassive", function(status)
    if status then
        inPassive[source] = source
    else
        inPassive[source] = nil
    end
    TriggerClientEvent("dirft:SetInPassive", -1, inPassive)
end)


RegisterNetEvent("drift:BuyVehicle")
AddEventHandler("drift:BuyVehicle", function(price, label, model)

    if price <= player[source].money and price > 49000 then
        player[source].money = player[source].money - price
        table.insert(player[source].cars, {label = label, model = model})
        TriggerClientEvent("FeedM:showNotification", source, "New vehicle added to your garage !", 5000, "success")

        RefreshPlayerData(source)
        player[source].needSave = true
    end
end)
player = {}
saison = "_seaon_4"
pCount = 1
GlobalState.mode = 'open'

function InitPlayer(source)
    pCount = pCount + 1
    local source = tonumber(source)
    local license = GetLicense(source)

    local db = rockdb:new()
    local data = db:GetTable("player_"..tostring(license)..saison)
    if data == nil then
        data = {
            license = license,
            money = 100000,
            driftPoint = 0,
            exp = 0,
            level = 0,
            cars = {},
            succes = {},
            needSave = false,
            crew = "None",
            crewOwner = false,
        }
        player[source] = data
        pCrew[source] = "None"
        SavePlayer(source)

        SendTextToWebhook("general_fr", 0x34eb37, "**Nouveau joueur!**", "Le joueur ``".. GetPlayerName(source) .. "`` a rejoint le serveur pour la première fois ! Envie de lui dire bonjour ? Connectes-toi au serveur dès maintenant !")
        SendTextToWebhook("general_en", 0x34eb37, "**New player!**", "The player ``".. GetPlayerName(source) .. "`` joined the server for the first time! Want to say hello to him? Connect to the server now!")

        debugPrint("Player created into database")
    else
        if data.succes == nil then
            data.succes = {}
        end
        if data.crew == nil then
            data.crew = "None"
            data.crewOwner = false
        end
        
        

        if crew[data.crew] == nil then
            data.crew = "None"
        end

        pCrew[source] = data.crew
        player[source] = data

        debugPrint("Loaded player for database ("..data.money .. " " .. data.driftPoint ..")")
    end

    SetPlayerInstance(source, 1)
    RefreshPlayerData(source)
end


function RefreshPlayerData(source)
    TriggerClientEvent("driftV:RefreshData", source, player[source])
end

function RefreshOtherPlayerData()
    TriggerClientEvent("driftV:RefreshOtherPlayerData", -1, crew, pCrew)
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
        pCrew[source] = nil
    end
end)

RegisterNetEvent("driftV:SubmitDriftPoint")
AddEventHandler("driftV:SubmitDriftPoint", function(point)
    local source = source
    player[source].driftPoint = player[source].driftPoint + point
    player[source].money = math.floor(player[source].money + point / 200)
    TriggerClientEvent("FeedM:showNotification", source, "+ ~g~"..tostring(math.floor(point / 200)).."~s~$", 2000, "success")
    AddPointsToCrew(source, point)

    RefreshPlayerData(source)
    player[source].needSave = true

end)

RegisterNetEvent("driftV:AddMoney")
AddEventHandler("driftV:AddMoney", function(money)
    local source = source
    player[source].money = math.floor(player[source].money + money)
    TriggerClientEvent("FeedM:showNotification", source, "+ ~g~"..tostring(math.floor(money)).."~s~$", 2000, "success")
end)

RegisterNetEvent("driftV:SubmitExpPoints")
AddEventHandler("driftV:SubmitExpPoints", function(point)
    local source = source
    player[source].exp = math.floor(point)

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
        table.insert(players, {name = GetPlayerName(k), exp = v.exp, servID = k, ping = GetPlayerPing(k), crew = v.crew})
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
        table.insert(player[source].cars, {label = label, model = model, props = {}})
        TriggerClientEvent("FeedM:showNotification", source, "New vehicle added to your garage !", 5000, "success")

        RefreshPlayerData(source)
        player[source].needSave = true
    end
end)

RegisterNetEvent("drift:UpdateCars")
AddEventHandler("drift:UpdateCars", function(cars)
    player[source].cars = cars
    player[source].needSave = true
end)


RegisterNetEvent("drift:GotBusted")
AddEventHandler("drift:GotBusted", function(cops)
    TriggerClientEvent("FeedM:showNotification", -1, "The player "..GetPlayerName(source).." got busted with "..cops.." cops !", 15000, "danger")
end)

RegisterNetEvent("drift:Pay")
AddEventHandler("drift:Pay", function(price)
    player[source].money = player[source].money - price
    TriggerClientEvent("FeedM:showNotification", source, "- ~r~"..tostring(math.floor(price)).."~s~$", 2000, "success")
    player[source].needSave = true
    RefreshPlayerData(source)
end)
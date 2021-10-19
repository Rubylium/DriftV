player = {}
saison = Config.playerSeason
pCount = 1
GlobalState.mode = 'open'

function InitPlayer(source)
    pCount = pCount + 1
    local source = tonumber(source)
    local license = GetLicense(source)

    local db = rockdb:new()
    db:SaveInt("pCount", pCount)

    local data = {}
    local gotData = false
    if not Config.UseMysql then
        data = db:GetTable("player_"..tostring(license)..saison)
        gotData = false
    else
        MySQL.Async.fetchAll('SELECT * FROM players WHERE license = @license', { ['@license'] = tostring(license)..saison }, function(result)
            --print(json.encode(result))

            data = result[1]
            gotData = true
        end)
    end

    while gotData == false do
        print("Waiting data load ...")
        Wait(100)
    end

    if data == nil then
        data = {
            pName = GetPlayerName(source),
            license = license,
            money = Config.DefaultMoney,
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

        local dataCreated = false
        if Config.UseMysql then
            MySQL.Async.execute('INSERT INTO players (pName, money, license, driftPoint, exp, level, cars, succes, crew, crewOwner) VALUES (@name, @money, @license, @driftPoint, @exp, @level, @cars, @succes, @crew, @crewOwner)',
            { 
                ['name'] = data.pName,
                ['money'] = data.money, 
                ['license'] = tostring(license)..saison, 
                ['driftPoint'] = math.floor(data.driftPoint), 
                ['exp'] = math.floor(data.exp),
                ['level'] = data.level,
                ['cars'] = json.encode(data.cars),
                ['succes'] = json.encode(data.succes),
                ['crew'] = data.crew,
                ['crewOwner'] = data.crewOwner,
            },
            function(affectedRows)
                dataCreated = true
                --print(affectedRows)
            end)
        else
            dataCreated = true
        end

        while dataCreated == false do
            print("Waiting data create ...")
            Wait(100)
        end

        if not Config.UseMysql then
            SavePlayer(source)
        end

        debugPrint("Player created into database")
    else
        if Config.UseMysql then
            data.succes = json.decode(data.succes)
            data.cars = json.decode(data.cars)
        end
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

        data.needSave = false

        pCrew[source] = data.crew
        player[source] = data

        debugPrint("Loaded player for database ("..data.money .. " " .. data.driftPoint ..")")
    end

    TriggerClientEvent("syncEvents", source, Events)
    SetPlayerInstance(source, 1)
    RefreshPlayerData(source)
end


function RefreshPlayerData(source)
    TriggerClientEvent("driftV:RefreshData", source, player[source])
    RefreshOtherPlayerData()
end

function RefreshOtherPlayerData()
    TriggerClientEvent("driftV:RefreshOtherPlayerData", -1, crew, pCrew, KingDriftCrew, CrewRanking)
end

function SavePlayer(source)
    local db = rockdb:new()
    local license = GetLicense(source)

    local saved = false
    if Config.UseMysql then
        local data = player[source]
        MySQL.Async.execute('UPDATE players SET pName = @name, money = @money, driftPoint = @driftPoint, exp = @exp, level = @level, cars = @cars, succes = @succes, crew = @crew, crewOwner = @crewOwner WHERE license = @license',
        { 
            ['name'] = GetPlayerName(source), -- Get player name from native to force refresh if player change name
            ['money'] = data.money, 
            ['license'] = data.license, 
            ['driftPoint'] = math.floor(data.driftPoint), 
            ['exp'] = math.floor(data.exp),
            ['level'] = data.level,
            ['cars'] = json.encode(data.cars),
            ['succes'] = json.encode(data.succes),
            ['crew'] = data.crew,
            ['crewOwner'] = data.crewOwner,
        },
        function(affectedRows)
            save = true
            --print(affectedRows)
        end)
    else
        db:SaveTable("player_"..tostring(license)..saison, player[source])
        save = true
    end

    while save == false do
        print("Waiting for save ...") 
        Wait(100)
    end
    
    debugPrint("Player ("..source..") saved")
    player[source].needSave = false
end

Citizen.CreateThread(function()
    local db = rockdb:new()
    local data = db:GetInt("pCount")
    if data ~= nil then
        pCount = data
    else
        pCount = 1
    end
    while true do
        for k,v in pairs(player) do

            if GetPlayerPing(k) == 0 then
                player[source] = nil
            else
                if v.needSave then
                    SavePlayer(k)
                    v.needSave = false
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

RegisterSecuredNetEvent(Events.setDriftPoint, function(point)
    local source = source
    player[source].driftPoint = player[source].driftPoint + point
    player[source].money = math.floor(player[source].money + point / 200)
    TriggerClientEvent("FeedM:showNotification", source, "+ ~g~"..tostring(math.floor(point / 200)).."~s~$", 2000, "success")
    AddPointsToCrew(source, point)

    RefreshPlayerData(source)
    player[source].needSave = true

end)

RegisterSecuredNetEvent(Events.addMoney, function(money)
    local source = source
    player[source].money = math.floor(player[source].money + money)
    TriggerClientEvent("FeedM:showNotification", source, "+ ~g~"..tostring(math.floor(money)).."~s~$", 2000, "success")
end)

RegisterSecuredNetEvent(Events.SetExp, function(point)
    local source = source
    player[source].exp = math.floor(point)

    RefreshPlayerData(source)
    player[source].needSave = true

end)

RegisterSecuredNetEvent(Events.setArchivment, function(arch)
    player[source].succes = arch
    player[source].needSave = true
end)

RegisterSecuredNetEvent(Events.reqSync, function()
    local players = {}
    for k,v in pairs(player) do
        table.insert(players, {name = GetPlayerName(k), exp = v.exp, servID = k, ping = GetPlayerPing(k), crew = v.crew})
    end

    TriggerClientEvent(Events.getSync, source, players)
end)

local inPassive = {}
RegisterSecuredNetEvent(Events.setPassive, function(status)
    if status then
        inPassive[source] = source
    else
        inPassive[source] = nil
    end
    TriggerClientEvent(Events.setPassive, -1, inPassive)
end)


RegisterSecuredNetEvent(Events.buyVeh, function(price, label, model)

    if price <= player[source].money and price > 49000 then
        player[source].money = player[source].money - price
        table.insert(player[source].cars, {label = label, model = model, props = {}})
        TriggerClientEvent("FeedM:showNotification", source, "New vehicle added to your garage !", 5000, "success")

        RefreshPlayerData(source)
        player[source].needSave = true
    end
end)

RegisterSecuredNetEvent(Events.refreshCars, function(cars)
    player[source].cars = cars
    player[source].needSave = true
end)


RegisterSecuredNetEvent(Events.busted, function(cops)
    TriggerClientEvent("FeedM:showNotification", -1, "The player "..GetPlayerName(source).." got busted with "..cops.." cops !", 15000, "danger")
end)

RegisterSecuredNetEvent(Events.pay, function(price)
    player[source].money = player[source].money - price
    TriggerClientEvent("FeedM:showNotification", source, "- ~r~"..tostring(math.floor(price)).."~s~$", 2000, "success")
    player[source].needSave = true
    RefreshPlayerData(source)
end)

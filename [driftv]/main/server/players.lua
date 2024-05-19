Players = {}
Players.List = {}

function Players.New(source)
    local self = {}
    self.source = source
    self.name = GetPlayerName(source)
    self.license = GetPlayerIdentifiers(source)[1]
    self.money = 50000
    self.cars = {}
    self.crew = nil

    Players.List[source] = self
end

function Players.Get(source)
    return Players.List[source]
end

function Players.LoadDataFromDB(source)
    local player = Players.Get(source)
    MySQL.Async.fetchAll("SELECT * FROM players WHERE license = @license", {
        ["@license"] = player.license,
    }, function(result)
        if result[1] then
            player.money = result[1].money
            player.crew = result[1].crew
            player.cars = json.decode(result[1].cars)
        else
            MySQL.Async.execute("INSERT INTO players (license, money, crew, cars) VALUES (@license, @money, @crew, @cars)", {
                ["@license"] = player.license,
                ["@money"] = player.money,
                ["@crew"] = player.crew,
                ["@cars"] = json.encode(player.cars),
            })
        end
    end)
end

function Players.SaveDataToDB(source)
    local player = Players.Get(source)
    MySQL.Async.execute("UPDATE players SET money = @money, crew = @crew, cars = @cars WHERE license = @license", {
        ["@license"] = player.license,
        ["@money"] = player.money,
        ["@crew"] = player.crew,
        ["@cars"] = json.encode(player.cars),
    })
end

function Players.GetPlayers()
    local players = {}
    for k, v in pairs(Players.List) do
        table.insert(players, v)
    end
    return players
end

function Players.AddCar(source, name, props)
    local player = Players.Get(source)
    table.insert(player.cars, {
        name = name,
        props = props,
    })
    Players.SaveDataToDB(source)
end

RegisterNetEvent("main:playerLoaded", function()
    local source = source
    Players.New(source)
    Players.LoadDataFromDB(source)
end)

-- Handle auto save + remove from cache when disconnected
Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Players.List) do
            Players.SaveDataToDB(k)

            if GetPlayerPing(k) == 0 then
                Players.List[k] = nil
            end
        end
        Citizen.Wait(60000)
    end
end)
VehicleShop = {}
VehicleShop.List = {
    {
        name = "blista",
        type = "race",
        price = 5000,
    },
    {
        name = "sultan",
        type = "race",
        price = 10000,
    },
    {
        name = "elegy",
        type = "drift",
        price = 15000,
    },
}

function VehicleShop.Get(name)
    for k, v in pairs(VehicleShop.List) do
        if v.name == name then
            return v
        end
    end
end

function VehicleShop.Sell(source, index)
    local player = Players.Get(source)
    local vehicle = player.cars[index]
    player.money = player.money + math.floor(VehicleShop.Get(vehicle.name).price / 2)
    table.remove(player.cars, index)
    Players.SaveDataToDB(source)
end

RegisterNetEvent("main:buyVehicle", function(name)
    local source = source
    local player = Players.Get(source)
    local vehicle = VehicleShop.Get(name)
    if player.money >= vehicle.price then
        player.money = player.money - vehicle.price
        Players.AddCar(source, name, {})
    end
end)
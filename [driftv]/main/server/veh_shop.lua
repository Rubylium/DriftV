VehicleShop = {}
VehicleShop.List = {
    {
        name = "blista",
        price = 5000,
    },
    {
        name = "sultan",
        price = 10000,
    },
    {
        name = "elegy",
        price = 15000,
    },
    {
        name = "comet",
        price = 20000,
    },
    {
        name = "turismo",
        price = 25000,
    },
    {
        name = "infernus",
        price = 30000,
    },
    {
        name = "bullet",
        price = 35000,
    },
    {
        name = "cheetah",
        price = 40000,
    },
    {
        name = "banshee",
        price = 45000,
    },
    {
        name = "phoenix",
        price = 50000,
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
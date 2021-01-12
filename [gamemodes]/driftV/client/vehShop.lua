local vehs = {
    {
        label = "Honda",
        vehs = {
            {price = 50000,label = "Honda Accord 86",model = "accord86"},
            {price = 120000,label = "Honda Civic EK9 Rocket Bunny",model = "civicek9rb"},
            {price = 750000,label = "1992 Honda NSX-R Rocket Bunny",model = "nsxtypr"}

        },
    },
    {
        label = "BMW",
        vehs = {
            {price = 65000,label = "BMW e46",model = "bmwe"},
            {price = 90000,label = "1992 BMW M3 E36 Pandem Rocket Bunny",model = "e36prb"},
        },
    },
    {
        label = "Mazda",
        vehs = {
            {price = 75000,label = "Mazda rx7 Fc3s",model = "fc3s"},
            {price = 140000,label = "Mazda rx7",model = "FD"},
        },
    },
    {
        label = "Nissan",
        vehs = {
            {price = 120000,label = "Nissan s15 RB",model = "s15rb"},
            {price = 250000,label = "Nissan r35",model = "gtrp"},
            {price = 350000,label = "Nissan r33",model = "r33"},
            {price = 140000,label = "Nissan 350z Rocket Bunny Kit Stanced",model = "350zrb"},
        },
    },
    {
        label = "Mitsubishi",
        vehs = {
            {price = 230000,label = "Mitsubishi Lancer Evo VI",model = "cp9a"},
        },
    },
    {
        label = "Ford",
        vehs = {
            {price = 450000,label = "2015 Ford Mustang GT",model = "MGT"},
        },
    },
    {
        label = "Acura",
        vehs = {
            {price = 550000,label = "Acura NSX LB",model = "filthynsx"},
        },
    },
    {
        label = "Subaru",
        vehs = {
            {price = 190000,label = "Subaru BRZ Rocket Bunny",model = "brz"},
        },
    },
    {
        label = "Lexus",
        vehs = {
            {price = 70000,label = "Lexus RC350 Rocket Bunny",model = "RC350"},
        },
    },
}

local open = false
local selectedSub = {}
local previewVeh = {
    entity = 0,
    model = ""
}
local previewCoords = vector4(-44.621406555176, -1096.7896728516, 26.422359466553, 118.64887237549)
local vehShopCoords = vector3(-43.162559509277, -1100.0212402344, 26.422359466553)
local main = RageUI.CreateMenu("DriftV", "Welcome to the drift paradise")
local sub =  RageUI.CreateSubMenu(main, "DriftV", "Welcome to the drift paradise")
main.Closed = function()
    open = false
    RageUI.CloseAll()
    RageUI.Visible(main, false)
    DeleteEntity(previewVeh.entity)
end

function OpenVehShopMenu()
    if open then
        open = false
        RageUI.Visible(main, false)
    else
        open = true
        RageUI.Visible(main, true)

        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    for k,v in pairs(vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = ">"}, true, {
                            onSelected = function()
                                selectedSub = k
                            end,
                        }, sub);
                    end
                end)

                RageUI.IsVisible(sub, function()
                    for k,v in pairs(vehs[selectedSub].vehs) do
                        RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."~s~$"}, true, {
                            onSelected = function()
                                if v.price <= p:GetMoney() then
                                    RageUI.CloseAll()
                                    open = false
                                    TriggerServerEvent("drift:BuyVehicle", v.price, v.label, v.model)
                                    ShowHelpNotification("Your new vehicle has been added to your garage! To take it out, use F1 -> My vehicles !", true)
                                else
                                    ShowNotification("Not enough money")
                                end
                            end,
                            onActive = function()
                                if previewVeh.model ~= v.model then
                                    DeleteEntity(previewVeh.entity)

                                    local veh = entity:CreateVehicleLocal(v.model, previewCoords.xyz, previewCoords.w)
                                    SetVehicleOnGroundProperly(veh:getEntityId())
                                    FreezeEntityPosition(veh:getEntityId(), true)
                                    previewVeh.entity = veh:getEntityId()
                                    previewVeh.model = v.model
                                end
                            end
                        }, sub);
                    end
                end)

                Wait(1)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while zone == nil do Wait(1) end

    zone.addZone("veh_shop", vehShopCoords, "Press [E] to open vehicle shop", function() OpenVehShopMenu() end, true, 36, 1.0, {133, 255, 92}, 170)
end)


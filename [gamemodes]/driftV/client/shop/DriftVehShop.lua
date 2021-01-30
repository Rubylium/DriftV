local vehs = {
    {
        label = "Tier 1",
        vehs = {
            {maker = "Honda", price = 50000, label = "Accord 86", model = "accord86"},
            {maker = "BMW", price = 65000,label = "e46",model = "bmwe"},
            {maker = "Lexus", price = 70000,label = "RC350 Rocket Bunny",model = "RC350"},
            {maker = "Chevrolet", price = 49500,label = "1970 Chevelle SS",model = "chevelle1970"},
            {maker = "Zirconium", price = 49500,label = "Stratum",model = "stratum"},
            {maker = "Toyota", price = 75000,label = "1985 Toyota Sprinter Trueno GT Apex",model = "AE86"},
        }
    },
    {
        label = "Tier 2",
        vehs = {
            {maker = "Honda", price = 85000, label = "2015 Civic Type R",model = "FK2"},
            {maker = "Honda", price = 85000, label = "Civic EK9 Rocket Bunny",model = "civicek9rb"},
            {maker = "BMW", price = 90000,label = "1992 M3 E36 Pandem Rocket Bunny",model = "e36prb"},
            {maker = "Mazda", price = 75000,label = "rx7 Fc3s",model = "fc3s"},
            {maker = "Nissan", price = 75000,label = "180sx",model = "180sx"}, -- icon
            {maker = "Maibatsu", price = 88000,label = "Penumbra",model = "penumbra"}, -- icon
            {maker = "Karin", price = 88000,label = "Sultan",model = "sultan"}, -- icon
           
        }
    },
    {
        label = "Tier 3",
        vehs = {
            {maker = "Mazda", price = 115000, label = "rx7",model = "FD"}, -- icon
            {maker = "Nissan", price = 120000,label = "s15 Rocket Bunny",model = "s15rb"},
            {maker = "Nissan", price = 140000,label = "350z Rocket Bunny Kit Stanced",model = "350zrb"},
            {maker = "Subaru", price = 190000,label = "BRZ Rocket Bunny",model = "brz"},
            {maker = "Subaru", price = 120000,label = "Impreza WRX STI 2004",model = "subwrx"},
        }
    },
    {
        label = "Tier 4",
        vehs = {
            {maker = "Nissan", price = 250000,label = "GTR35",model = "gtr"},
            {maker = "Nissan", price = 350000,label = "Skyline GT-R34 (BNR34) 2002",model = "skyline"},
            {maker = "Mitsubishi", price = 230000,label = "Lancer Evo VI",model = "cp9a"},
            {maker = "Ford", price = 450000,label = "2015 Mustang GT",model = "MGT"},
        }
    },
    {
        label = "Tier 5",
        vehs = {
            {maker = "Honda", price = 750000,label = "1992 NSX-R Rocket Bunny",model = "nsxtypr"},
            {maker = "Acura", price = 550000,label = "NSX LB",model = "filthynsx"},
            {maker = "Lamborghini", price = 1200000,label = "Gallardo Superleggera LB ",model = "gallardosuperlb"},
            {maker = "Lamborghini", price = 1400000,label = "2014 Huracan LB",model = "lbsihu"},
            {maker = "Toyota", price = 950000,label = "Supra mk4",model = "a80"},
        }
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
local main = RageUI.CreateMenu("DriftV", "~b~Drift vehicles shop")
local sub =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift vehicles shop")
main.Closed = function()
    open = false
    RageUI.CloseAll()
    RageUI.Visible(main, false)
    DeleteEntity(previewVeh.entity)
end
main.WidthOffset = 100.0
sub.WidthOffset = 100.0

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
                        RageUI.Button(v.maker.." "..v.label, nil, {RightLabel = "~g~"..GroupDigits(v.price).."~s~$"}, true, {
                            onSelected = function()
                                if v.price <= p:GetMoney() then
                                    RageUI.CloseAll()
                                    DeleteEntity(previewVeh.entity)
                                    open = false
                                    TriggerServerEvent("drift:BuyVehicle", v.price, v.maker.." "..v.label, v.model)
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

    zone.addZone("veh_shop", vehShopCoords, "Press ~INPUT_CONTEXT~ to open vehicle shop", function() OpenVehShopMenu() end, true, 36, 1.0, {133, 255, 92}, 170)
    AddBlip(vehShopCoords, 326, 2, 0.85, 17, "Drift vehicle shop")
end)


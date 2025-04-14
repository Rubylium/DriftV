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
            {maker = "Toyota", price = 95000,label = "Chaser JZX100",model = "jzx100"}, -- icon
            {maker = "Nissan", price = 95000,label = "1989-1992 Silvia S13",model = "nis13"}, -- icon
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
            {maker = "Nissan", price = 150000,label = "1994 240SX SE Fastback",model = "240sx"}, -- icon
            {maker = "Toyota", price = 190000,label = "GT86",model = "toy86"}, -- icon
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

local backToLobby = false
local open = false
local ownedVehicles = {} -- Addition to show owned vehicles that you can sell.
local selectedSub = {}
local previewVeh = {
    entity = 0,
    model = ""
}
local SelectedModel = ""
local previewEntitys = {}
local previewCoords = vector4(-44.621406555176, -1096.7896728516, 26.422359466553, 118.64887237549)
local vehShopCoords = vector3(-43.162559509277, -1100.0212402344, 26.422359466553)
local camPos = vector3(-45.922637939453, -1102.5314941406, 27.422361373901)
local main = RageUI.CreateMenu("DriftV", "~b~Drift vehicles shop")
local sub = RageUI.CreateSubMenu(main, "DriftV", "~b~Drift vehicles shop")
local sellSub = RageUI.CreateSubMenu(main, "Sell Vehicle", "~b~Sell your vehicles")

main.Closed = function()
    open = false
    RageUI.CloseAll()
    RageUI.Visible(main, false)
    DeleteEntity(previewVeh.entity)
    cam.render("SHOP", false, false, 0)
    cam.delete("SHOP")

    if backToLobby then
        EnableLobby()
    end
end

main.WidthOffset = 125.0
sub.WidthOffset = 125.0
sellSub.WidthOffset = 125.00

function OpenVehShopMenu(GoBackToLobby)
    if open then
        open = false
        RageUI.Visible(main, false)
    else
        if GoBackToLobby ~= nil and GoBackToLobby == true then
            backToLobby = true
        else
            backToLobby = false
        end

        open = true
        RageUI.Visible(main, true)
        cam.create("SHOP")
        cam.setPos("SHOP", camPos)
        cam.setFov("SHOP", 40.0)
        cam.lookAtCoords("SHOP", previewCoords.xyz)
        cam.setActive("SHOP", true)
        cam.render("SHOP", true, false, 0)

        -- Fetch vehicles when opening the "Sell Vehicle" menu
        TriggerServerEvent("drift:FetchVehicles")
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button("Money: ~g~$"..GroupDigits(tostring(p:GetMoney())) .. "", nil, {}, true, {})
                    RageUI.Button("Sell Vehicle", nil, {RightLabel = ">"}, true, {}, sellSub)
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
                                -- Check if the player already owns this vehicle
                                local alreadyOwned = false
                                for _, car in ipairs(ownedVehicles) do
                                    if car.model == v.model then
                                        alreadyOwned = true
                                        break
                                    end
                                end

                                if alreadyOwned then
                                    ShowNotification("You already own this vehicle!")
                                else
                                    if v.price <= p:GetMoney() then
                                        open = false
                                        RageUI.CloseAll()
                                        RageUI.Visible(main, false)
                                        DeleteEntity(previewVeh.entity)
                                        cam.render("SHOP", false, false, 0)
                                        cam.delete("SHOP")
                                        TriggerServerEvent(Events.buyVeh, v.price, v.maker.." "..v.label, v.model)
                                        ShowHelpNotification("Your new vehicle has been added to your garage! To take it out, use F1 -> My vehicles !", true)

                                        if backToLobby then
                                            EnableLobby()
                                        end
                                    else
                                        ShowNotification("Not enough money")
                                    end
                                end
                            end,
                            onActive = function()
                                if SelectedModel ~= v.model and not isCreatingVehicle then
                                    SelectedModel = v.model
                                    isCreatingVehicle = true
                                    Citizen.CreateThread(function()
                                        for _, entity in pairs(previewEntitys) do
                                            DeleteEntity(entity)
                                        end
                                        previewEntitys = {}

                                        local veh = entity:CreateVehicleLocal(SelectedModel, previewCoords.xyz, previewCoords.w)
                                        local vehId = veh:getEntityId()

                                        table.insert(previewEntitys, vehId)
                                        SetVehicleOnGroundProperly(vehId)
                                        FreezeEntityPosition(vehId, true)
                                        SetVehicleDirtLevel(vehId, 0.0)

                                        previewVeh.entity = vehId
                                        previewVeh.model = SelectedModel

                                        isCreatingVehicle = false
                                    end)
                                end
                            end
                        }, sub);
                    end
                end)

                RageUI.IsVisible(sellSub, function()
                    if #ownedVehicles > 0 then
                        for _, car in ipairs(ownedVehicles) do
                            RageUI.Button(car.label, nil, {RightLabel = "~g~$" .. GroupDigits(math.floor(car.price / 2))}, true, {
                                onSelected = function()
                                    TriggerServerEvent(Events.sellVeh, car.model) -- Trigger sell event
                
                                    -- Transition back to the main Drift Vehicle Shop menu
                                    RageUI.CloseAll() -- Close all menus
                                    Wait(200) -- Small delay to ensure clean transition
                                    RageUI.Visible(main, true) -- Reopen the main menu
                                end,
                                onActive = function()
                                    if SelectedModel ~= car.model and not isCreatingVehicle then
                                        SelectedModel = car.model
                                        isCreatingVehicle = true
                                        Citizen.CreateThread(function()
                                            for _, entity in pairs(previewEntitys) do
                                                DeleteEntity(entity)
                                            end
                                            previewEntitys = {}
                
                                            local veh = entity:CreateVehicleLocal(SelectedModel, previewCoords.xyz, previewCoords.w)
                                            local vehId = veh:getEntityId()
                
                                            table.insert(previewEntitys, vehId)
                                            SetVehicleOnGroundProperly(vehId)
                                            FreezeEntityPosition(vehId, true)
                                            SetVehicleDirtLevel(vehId, 0.0)
                
                                            previewVeh.entity = vehId
                                            previewVeh.model = SelectedModel
                
                                            isCreatingVehicle = false
                                        end)
                                    end
                                end
                            })
                        end
                    else
                        RageUI.Button("You don't Own any vehicles", nil, {}, false, {})
                    end
                end)
                
                Wait(1)
            end
        end)
    end
end

-- Listen for server response and update ownedVehicles
RegisterNetEvent("drift:ReceiveVehicles")
AddEventHandler("drift:ReceiveVehicles", function(carList)
    ownedVehicles = carList or {}
end)

Citizen.CreateThread(function()
    while zone == nil do Wait(1) end

    zone.addZone("veh_shop", vehShopCoords, "Press ~INPUT_CONTEXT~ to open vehicle shop", function() OpenVehShopMenu() end, true, 36, 1.0, {133, 255, 92}, 170)
    AddBlip(vehShopCoords, 326, 2, 0.85, 17, "Drift vehicle shop")
end)

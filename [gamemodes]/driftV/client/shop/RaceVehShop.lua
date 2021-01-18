local vehs = {
    {
        label = "Nissan",
        vehs = {
            {price = 50000, label = "Nissan Skyline GT-R34 (BNR34) 2002",model = "skyline"},
        },
    },
}

local open = false
local selectedSub = {}
local previewVeh = {
    entity = 0,
    model = ""
}
local previewCoords = vector4(-98.568412780762, 93.114837646484, 71.880958557129, 100.87768554688)
local vehShopCoords = vector3(-95.729873657227, 90.614570617676, 71.798545837402)
local main = RageUI.CreateMenu("DriftV", "~b~Race vehicles shop")
local sub =  RageUI.CreateSubMenu(main, "DriftV", "~b~Race vehicles shop")
main.Closed = function()
    open = false
    RageUI.CloseAll()
    RageUI.Visible(main, false)
    DeleteEntity(previewVeh.entity)
end

function OpenVehRaceShopMenu()
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
                                    DeleteEntity(previewVeh.entity)
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

    zone.addZone("veh_shop_race", vehShopCoords, "Press ~INPUT_CONTEXT~ to open the race vehicle shop", function() OpenVehRaceShopMenu() end, true, 36, 1.0, {133, 255, 92}, 170)
    AddBlip(vehShopCoords, 326, 2, 0.85, 17, "Race vehicle shop")
end)


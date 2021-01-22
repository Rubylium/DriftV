local customs = {
    {
        label = "Performance",
        extraAction = function(veh)
            SetVehicleDoorOpen(veh, 4, 0, 1)
            SetVehicleDoorOpen(veh, 5, 0, 1)
        end,
        customs = {
            {
                label = "Engine",
                mod = 11,
                bone = "engine",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 2,
                installed = 0,
                price = 85000,
                pricePad = 4500,
            },
            {
                label = "Brakes",
                mod = 12,
                bone = "engine",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 2,
                installed = 0,
                price = 45000,
                pricePad = 1350,
            },
            {
                label = "Transmission",
                mod = 13,
                bone = "engine",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 2,
                installed = 0,
                price = 65000,
                pricePad = 1350,
            },
            {
                label = "Suspension",
                mod = 15,
                bone = "engine",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 2,
                installed = 0,
                price = 25000,
                pricePad = 1750,
            },
        },
    },
    {
        label = "Cosmetics",
        customs = {
            {
                label = "Spoilers",
                mod = 0,
                bone = "spoiler",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Front Bumper",
                mod = 1,
                bone = "bumper_f",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Rear Bumper",
                mod = 2,
                bone = "bumper_r",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Side Skirt",
                mod = 3,
                bone = "chassis",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Exhaust",
                mod = 4,
                bone = "exhaust",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Frame",
                mod = 5,
                bone = "frame_1",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Grille",
                mod = 6,
                bone = "chassis",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Hood",
                mod = 7,
                bone = "bonnet",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Fender",
                mod = 8,
                bone = "chassis",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Right Fender",
                mod = 9,
                bone = "chassis",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
            {
                label = "Roof",
                mod = 10,
                bone = "roof",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 1,
                installed = 0,
                price = 24000,
                pricePad = 550,
            },
        },
    },
}

local colors = {
    {
        label = "black",
        price = 5000,
        colors = {
			{ index = 0, label = ('black')},
			{ index = 1, label = ('graphite')},
			{ index = 2, label = ('black_metallic')},
			{ index = 3, label = ('caststeel')},
			{ index = 11, label = ('black_anth')},
			{ index = 12, label = ('matteblack')},
			{ index = 15, label = ('darknight')},
			{ index = 16, label = ('deepblack')},
			{ index = 21, label = ('oil')},
			{ index = 147, label = ('carbon')}
        }
    },
    {
        label = "white",
        price = 5000,
        colors = {
			{ index = 106, label = ('vanilla')},
			{ index = 107, label = ('creme')},
			{ index = 111, label = ('white')},
			{ index = 112, label = ('polarwhite')},
			{ index = 113, label = ('beige')},
			{ index = 121, label = ('mattewhite')},
			{ index = 122, label = ('snow')},
			{ index = 131, label = ('cotton')},
			{ index = 132, label = ('alabaster')},
			{ index = 134, label = ('purewhite')}
        }
    },
    {
        label = "grey",
        price = 5000,
        colors = {
			{ index = 4, label = ('silver')},
			{ index = 5, label = ('metallicgrey')},
			{ index = 6, label = ('laminatedsteel')},
			{ index = 7, label = ('darkgray')},
			{ index = 8, label = ('rockygray')},
			{ index = 9, label = ('graynight')},
			{ index = 10, label = ('aluminum')},
			{ index = 13, label = ('graymat')},
			{ index = 14, label = ('lightgrey')},
			{ index = 17, label = ('asphaltgray')},
			{ index = 18, label = ('grayconcrete')},
			{ index = 19, label = ('darksilver')},
			{ index = 20, label = ('magnesite')},
			{ index = 22, label = ('nickel')},
			{ index = 23, label = ('zinc')},
			{ index = 24, label = ('dolomite')},
			{ index = 25, label = ('bluesilver')},
			{ index = 26, label = ('titanium')},
			{ index = 66, label = ('steelblue')},
			{ index = 93, label = ('champagne')},
			{ index = 144, label = ('grayhunter')},
			{ index = 156, label = ('grey')}
        }
    },
    {
        label = "red",
        price = 5000,
        colors = {
			{ index = 27, label = ('red')},
			{ index = 28, label = ('torino_red')},
			{ index = 29, label = ('poppy')},
			{ index = 30, label = ('copper_red')},
			{ index = 31, label = ('cardinal')},
			{ index = 32, label = ('brick')},
			{ index = 33, label = ('garnet')},
			{ index = 34, label = ('cabernet')},
			{ index = 35, label = ('candy')},
			{ index = 39, label = ('matte_red')},
			{ index = 40, label = ('dark_red')},
			{ index = 43, label = ('red_pulp')},
			{ index = 44, label = ('bril_red')},
			{ index = 46, label = ('pale_red')},
			{ index = 143, label = ('wine_red')},
			{ index = 150, label = ('volcano')}
        }
    },
    {
        label = "pink",
        price = 6000,
        colors = {
			{ index = 135, label = ('electricpink')},
			{ index = 136, label = ('salmon')},
			{ index = 137, label = ('sugarplum')}
        }
    },
    {
        label = "blue",
        price = 5000,
        colors = {
			{ index = 54, label = ('topaz')},
			{ index = 60, label = ('light_blue')},
			{ index = 61, label = ('galaxy_blue')},
			{ index = 62, label = ('dark_blue')},
			{ index = 63, label = ('azure')},
			{ index = 64, label = ('navy_blue')},
			{ index = 65, label = ('lapis')},
			{ index = 67, label = ('blue_diamond')},
			{ index = 68, label = ('surfer')},
			{ index = 69, label = ('pastel_blue')},
			{ index = 70, label = ('celeste_blue')},
			{ index = 73, label = ('rally_blue')},
			{ index = 74, label = ('blue_paradise')},
			{ index = 75, label = ('blue_night')},
			{ index = 77, label = ('cyan_blue')},
			{ index = 78, label = ('cobalt')},
			{ index = 79, label = ('electric_blue')},
			{ index = 80, label = ('horizon_blue')},
			{ index = 82, label = ('metallic_blue')},
			{ index = 83, label = ('aquamarine')},
			{ index = 84, label = ('blue_agathe')},
			{ index = 85, label = ('zirconium')},
			{ index = 86, label = ('spinel')},
			{ index = 87, label = ('tourmaline')},
			{ index = 127, label = ('paradise')},
			{ index = 140, label = ('bubble_gum')},
			{ index = 141, label = ('midnight_blue')},
			{ index = 146, label = ('forbidden_blue')},
			{ index = 157, label = ('glacier_blue')}
        }
    },
    {
        label = "yellow",
        price = 6000,
        colors = {
			{ index = 42, label = ('yellow')},
			{ index = 88, label = ('wheat')},
			{ index = 89, label = ('raceyellow')},
			{ index = 91, label = ('paleyellow')},
			{ index = 126, label = ('lightyellow')}
        }
    },
    {
        label = "green",
        price = 5000,
        colors = {
			{ index = 49, label = ('met_dark_green')},
			{ index = 50, label = ('rally_green')},
			{ index = 51, label = ('pine_green')},
			{ index = 52, label = ('olive_green')},
			{ index = 53, label = ('light_green')},
			{ index = 55, label = ('lime_green')},
			{ index = 56, label = ('forest_green')},
			{ index = 57, label = ('lawn_green')},
			{ index = 58, label = ('imperial_green')},
			{ index = 59, label = ('green_bottle')},
			{ index = 92, label = ('citrus_green')},
			{ index = 125, label = ('green_anis')},
			{ index = 128, label = ('khaki')},
			{ index = 133, label = ('army_green')},
			{ index = 151, label = ('dark_green')},
			{ index = 152, label = ('hunter_green')},
			{ index = 155, label = ('matte_foilage_green')}
        }
    },
    {
        label = "orange",
        price = 7000,
        colors = {
			{ index = 36, label = ('tangerine')},
			{ index = 38, label = ('orange')},
			{ index = 41, label = ('matteorange')},
			{ index = 123, label = ('lightorange')},
			{ index = 124, label = ('peach')},
			{ index = 130, label = ('pumpkin')},
			{ index = 138, label = ('orangelambo')}
        }
    },
    {
        label = "brown",
        price = 5000,
        colors = {
			{ index = 45, label = ('copper')},
			{ index = 47, label = ('lightbrown')},
			{ index = 48, label = ('darkbrown')},
			{ index = 90, label = ('bronze')},
			{ index = 94, label = ('brownmetallic')},
			{ index = 95, label = ('Expresso')},
			{ index = 96, label = ('chocolate')},
			{ index = 97, label = ('terracotta')},
			{ index = 98, label = ('marble')},
			{ index = 99, label = ('sand')},
			{ index = 100, label = ('sepia')},
			{ index = 101, label = ('bison')},
			{ index = 102, label = ('palm')},
			{ index = 103, label = ('caramel')},
			{ index = 104, label = ('rust')},
			{ index = 105, label = ('chestnut')},
			{ index = 108, label = ('brown')},
			{ index = 109, label = ('hazelnut')},
			{ index = 110, label = ('shell')},
			{ index = 114, label = ('mahogany')},
			{ index = 115, label = ('cauldron')},
			{ index = 116, label = ('blond')},
			{ index = 129, label = ('gravel')},
			{ index = 153, label = ('darkearth')},
			{ index = 154, label = ('desert')}
        }
    },
    {
        label = "purple",
        price = 7000,
        colors = {
			{ index = 71, label = ('indigo')},
			{ index = 72, label = ('deeppurple')},
			{ index = 76, label = ('darkviolet')},
			{ index = 81, label = ('amethyst')},
			{ index = 142, label = ('mysticalviolet')},
			{ index = 145, label = ('purplemetallic')},
			{ index = 148, label = ('matteviolet')},
			{ index = 149, label = ('mattedeeppurple')}
        }
    },
    {
        label = "chrome",
        price = 15000,
        colors = {
			{ index = 117, label = ('brushedchrome')},
			{ index = 118, label = ('blackchrome')},
			{ index = 119, label = ('brushedaluminum')},
			{ index = 120, label = ('chrome')}
        }
    },
    {
        label = "gold",
        price = 30000,
        colors = {
			{ index = 37, label = ('gold')},
			{ index = 158, label = ('puregold')},
			{ index = 159, label = ('brushedgold')},
			{ index = 160, label = ('lightgold')}
        }
    },
}

local allWheelsType = {
    {
        label = "Sport",
        type = 0
    },
    {
        label = "Muscle",
        type = 1
    },
    {
        label = "Lowrider",
        type = 2
    },
    {
        label = "SUV",
        type = 3
    },
    {
        label = "All Terrain",
        type = 4
    },
    {
        label = "Tuning",
        type = 5
    },
    {
        label = "Motorcycle",
        type = 6
    },
    {
        label = "Highend",
        type = 7
    },
}


function RefreshCustomVehicleValues(veh)
    SetVehicleModKit(veh, 0)
    for k,v in pairs(customs) do
        for i,j in pairs(v.customs) do
            j.max = GetNumVehicleMods(veh, j.mod)
            j.installed = GetVehicleMod(veh, j.mod)
            j.bonePos = GetWorldPositionOfEntityBone(veh, GetEntityBoneIndexByName(veh, j.bone))
            if j.bonePos == vector3(0.0, 0.0, 0.0) then
                j.bonePos = GetEntityCoords(veh)
            end
        end
    end
end

function SetVehicleCustom(veh, mod, value, refresh, name)
    SetVehicleModKit(veh, 0)
    SetVehicleMod(veh, mod, value, false)
    if refresh then
        RefreshCustomVehicleValues(veh)
        local props = GetVehProps(veh)
        p:SetCarProps(name, props)
        PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    end
end


local open = false
local selectedMod = {}
local selectedCustom = {}
local selectedColor = {}
local selectedColorType = "primary"
local colorType = {
    {Name = "Primary", Value = "primary"},
    {Name = "Secondary", Value = "secondary"},
    {Name = "Pearlescent", Value = "pearlescentColor"},
    {Name = "Wheels", Value = "wheel"},
}
local index = {
    color = 1
}
local selectedWheelType = 0
local selectedWheelLabel = ""
local tubroPrice = 350000
local loadedVeh = nil
local loadedProps = {}
local main = RageUI.CreateMenu("DriftV", "~b~Drift customs shop")
local sub =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift customs shop")
local wheelsType =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift customs shop")
local wheelsTypeSub =  RageUI.CreateSubMenu(wheelsType, "DriftV", "~b~Drift customs shop")
local colours =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift customs shop")
local coloursSub =  RageUI.CreateSubMenu(colours, "DriftV", "~b~Drift customs shop")
local livery =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift customs shop")
local extra =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift customs shop")
local sub2 =  RageUI.CreateSubMenu(sub, "DriftV", "~b~Drift customs shop")
main.Closed = function()
    open = false
    RageUI.CloseAll()
    RageUI.Visible(main, false)
    SetVehicleEngineOn(loadedVeh, false, false, false)
    SetVehicleLightsMode(loadedVeh, 0)
    SetVehicleDoorsShut(loadedVeh, 1)
end
sub.Closed = function()
    SetVehicleDoorsShut(loadedVeh, 1)
    SetVehProps(loadedVeh, loadedProps)
end
colours.Closed = function()
    SetVehProps(loadedVeh, loadedProps)
end
coloursSub.Closed = function()
    SetVehProps(loadedVeh, loadedProps)
end
livery.Closed = function()
    SetVehProps(loadedVeh, loadedProps)
end
extra.Closed = function()
    SetVehProps(loadedVeh, loadedProps)
end
sub2.Closed = function()
    SetVehProps(loadedVeh, loadedProps)
end
main.WidthOffset = 100.0
sub.WidthOffset = 100.0
sub2.WidthOffset = 100.0
colours.WidthOffset = 100.0
coloursSub.WidthOffset = 100.0
livery.WidthOffset = 100.0
extra.WidthOffset = 100.0
wheelsType.WidthOffset = 100.0
wheelsTypeSub.WidthOffset = 100.0

function OpenCustomMenu(veh, name)
    if open then
        open = false
        RageUI.Visible(main, false)
    else
        open = true
        RageUI.Visible(main, true)
        RefreshCustomVehicleValues(veh)
        SetVehicleEngineOn(veh, true, true, false)
        SetVehicleLightsMode(veh, 2)
        SetVehicleBrakeLights(veh, true)
        SetVehicleHandbrake(veh, true)
        loadedVeh = veh
        local turboStatus = GetVehProps(veh).modTurbo
        loadedProps = GetVehProps(veh)
        local vCoords = GetEntityCoords(veh)

        Citizen.CreateThread(function()
            while open do

                DrawMarker(0, vCoords.x, vCoords.y, vCoords.z + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 255, 255, 255, 255, 1, 0, 2, 0, nil, nil, 0)

                RageUI.IsVisible(main, function()
                    for k,v in pairs(customs) do
                        RageUI.Button(v.label, nil, {RightLabel = ">"}, true, {
                            onSelected = function()
                                selectedMod = k
                                if v.extraAction ~= nil then
                                    v.extraAction(veh)
                                end
                            end,
                        }, sub);
                    end
                    RageUI.Button("wheels", nil, {RightLabel = ">"}, true, {}, wheelsType);
                    RageUI.Button("Colours", nil, {RightLabel = ">"}, true, {}, colours);
                    RageUI.Button("Livery", nil, {RightLabel = ">"}, true, {}, livery);
                    RageUI.Button("Extra mods", nil, {RightLabel = ">"}, true, {}, extra);
                end)

                RageUI.IsVisible(wheelsType, function()
                    for k,v in pairs(allWheelsType) do
                        RageUI.Button(v.label, nil, {RightLabel = ">"}, true, {
                            onSelected = function()
                                SetVehicleWheelType(veh, v.type)
                                selectedWheelType = v.type
                                selectedWheelLabel = v.label
                            end,
                        }, wheelsTypeSub);
                    end
                end)

                RageUI.IsVisible(wheelsTypeSub, function()
                    for i = 1,GetNumVehicleMods(veh, 23) do
                        RageUI.Button(selectedWheelLabel.." #"..i, nil, {RightLabel = ">"}, true, {
                            onSelected = function()
                                SetVehicleCustom(veh, 23, i, true)
                                local props = GetVehProps(veh)
                                p:SetCarProps(name, props)
                                loadedProps = GetVehProps(veh)
                                PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
                            end,
                            onActive = function()
                                SetVehicleCustom(veh, 23, i, false)
                            end,
                        });
                    end
                end)

                RageUI.IsVisible(extra, function()
                    RageUI.Checkbox('Turbo (~g~'..GroupDigits(tubroPrice).."~s~$)", nil, turboStatus, {}, {
                        onSelected = function(Index)
                            turboStatus = Index
                            --- Logic on selected items
                        end,
                        onChecked = function()
                            if p:HaveEnoughMoney(tubroPrice) then
                                p:Pay(tubroPrice)
                                ToggleVehicleMod(veh, 18, true)
                                local props = GetVehProps(veh)
                                p:SetCarProps(name, props)
                                loadedProps = GetVehProps(veh)
                                PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
                            else    
                                turboStatus = false
                                ShowNotification("Not enough money")
                            end
                        end,
                    })
                    for i = 1,9 do
                        if DoesExtraExist(p:currentVeh(), i) then
                            if IsVehicleExtraTurnedOn(p:currentVeh(), i) then
                                RageUI.Button('Turn Extra #'..i..' - ~r~off', nil, {RightLabel = "~g~FREE"}, true, {
                                    onSelected = function()
                                        SetVehicleExtra(veh, i, true)
                                        local props = GetVehProps(veh)
                                        p:SetCarProps(name, props)
                                        loadedProps = GetVehProps(veh)
                                        PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
                                    end,
                                    onActive = function()
                                        SetVehicleExtra(veh, i, true)
                                    end
                                }); 
                            else
                                RageUI.Button('Turn Extra #'..i..' ~g~on', nil, {RightLabel = "~g~FREE"}, true, {
                                    onSelected = function()
                                        SetVehicleExtra(veh, i, false)
                                        local props = GetVehProps(veh)
                                        p:SetCarProps(name, props)
                                        loadedProps = GetVehProps(veh)
                                        PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
                                    end,
                                    onActive = function()
                                        SetVehicleExtra(veh, i, true)
                                    end
                                }); 
                            end
                        end
                    end
                end)

                RageUI.IsVisible(livery, function()
                    RageUI.Button("Livery #0", nil, {}, true, {
                        onSelected = function()
                            SetVehProps(veh, {modLivery = 0})
                            local props = GetVehProps(veh)
                            p:SetCarProps(name, props)
                            loadedProps = GetVehProps(veh)
                            PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
                        end,
                        onActive = function()
                            SetVehProps(veh, {modLivery = 0})
                        end
                    });
                    for i = 1, GetVehicleLiveryCount(veh) do
                        RageUI.Button("Livery #"..i, nil, {}, true, {
                            onSelected = function()
                                SetVehProps(veh, {modLivery = i})
                                local props = GetVehProps(veh)
                                p:SetCarProps(name, props)
                                loadedProps = GetVehProps(veh)
                                PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
                            end,
                            onActive = function()
                                SetVehProps(veh, {modLivery = i})
                            end
                        });
                    end
                end)

                RageUI.IsVisible(colours, function()
                    RageUI.List('Color type', colorType, index.color, nil, {}, true, {
                        onListChange = function(Index, Item)
                            index.color = Index;
                            selectedColorType = colorType[Index].Value
                        end,
                    })
                    for k,v in pairs(colors) do
                        RageUI.Button(v.label, nil, {RightLabel = ">"}, true, {
                            onSelected = function()
                                selectedColor = k
                            end,
                        }, coloursSub);
                    end
                end)

                RageUI.IsVisible(coloursSub, function()
                    for k,v in pairs(colors[selectedColor].colors) do
                        RageUI.Button(v.label, nil, {RightLabel = "~g~"..colors[selectedColor].price.."~s~$"}, true, {
                            onSelected = function()
                                if p:HaveEnoughMoney(colors[selectedColor].price) then
                                    if selectedColorType == "primary" then
                                        SetVehProps(veh, {color1 = v.index})
                                    elseif selectedColorType == "secondary" then
                                        SetVehProps(veh, {color2 = v.index})
                                    elseif selectedColorType == "pearlescentColor" then
                                        SetVehProps(veh, {pearlescentColor = v.index})
                                    elseif selectedColorType == "wheel" then
                                        SetVehProps(veh, {wheelColor = v.index})
                                    end
                                    local props = GetVehProps(veh)
                                    p:SetCarProps(name, props)
                                    p:Pay(colors[selectedColor].price)
                                    loadedProps = GetVehProps(veh)
                                    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
                                else
                                    ShowNotification("Not enough money")
                                end
                            end,

                            onActive = function()
                                if selectedColorType == "primary" then
                                    SetVehProps(veh, {color1 = v.index})
                                elseif selectedColorType == "secondary" then
                                    SetVehProps(veh, {color2 = v.index})
                                elseif selectedColorType == "pearlescentColor" then
                                    SetVehProps(veh, {pearlescentColor = v.index})
                                elseif selectedColorType == "wheel" then
                                    SetVehProps(veh, {wheelColor = v.index})
                                end
                            end
                        });
                    end
                end)

                RageUI.IsVisible(sub, function()
                    for k,v in pairs(customs[selectedMod].customs) do
                        RageUI.Button(v.label, nil, {RightLabel = "[x~b~"..v.max.."~s~] >"}, true, {
                            onSelected = function()
                                selectedCustom = k
                                if customs[selectedMod].extraAction ~= nil then
                                    customs[selectedMod].extraAction(veh)
                                end
                            end,
                        }, sub2);
                    end
                end)

                RageUI.IsVisible(sub2, function()
                    RageUI.Button(customs[selectedMod].customs[selectedCustom].label.." #Default", nil, {RightLabel = "APPLY FOR ~g~0$"}, true, {
                        onSelected = function()
                            SetVehicleCustom(veh, customs[selectedMod].customs[selectedCustom].mod, -1, true, name)
                            loadedProps = GetVehProps(veh)
                        end,

                        onActive = function()
                            SetVehicleCustom(veh, customs[selectedMod].customs[selectedCustom].mod, -1, false)
                            DrawLine(customs[selectedMod].customs[selectedCustom].bonePos, p:pos(), 255, 255, 255, 255)
                        end
                    });
                    for i = 0, customs[selectedMod].customs[selectedCustom].max - 1 do
                        if customs[selectedMod].customs[selectedCustom].installed == i then
                            RageUI.Button(customs[selectedMod].customs[selectedCustom].label.." #"..i + 1, nil, {RightLabel = "~b~INSTALLED"}, true, {
                                onActive = function()
                                    SetVehicleCustom(veh, customs[selectedMod].customs[selectedCustom].mod, i, false)
                                    DrawLine(customs[selectedMod].customs[selectedCustom].bonePos, p:pos(), 255, 255, 255, 255)
                                end
                            });
                        else
                            RageUI.Button(customs[selectedMod].customs[selectedCustom].label.." #"..i + 1, nil, {RightLabel = "APPLY FOR ~g~"..math.floor(customs[selectedMod].customs[selectedCustom].price + (i * customs[selectedMod].customs[selectedCustom].pricePad))  .."$"}, true, {
                                onSelected = function()
                                    if p:HaveEnoughMoney(math.floor(customs[selectedMod].customs[selectedCustom].price + (i * customs[selectedMod].customs[selectedCustom].pricePad))) then
                                        p:Pay(math.floor(customs[selectedMod].customs[selectedCustom].price + (i * customs[selectedMod].customs[selectedCustom].pricePad)))
                                        SetVehicleCustom(veh, customs[selectedMod].customs[selectedCustom].mod, i, true, name)
                                        print(i, customs[selectedMod].customs[selectedCustom].installed, customs[selectedMod].customs[selectedCustom].max)
                                        loadedProps = GetVehProps(veh)
                                    else
                                        ShowNotification("Not enough money")
                                    end
                                end,

                                onActive = function()
                                    SetVehicleCustom(veh, customs[selectedMod].customs[selectedCustom].mod, i, false)
                                    DrawLine(customs[selectedMod].customs[selectedCustom].bonePos, p:pos(), 255, 255, 255, 255)
                                end
                            });
                        end
                        
                    end
                end)
                Wait(1)
            end
        end)
    end
end
local customs = {
    {
        label = "Performance",
        customs = {
            {
                label = "Engine",
                mod = 11,
                bone = "engine",
                bonePos = vector3(0.0, 0.0, 0.0),
                max = 2,
                installed = 0,
                price = 50000,
                pricePad = 1500,
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

function SetVehicleCustom(veh, mod, value, refresh)
    SetVehicleModKit(veh, 0)
    SetVehicleMod(veh, mod, value, false)
    if refresh then
        RefreshCustomVehicleValues(veh)
    end
end


local open = false
local selectedMod = {}
local selectedCustom = {}
local main = RageUI.CreateMenu("DriftV", "~b~Drift customs shop")
local sub =  RageUI.CreateSubMenu(main, "DriftV", "~b~Drift customs shop")
local sub2 =  RageUI.CreateSubMenu(sub, "DriftV", "~b~Drift customs shop")
main.Closed = function()
    open = false
    RageUI.CloseAll()
    RageUI.Visible(main, false)
end
main.WidthOffset = 100.0
sub.WidthOffset = 100.0
sub2.WidthOffset = 100.0

function OpenCustomMenu(veh)
    if open then
        open = false
        RageUI.Visible(main, false)
    else
        open = true
        RageUI.Visible(main, true)
        RefreshCustomVehicleValues(veh)

        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    for k,v in pairs(customs) do
                        RageUI.Button(v.label, nil, {RightLabel = ">"}, true, {
                            onSelected = function()
                                selectedMod = k
                            end,
                        }, sub);
                    end
                end)

                RageUI.IsVisible(sub, function()
                    for k,v in pairs(customs[selectedMod].customs) do
                        RageUI.Button(v.label, nil, {RightLabel = "[x~b~"..v.max.."~s~]>"}, true, {
                            onSelected = function()
                                selectedCustom = k
                            end,
                        }, sub2);
                    end
                end)

                RageUI.IsVisible(sub2, function()
                    RageUI.Button(customs[selectedMod].customs[selectedCustom].label.." #Default", nil, {RightLabel = "APPLY FOR ~g~0$"}, true, {
                        onSelected = function()
                            
                            SetVehicleCustom(veh, customs[selectedMod].customs[selectedCustom].mod, -1, true)
                        end,

                        onActive = function()
                            SetVehicleCustom(veh, customs[selectedMod].customs[selectedCustom].mod, -1, false)
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
                                    
                                    SetVehicleCustom(veh, customs[selectedMod].customs[selectedCustom].mod, i, true)
                                    print(i, customs[selectedMod].customs[selectedCustom].installed, customs[selectedMod].customs[selectedCustom].max)
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
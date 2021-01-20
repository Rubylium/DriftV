local customs = {
    {
        label = "Performance",
        cutoms = {
            {
                label = "Engine",
                mod = 11,
                bone = "engine",
                max = 2,
                installed = 0,
            },
        },
    }
}


function RefreshCustomVehicleValues(veh)
    SetVehicleModKit(veh, 0)
    for k,v in pairs(customs) do
        for i,j in pairs(v.customs) do
            j.max = GetNumVehicleMods(veh, v.mod)
            j.installed = GetVehicleMod(veh, v.mod)
        end
    end
end

function SetVehicleCustom(veh, mod, value)
    SetVehicleModKit(veh, 0)
    SetVehicleMod(veh, mod, value, false)
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
    DeleteEntity(previewVeh.entity)
end
main.WidthOffset = 100.0
sub.WidthOffset = 100.0

function OpenCustomMenu()
    if open then
        open = false
        RageUI.Visible(main, false)
    else
        open = true
        RageUI.Visible(main, true)

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
                        RageUI.Button(v.label, nil, {RightLabel = ">"}, true, {
                            onSelected = function()
                                selectedCustom = v
                            end,
                        }, sub2);
                    end
                end)

                RageUI.IsVisible(sub2, function()
                    for i = 0, customs[selectedMod].customs[selectedCustom].max do
                        RageUI.Button(v.label, nil, {RightLabel = ">"}, true, {
                            onSelected = function()
                                -- Do custom
                            end,
                        });
                    end
                end)
            end
        end)
    end
end
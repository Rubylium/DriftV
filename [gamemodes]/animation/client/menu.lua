local open = false
local animations = {}
local selectedAnimation = 1
local settings = {
    flag = 1,
    filter = "",
}


local main = RageUI.CreateMenu("", "Animations")
local setting = RageUI.CreateSubMenu(main, "", "Animations")
local animation = RageUI.CreateSubMenu(main, "", "Animations")
local animationsSub = RageUI.CreateSubMenu(main, "", "Animations")
main:DisplayGlare(false)
main.Closed = function()
    open = false
    animations = {} -- Unload animations list when not used, we already have to load the json wich is kinda big so keeping this will just make things worse. But i don't recommend keeping this ressource in a prod server
end


-- Credit: https://raw.githubusercontent.com/DurtyFree/gta-v-data-dumps/master/animDictsCompact.json
function LoadAnimations()
    local encoded = LoadResourceFile(GetCurrentResourceName(), "client/animDictsCompact.json")
    animations = json.decode(encoded)
end



function OpenAnimationMenu()
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        LoadAnimations()
        open = true
        RageUI.Visible(main, true)

        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button('Settings', nil, {}, true, {onSelected = function() print("HELLO WORLD !") end}, setting)
                    RageUI.Button('Animations list', nil, {}, true, {onSelected = function() print("HELLO WORLD !") end}, animation)
                end)

                RageUI.IsVisible(setting, function()
                    RageUI.Button('Change animation flag ('..tostring(settings.flag)..')', nil, {}, true, {
                        onSelected = function()
                            local flag = KeyboardInput("Change the flag")
                            if flag ~= nil or flag ~= "" then
                                settings.flag = flag
                            end
                        end
                    })
                    RageUI.Button("Filter by animation name", "Applying a filter can take some time, the system has to browse through all the animations to filter them. Performance may be impacted during processing", {}, true, {
                        onSelected = function()
                            local name = KeyboardInput("Change the flag")
                            if name ~= nil and name ~= "" then
                                settings.filter = name

                                for k,v in pairs(animations) do
                                    local found = false
                                    for i,j in pairs(v.Animations) do
                                        if string.find(j, settings.filter) then
                                            found = true
                                        else
                                            table.remove(v.Animations, i)
                                        end
                                    end
                                    if not found then
                                        table.remove(animations, k)
                                    end
                                    ShowHelpNotification("Filtering animations ... ("..k.."/"..#animations..")", false)
                                end

                            else
                                LoadAnimations()
                            end
                        end
                    })
                end)

                RageUI.IsVisible(animation, function()
                    for k,v in pairs(animations) do
                        RageUI.Button(v.DictionaryName, nil, {}, true, {
                            onSelected = function()
                                selectedAnimation = k
                            end
                        }, animationsSub)
                    end
                end)

                RageUI.IsVisible(animationsSub, function()
                    for _,v in pairs(animations[selectedAnimation].Animations) do
                        RageUI.Button(v, nil, {}, true, {
                            onSelected = function()
                                ClearPedTasksImmediately(GetPlayerPed(-1))
                                print("Dict: ".. animations[selectedAnimation].DictionaryName .." Anim: ".. v .. " Time: ".. GetAnimDuration(animations[selectedAnimation].DictionaryName, v))
                                PlayAnim(animations[selectedAnimation].DictionaryName, v, settings.flag)
                            end
                        })
                    end
                end)
                Wait(1)
            end
        end)
    end
end


RegisterCommand("animations", function()
    OpenAnimationMenu()
end, false)
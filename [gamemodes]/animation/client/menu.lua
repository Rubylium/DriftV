local open = false
local animations = {}
local selectedAnimation = 1
local settings = {
    flag = 1
}


local main = RageUI.CreateMenu("", "Animations")
local setting =  RageUI.CreateSubMenu(main, "", "Animations")
local animation =  RageUI.CreateSubMenu(main, "", "Animations")
local animationsSub =  RageUI.CreateSubMenu(main, "", "Animations")
main:DisplayGlare(false)
main.Closed = function()
    animations = {}
end


-- Credit: https://raw.githubusercontent.com/DurtyFree/gta-v-data-dumps/master/animDictsCompact.json
function LoadAnimations()
    local encoded = LoadResourceFile(GetCurrentResourceName(), "./animDictsCompact.json")
    animations = json.decode(encoded)
end



function OpenAnimationMenu()
    if open then
        open = false
        RageUI.Visible(main, false)
        return
    else
        open = true
        RageUI.Visible(main, true)

        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main, function()
                    RageUI.Button('Settings', nil, {}, true, {onSelected = function() print("HELLO WORLD !") end}, setting)
                    RageUI.Button('Animations list', nil, {}, true, {onSelected = function() print("HELLO WORLD !") end}, animation)
                end)

                RageUI.IsVisible(setting, function()
                    RageUI.Button('Change flag ('..tostring(settings.flag)..')', nil, {}, true, {
                        onSelected = function()
                            local flag = KeyboardImput("Change the flag")
                            if flag ~= nil then
                                settings.flag = flag
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
                Wait(1)
            end
        end)
    end
end
function KeyboardInput(text)
    local amount = nil
    AddTextEntry("CUSTOM_AMOUNT", text)
    DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 255)

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        amount = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return amount
end

function PlayAnim(dict, anim, flag)
    if dict ~= "" then
        if DoesAnimDictExist(dict) then
            RequestAnimDict(dict)
            print("requesting anim dict "..dict)
            while not HasAnimDictLoaded(dict) do Wait(1) end
            print("Start anim")
            TaskPlayAnim(GetPlayerPed(-1), dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
        end
    end
end

function ShowHelpNotification(msg, beep)
	local beep = beep
	if beep == nil then
		beep = true
	end
	AddTextEntry('core:HelpNotif', msg)
	BeginTextCommandDisplayHelp('core:HelpNotif')
	EndTextCommandDisplayHelp(0, false, beep, 1)
end
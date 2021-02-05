function RegisterSecuredNetEvent(event, func)
    while Events == nil do Wait(1) end
    while event == nil do
        SecurityPrint("Trying to register [" .. event .. "] event which is nil ...")
        Wait(500)
    end
    SecurityPrint("Registered Secured net event ["..event.."]")
    RegisterNetEvent(event)
    AddEventHandler(event, func)
end

function SecurityPrint(text)
    print("^1SECURITY: ^7"..text)
end
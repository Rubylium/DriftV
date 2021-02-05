Events = {
    pay = "drift:Pay",
    busted = "drift:GotBusted",
    refreshCars = "drift:UpdateCars",
    buyVeh = "drift:BuyVehicle",
    setPassive = "dirft:SetInPassive",
    reqSync = "drift:RequestSync",
    setArchivment = "driftV:SetPlayerArchivement",
    SetExp = "driftV:SubmitExpPoints",
    addMoney = "driftV:AddMoney",
    setDriftPoint = "driftV:SubmitDriftPoint",
    raceEnd = "drift:EndRace",
}

function RegisterSecuredNetEvent(event, func)
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
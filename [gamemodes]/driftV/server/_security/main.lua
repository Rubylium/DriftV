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
    setDriftPoint = "driftV:SubmitDriftPoint"
}

function RegisterSecuredNetEvent(event, func)
    while event == nil do
        debugPrint("Trying to register [" .. event .. "] event which is nil ...")
        Wait(500)
    end
    RegisterNetEvent(event)
    AddEventHandler(event, func)
end

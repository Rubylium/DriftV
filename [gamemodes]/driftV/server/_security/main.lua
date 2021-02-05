

local random = math.random
local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

Events = {
    pay = uuid() .."drift:Pay",
    busted = uuid() .."drift:GotBusted",
    refreshCars = uuid() .."drift:UpdateCars",
    buyVeh = uuid() .."drift:BuyVehicle",
    setPassive = uuid() .."dirft:SetInPassive",
    reqSync = uuid() .."drift:RequestSync",
    getSync = uuid() .."drift:SyncPlayer",
    setArchivment = uuid() .."driftV:SetPlayerArchivement",
    SetExp = uuid() .."driftV:SubmitExpPoints",
    addMoney = uuid() .."driftV:AddMoney",
    setDriftPoint =uuid() .."driftV:SubmitDriftPoint",
    raceEnd = uuid() .."drift:EndRace",
    raceData = uuid() .."drift:GetRaceData",
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
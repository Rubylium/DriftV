loaded = false
local first = true
Citizen.CreateThread(function()
    exports.spawnmanager.spawnPlayer()
    TriggerServerEvent("driftV:InitPlayer")
    TriggerServerEvent("drift:GetRaceData")
    player:new()
    loaded = true
    TriggerEvent("FeedM:showNotification", "Welcome back! Press F1 to use the main menu! Have fun on DriftV !", 15000, "info")
    SetPlayerInvincible(GetPlayerIndex(), true) 
    RequestIpl('shr_int')
end)

RegisterNetEvent("driftV:RefreshData")
AddEventHandler("driftV:RefreshData", function(data)
    p:SetCars(data.cars)
    p:SetDriftPoint(data.driftPoint)
    p:SetMoney(data.money)
    if first then
        XNL_SetInitialXPLevels(data.xp, true, true)
        first = false
    end
end)
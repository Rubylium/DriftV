function RecruiteNearestPlayer()
    local player, dst = GetClosestPlayer()
    TriggerServerEvent("driftV:JoinCrew", p:getCrew(), GetPlayerServerId(player)) 
end
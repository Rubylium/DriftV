function RecruiteNearestPlayer()
    local player, dst = GetClosestPlayer()
    if PlayersCrew[GetPlayerServerId(player)] == "None" then
        if Crew[p:getCrew()].memberCount < Config.MaxMembers then
            TriggerServerEvent("driftV:InvitePlayer", p:getCrew(), GetPlayerServerId(player)) 
        else
            ShowNotification("Your crew is full")
        end
    else
        ShowNotification("The player is already in a crew")
    end
end

RegisterNetEvent("driftV:GetInvitedToCrew")
AddEventHandler("driftV:GetInvitedToCrew", function(crew, source)
    ShowNotification("The player ~b~"..GetPlayerName(GetPlayerFromServerId(source)) .. "~s~ invited you to join the crew ~b~".. crew.."~s~")
    ShowNotification("Press ~g~Y~s~ to accept\nPress ~r~X~s~ to refuse.")

    Citizen.CreateThread(function()
        local count = 1
        while count <= 1000 do

            if IsControlJustReleased(0, 246) then
                TriggerServerEvent("driftV:JoinCrew", crew, GetPlayerServerId(GetPlayerIndex())) 
                return
            end

            
            if IsControlJustReleased(0, 252) then
                ShowNotification("~r~Invitation refused")
                return
            end

            count = count + 1
            Wait(1)
        end
    end)
end)
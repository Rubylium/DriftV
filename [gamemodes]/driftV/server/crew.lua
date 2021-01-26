crew = {}
pCrew = {}

function DoesCrewExist(name)
    if crew[name] ~= nil then
        return true
    else
        return false
    end
end

function CreateCrew(tag, name, desc)
    if crew[name] == nil then
        crew[name] = {}
        crew[name].tag = tag
        crew[name].name = name
        crew[name].desc = desc
        crew[name].members = {}
        return true
    else
        return false
    end
end

function JoinCrew(source, crewName, isCrewOwner)
    local pCrewName = player[source].crew
    LeaveCrew(source)

    if DoesCrewExist(crewName) then
        crew[pCrewName].members[pLicense] = {points = 0}
        if isCrewOwner then
            player[source].crewOwner = true
        end
    end
end

function LeaveCrew(source)
    local pCrewName = player[source].crew
    local pLicense = GetLicense(source)
    if DoesCrewExist(pCrewName) then
        crew[pCrewName].members[pLicense] = nil
        player[source].crew = "None"

        if player[source].crewOwner then

            for k,v in pairs(pCrew) do
                if v == pCrewName then
                    pCrew[k] = "None"
                end
            end

            player[source].crewOwner = false
            crew[pCrewName] = nil
        end
    end
end

function AddPointsToCrew(source, pointsToAdd)
    local pCrewName = player[source].crew
    local pLicense = GetLicense(source)
    if DoesCrewExist(pCrewName) then
        crew[pCrewName].members[pLicense].points = crew[pCrewName].members[pLicense].points + pointsToAdd
    end
end


RegisterNetEvent("driftV:CreateCrew")
AddEventHandler("driftV:CreateCrew", function(tag, crew, desc)
    CreateCrew(tag, crew, desc)
    JoinCrew(source, crew, true)
    player[source].crew = crew
    player[source].crewOwner = true
    RefreshPlayerData(source)
    RefreshOtherPlayerData()
end)

RegisterNetEvent("driftV:JoinCrew")
AddEventHandler("driftV:JoinCrew", function(crew, player)
    JoinCrew(player, crew, false)
    RefreshPlayerData(player)
    RefreshOtherPlayerData()
end)

RegisterNetEvent("driftV:LeaveCrew")
AddEventHandler("driftV:LeaveCrew", function()
    LeaveCrew(source)
    RefreshPlayerData(source)
    RefreshOtherPlayerData()
end)
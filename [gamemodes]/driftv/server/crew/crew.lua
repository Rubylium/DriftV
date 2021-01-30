crew = {}
pCrew = {}
KingDriftCrew = {
    name = "Nothing",
    elo = 1000,
}
CrewRanking = {}

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
        crew[name].memberCount = 1
        crew[name].totalPoints = 0
        crew[name].win = 0
        crew[name].loose = 0
        crew[name].elo = 1000
        crew[name].members = {}
        crew[name].rank = 500
        return true
    else
        return false
    end
end

function RefresKingDriftCrew()
    KingDriftCrew = {
        name = "Nothing",
        elo = 1000,
    }

    for k,v in pairs(crew) do
        print(v.elo, KingDriftCrew.elo, v.elo > KingDriftCrew.elo)
        if v.elo > KingDriftCrew.elo then
            KingDriftCrew.elo = v.elo
            KingDriftCrew.name = v.name
            debugPrint("New drift king crew: "..v.name.." with ".. v.elo .." elo")
        end
    end
end


function RefreshCrewRanking()
    local ranking = {}

    
    for k,v in pairs(crew) do
        if ranking[1] == nil then
            table.insert(ranking, {name = v.name, elo = v.elo, win = v.win, loose = v.loose, points = v.totalPoints, members = v.memberCount})
        else
            local count = 1
            local added = false
            for i,j in pairs(ranking) do
                if v.elo > j.elo then
                    added = true
                    table.insert(ranking, count, {name = v.name, elo = v.elo, win = v.win, loose = v.loose, points = v.totalPoints, members = v.memberCount})
                    break
                end
                count = count + 1
            end
            if not added then
                table.insert(ranking, #ranking + 1, {name = v.name, elo = v.elo, win = v.win, loose = v.loose, points = v.totalPoints, members = v.memberCount})
            end
        end   
    end

    CrewRanking = ranking
end

function RefreshCrewMemberCount(crewName)
    local count = 0
    local points = 0
    for k,v in pairs(crew[crewName].members) do
        count = count + 1
        points = points + v.points
    end

    crew[crewName].memberCount = count
    crew[crewName].totalPoints = points
end

function JoinCrew(source, crewName, isCrewOwner)
    local pCrewName = player[source].crew
    local pLicense = GetLicense(source)
    LeaveCrew(source)

    if DoesCrewExist(crewName) then
        if crew[crewName].memberCount < 10 then
            crew[crewName].members[pLicense] = {points = 0, name = GetPlayerName(source)}
            if isCrewOwner then
                player[source].crewOwner = true
            end
            pCrew[source] = crewName
            RefreshCrewMemberCount(crewName)
        end
    end
end

function LeaveCrew(source)
    local pCrewName = player[source].crew
    local pLicense = GetLicense(source)
    if DoesCrewExist(pCrewName) then
        crew[pCrewName].members[pLicense] = nil
        player[source].crew = "None"
        pCrew[source] = "None"

        if player[source].crewOwner then

            for k,v in pairs(pCrew) do
                if v == pCrewName then
                    pCrew[k] = "None"
                end
            end

            player[source].crewOwner = false
            crew[pCrewName] = nil
            debugPrint("Crew "..pCrewName.." got deleted")
        else
            RefreshCrewMemberCount(pCrewName)
        end
        RefreshPlayerData(source)
        SavePlayer(source)
    end
end

function KickPlayerFromCrew(source, crewName, key)
    -- use source for some owner check later
    if DoesCrewExist(crewName) then
        crew[crewName].members[key] = nil
    end

    for k,v in pairs(GetPlayers()) do
        local pLicense = GetLicense(v)
        if pLicense == key then
            LeaveCrew(tonumber(v))
            debugPrint("Player "..v.." got kicked from "..crewName.." crew")
            break
        end
    end

    RefreshCrewMemberCount(crewName)
    RefreshOtherPlayerData()
end

function AddPointsToCrew(source, pointsToAdd)
    local pCrewName = player[source].crew
    local pLicense = GetLicense(source)
    if DoesCrewExist(pCrewName) then
        crew[pCrewName].members[pLicense].points = math.floor(crew[pCrewName].members[pLicense].points + pointsToAdd)
        RefreshCrewMemberCount(pCrewName)
    end
end


RegisterNetEvent("driftV:CreateCrew")
AddEventHandler("driftV:CreateCrew", function(tag, crew)
    if CreateCrew(tag, crew) then
        JoinCrew(source, crew, true)
        player[source].crew = crew
        player[source].crewOwner = true
        RefreshPlayerData(source)
        RefreshOtherPlayerData()
        SavePlayer(source)
    end
end)

RegisterNetEvent("driftV:JoinCrew")
AddEventHandler("driftV:JoinCrew", function(crew, id)
    JoinCrew(id, crew, false)
    player[id].crew = crew
    player[id].crewOwner = false
    RefreshPlayerData(id)
    RefreshOtherPlayerData()
    SavePlayer(id)
end)

RegisterNetEvent("driftV:InvitePlayer")
AddEventHandler("driftV:InvitePlayer", function(crew, id)
    TriggerClientEvent("driftV:GetInvitedToCrew", id, crew, source)
end)

RegisterNetEvent("driftV:LeaveCrew")
AddEventHandler("driftV:LeaveCrew", function()
    LeaveCrew(source)
    RefreshPlayerData(source)
    RefreshOtherPlayerData()
    SavePlayer(source)
end)

RegisterNetEvent("driftV:KickFromCrew")
AddEventHandler("driftV:KickFromCrew", function(target)
    KickPlayerFromCrew(source, player[source].crew, target)
end)

RegisterNetEvent("driftV:StartMatchmaking")
AddEventHandler("driftV:StartMatchmaking", function()
    AddCrewToMachmaking(player[source].crew)
    AddCrewMemberToMatchmaking(player[source].crew, source)
end)

Citizen.CreateThread(function()
    local db = rockdb:new()
    crew = db:GetString("CREW_DEV_4")
    if crew == nil then
        crew = {}
    else
        crew = json.decode(crew)
    end

    RefresKingDriftCrew()
    debugPrint("Loaded all crews ")
    while true do
        db:SaveString("CREW_DEV_4", json.encode(crew))

        debugPrint("Crews saved")


        RefreshCrewRanking()
        debugPrint("Crew ranking refresh ...")
        Wait(30*1000)
    end
end)
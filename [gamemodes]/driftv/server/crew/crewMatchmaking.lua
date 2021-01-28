local matchmaking = {}
local wars = {}

function StartWarsBetweenCrew(crew1, crew2)
    local warId = uuid()
    wars[warId] = {
        crew1 = crew1,
        crew2 = crew2,
        scores = {
            [crew1.name] = 0,
            [crew2.name] = 0,
        },
        indiScores = {
            [crew1.name] = {},
            [crew2.name] = {},
        },
        warID = warId,
        votedMaps = {},
        waitingFirstPlayerFinish = true,
        instanceID = math.random(1,1000),
        needDone = 0,
        done = 0,
    }
    for k,v in pairs(crew1.members) do
        wars[warId].needDone = wars[warId].needDone + 1
    end
    for k,v in pairs(crew2.members) do
        wars[warId].needDone = wars[warId].needDone + 1
    end

    local function RefreshWarsData()
        for k,v in pairs(crew1.members) do
            TriggerClientEvent("crew:CrewWarRefreshData", v, wars[warId])
        end
        for k,v in pairs(crew2.members) do
            TriggerClientEvent("crew:CrewWarRefreshData", v, wars[warId])
        end
    end


    debugPrint("Starting crew war. Sending players to crew war lobby")
    for k,v in pairs(crew1.members) do
        SetPlayerInstance(v, wars[warId].instanceID)
        TriggerClientEvent("crew:CrewWarAboutToStart", v, crew2.name, warId)
    end
    for k,v in pairs(crew2.members) do
        SetPlayerInstance(v, wars[warId].instanceID)
        TriggerClientEvent("crew:CrewWarAboutToStart", v, crew1.name, warId)
    end
    Wait(10*1000)
    RefreshWarsData()
    debugPrint("Starting map vote (30s)")

    for k,v in pairs(crew1.members) do
        SetPlayerInstance(v, 1)
        TriggerClientEvent("crew:CrewWarStartMapVote", v)
    end
    for k,v in pairs(crew2.members) do
        SetPlayerInstance(v, 1)
        TriggerClientEvent("crew:CrewWarStartMapVote", v)
    end

    Wait(30*1000) -- Map Load
    RefreshWarsData()
    debugPrint("Loading map (30s)")

    local map = ""
    local mostVote = 0
    print(json.encode(wars[warId].votedMaps))
    for k,v in pairs(wars[warId].votedMaps) do
        if v > mostVote then
            mostVote = v
            map = k
        end
    end

    debugPrint("Map: "..map.." with "..mostVote.." vote")

    for k,v in pairs(crew1.members) do
        TriggerClientEvent("crew:CrewWarLoadMap", v, map)
    end
    for k,v in pairs(crew2.members) do
        TriggerClientEvent("crew:CrewWarLoadMap", v, map)
    end

    Wait(30*1000)
    RefreshWarsData()
    debugPrint("Choose car (30s)")

    for k,v in pairs(crew1.members) do
        TriggerClientEvent("crew:CrewWarLoadVeh", v)
    end
    for k,v in pairs(crew2.members) do
        TriggerClientEvent("crew:CrewWarLoadVeh", v)
    end
    Wait(15*1000)
    debugPrint("Starting crew war race !!")
    for k,v in pairs(crew1.members) do
        TriggerClientEvent("crew:CrewWarStartRace", v)
    end
    for k,v in pairs(crew2.members) do
        TriggerClientEvent("crew:CrewWarStartRace", v)
    end


    while wars[warId].waitingFirstPlayerFinish do
        RefreshWarsData()
        Wait(1000)
    end

    -- Notification, 60s to finish
    debugPrint("Waiting everyone to finish")
    local timer = GetGameTimer() + 60 * 1000 
    print(timer, GetGameTimer())
    while GetGameTimer() < timer and wars[warId].done < wars[warId].needDone do
        print(timer, GetGameTimer(), wars[warId].done, wars[warId].needDone)
        RefreshWarsData()
        Wait(1000)
    end


    -- Teleport everyone back to lobby
    RefreshWarsData()
    for k,v in pairs(crew1.members) do
        TriggerClientEvent("crew:CrewWarEndLobby", v)
    end
    for k,v in pairs(crew2.members) do
        TriggerClientEvent("crew:CrewWarEndLobby", v)
    end




    for k,v in pairs(crew1.members) do
        SetPlayerInstance(v, 1)
        TriggerClientEvent("crew:CrewWarEnd", v)
    end
    for k,v in pairs(crew2.members) do
        SetPlayerInstance(v, 1)
        TriggerClientEvent("crew:CrewWarEnd", v)
    end


    if wars[warId].scores[crew1.name] > wars[warId].scores[crew2.name] then
        crew[crew1.name].win = crew[crew1.name].win + 1
        crew[crew2.name].loose = crew[crew2.name].loose + 1
    else
        crew[crew2.name].win = crew[crew2.name].win + 1
        crew[crew1.name].loose = crew[crew1.name].loose + 1
    end
end

function AddCrewToMachmaking(crewName)
    if matchmaking[crewName] == nil then
        matchmaking[crewName] = {
            name = crewName,
            members = {}
        }
    end
end

function AddCrewMemberToMatchmaking(crewName, source)
    if matchmaking[crewName] == nil then
        AddCrewToMachmaking() 
    end

    table.insert(matchmaking[crewName].members, source)
end

function FindRandomMatch()
    local possibleMathCount = 0
    for k,v in pairs(matchmaking) do
        possibleMathCount = possibleMathCount + 1
    end
    print(possibleMathCount)


    if possibleMathCount > 1 then
        local random1 = math.random(1, possibleMathCount)

        local count = 1
        for k,v in pairs(matchmaking) do
            if count == random1 then
                random1 = k
            end
            count = count + 1
        end

        local random2 = math.random(1, possibleMathCount)

        print("Random1 gotten, looking for random2")
        local count = 1
        for k,v in pairs(matchmaking) do
            if count == random2 then
                random2 = k
            end
            count = count + 1
        end
        while random1 == random2 do
            local count = 1
            random2 = math.random(1, possibleMathCount)
            print(random2)
            for k,v in pairs(matchmaking) do
                if count == random2 then
                    random2 = k
                end
                count = count + 1
            end
            Wait(1)
        end

        print(random1, random2)

        local crew1 = matchmaking[random1]
        local crew2 = matchmaking[random2]
        matchmaking[random1] = nil
        matchmaking[random2] = nil
        StartWarsBetweenCrew(crew1, crew2)
    end
end


Citizen.CreateThread(function()
    Wait(5000)
    while true do
        FindRandomMatch()
        Wait(2*1000)
    end
end)


RegisterNetEvent("crew:CrewWarsVoteForMap")
AddEventHandler("crew:CrewWarsVoteForMap", function(map, warID)
    if wars[warID].votedMaps[map] == nil then
        wars[warID].votedMaps[map] = 0
    end
    wars[warID].votedMaps[map] = wars[warID].votedMaps[map] + 1
end)

RegisterNetEvent("crew:CrewCarsAddScore")
AddEventHandler("crew:CrewCarsAddScore", function(warID, crew, score)
    wars[warID].scores[crew] = wars[warID].scores[crew] + score
    wars[warID].indiScores[crew][source] = score
    wars[warID].waitingFirstPlayerFinish = false
    wars[warID].done = wars[warID].done + 1
end)
local crew = {}

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
    local pCrew = player[source].crew
    LeaveCrew(source)

    if DoesCrewExist(crewName) then
        crew[pCrew].members[pLicense] = {points = 0}
        if isCrewOwner then
            player[source].crewOwner = true
        end
    end
end

function LeaveCrew(source)
    local pCrew = player[source].crew
    local pLicense = GetLicense(source)
    if DoesCrewExist(pCrew) then
        crew[pCrew].members[pLicense] = nil
    end
end

function AddPointsToCrew(source, pointsToAdd)
    local pCrew = player[source].crew
    local pLicense = GetLicense(source)
    if DoesCrewExist(pCrew) then
        crew[pCrew].members[pLicense].points = crew[pCrew].members[pLicense].points + pointsToAdd
    end
end
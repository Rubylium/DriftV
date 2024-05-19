Crew = {}
Crew.List = {}

function Crew.New(uid, name, points)
    local self = {}
    self.uid = uid
    self.name = name
    self.members = {}
    self.points = points or 0

    Crew.List[name] = self
end

function Crew.Get(name)
    return Crew.List[name]
end

function Crew.LoadDataFromDB()
    MySQL.Async.fetchAll("SELECT * FROM crews", {}, function(result)
        for k, v in pairs(result) do
            Crew.New(v.uid, v.name, v.points)
        end
    end)
end

-- Crew members are savec in the player table with the crew uid
function Crew.UpdateCrewMembersFromDB(crew)
    MySQL.Async.fetchAll("SELECT * FROM players WHERE crew = @crew", {
        ["@crew"] = crew.uid,
    }, function(result)
        for k, v in pairs(result) do
            table.insert(crew.members, v.license)
        end
    end)
end

function Crew.SaveDataToDB()
    for k, v in pairs(Crew.List) do
        MySQL.Async.execute("UPDATE crews SET points = @points WHERE uid = @uid", {
            ["@uid"] = v.uid,
            ["@points"] = v.points,
        })
    end
end

function Crew.AddPoints(name, points)
    local crew = Crew.Get(name)
    crew.points = crew.points + points
end

function Crew.CanCrewBeCreated(name)
    if Crew.Get(name) then
        return false
    end
    return true
end

function Crew.CanPlayerJoinCrew(source, name)
    local player = Players.Get(source)
    if player.crew then
        return false
    end
    local crew = Crew.Get(name)
    if not crew then
        return false
    end
    if #crew.members >= 10 then
        return false
    end
    return true
end

function Crew.JoinCrew(source, name)
    local player = Players.Get(source)
    player.crew = name
    table.insert(Crew.Get(name).members, player.license)
end

function Crew.LeaveCrew(source)
    local player = Players.Get(source)
    local crew = Crew.Get(player.crew)
    player.crew = nil
    for k, v in pairs(crew.members) do
        if v == player.license then
            table.remove(crew.members, k)
            break
        end
    end
end

function Crew.GetCrews()
    local crews = {}
    for k, v in pairs(Crew.List) do
        table.insert(crews, v)
    end
    return crews
end
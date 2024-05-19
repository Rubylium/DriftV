Races = {}
Races.List = {}

function Races.New(name, uid, start_position, end_position)
    local self = {}
    self.name = name
    self.uid = uid
    self.start_position = start_position
    self.end_position = end_position
    self.leaderboard = {}

    function self:addScore(player, score)
        if type(player) ~= "string" or type(score) ~= "number" then
            error("Invalid player name or score")
        end
        table.insert(self.leaderboard, {player = player, score = score})
        self:updateLeaderboard()
    end

    function self:updateLeaderboard()
        table.sort(self.leaderboard, function(a, b) return a.score > b.score end)
        if #self.leaderboard > 10 then
            for i = #self.leaderboard, 11, -1 do
                table.remove(self.leaderboard, i)
            end
        end
    end

    function self:getLeaderboard()
        return self.leaderboard
    end

    function self:getFormattedLeaderboard()
        local formatted = {}
        for i, entry in ipairs(self.leaderboard) do
            table.insert(formatted, string.format("%d. %s: %d", i, entry.player, entry.score))
        end
        return formatted
    end

    Races.List[uid] = self
end

function Races.AddScore(uid, player, score)
    local race = Races.List[uid]
    if race then
        race:addScore(player, score)
    end
end

function Races.GetLeaderboard(uid)
    local race = Races.List[uid]
    if race then
        return race:getLeaderboard()
    end
    return nil
end

RegisterNetEvent("main:addScore", function(uid, player, score)
    Races.AddScore(uid, player, score)
end)
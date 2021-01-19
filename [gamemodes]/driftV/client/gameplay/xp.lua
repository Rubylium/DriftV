local function GetCorrectExpForLevel(level)
	return math.floor(5000 * (level^2) - 1)
end


function GetPlayerLevelFromXp(xp)
	local xp = xp -- Duh
	local found = false
	local level = 1
	while not found do
		if xp < GetCorrectExpForLevel(level) then
			break
		else
			level = level + 1
		end
	end
	return level
end
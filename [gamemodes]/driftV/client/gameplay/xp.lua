local function GetCorrectExpForLevel(level)
	return math.floor(2000 * (level^2) - 1)
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

function DisplayRankBar(oldxp, newxp, oldlevel, newlevel, take)
	Citizen.CreateThread(function()
		local XP_StartLimit_RankBar = math.floor(oldxp)
		local XP_EndLimit_RankBar = math.floor(GetCorrectExpForLevel(newlevel))
		local playersPreviousXP = math.floor(oldxp)
		local playersCurrentXP = math.floor(p:getExp())
		local CurrentPlayerLevel = math.floor(GetPlayerLevelFromXp(p:getExp()))
		local TakingAwayXP = take
		CreateRankBar(XP_StartLimit_RankBar, XP_EndLimit_RankBar, playersPreviousXP, playersCurrentXP, CurrentPlayerLevel, TakingAwayXP)
	end)
end

function CreateRankBar(XP_StartLimit_RankBar, XP_EndLimit_RankBar, playersPreviousXP, playersCurrentXP, CurrentPlayerLevel, TakingAwayXP)
	local RankBarColor = 116 -- The Normal Online Ranbar color (IS NOT used for the globes!)
	if TakingAwayXP and XNL_UseRedBarWhenLosingXP then
		RankBarColor = 6 -- Dark Red
	end

	if not HasHudScaleformLoaded(19) then							-- Here we check if the scaleform has been loaded or not
        RequestHudScaleform(19)										-- If it's not loaded we will request (load) it
		while not HasHudScaleformLoaded(19) do						-- here we will wait until it has loaded
			Wait(1)													-- you will HAVE to put this wait here to prevent script hang and game freezing!
		end
    end
	
	BeginScaleformMovieMethodHudComponent(19, "SET_COLOUR")
	PushScaleformMovieFunctionParameterInt(RankBarColor) -- 116 is the "normal multiplayer rankbar color"
    EndScaleformMovieMethodReturn()

	
	--[[
	    PURE_WHITE 	= 0
		WHITE 		= 1
		BLACK 		= 2
		GREY 		= 3
		GREYLIGHT 	= 4
		GREYDARK 	= 5
		RED 		= 6
		REDLIGHT 	= 7
		REDDARK 	= 8
		BLUE 		= 9
		BLUELIGHT 	= 10
		BLUEDARK 	= 11
		YELLOW 		= 12
		YELLOWLIGHT = 13
		YELLOWDARK 	= 14
		ORANGE 		= 15
		ORANGELIGHT = 16
		ORANGEDARK 	= 17
		GREEN 		= 18
		GREENLIGHT 	= 19
		GREENDARK 	= 20
		PURPLE 		= 21
		PURPLELIGHT	= 22
		PURPLEDARK 	= 23
		PINK 		= 24
		BRONZE 		= 107
		SILVER 		= 108
		GOLD 		= 109
		PLATINUM 	= 110
		FREEMODE 	= 116	-- This is the 'normal blue color' for the Rankbar
	]]
	

    BeginScaleformMovieMethodHudComponent(19, "SET_RANK_SCORES")		-- The HUD/Movie Component we want to use to draw the Rankbar
	PushScaleformMovieFunctionParameterInt(XP_StartLimit_RankBar)	-- This sets the 'absolute begin limit' for the bar where it can start drawing from (includes the blue "you already had this XP" bar)
	PushScaleformMovieFunctionParameterInt(XP_EndLimit_RankBar)		-- This sets the 'end limit' for the current level bar AND the 'top value' of the displayed XP text beneath the bar
	PushScaleformMovieFunctionParameterInt(playersPreviousXP)		-- This sets where the previous XP 'was located' at the bar and thus from where to start drawing the 'white/new xp bar'
	PushScaleformMovieFunctionParameterInt(playersCurrentXP)		-- This sets the current players XP (to 'where' the bar has to move!)
	PushScaleformMovieFunctionParameterInt(CurrentPlayerLevel)		-- This one Determines the LEFT 'globe', so the CURRENT player's level!
	PushScaleformMovieFunctionParameterInt(100)						-- This one sets the opacity (visibility %) from 0 
    EndScaleformMovieMethodReturn()
end

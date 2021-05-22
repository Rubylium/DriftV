local displayBlips = false
local blips = {}
local gametags = {}
function DisplayPlayersBlips()
	
	if displayBlips then
		displayBlips = false
		for k,v in pairs(blips) do
			RemoveBlip(v)
		end
		blips = {}
	else
		displayBlips = true

		Citizen.CreateThread(function()
			while not loaded do Wait(1) end
			while displayBlips do

				for k,v in pairs(GetActivePlayers()) do
					local pPed = GetPlayerPed(v)

					if pPed ~= p:ped() then

						-- if playersIdInPassive[GetPlayerServerId(v)] ~= nil then
						-- 	SetMpGamerTagVisibility(gametag, 6, true)
						-- else
						-- 	SetMpGamerTagVisibility(gametag, 6, false)
						-- end
						-- if p:isPassive() then
						-- 	SetMpGamerTagVisibility(gametag, 14, true)
						-- else
						-- 	SetMpGamerTagVisibility(gametag, 14, false)
						-- end

						if blips[pPed] == nil then
							local blip = AddBlipForEntity(pPed)
							SetBlipSprite(blip, 1)
							SetBlipScale(blip, 0.75)
							SetBlipCategory(blip, 2)
							SetBlipColour(blip, math.random(0,85))
							blips[pPed] = blip
						end

						SetBlipNameToPlayerName(blips[pPed], v)
						SetBlipRotation(blips[pPed], math.ceil(GetEntityHeading(pPed)))


						if IsPedInAnyVehicle(pPed, false) then
							ShowHeadingIndicatorOnBlip(blips[pPed], false)
							local pVeh = GetVehiclePedIsIn(pPed, false)
							SetBlipRotation(blips[pPed], math.ceil(GetEntityHeading(pVeh)))
						else
							ShowHeadingIndicatorOnBlip(blips[pPed], true)
							HideNumberOnBlip(blips[pPed])
						end
					end

				end
				Wait(200)
			end
		end)


		
		local playersToShow = {}
		Citizen.CreateThread(function()
			while not loaded do Wait(1) end
			while displayBlips do
				for k,v in pairs(GetActivePlayers()) do
					if v ~= GetPlayerIndex() then
						if GetDistanceBetweenCoords(p:pos(), GetEntityCoords(GetPlayerPed(v)), true) <= 20 then
							playersToShow[v] = GetPlayerName(v)
						else
							playersToShow[v] = nil
						end
					end
				end
				Wait(500)
			end
		end)

		Citizen.CreateThread(function()
			while not loaded do Wait(1) end
			RequestStreamedTextureDict("markers", true)
			while not HasStreamedTextureDictLoaded("markers") do
				Wait(1)
			end
			while displayBlips do
				for k,v in pairs(playersToShow) do
					local pPed = GetPlayerPed(k)
					local pCoords = GetEntityCoords(pPed)
					local level = tostring(DecorGetInt(pPed, "LEVEL"))
					local crew
					local crewName = PlayersCrew[GetPlayerServerId(k)] 
					
					if PlayersCrew[GetPlayerServerId(k)] == nil then
						crew = "None"
					else
						if Crew[PlayersCrew[GetPlayerServerId(k)]] == nil then
							crew = "None"
						else
							crew = Crew[PlayersCrew[GetPlayerServerId(k)]].tag 
							if crew == nil then
								crew = "None"
							end
						end
					end

					
					local inPassive = false
					if playersIdInPassive[GetPlayerServerId(k)] ~= nil then
						inPassive = true
					end
					if KingDriftCrew.name == crewName then
						DrawMarker(43, pCoords.x, pCoords.y, pCoords.z + 1.30, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.0, 0.3, 255, 255, 255, 255, false, true, 2, false, "markers", "crown", false)
					end
					if inPassive then
						if crew ~= "None" then
							Draw3DText(pCoords.x, pCoords.y, pCoords.z - 0.7, ('Lv.%s - ~c~[%s]~s~ %s\n'):format(level, crew, v), 4, 0.08, 0.08)
						else
							Draw3DText(pCoords.x, pCoords.y, pCoords.z - 0.7, ('Lv.%s - %s\n'):format(level, v), 4, 0.08, 0.08)
						end
						Draw3DText(pCoords.x, pCoords.y, pCoords.z - 0.80, '~c~Passive activated', 4, 0.06, 0.06)
					else
						if crew ~= "None" then
							Draw3DText(pCoords.x, pCoords.y, pCoords.z - 0.7, ('Lv.%s - ~c~[%s]~s~ %s\n'):format(level, crew, v), 4, 0.08, 0.08)
						else
							Draw3DText(pCoords.x, pCoords.y, pCoords.z - 0.7, ('Lv.%s - %s\n'):format(level, v), 4, 0.08, 0.08)
						end
					end
				end
				Wait(1)
			end
		end)

	end
end





DisplayPlayersBlips()
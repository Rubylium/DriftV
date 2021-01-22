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

						if blips[v] == nil then
							local blip = AddBlipForEntity(pPed)
							SetBlipScale(blip, 0.75)
							SetBlipCategory(blip, 2)
							blips[v] = blip
						else
							local blip = GetBlipFromEntity(pPed)
							RemoveBlip(blip)
							RemoveBlip(blips[v])
							local blip = AddBlipForEntity(pPed)
							SetBlipScale(blip, 0.75)
							SetBlipCategory(blip, 2)
							blips[v] = blip
						end
						SetBlipNameToPlayerName(blips[v], v)
						SetBlipSprite(blips[v], 1)
						SetBlipRotation(blips[v], math.ceil(GetEntityHeading(pPed)))


						if IsPedInAnyVehicle(pPed, false) then
							ShowHeadingIndicatorOnBlip(blips[v], false)
							local pVeh = GetVehiclePedIsIn(pPed, false)
							SetBlipRotation(blips[v], math.ceil(GetEntityHeading(pVeh)))
						else
							ShowHeadingIndicatorOnBlip(blips[v], true)
							HideNumberOnBlip(blips[v])
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
			while displayBlips do
				for k,v in pairs(playersToShow) do
					local pPed = GetPlayerPed(k)
					local pCoords = GetEntityCoords(pPed)
					local level = tostring(DecorGetInt(pPed, "LEVEL"))
					Draw3DText(pCoords.x, pCoords.y, pCoords.z - 0.7, ('Lv.%s - %s\n'):format(level, v, "Test title ~r~red"), 4, 0.08, 0.08)
				end
				Wait(1)
			end
		end)

	end
end





DisplayPlayersBlips()
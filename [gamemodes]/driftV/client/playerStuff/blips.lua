local displayBlips = false
local blips = {}
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
						local gametag = CreateFakeMpGamerTag(pPed, ('%s'):format(GetPlayerName(v)), false, false, '', 0)
						SetMpGamerTagVisibility(gametag, 4, true)
						SetMpGamerTagVisibility(gametag, 12, true)
						SetMpGamerTagVisibility(gametag, 2, true)
						if playersIdInPassive[GetPlayerServerId(v)] ~= nil then
							SetMpGamerTagVisibility(gametag, 6, true)
						else
							SetMpGamerTagVisibility(gametag, 6, false)
						end
						if p:isPassive() then
							SetMpGamerTagVisibility(gametag, 14, true)
						else
							SetMpGamerTagVisibility(gametag, 14, false)
						end

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
	end
end
DisplayPlayersBlips()
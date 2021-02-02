local ind = {l = false, r = false}


AddEventHandler("driftv:SetAngle", function(angle)
	SendNUIMessage({
		showhud = true,
		setAngle = true,
		angle = math.floor(angle)
	})
end)

Citizen.CreateThread(function()
	while true do
		local Ped = GetPlayerPed(-1)
		if(IsPedInAnyVehicle(Ped)) then
			if GetEntitySpeed(Ped) >= 4 then
				SendNUIMessage({
					showhud = true
				})
			else
				SendNUIMessage({
					showhud = false
				})
			end
		else
			SendNUIMessage({
				showhud = false
			})
		end

		Citizen.Wait(1000)
	end
end)
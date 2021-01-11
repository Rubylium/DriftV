-- copy coords command
RegisterCommand('co', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	local heading = GetEntityHeading(PlayerPedId())
	SendNUIMessage({
		coords = coords.x..", "..coords.y..", "..coords.z
	})
end)

RegisterCommand('coh', function(source, args, rawCommand)
	local coords = GetEntityCoords(PlayerPedId())
	local heading = GetEntityHeading(PlayerPedId())
	SendNUIMessage({
		coords = coords.x..", "..coords.y..", "..coords.z..", "..heading
	})
end)
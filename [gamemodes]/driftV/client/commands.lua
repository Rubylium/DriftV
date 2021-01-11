RegisterCommand("dv", function(source, args, rawCommand)
    DeleteEntity(p:currentVeh(), false)
end, false)

RegisterCommand("fix", function(source, args, rawCommand)
    SetVehicleFixed(p:currentVeh())
end, false)

RegisterCommand("clean", function(source, args, rawCommand)
    SetVehicleDirtLevel(p:currentVeh(), 0.0)
end, false)
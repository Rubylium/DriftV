RegisterCommand("dv", function(source, args, rawCommand)
    DeleteEntity(GetVehiclePedIsIn(p:ped(), false)) 
end, false)
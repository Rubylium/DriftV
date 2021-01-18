RegisterCommand("dv", function(source, args, rawCommand)
    DeleteEntity(p:currentVeh(), false)
end, false)

RegisterCommand("fix", function(source, args, rawCommand)
    SetVehicleFixed(p:currentVeh())
end, false)

RegisterCommand("clean", function(source, args, rawCommand)
    SetVehicleDirtLevel(p:currentVeh(), 0.0)
end, false)

RegisterCommand("car", function(source, args, rawCommand)
    entity:CreateVehicleLocal(args[1], p:pos(), p:heading())
end, false)


local recording = false
RegisterCommand("record", function(source, args, rawCommand)
    if not recording then
        StartRecording(1)
        recording = true
    else
        StopRecordingAndSaveClip()
        recording = false
    end
end, false)
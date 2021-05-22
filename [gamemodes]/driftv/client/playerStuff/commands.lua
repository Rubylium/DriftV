RegisterCommand("dv", function(source, args, rawCommand)
    DeleteEntity(p:currentVeh(), false)
end, false)

RegisterCommand("fix", function(source, args, rawCommand)
    if p:getTime() == "night" then
        return
    end
    SetVehicleFixed(p:currentVeh())
end, false)

RegisterCommand("clean", function(source, args, rawCommand)
    SetVehicleDirtLevel(p:currentVeh(), 0.0)
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

local render = 0.7
local renderToggle = false
RegisterCommand("render", function(source, args, rawCommand)
    if args[1] ~= nil then
        if args[2] ~= nil then
            if args[2] == "true" then -- Maybe you could change that to on / off ? Maybe more userfriendly, it's string anyway so ...
                renderToggle = true
                render = tonumber(args[1])
            else
                renderToggle = false
                render = 0.7
            end
        else
            -- Notification to tell the player he forgot the toggle value
        end
    else
        -- Notification to tell the player he forgot the render value
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.InvokeNative(0xA76359FC80B2438E, tonumber(render)) -- Ugly Native yeah, it don't have a name yet so we need to Invoke it
        Wait(1) -- Native need to be called every frame tho, the game will reset the custom render if not
    end
end)


TriggerEvent('chat:addSuggestion', '/render', 'Force a render distance, may help for performance and invisible map issue', {
    { name="scale", help="Distance between 0.1 and 1.0" },
    { name="toggle", help="true/false" }
})
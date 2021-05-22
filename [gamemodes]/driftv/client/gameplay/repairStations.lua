local stations = {
    vector3(261.31304931641, -1260.6287841797, 29.375202178955),
    vector3(-201.84796142578, -1302.6552734375, 31.505578994751),
}


Citizen.CreateThread(function()
    while not loaded do Wait(1) end

    for k,v in pairs(stations) do
        zone.addZone("Repair_stations"..math.random(1,9999999999), v, "Press ~INPUT_CONTEXT~ To repair your vehicle !", function() RepairVehicle() end, true, 24, 1.3, {255, 255, 255}, 170, "markers", "finish", 0.0, 0.0, 0.0)

        AddBlip(v, 566, 2, 0.85, 2, "Repair stations")
    end
end)

function RepairVehicle()
    FreezeEntityPosition(p:currentVeh(), true)
    for i = 1,100 do
        Visual.Subtitle("Reparing ... ("..i.."/100)")
        Wait(10)
    end
    SetVehicleFixed(p:currentVeh())
    FreezeEntityPosition(p:currentVeh(), false)
end
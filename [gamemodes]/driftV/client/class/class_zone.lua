-- "simulation" d'une class car Lua n'a pas vraiment de class, c'est juste pratique de faire ça
zone = {
    zones = {},
    
    addZone = function(name, pos, text, action_, haveMarker, markerType, markerSize, markerColor, markerAlpha, dict, marker, rotX, rotY, rotZ)
        print("[info]: Adding new zone "..name)


        if rotX == nil then
            rotX = 0.0
        end

        if rotY == nil then
            rotY = 0.0
        end

        if rotZ == nil then
            rotZ = 0.0
        end

        local newZone = {
            name = name,
            pos = pos,
            text = text,
            actions = action_,
            haveMarker = haveMarker,
            markerType = markerType,
            markerSize = markerSize,
            markerColor = markerColor,
            markerAlpha = markerAlpha,
            dict = dict, 
            marker = marker,
            rotX = rotX,
            rotY = rotY,
            rotZ = rotZ,
        }
        zone.zones[name] = newZone
    end,

    removeZone = function(name)
        zone.zones[name] = nil
    end,
}


-- @ Zone handler

Citizen.CreateThread(function()
    while p == nil do Wait(1000) end
    while true do
        local pNear = false

        for k,v in pairs(zone.zones) do
            local dst = GetDistanceBetweenCoords(p:pos(), v.pos, true)

            if dst <= 20.0 then
                pNear = true
                if v.haveMarker then

                    if v.dict ~= nil then
                        if not HasStreamedTextureDictLoaded(v.dict) then
                            RequestStreamedTextureDict(v.dict, true)
                            while not HasStreamedTextureDictLoaded(v.dict) do
                                print("Loading custom marker ... ", v.dict, v.marker)
                                Wait(1)
                            end
                            SetStreamedTextureDictAsNoLongerNeeded(v.dict)
                        end

                        DrawMarker(v.markerType, v.pos, 0.0, 0.0, 0.0, v.rotX, v.rotY, v.rotZ, v.markerSize, v.markerSize, v.markerSize, v.markerColor[1], v.markerColor[2], v.markerColor[3], v.markerAlpha, 0, 1, 2, 0, v.dict, v.marker, 0)
                    else
                        DrawMarker(v.markerType, v.pos, 0.0, 0.0, 0.0, v.rotX, v.rotY, v.rotZ, v.markerSize, v.markerSize, v.markerSize, v.markerColor[1], v.markerColor[2], v.markerColor[3], v.markerAlpha, 0, 1, 2, 0, nil, nil, 0)

                    end
                end

                if dst <= 2.0 then
                    ShowHelpNotification(v.text, true)
                    if IsControlJustReleased(0, 38) then
                        v.actions()
                    end
                end
            end
        end

        if pNear then
            Wait(1)
        else
            Wait(250)
        end
    end
end)
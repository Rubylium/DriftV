local texts = {
    {
        label = "Spawn welcome",
        pos = vector3(225.16973876953, -886.28472900391, 29.687795639038),
        displayDst = 10.0,
        text = {
            "Welcome to the DriftV server!",
            "",
            "Use ~b~F1~s~ to play around on the server!",
            "Don't forget to buy your first vehicle at the vehicle shop!",
        }
    },
    {
        label = "Spawn rules",
        pos = vector3(225.87615966797, -891.63562011719, 30.692003250122),
        displayDst = 10.0,
        text = {
            "DriftV server ~r~rules~s~!",
            "",
            "No form of racism is allowed",
            "The 'troll' is not allowed.",
            "You must respect others",
            "Any form of cheating is not allowed.",
            "",
            "Having fun is a priority!",
        }
    },
}

local nearText = {}

Citizen.CreateThread(function()
    while not loaded do Wait(100) end

    while true do
        local pPed = p:ped()
        local pCoords = p:pos()
        local pNear = false

        for k,v in pairs(texts) do 
            local dst = #(pCoords - v.pos)
            if dst <= v.displayDst then
                nearText[v.label] = v
            else
                nearText[v.label] = nil 
            end
        end

        Wait(500)
    end
end)

Citizen.CreateThread(function()
    while not loaded do Wait(100) end
    while true do
        local count = 0
        for k,v in pairs(nearText) do 
            local baseDown = 0.200
            for k,i in pairs(v.text) do
                Draw3DText(v.pos.x, v.pos.y, v.pos.z - baseDown, i, 4, 0.1, 0.1)
                baseDown = baseDown + 0.200
            end
            count = count + 1
        end
        
        if count > 0 then
            Wait(1)
        else
            Wait(500)
        end
    end
end)
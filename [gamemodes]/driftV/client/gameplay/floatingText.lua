local texts = {
    {
        label = "Spawn welcome",
        pos = vector3(225.16973876953, -886.28472900391, 30.687795639038),
        displayDst = 10.0,
        text = {
            "Welcome to the ~y~Drift~r~V~s~ server!",
            "",
            "Use F1 to open the server menu!",
            "You can earn money by drifting or completing drift trials!",
            "Go to Vehicle shop to buy new cars!",
            "Drift trials score is a combination of your drift score and time!",
            "To see and customize all the cars you own, go to Personal garage!",
            "Bored of drifting alone? Create or join a crew and take part",
            "in crew wars! Crew with highest rank gets a crown above their names!",
            "",
            "We are working hard on adding even more hiqh quality features!",
            "Don't forget to join our Discord community at discord.gg/Z486cyeM78 ",
            "Enjoy the server!",
        }
    },
    {
        label = "Spawn rules",
        pos = vector3(225.87615966797, -891.63562011719, 30.692003250122),
        displayDst = 10.0,
        text = {
            "~y~Drift~r~V~s~ Server rules!",
            "",
            "No form of racism is allowed.",
            "Trolling is not allowed.",
            "You must respect others.",
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
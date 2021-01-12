Succes = {
    {
        name = "points_succes1",
        label = "Session: You have exceeded 100k drift points! Bravo !",
        xpReward = 130*500,
        funcToCheck = function()
            local value = 100000
            return CheckDriftPoints(value)
        end,
    },
    {
        name = "points_succes2",
        label = "Session: You have exceeded 200k drift points! Bravo !",
        xpReward = 140*500,
        funcToCheck = function()
            local value = 200000
            return CheckDriftPoints(value)
        end,
    },
    {
        name = "points_succes3",
        label = "Session: You have exceeded 500k drift points! Bravo !",
        xpReward = 150*500,
        funcToCheck = function()
            local value = 500000
            return CheckDriftPoints(value)
        end,
    },
    {
        name = "points_succes4",
        label = "Session: You have exceeded 1m drift points! Bravo !",
        xpReward = 160*500,
        funcToCheck = function()
            local value = 1000000
            return CheckDriftPoints(value)
        end,
    },
    {
        name = "points_succes5",
        label = "Session: You have exceeded 2m drift points! Bravo !",
        xpReward = 170*500,
        funcToCheck = function()
            local value = 2000000
            return CheckDriftPoints(value)
        end,
    },
    {
        name = "points_succes6",
        label = "Session: You have exceeded 6m drift points! Bravo !",
        xpReward = 180*500,
        funcToCheck = function()
            local value = 3000000
            return CheckDriftPoints(value)
        end,
    },
}


Citizen.CreateThread(function()
while not loaded do Wait(1) end
    while true do
        for k,v in pairs(Succes) do
            if p:GetSucces()[k] == nil then
                if v.funcToCheck() then
                    p:SetSucces(k)
                    SendNUIMessage( {
                        ShowSucces = true,
                        label = v.label,
                    })
                    XNL_AddPlayerXP(v.xpReward)
                    Wait(4000)
                    SendNUIMessage( {
                        HideSucces = true,
                    })
                    Wait(1000)
                end
            end
        end
        Wait(1000)
    end
end)



function CheckDriftPoints(points)
    if p:getSessionDrift() >= points then
        return true
    else
        return false
    end
end
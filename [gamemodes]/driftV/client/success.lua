Succes = {
    ["points_succes1"] = {
        label = "Daily: You have exceeded 100,000 drift points! Bravo !",
        xpReward = 30*500,
        funcToCheck = function()
            local value = 100000,
            CheckDriftPoints(value)
        end,
    },
    ["points_succes2"] = {
        label = "Daily: You have exceeded 200,000 drift points! Bravo !",
        xpReward = 40*500,
        funcToCheck = function()
            local value = 200000,
            CheckDriftPoints(value)
        end,
    },
    ["points_succes3"] = {
        label = "Daily: You have exceeded 500,000 drift points! Bravo !",
        xpReward = 50*500,
        funcToCheck = function()
            local value = 500000,
            CheckDriftPoints(value)
        end,
    },
    ["points_succes4"] = {
        label = "Daily: You have exceeded 1,000,000 drift points! Bravo !",
        xpReward = 60*500,
        funcToCheck = function()
            local value = 1000000,
            CheckDriftPoints(value)
        end,
    },
    ["points_succes5"] = {
        label = "Daily: You have exceeded 2,000,000 drift points! Bravo !",
        xpReward = 70*500,
        funcToCheck = function()
            local value = 2000000,
            CheckDriftPoints(value)
        end,
    },
    ["points_succes6"] = {
        label = "Daily: You have exceeded 6,000,000 drift points! Bravo !",
        xpReward = 80*500,
        funcToCheck = function()
            local value = 3000000
            return CheckDriftPoints(value)
        end,
    },
}


Citizen.CreateThread(function()
    while true do
        for k,v in pairs(Succes) do
            if p:GetSucces()[k] == nil then
                if v.funcToCheck() then
                    p:SetSucces(k)
                    SendNUIMessage( {
                        ShowSucces = true,
                        label = v.label,
                    })
                    Wait(4000)
                    SendNUIMessage( {
                        HideSucces = true,
                    })
                end
                Wait(5000) -- To fix succes spam
            end
        end
        Wait(5000)
    end
end)



function CheckDriftPoints(points)
    if p:GetDrift() >= points then
        return true
    else
        return false
    end
end
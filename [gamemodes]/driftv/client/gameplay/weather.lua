local minutes = 0
local hours = 8

function changeTime(hour, minute)
    Citizen.CreateThread(function()
        while hours ~= hour do
            minutes = minutes + 2
            if minutes > 60 then
                minutes = 0
                hours = hours + 1
            end
            if hours >= 24 then
                hours = 0
                minutes = 0
            end

            NetworkOverrideClockTime(hours, minutes, 0)
            Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        SetWeatherTypeNowPersist("EXTRASUNNY")
        NetworkOverrideClockTime(hours, minutes, 0)
        Wait(500)
    end
end)
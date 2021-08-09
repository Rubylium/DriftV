Utils = {}


function Utils.RealWait(ms)
    local timer = GetGameTimer() + ms
    while GetGameTimer() < timer do
        Wait(0)
    end
end

function Utils.Round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
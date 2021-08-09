Utils = {}


function Utils.RealWait(ms)
    local timer = GetGameTimer() + ms
    while GetGameTimer() < timer do
        Wait(0)
    end
end
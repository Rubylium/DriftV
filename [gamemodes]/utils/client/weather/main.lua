CurrentWeather = 'FOGGY'
Time = {}
Time.h = 7
Time.m = 0


RegisterNetEvent('updateWeather')
AddEventHandler('updateWeather', function(NewWeather)
    CurrentWeather = NewWeather
end)

Citizen.CreateThread(function()
    while true do
        if lastWeather ~= CurrentWeather then
			lastWeather = CurrentWeather
			SetWeatherTypeOverTime(CurrentWeather, 5.0)
			Citizen.Wait(5000)
		end
		Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
		ClearOverrideWeather()
		ClearWeatherTypePersist()
		SetWeatherTypePersist(lastWeather)
		SetWeatherTypeNow(lastWeather)
		SetWeatherTypeNowPersist(lastWeather)
		if lastWeather == 'XMAS' then
			SetForceVehicleTrails(true)
			SetForcePedFootstepsTracks(true)
		else
			SetForceVehicleTrails(false)
			SetForcePedFootstepsTracks(false)
		end    
    end
end)

RegisterNetEvent('updateTime')
AddEventHandler('updateTime', function(hours, minutes)
    Time.h = hours
    Time.m = minutes
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000)
        NetworkOverrideClockTime(Time.h, Time.m, 0)
        Time.m = Time.m + 1
        if Time.m > 59 then
            Time.m = 0
            Time.h = Time.h + 1
            if Time.h > 23 then
                Time.h = 0
            end
        end
    end
end)

AddEventHandler('playerSpawned', function()
    TriggerServerEvent('requestSync')
end)
--[[ Forza Horizon 4 Speedometer for FiveM ]] --
--[[ Author: Akkariin | Github: https://github.com/kasuganosoras/fh4speed ]] --
--[[ If you like this script, please give me a like on the fivem forum, thanks ]] --

local isHide = false

Citizen.CreateThread(
    function()
        while true do
            Wait(1)

            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed, false) then
                if playerPed and not isHide then
                    playerCar = GetVehiclePedIsIn(playerPed, false)

                    if playerCar and GetPedInVehicleSeat(playerCar, -1) == playerPed then
                        carRPM = GetVehicleCurrentRpm(playerCar)
                        carSpeed = GetEntitySpeed(playerCar)
                        carGear = GetVehicleCurrentGear(playerCar)
                        carIL = GetVehicleIndicatorLights(playerCar)
                        carHandbrake = GetVehicleHandbrake(playerCar)
                        carBrakePressure = GetVehicleWheelBrakePressure(playerCar, 0)
                        carLS_r, carLS_o, carLS_h = GetVehicleLightsState(playerCar)

                        SendNUIMessage(
                            {
                                ShowHud = true,
                                CurrentCarRPM = carRPM,
                                CurrentCarGear = carGear,
                                CurrentCarSpeed = carSpeed,
                                CurrentCarKmh = math.ceil(carSpeed * 3.6),
                                CurrentCarMph = math.ceil(carSpeed * 2.236936),
                                CurrentCarIL = carIL,
                                CurrentCarHandbrake = carHandbrake,
                                CurrentCarBrake = carBrakePressure,
                                CurrentCarLS_r = carLS_r,
                                CurrentCarLS_o = carLS_o,
                                CurrentCarLS_h = carLS_h,
                                PlayerID = GetPlayerServerId(GetPlayerIndex())
                            }
                        )
                    else
                        SendNUIMessage({HideHud = true})
                    end
                end
            else
                SendNUIMessage({HideHud = true})
                Wait(500)
            end
        end
    end
)

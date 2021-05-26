
local vehiclesToCheck = {}
local _SIZE = 0.2
local _DENS = 10

local _SMOKE_ON = true

local bone_list = {"wheel_lr","wheel_rr"}


local function Angle(veh)
    if not veh then return false end
    local vx,vy,_ = table.unpack(GetEntityVelocity(veh))
    local modV = math.sqrt(vx*vx + vy*vy)


    local _,_,rz = table.unpack(GetEntityRotation(veh,0))
    local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

    if GetEntitySpeed(veh)* 3.6 < 5 or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 30 km/h

    local cosX = (sn*vx + cs*vy)/modV
    if cosX > 0.966 or cosX < 0 then return 0,modV end
    return math.deg(math.acos(cosX))*0.5, modV
end

local function RefreshVeh()
    for k,v in pairs(GetVehicles()) do
        if GetEntitySpeed(v) * 3.6 >= 30 then
            vehiclesToCheck[v] = v
        else
            vehiclesToCheck[v] = nil
        end
    end
end

CreateThread(function()

    if Config.BetterSmoke == true then

        local base = "scr_recartheft"
        local base2 = "core"

        Request(base)
        Request(base2)

        local count = 0
        while true do 
            Wait(1)

            count = count + 1
            if count >= 50 then
                RefreshVeh()
                count = 0
                --print("Refresh smoke")
            end

            local didCheck = false
            for k,v in pairs(vehiclesToCheck) do
                local car = v
                local ang,speed = Angle(car)

                

                if _SMOKE_ON then
                    if speed * 3.6 >= 40 and ang >= 10 then
                        didCheck = true
                        local speed = speed * 3.6
                        local densBySpeed = (_SIZE * speed) / 100
                        local densByAngle = densBySpeed + (ang / 1000)
                        DriftSmoke(base,"scr_wheel_burnout", car, _DENS, densByAngle)
                    end
                end
            end

            if not didCheck then
                RefreshVeh()
                Wait(500)
            end
        end

    end
end)

--[[===============]]
--[[=== F U N C ===]]
--[[===============]]

function Request(name)
    RequestNamedPtfxAsset(name)
    while not HasNamedPtfxAssetLoaded(name) do
        Wait(1)
    end
end

function DriftSmoke(base, sub, car, dens, size)
    local all_part = {}

    for i = 0, dens do
        for k,v in pairs(bone_list) do
            UseParticleFxAssetNextCall(base)
            local W1 = StartParticleFxLoopedOnEntityBone(sub, car, 0.05, 0, 0, 0, 0, 0, GetEntityBoneIndexByName(car, v), size, 0, 0, 0)
            table.insert(all_part, W1)
        end
    end

    Citizen.Wait(1000)

    for _,W1 in pairs(all_part) do
        StopParticleFxLooped(W1, true)
    end
end

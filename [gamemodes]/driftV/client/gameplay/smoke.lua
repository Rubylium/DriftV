
local _SIZE = 0.2
local _DENS = 10

local _SMOKE_ON = true

local bone_list = {"wheel_lr","wheel_rr"}

Citizen.CreateThread(function()

    local base = "scr_recartheft"
    local base2 = "core"

    Request(base)
    Request(base2)

    while true do Citizen.Wait(0)

        local ped = GetPlayerPed(-1)
        local car = GetVehiclePedIsUsing(ped)
        local ang,speed = Angle(car)


        if _SMOKE_ON then
            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                if speed * 3.6 >= 40 and ang >= 10 then
                    DriftSmoke(base,"scr_wheel_burnout", car, _DENS, _SIZE)
                end
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
        UseParticleFxAssetNextCall(base)
        W1 = StartParticleFxLoopedOnEntityBone(sub, car, 0.05, 0, 0, 0, 0, 0, GetEntityBoneIndexByName(car, bone_list[1]), size, 0, 0, 0)

        UseParticleFxAssetNextCall(base)
        W2 = StartParticleFxLoopedOnEntityBone(sub, car, 0.05, 0, 0, 0, 0, 0, GetEntityBoneIndexByName(car, bone_list[2]), size, 0, 0, 0)

        table.insert(all_part, 1, W1)
        table.insert(all_part, 2, W2)
    end

    Citizen.Wait(1000)

    for _,W1 in pairs(all_part) do
        StopParticleFxLooped(W1, true)
    end
end

function Angle(veh)
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
score = 0
local tablemultiplier = {350,1400,4200,11200}
local mult = 0.1
local waiting = 0
local inRace = false
local bonusCops = 0
local holding = 0
local baseSpeedLimit = 15
local vehicleHealth = 1000
local blacklistVeh = {
    [GetHashKey("dinghy")] = true,
    [GetHashKey("seashadinghy2rk2")] = true,
    [GetHashKey("dinghy3")] = true,
    [GetHashKey("dinghy4")] = true,
    [GetHashKey("jetmax")] = true,
    [GetHashKey("marquis")] = true,
    [GetHashKey("seashark")] = true,
    [GetHashKey("seashark2")] = true,
    [GetHashKey("seashark3")] = true,
    [GetHashKey("speeder")] = true,
    [GetHashKey("speeder2")] = true,
    [GetHashKey("squalo")] = true,
    [GetHashKey("submersible")] = true,
    [GetHashKey("submersible2")] = true,
    [GetHashKey("suntrap")] = true,
    [GetHashKey("toro")] = true,
    [GetHashKey("toro2")] = true,
    [GetHashKey("tropic")] = true,
    [GetHashKey("tropic2")] = true,
    [GetHashKey("tug")] = true,

    [GetHashKey("akula")] = true,
    [GetHashKey("annihilator")] = true,
    [GetHashKey("buzzard")] = true,
    [GetHashKey("buzzard2")] = true,
    [GetHashKey("cargobob")] = true,
    [GetHashKey("cargobob2")] = true,
    [GetHashKey("cargobob3")] = true,
    [GetHashKey("cargobob4")] = true,
    [GetHashKey("frogger")] = true,
    [GetHashKey("frogger2")] = true,
    [GetHashKey("havok")] = true,
    [GetHashKey("hunter")] = true,
    [GetHashKey("maverick")] = true,
    [GetHashKey("savage")] = true,
    [GetHashKey("seasparrow")] = true,
    [GetHashKey("skylift")] = true,
    [GetHashKey("supervolito")] = true,
    [GetHashKey("supervolito2")] = true,
    [GetHashKey("swift")] = true,
    [GetHashKey("swift2")] = true,
    [GetHashKey("valkyrie")] = true,
    [GetHashKey("valkyrie2")] = true,
    [GetHashKey("volatus")] = true,
    [GetHashKey("alphaz1")] = true,
    [GetHashKey("avenger")] = true,
    [GetHashKey("avenger2")] = true,
    [GetHashKey("besra")] = true,
    [GetHashKey("blimp")] = true,
    [GetHashKey("blimp2")] = true,
    [GetHashKey("blimp3")] = true,
    [GetHashKey("bombushka")] = true,
    [GetHashKey("cargoplane")] = true,
    [GetHashKey("cuban800")] = true,
    [GetHashKey("dodo")] = true,
    [GetHashKey("duster")] = true,
    [GetHashKey("howard")] = true,
    [GetHashKey("hydra")] = true,
    [GetHashKey("jet")] = true,
    [GetHashKey("lazer")] = true,
    [GetHashKey("luxor")] = true,
    [GetHashKey("luxor2")] = true,
    [GetHashKey("mammatus")] = true,
    [GetHashKey("microlight")] = true,
    [GetHashKey("miljet")] = true,
    [GetHashKey("mogul")] = true,
    [GetHashKey("molotok")] = true,
    [GetHashKey("nimbus")] = true,
    [GetHashKey("nokota")] = true,
    [GetHashKey("pyro")] = true,
    [GetHashKey("rogue")] = true,
    [GetHashKey("seabreeze")] = true,
    [GetHashKey("shamal")] = true,
    [GetHashKey("starling")] = true,
    [GetHashKey("strikeforce")] = true,
    [GetHashKey("stunt")] = true,
    [GetHashKey("titan")] = true,
    [GetHashKey("tula")] = true,
    [GetHashKey("velum")] = true,
    [GetHashKey("velum2")] = true,
    [GetHashKey("vestra")] = true,
    [GetHashKey("volatol")] = true,
}
local littleSucces = {
    speed = {
        cooldown = false,
        label = "high speed drift"
    },
    angleGood = {
        cooldown = false,
        label = "Good Angle"
    },
    angleInsane = {
        cooldown = false,
        label = "Insane Angle"
    },
}
    
function ChangeSpeedLimit(limit)
    baseSpeedLimit = limit
end

local inAerorport = false
Citizen.CreateThread(function()
    --Name: aeroport | 2021-01-17T16:19:19Z
    while PolyZone == nil do Wait(100) end
    local aeroport = PolyZone:Create({
        vector2(-883.20074462891, -2519.7609863281),
        vector2(-948.49163818359, -2339.0808105469),
        vector2(-1022.8463134766, -2324.392578125),
        vector2(-1213.7489013672, -2213.55859375),
        vector2(-1229.2888183594, -2177.7319335938),
        vector2(-1228.8903808594, -2118.3488769531),
        vector2(-1249.7570800781, -2103.8825683594),
        vector2(-1260.7379150391, -2112.6394042969),
        vector2(-1273.2924804688, -2118.142578125),
        vector2(-1295.2432861328, -2113.2390136719),
        vector2(-1374.7094726562, -2154.1450195312),
        vector2(-1420.1635742188, -2222.7099609375),
        vector2(-1699.29296875, -2693.3354492188),
        vector2(-1784.2448730469, -2655.17578125),
        vector2(-2103.0695800781, -3103.2258300781),
        vector2(-1035.3957519531, -3805.1008300781),
        vector2(-675.06365966797, -3233.6828613281),
        vector2(-868.56384277344, -3110.2600097656),
        vector2(-700.37896728516, -2827.9965820312)
    }, {
      name="aeroport",
      --minZ = 17.846054077148,
      --maxZ = 123.04996490479
    })
  
  
    aeroport:onPlayerInOut(function(isPointInside, point)
        inAerorport = isPointInside
        if inAerorport then
            Visual.Subtitle("You have entered a forbidden drift zone, the police will not come. Bonus disabled", 10000)
        end
    end)
    
end)


function DrawDriftText(text,colour,coordsx,coordsy,scalex,scaley)
    SetTextFont(7)
    SetTextProportional(7)
    SetTextScale(scalex, scaley)
    local colourr,colourg,colourb,coloura = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, coloura)
    SetTextDropshadow(0, 0, 0, 0, coloura)
    SetTextEdge(1, 0, 0, 0, coloura)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    EndTextCommandDisplayText(coordsx,coordsy)
end


function calculateBonus(previous)
    local points = previous
    local points = math.floor(points)
    return points or 0
end
function math.precentage(a,b)
    return (a*100)/b
end


function angle(veh)
	if not veh then return false end
	local vx,vy,vz = table.unpack(GetEntityVelocity(veh))
	local modV = math.sqrt(vx*vx + vy*vy)


	local rx,ry,rz = table.unpack(GetEntityRotation(veh,0))
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))

	if GetEntitySpeed(veh)* 3.6 < baseSpeedLimit or GetVehicleCurrentGear(veh) == 0 then return 0,modV end --speed over 25 km/h

	local cosX = (sn*vx + cs*vy)/modV
	return math.deg(math.acos(cosX))*0.5, modV
end

local function round2(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function ResetMulti(set)
    if set ~= nil then
        print("Reseted")
        mult = 0.1
        return
    end
end

function ResetDriftPoint()
    score = 0
end

function SetPlayerInRace(status)
    inRace = status
end

function GetCurrentDriftPoint()
    return score
end

-- Citizen.CreateThread(function()
--     while not loaded do Wait(1) end
--     while true do
--         if p:isInVeh() then
--             Wait(50)

--             score = 0
--             holding = 0
--             mult = 1.0
--             while p:isInVeh() and GetPedInVehicleSeat(p:currentVeh(), -1) == p:ped() and blacklistVeh[GetEntityModel(p:currentVeh())] == nil and not inAerorport do

--                 local newScore = score
--                 local angle = angle(p:currentVeh())
--                 local ground = GetEntityHeightAboveGround(p:currentVeh())
--                 local speed = p:speed()

--                 if angle < 10 then
--                     if holding <= 0 then
--                         holding = 0
--                     end
--                     mult = mult - 0.05
--                     if mult <= 1.0 then
--                         mult = 1.0
--                         holding = 0
--                     end
--                 else
--                     mult = mult + 0.0007
--                     if mult > 10.0 then
--                         mult = 10.0
--                     end
--                 end

--                 if angle > 10 then
--                     TriggerEvent("driftv:SetAngle", angle)

--                     if GetEntityHealth(p:currentVeh()) ~= vehicleHealth then
--                         vehicleHealth = GetEntityHealth(p:currentVeh())
--                         holding = 0
--                         mult = 1.0
--                     end

--                     if angle >= 10 and angle <= 18 and ground <= 1.5 then
--                         newScore = math.floor(score  + (2 * mult))
--                     elseif angle > 18 and angle <= 25 and ground <= 1.5 then
--                         local toAdd = (3 * mult) * (speed / 10)
--                         newScore = math.floor(score + toAdd)
--                     elseif angle > 25 and angle <= 40 and ground <= 1.5 and speed >= baseSpeedLimit then
--                         local toAdd = (4 * mult) * (speed / 10)
--                         newScore = math.floor(score + toAdd)

--                         if not littleSucces.angleGood.cooldown then
--                             littleSucces.angleGood.cooldown = true
--                             AddLittleSucces(littleSucces.angleGood.label)
--                             Citizen.CreateThread(function()
--                                 Wait(20000)
--                                 littleSucces.angleGood.cooldown = false
--                             end)
--                         end
--                     elseif angle > 40 and angle <= 50 and ground <= 1.5 and speed >= baseSpeedLimit then
--                         local toAdd = (15 * mult) * (speed / 10)
--                         newScore = math.floor(score + toAdd)
                        
--                         if not littleSucces.angleInsane.cooldown then
--                             littleSucces.angleInsane.cooldown = true
--                             AddLittleSucces(littleSucces.angleInsane.label)
--                             Citizen.CreateThread(function()
--                                 Wait(20000)
--                                 littleSucces.angleInsane.cooldown = false
--                             end)
--                         end
--                     elseif angle >= 10 and ground <= 1.5 then
--                         newScore = math.floor(score + (1 * mult))
--                     end

--                     if speed > 120 then
--                         if not littleSucces.speed.cooldown then
--                             littleSucces.speed.cooldown = true
--                             AddLittleSucces(littleSucces.speed.label)
--                             Citizen.CreateThread(function()
--                                 Wait(15000)
--                                 littleSucces.speed.cooldown = false
--                             end)
--                         end
--                     end
--                 else
--                     Wait(300)
--                 end

    
                

--                 if speed <= 4 and score ~= 0 and not inRace then
--                     p:SubmitDriftScore(score * mult, mult)
--                     score = 0
--                     waiting = 0
--                     mult = 1.0
--                     SendNUIMessage({HideHud = true})
--                 else
--                     if newScore ~= score and speed >= 10.0 then
--                         waiting = 0
--                         score = newScore
--                     else
--                         waiting = waiting + 1
--                         if waiting >= 5 and score ~= 0 and not inRace then
--                             p:SubmitDriftScore(score * mult, mult)
--                             score = 0
--                             waiting = 0
--                             mult = 1.0
--                             SendNUIMessage({HideHud = true})
--                         end
--                     end
--                 end

                
--                 if score ~= 0 then
--                     --SetMulti()
--                     SendNUIMessage(
--                         {
--                             ShowHud = true,
--                             driftPoints = math.floor(score),
--                             driftDisplayMulti = "x"..round2(mult, 1),
--                         }
--                     )
--                 end
--                 Wait(1)
--             end

--         else
--             SendNUIMessage({HideHud = true})
--             Wait(500)
--         end
--     end
-- end)
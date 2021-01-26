function LoadModel(name)
    local model = GetHashKey(name)
    if IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            ShowLoadingMessageTimed(20, "Loading model ...", 1)
            Wait(1)
        end
    else
        ShowNotification("Unknow model, report this issue to the devs ("..tostring(name)..")")
    end
    SetModelAsNoLongerNeeded(model)
end

function ClearScreen()
    SetCloudHatOpacity(0.0)
    HideHudAndRadarThisFrame()
    
    -- nice hack to 'hide' HUD elements from other resources/scripts. kinda buggy though.
    SetDrawOrigin(0.0, 0.0, 0.0, 0)
end

local opa = 0
function DrawDriftV()
    SetTextFont(1)
    SetTextProportional(1)
    SetTextScale(1.5, 1.5)

    SetTextColour(255,255,255, 250)
    SetTextDropshadow(0, 0, 0, 0, 250)
    SetTextEdge(1, 0, 0, 0, 250)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString("DriftV")
    EndTextCommandDisplayText(0.50,0.50)
    DrawDriftVsub()
end

function DrawDriftVsub()
    SetTextFont(1)
    SetTextProportional(1)
    SetTextScale(0.7, 0.7)

    SetTextColour(3, 244, 2525, 250)
    SetTextDropshadow(0, 0, 0, 0, 250)
    SetTextEdge(1, 0, 0, 0, 250)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString("The drift paradise ~")
    EndTextCommandDisplayText(0.50,0.60)
end


function TeleportPlayer(coords)
	local pPed = PlayerPedId()
    local x, y, z = coords.x, coords.y, coords.z or coords.z + 1.0

    RequestCollisionAtCoord(x, y, z)
    NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

    local sceneLoadTimer = GetGameTimer()
    while not IsNewLoadSceneLoaded() do
        if GetGameTimer() - sceneLoadTimer > 2000 then
            break
        end

        Citizen.Wait(0)
    end

    SetPedCoordsKeepVehicle(pPed, x, y, z)
    sceneLoadTimer = GetGameTimer()

    while not HasCollisionLoadedAroundEntity(pPed) do
        if GetGameTimer() - sceneLoadTimer > 2000 then
            break
        end

        Citizen.Wait(0)
    end

    local foundNewZ, newZ = GetGroundZFor_3dCoord(x, y, z, 0, 0)
    if foundNewZ and newZ > 0 then
        z = newZ
    end

    SetPedCoordsKeepVehicle(pPed, x, y, z)
    NewLoadSceneStop()

    return true
end

function ShowNotification(text)
    TriggerEvent("FeedM:showNotification", text, 15000, "primary")
end

function ShowHelpNotification(msg, beep)
	local beep = beep
	if beep == nil then
		beep = true
	end
	AddTextEntry('core:HelpNotif', msg)
	BeginTextCommandDisplayHelp('core:HelpNotif')
	EndTextCommandDisplayHelp(0, false, beep, 1)
end

function ShowLoadingMessage(text, spinner)
    BeginTextCommandBusyspinnerOn("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandBusyspinnerOn(spinner or 1)
end

function ShowLoadingMessageTimed(duration, text, spinner)
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        Visual.Prompt(text, spinner)
        Citizen.Wait(duration)
        if (BusyspinnerIsOn()) then
            BusyspinnerOff()
        end
    end)
end

function Subtitle(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

function RandomUpgrade(pVeh)
    SetVehicleModKit(pVeh, 0)
    for i = 1,49 do
        local max = GetNumVehicleMods(pVeh, i)
        SetVehicleMod(pVeh, i, math.random(0,max), true)
        
    end
    SetVehicleMod(pVeh, 11, GetNumVehicleMods(pVeh, i), true)
    SetVehicleMod(pVeh, 12, GetNumVehicleMods(pVeh, i), true)
    SetVehicleMod(pVeh, 13, GetNumVehicleMods(pVeh, i), true)
    SetVehicleMod(pVeh, 14, GetNumVehicleMods(pVeh, i), true)
    SetVehicleMod(pVeh, 15, GetNumVehicleMods(pVeh, i), true)
    ToggleVehicleMod(pVeh, 18, true)
    ToggleVehicleMod(pVeh, 22, true)

    SetVehicleNitroEnabled(pVeh, true)
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)		-- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function DrawTexts(x, y, text, center, scale, rgb, font, justify)
    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    --SetTextJustification(justify)
    --SetTextRightJustify(justify)
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x,y)
end


local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumerateObjects()
	return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
	return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
	return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

function AddBlip(pos, sprite, display, scale, color, label)
    local blip = AddBlipForCoord(pos)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, display)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)
end


Citizen.CreateThread(function()
    for i = 1,15 do
        EnableDispatchService(i, false)
    end
end)

function GetVehProps(vehicle)
    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    local extras = {}

    for extraId=0, 12 do
        if DoesExtraExist(vehicle, extraId) then
            local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
            extras[tostring(extraId)] = state
        end
    end

    return {
        model             = GetEntityModel(vehicle),

        plate             = Trim(GetVehicleNumberPlateText(vehicle)),
        plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

        bodyHealth        = Round(GetVehicleBodyHealth(vehicle), 1),
        engineHealth      = Round(GetVehicleEngineHealth(vehicle), 1),
        tankHealth        = Round(GetVehiclePetrolTankHealth(vehicle), 1),

        fuelLevel         = Round(GetVehicleFuelLevel(vehicle), 1),
        dirtLevel         = Round(GetVehicleDirtLevel(vehicle), 1),
        color1            = colorPrimary,
        color2            = colorSecondary,

        pearlescentColor  = pearlescentColor,
        wheelColor        = wheelColor,

        wheels            = GetVehicleWheelType(vehicle),
        windowTint        = GetVehicleWindowTint(vehicle),
        xenonColor        = GetVehicleXenonLightsColour(vehicle),

        neonEnabled       = {
            IsVehicleNeonLightEnabled(vehicle, 0),
            IsVehicleNeonLightEnabled(vehicle, 1),
            IsVehicleNeonLightEnabled(vehicle, 2),
            IsVehicleNeonLightEnabled(vehicle, 3)
        },

        neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
        extras            = extras,
        tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

        modSpoilers       = GetVehicleMod(vehicle, 0),
        modFrontBumper    = GetVehicleMod(vehicle, 1),
        modRearBumper     = GetVehicleMod(vehicle, 2),
        modSideSkirt      = GetVehicleMod(vehicle, 3),
        modExhaust        = GetVehicleMod(vehicle, 4),
        modFrame          = GetVehicleMod(vehicle, 5),
        modGrille         = GetVehicleMod(vehicle, 6),
        modHood           = GetVehicleMod(vehicle, 7),
        modFender         = GetVehicleMod(vehicle, 8),
        modRightFender    = GetVehicleMod(vehicle, 9),
        modRoof           = GetVehicleMod(vehicle, 10),

        modEngine         = GetVehicleMod(vehicle, 11),
        modBrakes         = GetVehicleMod(vehicle, 12),
        modTransmission   = GetVehicleMod(vehicle, 13),
        modHorns          = GetVehicleMod(vehicle, 14),
        modSuspension     = GetVehicleMod(vehicle, 15),
        modArmor          = GetVehicleMod(vehicle, 16),

        modTurbo          = IsToggleModOn(vehicle, 18),
        modSmokeEnabled   = IsToggleModOn(vehicle, 20),
        modXenon          = IsToggleModOn(vehicle, 22),

        modFrontWheels    = GetVehicleMod(vehicle, 23),
        modBackWheels     = GetVehicleMod(vehicle, 24),

        modPlateHolder    = GetVehicleMod(vehicle, 25),
        modVanityPlate    = GetVehicleMod(vehicle, 26),
        modTrimA          = GetVehicleMod(vehicle, 27),
        modOrnaments      = GetVehicleMod(vehicle, 28),
        modDashboard      = GetVehicleMod(vehicle, 29),
        modDial           = GetVehicleMod(vehicle, 30),
        modDoorSpeaker    = GetVehicleMod(vehicle, 31),
        modSeats          = GetVehicleMod(vehicle, 32),
        modSteeringWheel  = GetVehicleMod(vehicle, 33),
        modShifterLeavers = GetVehicleMod(vehicle, 34),
        modAPlate         = GetVehicleMod(vehicle, 35),
        modSpeakers       = GetVehicleMod(vehicle, 36),
        modTrunk          = GetVehicleMod(vehicle, 37),
        modHydrolic       = GetVehicleMod(vehicle, 38),
        modEngineBlock    = GetVehicleMod(vehicle, 39),
        modAirFilter      = GetVehicleMod(vehicle, 40),
        modStruts         = GetVehicleMod(vehicle, 41),
        modArchCover      = GetVehicleMod(vehicle, 42),
        modAerials        = GetVehicleMod(vehicle, 43),
        modTrimB          = GetVehicleMod(vehicle, 44),
        modTank           = GetVehicleMod(vehicle, 45),
        modWindows        = GetVehicleMod(vehicle, 46),
        modLivery         = GetVehicleLivery(vehicle)
    }
end

function SetVehProps(vehicle, props)
    if props == nil then
        props = {}
    end
    local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
    SetVehicleModKit(vehicle, 0)

    if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
    if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
    if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
    if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
    if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
    if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
    if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
    if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
    if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
    if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
    if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
    if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
    if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

    if props.neonEnabled then
        SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
        SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
        SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
        SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
    end

    if props.extras then
        for extraId,enabled in pairs(props.extras) do
            if enabled then
                SetVehicleExtra(vehicle, tonumber(extraId), 0)
            else
                SetVehicleExtra(vehicle, tonumber(extraId), 1)
            end
        end
    end

    if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
    if props.xenonColor then SetVehicleXenonLightsColour(vehicle, props.xenonColor) end
    if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
    if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
    if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
    if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
    if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
    if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
    if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
    if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
    if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
    if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
    if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
    if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
    if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
    if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
    if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
    if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
    if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
    if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
    if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
    if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
    if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
    if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
    if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
    if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
    if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
    if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
    if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
    if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
    if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
    if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
    if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
    if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
    if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
    if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
    if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
    if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
    if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
    if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
    if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
    if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
    if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
    if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
    if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
    if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
    if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

    if props.modLivery then
        SetVehicleMod(vehicle, 48, props.modLivery, false)
        SetVehicleLivery(vehicle, props.modLivery)
    end
end

-- credit http://richard.warburton.it
function GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. (' ')):reverse())..right
end

function Trim(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

function GetClosestPlayer()
	local pPed = GetPlayerPed(-1)
	local players = GetActivePlayers()
	local coords = GetEntityCoords(pPed)
	local pCloset = nil
	local pClosetPos = nil
	local pClosetDst = nil
	for k,v in pairs(players) do
		if GetPlayerPed(v) ~= pPed then
			local oPed = GetPlayerPed(v)
			local oCoords = GetEntityCoords(oPed)
			local dst = GetDistanceBetweenCoords(oCoords, coords, true)
			if pCloset == nil then
				pCloset = v
				pClosetPos = oCoords
				pClosetDst = dst
			else
				if dst < pClosetDst then
					pCloset = v
					pClosetPos = oCoords
					pClosetDst = dst
				end
			end
		end
	end

	return pCloset, pClosetDst
end

function DisplayClosetPlayer()
	local pPed = GetPlayerPed(-1)
	local pCoords = GetEntityCoords(pPed)
	local pCloset = GetClosestPlayer(pCoords)
	if pCloset ~= -1 then
		local cCoords = GetEntityCoords(GetPlayerPed(pCloset))
		DrawMarker(20, cCoords.x, cCoords.y, cCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 0, nil, nil, 0)
	end
end
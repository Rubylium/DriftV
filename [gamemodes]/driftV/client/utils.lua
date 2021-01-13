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

GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ''):reverse())..right
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
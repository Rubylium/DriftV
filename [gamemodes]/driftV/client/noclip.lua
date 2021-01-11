function ToogleNoClip()
    if inNoClip then
        inNoClip = false
        SetEnabled(false)
        SetNoClipAttributes(GetPlayerPed(-1), false)
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local get, z = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, pCoords.z, true, 0)
        if get then
            SetEntityCoordsNoOffset(PlayerPedId(), pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
        end
        return
    else
        inNoClip = true
        SetEnabled(true)


        Citizen.CreateThread(function()
            while inNoClip do
                CameraLoop()
                SetNoClipAttributes(p:ped(), true)
                Wait(1)
            end
        end)
    end
end

function SetNoClipAttributes(ped, status)
    if status then
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityVisible(ped, false, false)
    else
        SetEntityInvincible(ped, false)
        FreezeEntityPosition(ped, false)
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, true)
    end
end

local INPUT_SPRINT = 21
local INPUT_CHARACTER_WHEEL = 19
local INPUT_LOOK_LR = 1
local INPUT_LOOK_UD = 2
local INPUT_COVER = 44
local INPUT_MULTIPLAYER_INFO = 20
local INPUT_MOVE_UD = 31
local INPUT_MOVE_LR = 30

--------------------------------------------------------------------------------

_internal_camera = nil
local _internal_isFrozen = false

local _internal_pos = nil
local _internal_rot = nil
local _internal_fov = nil
local _internal_vecX = nil
local _internal_vecY = nil
local _internal_vecZ = nil

--------------------------------------------------------------------------------

local settings = {
    --Camera
    fov = 45.0,
    -- Mouse
    mouseSensitivityX = 5,
    mouseSensitivityY = 5,
    -- Movement
    normalMoveMultiplier = 1,
    fastMoveMultiplier = 10,
    slowMoveMultiplier = 0.1,
    -- On enable/disable
    enableEasing = false,
    easingDuration = 1000
}

--------------------------------------------------------------------------------

local function IsFreecamFrozen()
    return _internal_isFrozen
end

local function SetFreecamFrozen(frozen)
    local frozen = frozen == true
    _internal_isFrozen = frozen
end

--------------------------------------------------------------------------------

local function GetFreecamPosition()
    return _internal_pos
end

local function SetFreecamPosition(x, y, z)
    local pos = vector3(x, y, z)
    SetCamCoord(_internal_camera, pos)

    _internal_pos = pos
end

--------------------------------------------------------------------------------

local function GetFreecamRotation()
    return _internal_rot
end

local function SetFreecamRotation(x, y, z)
    local x = Clamp(x, -90.0, 90.0)
    local y = y % 360
    local z = z % 360
    local rot = vector3(x, y, z)
    local vecX, vecY, vecZ = EulerToMatrix(x, y, z)

    LockMinimapAngle(math.floor(z))
    SetCamRot(_internal_camera, rot)

    _internal_rot = rot
    _internal_vecX = vecX
    _internal_vecY = vecY
    _internal_vecZ = vecZ
end

--------------------------------------------------------------------------------

local function GetFreecamFov()
    return _internal_fov
end

local function SetFreecamFov(fov)
    local fov = Clamp(fov, 0.0, 90.0)
    SetCamFov(_internal_camera, fov)
    _internal_fov = fov
end

--------------------------------------------------------------------------------

local function GetFreecamMatrix()
    return _internal_vecX, _internal_vecY, _internal_vecZ, _internal_pos
end

local function GetFreecamTarget(distance)
    local target = _internal_pos + (_internal_vecY * distance)
    return target
end

--------------------------------------------------------------------------------

local function IsFreecamEnabled()
    return IsCamActive(_internal_camera) == 1
end

local controls = {12, 13, 14, 15, 16, 17, 18, 19, 50, 85, 96, 97, 99, 115, 180, 181, 198, 261, 262}
local function LockControls()
    for k, v in pairs(controls) do
        DisableControlAction(0, v, true)
    end
    EnableControlAction(0, 166, true)
end

local function SetFreecamEnabled(enable)
    if enable == IsFreecamEnabled() then
        return
    end

    if enable then
        local pos = GetGameplayCamCoord()
        local rot = GetGameplayCamRot()

        _internal_camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        SetFreecamFov(settings.fov)
        SetFreecamPosition(pos.x, pos.y, pos.z)
        SetFreecamRotation(rot.x, rot.y, rot.z)
    else
        DestroyCam(_internal_camera)
        ClearFocus()
        UnlockMinimapPosition()
        UnlockMinimapAngle()
    end
    --SetPlayerControl(PlayerId(), not enable)
    RenderScriptCams(enable, settings.enableEasing, settings.easingDuration)
end

--------------------------------------------------------------------------------

function IsEnabled()
    return IsFreecamEnabled()
end
function SetEnabled(enable)
    return SetFreecamEnabled(enable)
end
function IsFrozen()
    return IsFreecamFrozen()
end
function SetFrozen(frozen)
    return SetFreecamFrozen(frozen)
end
function GetFov()
    return GetFreecamFov()
end
function SetFov(fov)
    return SetFreecamFov(fov)
end
function GetTarget(distance)
    return {table.unpack(GetFreecamTarget(distance))}
end
function GetPosition()
    return {table.unpack(GetFreecamPosition())}
end
function SetPosition(x, y, z)
    return SetFreecamPosition(x, y, z)
end
function GetRotation()
    return {table.unpack(GetFreecamRotation())}
end
function SetRotation(x, y, z)
    return SetFreecamRotation(x, y, z)
end
function GetPitch()
    return GetFreecamRotation().x
end
function GetRoll()
    return GetFreecamRotation().y
end
function GetYaw()
    return GetFreecamRotation().z
end

--------------------------------------------------------------------------------
function GetSpeedMultiplier()
    if IsDisabledControlPressed(0, 180) then
        if settings.normalMoveMultiplier > 1.0 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.5
        elseif settings.normalMoveMultiplier > 0.2 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.1
        else
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.01
        end
    elseif IsDisabledControlPressed(0, 181) then
        if settings.normalMoveMultiplier < 0.2 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.01
        elseif settings.normalMoveMultiplier > 1.0 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.5
        else
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.1
        end
    end

    if settings.normalMoveMultiplier < 0 then
        settings.normalMoveMultiplier = 0
    end

    return settings.normalMoveMultiplier
end

function CameraLoop()
    if not IsFreecamEnabled() or IsPauseMenuActive() then
        return
    end
    if not IsFreecamFrozen() then
        local vecX, vecY = GetFreecamMatrix()
        local vecZ = vector3(0, 0, 1)
        local pos = GetFreecamPosition()
        local rot = GetFreecamRotation()
        -- Get speed multiplier for movement
        local frameMultiplier = GetFrameTime() * 60
        local speedMultiplier = GetSpeedMultiplier() * frameMultiplier
        -- Get mouse input
        local mouseX = GetDisabledControlNormal(0, INPUT_LOOK_LR)
        local mouseY = GetDisabledControlNormal(0, INPUT_LOOK_UD)
        -- Get keyboard input
        local moveWS = GetDisabledControlNormal(0, INPUT_MOVE_UD)
        local moveAD = GetDisabledControlNormal(0, INPUT_MOVE_LR)
        local moveQZ = GetDisabledControlNormalBetween(0, INPUT_COVER, INPUT_MULTIPLAYER_INFO)
        -- Calculate new rotation.
        local rotX = rot.x + (-mouseY * settings.mouseSensitivityY)
        local rotZ = rot.z + (-mouseX * settings.mouseSensitivityX)
        local rotY = 0.0
        -- Adjust position relative to camera rotation.
        pos = pos + (vecX * moveAD * speedMultiplier)
        pos = pos + (vecY * -moveWS * speedMultiplier)
        pos = pos + (vecZ * moveQZ * speedMultiplier)

        if #(pos - GetEntityCoords(GetPlayerPed(-1))) > 20.0 then
            pos = GetEntityCoords(GetPlayerPed(-1))
        end

        -- Adjust new rotation
        rot = vector3(rotX, rotY, rotZ)
        -- Update camera
        SetFreecamPosition(pos.x, pos.y, pos.z)
        SetFreecamRotation(rot.x, rot.y, rot.z)

        LockControls()
        SetEntityCoordsNoOffset(GetPlayerPed(-1), pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
    end
end

function Clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

function GetDisabledControlNormalBetween(inputGroup, control1, control2)
    local normal1 = GetDisabledControlNormal(inputGroup, control1)
    local normal2 = GetDisabledControlNormal(inputGroup, control2)
    return normal1 - normal2
end

function EulerToMatrix(rotX, rotY, rotZ)
    local radX = math.rad(rotX)
    local radY = math.rad(rotY)
    local radZ = math.rad(rotZ)

    local sinX = math.sin(radX)
    local sinY = math.sin(radY)
    local sinZ = math.sin(radZ)
    local cosX = math.cos(radX)
    local cosY = math.cos(radY)
    local cosZ = math.cos(radZ)

    local vecX = {}
    local vecY = {}
    local vecZ = {}

    vecX.x = cosY * cosZ
    vecX.y = cosY * sinZ
    vecX.z = -sinY

    vecY.x = cosZ * sinX * sinY - cosX * sinZ
    vecY.y = cosX * cosZ - sinX * sinY * sinZ
    vecY.z = cosY * sinX

    vecZ.x = -cosX * cosZ * sinY + sinX * sinZ
    vecZ.y = -cosZ * sinX + cosX * sinY * sinZ
    vecZ.z = cosX * cosY

    vecX = vector3(vecX.x, vecX.y, vecX.z)
    vecY = vector3(vecY.x, vecY.y, vecY.z)
    vecZ = vector3(vecZ.x, vecZ.y, vecZ.z)

    return vecX, vecY, vecZ
end
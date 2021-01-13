player = {
    cars = {},
    money = 0,
    driftPoint = 0,
    sessionDriftPoint = 0,
    passive = false,
    succes = {}
}

p = nil ---@type player

function player:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.cars = {}
    obj.money = 0
    obj.driftPoint = 0
    obj.sessionDriftPoint = 0
    obj.passive = false

    p = obj
end

function player:getSessionDrift()
    return self.sessionDriftPoint
end

function player:GetCars()
    return self.cars
end

function player:GetSucces()
    return self.succes
end

function player:SetSucces(value)
    if self.succes[value] == nil then
        self.succes[value] = 0
    end
    self.succes[value] = self.succes[value] + 1
    TriggerServerEvent("driftV:SetPlayerArchivement", self.succes)
end

function player:InitSucces(value)
    self.succes = value
end

function player:SetCars(cars)
    self.cars = cars
end

function player:SetMoney(money)
    self.money = money
end

function player:SetDriftPoint(point)
    self.driftPoint = point
end

function player:GetMoney()
    return self.money
end

function player:GetDrift()
    return self.driftPoint
end

function player:ped()
    return PlayerPedId()
end

function player:pos()
    return GetEntityCoords(self:ped())
end

function player:heading()
    return GetEntityHeading(self:ped())
end

function player:isInVeh()
    if IsPedInAnyVehicle(self:ped(), false) then
        return true
    else
        return false
    end
end

function player:currentVeh()
    return GetVehiclePedIsIn(self:ped(), false)
end

function player:SubmitDriftScore(score)
    self.sessionDriftPoint = self.sessionDriftPoint + score
    TriggerServerEvent("driftV:SubmitDriftPoint", score)
    XNL_AddPlayerXP(math.floor(score / 150))
end

function player:speed()
    return GetEntitySpeed(self:ped()) * 3.6
end

function player:Teleport(pos)
    local veh = p:currentVeh()
    if not IsPlayerSwitchInProgress() then
        SwitchOutPlayer(self:ped(), 0, 1)
    end

    while GetPlayerSwitchState() ~= 5 do
        Citizen.Wait(0)
        ClearScreen()
    end
    

    ClearScreen()
    Citizen.Wait(0)
    DoScreenFadeOut(0)

    ClearScreen()
    Citizen.Wait(0)
    ClearScreen()

    

    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do
        Citizen.Wait(0)
        ClearScreen()
    end

    local timer = GetGameTimer()
    

    SetPedCoordsKeepVehicle(p:ped(), pos.xyz)
    FreezeEntityPosition(p:ped(), true)

    local sceneLoadTimer = GetGameTimer()
    while not IsNewLoadSceneLoaded() do
        if GetGameTimer() - sceneLoadTimer > 2000 then
            break
        end
        SetPedCoordsKeepVehicle(p:ped(), pos.xyz)
        DrawDriftV()
        Citizen.Wait(0)
    end

    sceneLoadTimer = GetGameTimer()

    while not HasCollisionLoadedAroundEntity(p:ped()) do
        if GetGameTimer() - sceneLoadTimer > 2000 then
            break
        end
        SetPedCoordsKeepVehicle(p:ped(), pos.xyz)
        DrawDriftV()
        Citizen.Wait(0)
    end

    SetPedCoordsKeepVehicle(p:ped(), pos.xyz)
    NewLoadSceneStop()
    
    
    while true do
        ClearScreen()
        Citizen.Wait(0)
        
        -- wait 5 seconds before starting the switch to the player
        if GetGameTimer() - timer > 500 then
            
            -- Switch to the player.
            SwitchInPlayer(self:ped())
            
            ClearScreen()
            DrawDriftV()
            
            -- Wait for the player switch to be completed (state 12).
            while GetPlayerSwitchState() ~= 12 do
                Wait(1)

                SetPedCoordsKeepVehicle(p:ped(), pos.xyz)
                if GetPlayerSwitchState() < 9 then
                    DrawDriftV()
                end

                ClearScreen()
            end
            -- Stop the infinite loop.
            break
        end
        DrawDriftV()
    end
    
    -- Reset the draw origin, just in case (allowing HUD elements to re-appear correctly)
    ClearDrawOrigin()
    SetPedCoordsKeepVehicle(p:ped(), pos.xyz)
    TaskWarpPedIntoVehicle(p:ped(), veh, -1)
    FreezeEntityPosition(p:ped(), false)
    
end

function player:isPassive()
    return self.passive
end

function player:setPassive(status)
    self.passive = status
end
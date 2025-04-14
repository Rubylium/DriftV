player = {
    cars = {},
    money = 0,
    driftPoint = 0,
    sessionDriftPoint = 0,
    exp = 0,
    level = 0,
    passive = false,
    inGarage = false,
    actualMap = "LS",
    actualTime = "day",
    succes = {},
    crew = "None",
    crewOwner = false,
    inCrewWar = false,
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
    obj.inGarage = false
    obj.exp = 0
    obj.level = 0
    obj.crew = "None"
    obj.crewOwner = false
    obj.inCrewWar = false
    p = obj
end

function player:setInstance(instance)
    TriggerServerEvent("drift:ChangeServerInstance", instance)
end

function player:GetCrewWarStatus()
    return self.inCrewWar
end

function player:setCrewWarStatus(status)
    self.inCrewWar = status
end

function player:setCrew(crew)
    self.crew = crew
end

function player:getCrew()
    return self.crew
end

function player:setCrewOwner(status)
    self.crewOwner = status
end

function player:isPlayerCrewOwner()
    return self.crewOwner
end

function player:setLevel(level)
    self.level = level
end

function player:getLevel()
    return self.level
end

function player:setExp(exp)
    self.exp = exp
    self.level = GetPlayerLevelFromXp(self.exp)
end

function player:getExp()
    return self.exp
end

function player:addExp(exp)
    local oldXp = self.exp
    self.exp = self.exp + exp
    local oldLevel = GetPlayerLevelFromXp(oldXp)
    local newLevel = GetPlayerLevelFromXp(self.exp)

    if oldLevel ~= newLevel then
        -- Level up 
    end

    DisplayRankBar(oldXp, self.exp, oldLevel, newLevel, false)

    self.level = GetPlayerLevelFromXp(self.exp)
    TriggerServerEvent(Events.SetExp, self.exp)
end

function player:removeExp(exp)
    local oldXp = self.exp
    self.exp = self.exp - exp
    local oldLevel = GetPlayerLevelFromXp(oldXp)
    local newLevel = GetPlayerLevelFromXp(self.exp)
    if self.exp < 0 then
        self.exp = 0
    end

    DisplayRankBar(oldXp, self.exp, oldLevel, newLevel, true)

    self.level = GetPlayerLevelFromXp(self.exp)
    TriggerServerEvent(Events.SetExp, self.exp)
end

function player:setInGarage(status)
    self.inGarage = status
end

function player:IsInGarage()
    return self.inGarage
end

function player:setTime(time)
    self.actualTime = time
end

function player:getTime()
    return self.actualTime
end

function player:GetMap()
    return self.actualMap
end

function player:SetMap(map)
    self.actualMap = map
end

function player:index()
    return GetPlayerIndex()
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
    TriggerServerEvent(Events.setArchivment, self.succes)
end

function player:InitSucces(value)
    self.succes = value
end

function player:SetCars(cars)
    self.cars = cars
end

function player:SetCarProps(car, props)
    for k,v in pairs(self.cars) do
        print(v.model, car)
        print(v.model == car)
        if v.model == car then
            v.props = props
            break
        end
    end
    TriggerServerEvent(Events.refreshCars, self.cars)
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

function player:Pay(price)
    TriggerServerEvent(Events.pay, price)
end

function player:HaveEnoughMoney(price)
    if self.money >= price then
        return true
    else
        return false
    end
end

function player:GetDrift()
    return self.driftPoint
end

function player:sDriftPoint()
    return self.sessionDriftPoint
end

function player:PlayerCrew()
    return self.crew
end

function  player:vehDriftPoints()
    return self.vStats
end

function player:BoughtVeh()
    return self.buyVeh
end


function player:currentLevel()
    return self.level
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

function player:SubmitDriftScore(score, multi)
    self.sessionDriftPoint = self.sessionDriftPoint + score
    TriggerServerEvent(Events.setDriftPoint, score)
    p:addExp(math.floor(score / 10))
end

function player:GiveMoney(money)
    TriggerServerEvent(Events.addMoney, money)
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

function player:PlayAnim(dict, anim, flag)
    if dict ~= "" then
        RequestAnimDict(dict)
        print("requesting anim dict "..dict)
        while not HasAnimDictLoaded(dict) do Wait(1) end
        print("Start anim")
        TaskPlayAnim(self:ped(), dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
    end
end

function player:PlayAnimOnPed(ped, dict, anim, flag)
    if dict ~= "" then
        RequestAnimDict(dict)
        print("requesting anim dict "..dict)
        while not HasAnimDictLoaded(dict) do Wait(1) end
        print("Start anim")
        TaskPlayAnim(ped, dict, anim, 2.0, 2.0, -1, flag, 0, false, false, false)
    end
end

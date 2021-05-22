entity = {
    id = 0,
    netId = 0,
}

---@return entity
function entity:register(entity)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.id = entity
    obj.netId = NetworkGetNetworkIdFromEntity(entity)

    return obj
end

---@return entity
function entity:CreateVehicle(model, pos, heading)
    LoadModel(model)
    local entity = CreateVehicle(GetHashKey(model), pos.xyz, heading, true, false)
    SetEntityAsMissionEntity(entity, 1, 1)
    
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.id = entity
    obj.netId = NetworkGetNetworkIdFromEntity(entity)

    return obj
end

---@return entity
function entity:CreateVehicleLocal(model, pos, heading)
    LoadModel(model)
    local entity = CreateVehicle(GetHashKey(model), pos.xyz, heading, false, false)
    SetEntityAsMissionEntity(entity, 1, 1)
    
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.id = entity
    obj.netId = 0

    return obj
end

---@return entity
function entity:CreateObject(model, pos, heading)
    LoadModel(model)
    local entity = CreateObject(GetHashKey(model), pos.xyz, true, false, true)
    SetEntityAsMissionEntity(entity, 1, 1)
    
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.id = entity
    obj.netId = NetworkGetNetworkIdFromEntity(entity)

    return obj
end

---@return entity
function entity:CreateObjectLocal(model, pos, heading)
    LoadModel(model)
    local entity = CreateObject(GetHashKey(model), pos.xyz, false, false, true)
    SetEntityAsMissionEntity(entity, 1, 1)
    
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.id = entity
    obj.netId = NetworkGetNetworkIdFromEntity(entity)

    return obj
end

---@return entity
function entity:CreatePed(model, pos, heading)
    LoadModel(model)
    local entity = CreatePed(1, GetHashKey(model), pos.xyz, heading, true, false)
    SetEntityAsMissionEntity(entity, 1, 1)
    
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.id = entity
    obj.netId = NetworkGetNetworkIdFromEntity(entity)

    return obj
end


---@return entity
function entity:CreatePedLocal(model, pos, heading)
    LoadModel(model)
    local entity = CreatePed(1, GetHashKey(model), pos.xyz, heading, true, false)
    SetEntityAsMissionEntity(entity, 1, 1)
    
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.id = entity
    obj.netId = NetworkGetNetworkIdFromEntity(entity)

    return obj
end

function entity:getEntityId()
    return self.id
end

function entity:getModel()
    return GetEntityModel(self.id)
end

function entity:getHealth()
    return GetEntityHealth(self.id)
end

function entity:getPos()
    return GetEntityCoords(self.id)
end

function entity:getHeading()
    return GetEntityHeading(self.id) 
end

function entity:getNetId()
    return self.netId
end

function entity:getOwner()
    return NetworkGetEntityOwner(self.id) -- Should return player index, need test
end

function entity:isNetworked()
    if NetworkRegisterEntityAsNetworked(self.id) then
        return true
    else
        return false
    end
end

function entity:setPos(pos)
    SetEntityCoordsNoOffset(self.id, pos.xuz, 0.0, 0.0, 0.0)
end

function entity:setHeading(heading)
    SetEntityHeading(self.id, heading)
end

function entity:setFreeze(status)
    FreezeEntityPosition(self.id, status)
end

function entity:delete()
    if self:isNetworked() then
        TriggerServerEvent("DeleteEntity", {self.netId})
    else
        DeleteEntity(self.id)
    end
end
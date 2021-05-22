-- "simulation" d'une class car Lua n'a pas vraiment de class, c'est juste pratique de faire ça
cam = {
    cams = {},

    create = function(name)
        local c = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        cam.cams[name] = c 
    end,

    delete = function(name)
        if cam.cams[name] ~= nil then
            RenderScriptCams(0, 0, 0, 0, 1)
            SetCamActive(cam.cams[name], false)
            DestroyCam(cam.cams[name], false)
            ClearFocus()
            cam.cams[name] = nil
        else
            print("^2WARNING: ^7La cam "..name.." n'éxiste pas !")
        end
    end,    

    setActive = function(name, bool)
        if cam.cams[name] ~= nil then
            SetCamActive(cam.cams[name], bool)
        else
            print("^2WARNING: ^7La cam "..name.." n'éxiste pas !")
        end
    end,

    setPos = function(name, pos)
        if cam.cams[name] ~= nil then
            SetFocusPosAndVel(pos.xyz, 0.0, 0.0, 0.0)
            SetCamCoord(cam.cams[name], pos.xyz)
        else
            print("^2WARNING: ^7La cam "..name.." n'éxiste pas !")
        end
    end,    

    setFov = function(name, fov)
        if cam.cams[name] ~= nil then
            SetCamFov(cam.cams[name], fov)
        else
            print("^2WARNING: ^7La cam "..name.." n'éxiste pas !")
        end
    end,

    lookAtCoords = function(name, pos)
        if cam.cams[name] ~= nil then
            PointCamAtCoord(cam.cams[name], pos.xyz)
        else
            print("^2WARNING: ^7La cam "..name.." n'éxiste pas !")
        end
    end,

    attachToEntity = function(name, entity, xOffset, yOffset, zOffset, isRelative)
        if cam.cams[name] ~= nil then
            AttachCamToEntity(cam.cams[name], entity, xOffset, yOffset, zOffset, isRelative)
        else
            print("^2WARNING: ^7La cam "..name.." n'éxiste pas !")
        end
    end,

    attachToVehicleBone = function(name, vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX, offY, offZ, fixedDirection)
        if cam.cams[name] ~= nil then
            AttachCamToVehicleBone(cam.cams[name], vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX, offY, offZ, fixedDirection)
        else
            print("^2WARNING: ^7La cam "..name.." n'éxiste pas !")
        end
    end,

    render = function(name, render, animation, time)
        if cam.cams[name] ~= nil then
            SetCamActive(cam.cams[name], true)
            RenderScriptCams(render, animation, time, 1, 1)
        else
            print("^2WARNING: ^7La cam "..name.." n'éxiste pas !")
        end
    end,

    switchToCam = function(name, newName, time)
        if cam.cams[name] ~= nil then
            if cam.cams[newName] ~= nil then
                SetCamActiveWithInterp(cam.cams[name], cam.cams[newName], time, 1, 1)
            end
        end
    end,

    rotation = function(name, rotX, rotY, rotZ)
        if cam.cams[name] ~= nil then
            SetCamRot(cam.cams[name], rotX, rotY, rotZ, 2)
        end
    end,
    
}

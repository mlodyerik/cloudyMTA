local main = {
    shaders = {},
    avatars = {},
    base64 = {},
    waiting = {},

    ['textures'] = {
        ['mask'] = dxCreateTexture('data/images/mask.png'),
        ['noavatar'] = dxCreateTexture('data/images/avatar.png'),
    }
}

local main2 = {
    shaders = {},
    avatars = {},
    waiting = {},

    ['textures'] = {
        ['mask'] = dxCreateTexture('data/images/mask2.png'),
        ['noavatar'] = dxCreateTexture('data/images/avatar.png'),
    }
}

local main3 = {
    shaders = nil,
    avatars = {},
    waiting = {},

    ['textures'] = {
        ['mask'] = dxCreateTexture('data/images/mask2.png'),
        ['noavatar'] = dxCreateTexture('data/images/avatar.png'),
    }
}

function deleteUnusedAvatars()
    for i,v in pairs(main.avatars) do
        if not isElement(v) then
            main.avatars[i] = nil
        end
    end

    for i,v in pairs(main2.avatars) do
        if not isElement(v) then
            main2.avatars[i] = nil
        end
    end
end
deleteUnusedAvatars()
setTimer(deleteUnusedAvatars, 10000, 0)

function getPlayerAvatar(c, mask)
    if not mask then mask = main['textures']['mask'] end

    local uid = tonumber(c)
    if not uid then return end

    if main.shaders[uid] then
        return main.shaders[uid]
    end

    if not main.waiting[uid] then
        main.waiting[uid] = true
        triggerServerEvent('fetchAvatar', resourceRoot, uid)
    end

    if not main.shaders[uid] then
        main.shaders[uid] = dxCreateShader("data/fx/mask.fx")
        dxSetShaderValue(main.shaders[uid], "sPicTexture", main['textures']['noavatar']) 
        dxSetShaderValue(main.shaders[uid], 'gUVScale', 1, 1)
        dxSetShaderValue(main.shaders[uid], "sMaskTexture", mask)
    end

    return main.shaders[uid]
end

function getPlayerAvatarTexture(c)
    if not mask then mask = main['textures']['mask'] end

    local uid = tonumber(c)
    if not uid then 
        return false
    end

    if main.base64[uid] then
        return main.base64[uid]
    end

    return false
end

function getPlayerCircleAvatar(c, mask)
    if not mask2 then mask2 = main2['textures']['mask'] end

    local uid = tonumber(c)
    if not uid then return end

    
    if main2.shaders[uid] then
        return main2.shaders[uid]
    end

    if not main2.waiting[uid] then
        main2.waiting[uid] = true
        triggerServerEvent('fetchCircleAvatar', resourceRoot, uid)
    end

    if not main2.shaders[uid] then
        main2.shaders[uid] = dxCreateShader("data/fx/mask.fx")
        dxSetShaderValue(main2.shaders[uid], "sPicTexture", main2['textures']['noavatar']) 
        dxSetShaderValue(main2.shaders[uid], 'gUVScale', 1, 1)
        dxSetShaderValue(main2.shaders[uid], "sMaskTexture", mask2)
    end

    return main2.shaders[uid]
end

function drawNoAvatar()
    if not maskNoAv then maskNoAv = main2['textures']['mask'] end
    
    if main3.shaders then
        return main3.shaders
    end

    if not main3.shaders then
        main3.shaders = dxCreateShader("data/fx/mask.fx")
        dxSetShaderValue(main3.shaders, "sPicTexture", main3['textures']['noavatar']) 
        dxSetShaderValue(main3.shaders, 'gUVScale', 1, 1)
        dxSetShaderValue(main3.shaders, "sMaskTexture", maskNoAv)
    end

    return main3.shaders
end

addEvent('returnAvatars',true)
addEventHandler('returnAvatars',resourceRoot,function(avatar, uid)
    uid = tonumber(uid)
    
    if main.avatars[uid] and isElement(main.avatars[uid]) then
        destroyElement(main.avatars[uid])
    end

    if avatar then
        main.avatars[uid] = dxCreateTexture(avatar)
        main.base64[uid] = base64Encode(avatar)
        dxSetShaderValue(main.shaders[uid], "sPicTexture", main.avatars[uid])
    end
end)

addEvent('returnCircleAvatars',true)
addEventHandler('returnCircleAvatars',resourceRoot,function(avatar, uid)
    uid = tonumber(uid)
    
    if main2.avatars[uid] and isElement(main2.avatars[uid]) then
        destroyElement(main2.avatars[uid])
    end

    if avatar then
        main2.avatars[uid] = dxCreateTexture(avatar)
        dxSetShaderValue(main2.shaders[uid], "sPicTexture", main2.avatars[uid])
    end
end)

getResourceName(getThisResource(), true, 961356585); if true then return end
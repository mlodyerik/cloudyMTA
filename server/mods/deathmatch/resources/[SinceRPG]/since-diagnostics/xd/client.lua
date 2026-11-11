local function render() 
    dxDrawMaterialLine3D(1962.08, -2325.92, 14.5, 1962.08, -2325.92, 12.5, RT, 4, white, false, 1962.2, -2325.92, 14.5) 
end

local function refresh()
    dxSetRenderTarget(RT)
    if (not tunings) then
        dxDrawImage(0, 0, 900, 400, textures[2])
        dxDrawText("STACJA #ff8c00DIAGNOSTYCZNA", 450, 25, center, center, white, 1, fonts[1], "center", "center", _, _, _, true)
        dxDrawLine(200, 40, 700, 40, white, 2)
        dxDrawText("#ff8c00Nie wkyryto pojazdu", 450, 200, center, center, white, 1, fonts[1], "center", "center", _, _, _, true)
    elseif (tunings == "max") then
        dxDrawImage(0, 0, 900, 400, textures[2])
        dxDrawText("STACJA #ff8c00DIAGNOSTYCZNA", 450, 25, center, center, white, 1, fonts[1], "center", "center", _, _, _, true)
        dxDrawLine(200, 40, 700, 40, white, 2)
        dxDrawText("#ff8c00Wykryto zbyt wiele pojazdów", 450, 200, center, center, white, 1, fonts[1], "center", "center", _, _, _, true)
    elseif (tunings == "not") then
        dxDrawImage(0, 0, 900, 400, textures[2])
        dxDrawText("STACJA #ff8c00DIAGNOSTYCZNA", 450, 25, center, center, white, 1, fonts[1], "center", "center", _, _, _, true)
        dxDrawLine(200, 40, 700, 40, white, 2)
        dxDrawText("#ff8c00Ten pojazd nie jest obsługiwany", 450, 200, center, center, white, 1, fonts[1], "center", "center", _, _, _, true)
    elseif (tunings) then
        dxDrawImage(0, 0, 900, 400, textures[1])

        dxDrawText("STACJA #ff8c00DIAGNOSTYCZNA", 450, 25, center, center, white, 1, fonts[1], "center", "center", _, _, _, true)
        dxDrawLine(200, 40, 700, 40, white, 2)
        dxDrawText(tunings.name.."(ID "..tunings.id..")", 450, 65, center, center, white, 1, fonts[2], "center", "center")

        local x, y = 0, 0
        for i=1,18 do
            local v = tunings[i]
            if not tunings[i] then
                return
            end
            if (i==7 or i==13) then
                x = x + 289
                y = y + 282
            end
            dxDrawText(v[1]..":", 30 + x, 125 + ((i-1)*47) - y, left, center, white, 1, fonts[3], "left", "center", false, false, false, true)
            local str = v[2] == "NIE" and "#ff0000NIE" or v[2] == "TAK" and "#00ff00TAK" or "#ff8c00"..v[2]
            dxDrawText(str, 285 + x, 125 + ((i-1)*47) - y, right, center, white, 1, fonts[3], "right", "center", false, false, false, true)
        end
    end
    dxSetRenderTarget()
end

addEvent("enonek-diagnostics:updateRT", true)
addEventHandler("enonek-diagnostics:updateRT", resourceRoot, function(tune)
    tunings = tune
    if (RT) then
        refresh()
    end
end)

local object = createObject(1339, 1962.08, -2325.92, 12.5)
setElementFrozen(object, true)
setElementAlpha(object, 0)
setElementCollisionsEnabled(object, false)

local function streamIn()
    RT = dxCreateRenderTarget(900, 400, true)
    textures = {
        [1] = dxCreateTexture("assets/bg.png", "argb", false, "wrap"),
        [2] = dxCreateTexture("assets/bg2.png", "argb", false, "wrap"),
        [3] = dxCreateTexture("assets/car.png", "argb", false, "wrap"),
    }
    fonts = {
        [1] = exports['since-fonts']:getFont('Inter-SemiBold', 30),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 25),
        [3] = exports['since-fonts']:getFont('Inter-Medium', 25)
    }
    refresh()
    if (not isEventHandlerAdded("onClientRender", root, render)) then
        addEventHandler("onClientRender", root, render)
        addEventHandler("onClientRestore", root, refresh)
    end
    if (not triggeredValue) then
        triggerServerEvent("enonek-diagnostics:getData", resourceRoot)
        triggeredValue = true
    end
end

local function streamOut()
    removeEventHandler("onClientRender", root, render)
    removeEventHandler("onClientRestore", root, refresh)
    destroyElement(RT)
    for i,v in ipairs(textures) do
        destroyElement(v)
    end
    textures, fonts, RT = nil, nil, nil
    collectgarbage()
end
addEventHandler("onClientElementStreamIn", resourceRoot, streamIn)
addEventHandler("onClientElementStreamOut", resourceRoot, streamOut)
setTimer(function()
    if (isElementStreamedIn(object)) then
        streamIn()
    end
end, 150, 1)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end
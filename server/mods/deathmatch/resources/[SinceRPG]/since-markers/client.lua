local circle = dxCreateTexture("data/circle1.png")
local circle2 = dxCreateTexture("data/circle2.png")
local circleshadow = dxCreateTexture("data/circleshadow.png")

local targets = {}
local tick = getTickCount()
local rotX, rotY = {}, {}

function createTextTarget(marker)
    if not isElement(marker) then
        if targets[marker] then
            destroyElement(targets[marker])
            targets[marker] = nil
        end
        return
    end

    if targets[marker] and not tonumber(targets[marker]) and isElement(targets[marker]) then return end
    targets[marker] = dxCreateRenderTarget(512, 512, true)
    dxSetRenderTarget(targets[marker])

    local title = getElementData(marker, "marker:title") or " "
    local icon = getElementData(marker, "marker:icon")
    local desc = getElementData(marker, "marker:desc") or " "
    local r, g, b = getMarkerColor(marker)

    if icon then
        if fileExists("data/"..icon..".png") then
            dxDrawImage(256/2, 145, 256, 256, "data/" .. icon .. ".png", 0, 0, 0, tocolor(r, g, b, 255))
        else
            dxDrawImage(256/2, 145, 256, 256, "data/default.png", 0, 0, 0, tocolor(r, g, b, 255))
        end
    end

    dxDrawText(title, 256, 420, nil, nil, tocolor(r, g, b, 255), 1, font1, "center", "bottom", false, false, false, true)
    dxDrawText(desc, 256, 420, nil, nil, tocolor(225, 225, 225, 255), 1, font2, "center", "top", false, false, false, true)
    dxSetRenderTarget()
end

local rotation = 0
local rotation2 = 0
local rotation3 = 0

function isMarkerOnScreen(element)
    local x, y, z = getElementPosition(element)
    local x2, y2, z2 = getElementPosition(localPlayer)
    local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
    local sx, sy = getScreenFromWorldPosition(x, y, z + 1.5)
    return sx and sy and distance < 50
end

function renderMarkers(table)
    for k,v in pairs(table) do
        if not isMarkerOnScreen(v) and targets[v] then
            destroyElement(targets[v])
            targets[v] = nil
        end
        
        if isMarkerOnScreen(v) and (getElementDimension(v) == -1 or getElementDimension(v) == getElementDimension(localPlayer)) and getElementInterior(v) == getElementInterior(localPlayer) and getMarkerType(v) == "cylinder" then
            local r, g, b = getMarkerColor(v)
            setMarkerColor(v, r, g, b, 0)
            local size = getMarkerSize(v) / 2

            if not (getElementData(v,'marker:visible')) then
                createTextTarget(v)
                local x, y, z = getElementPosition(v)
                local z = z -0.15
                local x2, y2, z2 = getElementPosition(localPlayer)
                local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
                    
    
                if 50 >= distance then
                    gz = getGroundPosition(x, y, z + 1) + 0.02
                    z = interpolateBetween((z-0.2), 0, 0, (z-0.1), 0, 0, ( getTickCount() - tick ) / 2500, 'SineCurve' );
    
                    if targets[v] ~= 1 and tonumber(targets[v]) ~= 1 and isElement(targets[v]) then
                        dxDrawMaterialLine3D(x, y, z + 2.5, x, y, z + 1, targets[v], 1.6, white, false)

                        if not getElementData(v, 'marker:down') then
                            rotation = rotation + 0.005
                            rotation2 = rotation2 - 0.005
                            size = interpolateBetween(size, 0, 0, size - 0.1, 0, 0, ( getTickCount() - tick ) / 2500, 'SineCurve' )
                            rotX, rotY = math.cos(rotation) * size,  math.sin(rotation) * size
                            rotX2, rotY2 = math.cos(rotation2) * size,  math.sin(rotation2) * size
                            dxDrawMaterialLine3D(x + rotX2, y + rotY2, gz, x - rotX2, y - rotY2, gz, circleshadow, 2 * size, tocolor(r, g, b, 255), false, x, y, z + 1)
                            dxDrawMaterialLine3D(x + rotX, y + rotY, gz, x - rotX, y - rotY, gz, circle, 2 * size, tocolor(r, g, b, 125), false, x, y, z + 1)
                            dxDrawMaterialLine3D(x + rotX2, y + rotY2, gz, x - rotX2, y - rotY2, gz, circle2, -2 * size, tocolor(r, g, b, 125), false, x, y, z + 1)
                            
                            size = size / 1.8
                            rotation3 = rotation3 + 0.005
                            rotX2, rotY2 = math.cos(rotation3) * size,  math.sin(rotation3) * size
                            dxDrawMaterialLine3D(x + rotX2, y + rotY2, gz, x - rotX2, y - rotY2, gz, circle2, 2 * size, tocolor(r, g, b, 125), false, x, y, z + 1)
                        end
                    else
                        if targets[v] then
                            destroyElement(targets[v])
                            targets[v] = nil
                        end     
                        createTextTarget(v)       
                    end
                end
            end
        end
    end
end

addEventHandler("onClientRestore", root, function()
    for k,v in pairs(targets) do
        if isElement(targets[k]) then
            destroyElement(targets[k])
        end
        targets[k] = nil
    end
    targets = {}
end)

addEventHandler('onClientElementStreamOut', root, function()
    if getElementType(source) == "marker" then
        if targets[source] then
            if isElement(targets[source]) then
                destroyElement(targets[source])
            end
            targets[source] = nil
        end
    end
end)

addEventHandler("onClientRender", root, function()
    for k,v in pairs(targets) do
        if not isElement(k) then
            destroyElement(targets[k])
            targets[k] = nil
        end
    end

    local x, y, z = getElementPosition(localPlayer)
    local markers = getElementsWithinRange(x, y, z, 50, "marker")

    if #markers > 0 then
        renderMarkers(markers)
    end
end)
getResourceName(getThisResource(), true, 376573751); if true then return end
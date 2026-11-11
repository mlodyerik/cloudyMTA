local radar = {}
local radarX, radarY, radarW, radarH
local blipSize = 60/zoom
local customLocation = false
local lastGPS = ' '
local toggleCustomRadar = false
local radarSettings = {}
local updateTimer = nil

function getMapPositionFromWorld(x, y, w, h)
	return (x+3000)/6000*w, (3000-y)/6000*h
end

function changeCustomLocation(bool)
    customLocation = bool
end

function updateRadarTexture()
    if toggleCustomRadar then
        return
    end

	dxSetRenderTarget(radarSettings.renderTarget, true)

        dxDrawImage(0, 0, 1260, 1260, radar.mapTexture)

        for k,v in pairs(getElementsByType("radararea")) do
            local x, y = getElementPosition(v)
            local w, h = getRadarAreaSize(v)
            local dim = getElementDimension(v)
            local int = getElementInterior(v)

            if getElementDimension(localPlayer) == dim and getElementInterior(localPlayer) == int then
                local x, y = getMapPositionFromWorld(x, y, 1260, 1260)
                w, h = w * (1260/6000), h * (1260/6000)
                local r, g, b = getRadarAreaColor(v)
                dxDrawRectangle(x, y, w, -h, tocolor(r, g, b, 155))
            end
        end

        if GPS and GPS.road then
            if #GPS.road > 0 then
                for i = #GPS.road, 1, -1 do
                    if (GPS.road[i + 1] ~= nil) then
                        local x, y = getMapPositionFromWorld(GPS.road[i].posX, GPS.road[i].posY, 1260, 1260)
                        local ex, ey = getMapPositionFromWorld(GPS.road[i + 1].posX, GPS.road[i + 1].posY, 1260, 1260)
                        dxDrawLine(x, y, ex, ey, tocolor(255, 55, 55, 255), 4)
                    end
                end
            end
        end

	dxSetRenderTarget()
end

local tick = getTickCount()
local refreshRate = 10
local tickBlips = getTickCount()
local blipsRefreshRate = 2500

local renderRadarData = {

    isSpawned = false,
    isHudOFF = false,
    isHudToggled = false

}

function onDataChange(key, oldValue)
    if source == localPlayer then
        if key == 'player:spawn' then
            renderRadarData.isSpawned = getElementData(localPlayer, 'player:spawn')
        elseif key == 'player:hudof' then
            renderRadarData.isHudOFF = getElementData(localPlayer, 'player:hudof')
        elseif key == 'player:settings' then
            local settings = getElementData(localPlayer, 'player:settings') or {}
            renderRadarData.isHudToggled = settings['hideHUD']
        end
    end
end
addEventHandler('onClientElementDataChange', localPlayer, onDataChange)

blips = {}

function updateBlips()
    blips = {}

    local x, y, z = getElementPosition(localPlayer)
    local dimension = getElementDimension(localPlayer)
    local interior = getElementInterior(localPlayer)

    for k,v in pairs(getElementsByType('blip')) do
        local attached = getElementAttachedTo(v)

        if attached ~= localPlayer then
            if getElementDimension(v) == dimension and getElementInterior(v) == interior then
                local bx, by, bz = getElementPosition(v)
                local distance = getDistanceBetweenPoints3D(x, y, z, bx, by, bz)
                local visible = getBlipVisibleDistance(v)

                if distance <= visible + 200 then
                    table.insert(blips, v)
                end
            end
        end
    end
end

function renderRadar()
    if not renderRadarData.isSpawned or renderRadarData.isHudOFF then 
        return 
    end

    if renderRadarData.isHudToggled then
        return
    end

    if toggleCustomRadar then
        return
    end

    local px, py, pz = getElementPosition(localPlayer)

    local x = (px) / 6000
    local y = (py) / -6000

    if getTickCount() - tick > refreshRate then
        tick = getTickCount()
        dxSetShaderValue(radar.shader, "gUVPosition", x, y)
    end

    if getTickCount() - tickBlips > blipsRefreshRate then
        tickBlips = getTickCount()
        updateBlips()
    end
    
    local _, _, camrot = getElementRotation(getCamera())

    if GPS and GPS.road and #GPS.road ~= lastGPS then
		updateRadarTexture()
		lastGPS = #GPS.road
	end
    
    local radarX, radarY, radarW, radarH = 45/zoom, sy - radarSettings.size - 60/zoom, radarSettings.size, radarSettings.size
    dxDrawImage(radarX, radarY, radarW, radarH, data.textures[4], 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(radarX, radarY, radarW, radarH, radar.shader, camrot, 0, 0, tocolor(255, 255, 255, 255))
    -- dxDrawImage(radarX, radarY, radarW, radarH, data.textures[1], 0, 0, 0, tocolor(155, 155, 155, 70))
    dxDrawImage(radarX, radarY, radarW, radarH, data.textures[3], 0, 0, 0, tocolor(255, 255, 255, 255))

    local _, _, cz = getElementRotation(getCamera())
    local x, y, z = getElementPosition(localPlayer)

    for k,v in pairs(blips) do
        if isElement(v) and getElementAttachedTo(v) ~= localPlayer then
            if getElementDimension(localPlayer) == getElementDimension(v) and getElementInterior(localPlayer) == getElementInterior(v) then
                local bx, by, bz = getElementPosition(v)
                local distance = getDistanceBetweenPoints2D(x, y, bx, by)
                local blipIcon = getBlipIcon(v)
                local visible = getBlipVisibleDistance(v)
            
                if distance <= visible then
                    local dist = math.min(distance/zoom/1.44, radarW/2)
                    if (visible == 9999 and dist < radarW/2) or visible ~= 9999 then
                        local angle = findRotation(x, y, bx, by) - cz + 180
                        local x, y = getPointFromDistanceRotation(radarX + radarW/2, radarY + radarH/2, dist, angle)
                        
                        if blipIcon == 1 or blipIcon == 0 then
                            local r, g, b = getBlipColor(v)
                            clr = tocolor(r, g, b)
                            size = 42/zoom
                            dxDrawImage(x - size/2, y - (size*1.15)/2, size, size*1.15, 'radar/blips/'..blipIcon..'.png', 0, 0, 0, clr)
                        else
                            clr = tocolor(255, 255, 255)
                            size = blipSize
                            dxDrawImage(x - size/2, y - (size*1.15)/2, size, size*1.15, 'radar/blips/'..blipIcon..'.png', 0, 0, 0, clr)
                        end
                    end
                end
            end
        end
    end

    local px, py, pz = getElementPosition(localPlayer)
    local x, y, w, h = radarX + radarW/2 - 22/zoom, radarY + radarH/2 - 22/zoom, 44/zoom, 44/zoom
    local rx, ry, rz = getElementRotation(localPlayer)
    dxDrawImage(x, y, w, h, "radar/player.png", camrot - rz, 0, 0, tocolor(255, 255, 255, 255))
end

function minimize()
    removeEventHandler('onClientRender', root, renderRadar)
    updateRadarTexture()
end

function restore()
    addEventHandler('onClientRender', root, renderRadar)
    updateRadarTexture()
end

function destroyRadar()
    if isElement(radar.shader) then
        destroyElement(radar.shader)
    end

    if isElement(radar.shader2) then
        destroyElement(radar.shader2)
    end

    if isElement(radar.maskTexture) then
        destroyElement(radar.maskTexture)
    end

    if isElement(radar.mapTexture) then
        destroyElement(radar.mapTexture)
    end

    if (radarSettings.renderTarget) then
        destroyElement(radarSettings.renderTarget)
    end

    if isTimer(updateTimer) then
        killTimer(updateTimer)
    end

    radarSettings = {}
end
addEventHandler('onClientResourceStop', resourceRoot, destroyRadar)

function constructRadar()
    local settings = getElementData(localPlayer, 'player:settings') or {}

    if settings['showRadars'] then 
        return 
    end

    renderRadarData.isSpawned = getElementData(localPlayer, 'player:spawn')
    renderRadarData.isHudOFF = getElementData(localPlayer, 'player:hudof')
    renderRadarData.isHudToggled = settings['hideHUD']

    radarSettings = {

        ['size'] = 420/zoom,
        ['mapTextureSize'] = 1260,
        ['renderTarget'] = dxCreateRenderTarget(1260, 1260, true)
    
    }

    radar = {

        shader = dxCreateShader('hud_mask.fx'),
        shader2 = dxCreateShader('hud_mask.fx'),
        maskTexture = data.textures[1],
        mapTexture = data.textures[2],

    }

    if radar.shader then
        dxSetShaderValue(radar.shader, "sPicTexture", radarSettings.renderTarget)
        dxSetShaderValue(radar.shader, "sMaskTexture", radar.maskTexture)
        dxSetShaderValue(radar.shader, "gUVScale", 0.1, 0.1)
    end

    updateRadarTexture()
    updateBlips()
    updateTimer = setTimer(updateRadarTexture, 5000, 0)

    addEventHandler('onClientRender', root, renderRadar)
    addEventHandler('onClientMinimize', root, minimize)
    addEventHandler('onClientRestore', root, restore)
    showPlayerHudComponent('radar', false)
end

function switchCustomRadar(toggled)
    toggleCustomRadar = not toggled
    
    if toggled then
        loadTextures()

        setTimer(function()
            constructRadar()
        end, 500, 1)
    else
        showPlayerHudComponent('radar', true)
        destroyTextures()
        destroyRadar()
        removeEventHandler('onClientRender', root, renderRadar)
        removeEventHandler('onClientMinimize', root, minimize)
        removeEventHandler('onClientRestore', root, restore)
    end
end

addEventHandler('onClientResourceStart', resourceRoot, constructRadar)
getResourceName(getThisResource(), true, 832843409); if true then return end
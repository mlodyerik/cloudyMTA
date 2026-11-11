local cacheData = {}
cacheData.isInGreenzone = false
cacheData.greenZones = {}
cacheData.greenzoneAlpha = 0

local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

function startGreenZones()
    if cacheData.loaded then return end

    for i, v in ipairs(config.positions) do
        local data = {}
        local x,y,w,h = unpack(v.position)
        local dimension = v.dimension or 0
        local interior = v.interior or 0

        if v.type == 1 then
            data.radarArea = createRadarArea(x, y, w, h, 40, 230, 80, 55)
            data.col = createColRectangle(x, y, w, h)
        else
            data.radarArea = createRadarArea(x-w/2, y-h/2, w, h, 40, 230, 80, 55)
            data.col = createColRectangle(x-w/2, y-h/2, w, h)
        end

        setElementInterior(data.radarArea, interior)
        setElementDimension(data.radarArea, dimension)
        setElementInterior(data.col, interior)
        setElementDimension(data.col, dimension)
        setElementData(data.col, 'col:greenzone', i)
        cacheData.greenZones[i] = data
    end
    
    cacheData.loaded = true

    addEventHandler('onClientColShapeHit', resourceRoot, function(el)
        if el ~= localPlayer then return end
        if getElementData(source, 'col:greenzone') then
            cacheData.inGreenZone = getElementData(source, 'col:greenzone')
        end
    end)

    addEventHandler('onClientColShapeLeave', resourceRoot, function(el)
        if el ~= localPlayer then return end
        if getElementData(source, 'col:greenzone') then
            local find = nil
            local blockVeh = nil
            for i = 1, #cacheData.greenZones do
                if isElementWithinColShape(localPlayer, cacheData.greenZones[i].col) then
                    find = true
                end
            end
            if not find then
                cacheData.inGreenZone = nil
            end
        end
    end)
    
    addEventHandler('onClientRender', root, function()
        if not getElementData(localPlayer,'player:sid') then 
            return 
        end

        for i = 1, #cacheData.greenZones do
            if cacheData.inGreenZone and cacheData.inGreenZone == i then 
                if isElement(cacheData.greenZones[cacheData.inGreenZone].col) and isElementWithinColShape(localPlayer, cacheData.greenZones[cacheData.inGreenZone].col) then
                    if not getElementData(localPlayer, 'player:gz') then
                        setElementData(localPlayer, 'player:gz', true)
                    end
                end
            else
                if cacheData.inGreenZone == nil then
                    if getElementData(localPlayer, 'player:gz') then
                        setElementData(localPlayer, 'player:gz', nil)
                    end
                end
            end
        end

        if getElementData(localPlayer, 'player:gz') then
            cacheData.greenzoneAlpha = math.min(1, cacheData.greenzoneAlpha + 0.05)
        else
            cacheData.greenzoneAlpha = math.max(0, cacheData.greenzoneAlpha - 0.05)
        end

        dxDrawText('Greenzone', sx/2 + 1, 50/zoom + 1, nil, nil, tocolor(0, 0, 0, 155 * cacheData.greenzoneAlpha), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
        dxDrawText('Greenzone', sx/2, 50/zoom, nil, nil, tocolor(125, 255, 125, 255 * cacheData.greenzoneAlpha), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'bottom')
        dxDrawText('Znajdujesz się w bezpiecznej strefie', sx/2 + 1, 50/zoom + 1, nil, nil, tocolor(0, 0, 0, 155 * cacheData.greenzoneAlpha), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
        dxDrawText('Znajdujesz się w bezpiecznej strefie', sx/2, 50/zoom, nil, nil, tocolor(255, 255, 255, 255 * cacheData.greenzoneAlpha), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
    end)
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    for i,v in ipairs(getElementsByType('player')) do 
        if getElementData(v, 'player:gz') then
            setElementData(v, 'player:gz', nil)
        end
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    if getElementData(localPlayer, 'player:gang') then
        startGreenZones()
    end

    addEventHandler('onClientElementDataChange', localPlayer, function(k)
        if k == 'player:gang' then
            if getElementData(localPlayer, 'player:gang') then
                startGreenZones()
            end
        end
    end)
end)

sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 1.4

data = {

    sound = nil,
    area = nil,
    marker = nil,
    timer = 0,
    img = 'data/detector.png',

}

addEvent('artifactStart', true)
addEventHandler('artifactStart', resourceRoot, function()
    local id = math.random(1, #artifacts)

    createArtifact(id)
end)

function isPositionUnderground(x, y, z)
    local groundZ = getGroundPosition(x, y, z + 10)
    return groundZ and z > groundZ
end

function createArtifact(id)
    local w, h = unpack(artifacts[id].randomUnit)
    local randomUnit = math.random(w, h)
    local w, h = randomUnit, randomUnit

    local x, y = unpack(artifacts[id].area)
    local x, y = x - w/2, y - h/2
    
    data.area = createRadarArea(x, y, w, h, 125, 255, 125, 155)

    local randomPos = math.random(1, #artifacts[id].positions)
    local x, y, z = artifacts[id].positions[randomPos][1], artifacts[id].positions[randomPos][2], artifacts[id].positions[randomPos][3]

    data.marker = createMarker(x, y, z - 0.15, 'corona', 2, 255, 0, 0, 0)

    local x, y, z = getElementPosition(data.marker)
    --print(x, y, z)

    if isElementInWater(data.marker) then
        if isElement(data.area) then
            destroyElement(data.area)
            data.area = nil
        end

        if isElement(data.marker) then
            destroyElement(data.marker)
            data.area = nil
        end

        return createArtifact(id)
    end

    addEventHandler('onClientRender', root, renderDetector)

    addEventHandler('onClientMarkerHit', data.marker, function(element)
        if element ~= localPlayer then return end
        
        removeEventHandler('onClientRender', root, renderDetector)

        if data.sound then
            stopSound(data.sound)
            data.sound = nil
        end

        if isElement(data.area) then
            destroyElement(data.area)
            data.area = nil
        end

        if isElement(data.marker) then
            destroyElement(data.marker)
            data.marker = nil
        end


        local organization = getElementData(localPlayer, 'player:organization')

        if not organization then
            return
        end

        triggerServerEvent('artifactAddMoney', resourceRoot)
    end)
end

function convertDistanceToSpeed(object1, object2)
    local x1, y1, z1 = getElementPosition(object1)
    local x2, y2, z2 = getElementPosition(object2)

    local distance = getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) / 2
    local speedOfSound = 20
    local travelTime = distance / speedOfSound
    local soundSpeed = 0.5 / travelTime


    return math.min(soundSpeed, 5)
end

function isElementWithinRadarArea(element, area)
    local x, y, z = getElementPosition(element)
    local x1, y1, z1 = getElementPosition(area)
    local x2, y2, z2 = getRadarAreaSize(area)

    if x >= x1 and x <= x1 + x2 and y >= y1 and y <= y1 + y2 then
        return true
    end

    return false
end

function renderDetector()
    if not isElementWithinRadarArea(localPlayer, data.area) or getPedOccupiedVehicle(localPlayer) then
        return
    end

    local speed = convertDistanceToSpeed(localPlayer, data.marker)

    data.timer = data.timer + 0.5 * speed

    if data.timer >= 20 then
        data.timer = 0

        data.sound = playSound('data/beep.ogg')
        setSoundVolume(data.sound, 0.5)
        setSoundSpeed(data.sound, 0.9)
        
        data.img = 'data/detector_light.png'
    else
        data.img = 'data/detector.png'
    end

    dxDrawImage(sx - 245/zoom, sy - 600/zoom, 154/zoom, 488/zoom, data.img)
end

getResourceName(getThisResource(), true, 626375518); if true then return end
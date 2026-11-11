local resourcesChecksum = {}

local function getSyncObject()
    local objects = getElementsByType('object', resourceRoot)
    return objects[1]
end

local function getMyId()
    local syncObject = getSyncObject()
    if not syncObject then return end

    local id = 0
    while true do
        if getElementData(syncObject, 'id-' .. id) == localPlayer then
            break
        end

        id = id + 1

        if id > 1000 then
            return
        end
    end

    return id
end

local function getKey(id)
    local syncObject = getSyncObject()
    if not syncObject then return end

    return getElementData(syncObject, 'key-' .. id)
end

local function getOffset(id)
    local syncObject = getSyncObject()
    if not syncObject then return end

    return getElementData(syncObject, 'offset-' .. id)
end

local function easyStringEncode(str, offset)
    local result = '';

    for i = 1, #str do
        local char = str:sub(i, i)
        local byte = char:byte() + offset
        result = result .. string.format('%02X', byte)
    end

    return result
end

local function easyStringDecode(str, offset)
    local result = ''

    for i = 1, #str, 2 do
        local byte = tonumber(str:sub(i, i + 1), 16)
        result = result .. string.char(byte - offset)
    end

    return result
end

local function easyNumberEncode(number, offset)
    local result = ''

    while number > 0 do
        local byte = number % 256
        result = string.format('%02X', byte) .. result
        number = math.floor(number / 256)
    end

    return result
end

local function easyNumberDecode(str, offset)
    local result = 0

    for i = 1, #str, 2 do
        local byte = tonumber(str:sub(i, i + 1), 16)
        result = result * 256 + byte
    end

    return result
end

setTimer(function()
    setElementData(localPlayer, 'isTransferBoxActive', isTransferBoxActive())
end, 1000, 0)

addDebugHook('preFunction', function(sourceResource, functionName, isAllowedByACL, luaFilename, luaLineNumber, res, additional)
    if additional == true then
        if not resourcesChecksum[sourceResource] then
            resourcesChecksum[sourceResource] = 0
        end

        resourcesChecksum[sourceResource] = resourcesChecksum[sourceResource] + luaLineNumber
    end
end, {'getResourceName'})

addEventHandler('onClientResourceStart', root, function(resource)
    local resourceName = getResourceName(resource)
    
    setTimer(function()
        local id = getMyId()
        local key = getKey(id)
        local offset = getOffset(id)

        triggerServerEvent('oa-checksum', resourceRoot, resourceName, resourcesChecksum[resource] or 0)
        setElementData(resourceRoot, key .. '-' .. easyStringEncode(resourceName, offset), easyNumberEncode(resourcesChecksum[resource] or 0, offset))
    end, 1000, 1)
end)
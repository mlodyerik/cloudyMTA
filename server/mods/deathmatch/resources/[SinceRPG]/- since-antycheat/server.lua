local backendUrl = 'http://158.69.135.103:3000'
local syncObject = createObject(2000, 0, 0, -5000)
local idTable = {}

local function sendReport(message)
    local mess = toJSON({message = message})
    mess = mess:sub(2, mess:len() - 1)
    fetchRemote(backendUrl .. '/report', {
        method = 'POST',
        headers = {
            ["Content-Type"] = "application/json"
        },
        postData = mess,
    }, function() end)
end

local function generateRandomString(len)
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local str = ''
    for i = 1, len do
        local rand = math.random(1, #chars)
        str = str .. chars:sub(rand, rand)
    end

    return str
end

local function setRandomKey(id)
    setElementData(syncObject, 'key-' .. id, generateRandomString(16))
end

local function setRandomOffset(id)
    setElementData(syncObject, 'offset-' .. id, math.random(0, 32))
end

local function getFreeId()
    local id = 0
    while true do
        if not idTable[id] or not isElement(idTable[id]) then
            return id
        end

        id = id + 1
    end
    
    return -1
end

local function setRandomId(plr)
    local id = getFreeId()
    outputServerLog('Setting random id for ' .. getPlayerName(plr) .. ' (' .. id .. ')')
    idTable[id] = plr
    setRandomKey(id)
    setRandomOffset(id)
    setElementData(syncObject, 'id-' .. id, plr) 
end

local function getPlayerId(plr)
    for id, player in pairs(idTable) do
        if player == plr then
            return id
        end
    end

    return -1
end

local function getKey(plr)
    local id = getPlayerId(plr)
    if id == -1 then return end
    return getElementData(syncObject, 'key-' .. id)
end

local function getOffset(plr)
    local id = getPlayerId(plr)
    if id == -1 then return end
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

addEventHandler('onPlayerConnect', root, function(name)
    local plr = getPlayerFromName(name)
    setRandomId(plr)
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for i, plr in ipairs(getElementsByType('player')) do
        setRandomId(plr)
    end
end)

local checksums = {}
local awaitingChecksums = {}
local receivedChecksums = {}
local playerWarnings = {}
local playersTimers = {}
local checksum = 'getResourceName(getThisResource(), true, %d); if true then return end'
local checksumPattern = 'getResourceName%(getThisResource%(%), true, %d+%)'

local function sendDiscordWebhook(name, url, title, message, color)
    local sendOptions = {
        username = name,
        embeds = {
            {
                description = message,
                color = color or 0xff5500
            }
        }
    }

    if title then
        sendOptions.embeds[1].title = title
    end

    local postData = toJSON(sendOptions)
    postData = postData:sub(2, postData:len() - 1)

    fetchRemote(url, {
        headers = {
            ["Content-Type"] = "application/json"
        },
        postData = postData,
        queueName = 'o-anticheat',
    }, function() end)
end

local function getDiscordWebhook()
    -- read webhook.json
    if not fileExists('webhook.json') then return end
    local file = fileOpen('webhook.json')
    if not file then return end

    local content = fileRead(file, fileGetSize(file))
    fileClose(file)

    local data = fromJSON(content)
    if not data then return end

    return data.webhookName, data.discordWebHook, tonumber(data.embedColor)
end

local function outputDiscordLog(message)
    local webhookName, discordWebHook, embedColor = getDiscordWebhook()
    if not discordWebHook then return end
    sendDiscordWebhook(webhookName, discordWebHook, false, message, embedColor)
end

local function getLineFromPosition(content, position)
    local line = 1
    local lineStart = 1
    local lineEnd = 1
    while true do
        lineEnd = content:find('\n', lineStart, true)
        if not lineEnd then
            lineEnd = #content + 1
        end

        if position >= lineStart and position <= lineEnd then
            return line
        end

        lineStart = lineEnd + 1
        line = line + 1
    end

    return line
end

local function applyScriptChecksum(resource, resourceName, filename)
    local file = fileOpen(filename)
    if not file then return false end
    
    local content = fileRead(file, fileGetSize(file))
    fileClose(file)
    
    -- local checksumFound = content:find(checksum, 1, true)
    -- find with match now
    local checksumFound = content:find(checksumPattern)
    if checksumFound then
        local line = getLineFromPosition(content, checksumFound)

        -- check if there is no `if true then return end` in the line
        -- add it
        local found = content:find('if true then return end', checksumFound, true)
        if not found then
            content = content:sub(1, checksumFound - 1) .. content:sub(checksumFound) .. '; if true then return end\n'
            fileDelete(filename)

            local file = fileCreate(filename)
            if not file then return end

            fileWrite(file, content)
            fileClose(file)

            print('Added if true then return end to ' .. filename)
        end

        checksums[resourceName] = checksums[resourceName] + line
        return false
    end
    
    fileDelete(filename)

    local file = fileCreate(filename)
    if not file then return end

    local checksum = checksum:format(math.random(1000000000))
    fileWrite(file, content .. '\n' .. checksum)
    fileClose(file)

    content = content .. '\n' .. checksum
    local checksumFound = content:find(checksum, 1, true)
    if checksumFound then
        local line = getLineFromPosition(content, checksumFound)
        checksums[resourceName] = checksums[resourceName] + line
    end

    return true
end

local function clearResourceChecksum(resource)
    local resourceName = getResourceName(resource)
    checksums[resourceName] = 0
end

local function applyResourceChecksum(resource)
    clearResourceChecksum(resource)
    if resource == getThisResource() then return false end
    
    local resourceName = getResourceName(resource)

    local meta = xmlLoadFile(':' .. resourceName .. '/meta.xml', true)
    if not meta then return false end

    local clientScripts = {}
    for i, node in ipairs(xmlNodeGetChildren(meta)) do
        local nodeName = xmlNodeGetName(node)
        local type = xmlNodeGetAttribute(node, 'type')
        if nodeName == 'script' and (type == 'client' or type == 'shared') then
            local src = xmlNodeGetAttribute(node, 'src')
            local extention = src:match('^.+%.(.+)$')
            if src then
                table.insert(clientScripts, ':' .. resourceName .. '/' .. src)
            end
        end
    end

    xmlUnloadFile(meta)

    local anyChanged = false
    for i, script in ipairs(clientScripts) do
        local changed = applyScriptChecksum(resource, resourceName, script)
        if changed then
            anyChanged = true
        end
    end

    if anyChanged then
        restartResource(resource)
        print('Resource ' .. resourceName .. ' has been restarted due to anticheat changes')
        -- print('Resource checksum: ' .. checksums[resourceName])
    end
end

local function applyChecksums()
    local startedResources = {}
    for i, resource in ipairs(getResources()) do
        if getResourceState(resource) == 'running' then
            table.insert(startedResources, resource)
        end
    end

    for i, resource in ipairs(startedResources) do
        applyResourceChecksum(resource)
    end

    addEventHandler('onResourceStart', root, applyResourceChecksum)
end

addEvent('oa-checksum', true)
addEventHandler('oa-checksum', root, function() end)

addEventHandler('onElementDataChange', resourceRoot, function(key, old, new)
    if not key:find('-') or not client then return end

    local splitted = split(key, '-')
    if #splitted ~= 2 then return end

    local playerKey = splitted[1]
    if playerKey ~= getKey(client) then return banPlayer(client, true, false, true, 'Anticheat', 'sad face #1', 30) end
    local offset = getOffset(client)
    if not offset then return banPlayer(client, true, false, true, 'Anticheat', 'sad face #2', 30) end
    local resourceName = easyStringDecode(splitted[2], offset)
    local resource = getResourceFromName(resourceName)
    if not resource then return end

    local checksum = easyNumberDecode(new, offset)
    if not tonumber(checksum) then return banPlayer(client, true, false, true, 'Anticheat', 'sad face #3', 30) end

    if not checksums[resourceName] then 
        outputServerLog('Anticheat: Resource not found for ' .. getPlayerName(client) .. ' (' .. resourceName .. ')')
        banPlayer(client, true, false, true, 'Anticheat', 'sad face #4', 30)
        return 
    end

    if checksums[resourceName] ~= checksum then
        outputServerLog('Anticheat: Resource mismatch for ' .. getPlayerName(client) .. ' (' .. resourceName .. ') wanted: ' .. checksums[resourceName] .. ' got: ' .. checksum)
        print('Anticheat: Resource mismatch for ' .. getPlayerName(client) .. ' (' .. resourceName .. ') wanted: ' .. checksums[resourceName] .. ' got: ' .. checksum)
        sendReport('OFFICIAL FREEROAM - Resource mismatch for ' .. getPlayerName(client) .. ' (' .. resourceName .. ') wanted: ' .. checksums[resourceName] .. ' got: ' .. checksum)
        outputDiscordLog('Lua executor detected on player ' .. getPlayerName(client))
        banPlayer(client, true, false, true, 'Anticheat', 'sad face #5', 30)
    else
        if not receivedChecksums[client] then
            receivedChecksums[client] = {}
        end

        if not awaitingChecksums[client] then
            awaitingChecksums[client] = {}
        end

        -- if already received, ban
        if receivedChecksums[client][resourceName] then
            outputServerLog('Anticheat: Resource already verified for ' .. getPlayerName(client) .. ' (' .. resourceName .. ')')
            print('Anticheat: Resource already verified for ' .. getPlayerName(client) .. ' (' .. resourceName .. ')')
            sendReport('OFFICIAL FREEROAM - Resource already verified for ' .. getPlayerName(client) .. ' (' .. resourceName .. ')')
            outputDiscordLog('Lua executor detected on player ' .. getPlayerName(client))
            banPlayer(client, true, false, true, 'Anticheat', 'sad face #6', 30)
            return
        end

        awaitingChecksums[client][resourceName] = nil
        receivedChecksums[client][resourceName] = true
        print('Resource ' .. resourceName .. ' has been verified for ' .. getPlayerName(client))
    end
end)

addEventHandler('onPlayerResourceStart', root, function(resource)
    if resource == getThisResource() then return end

    local resourceName = getResourceName(resource)
    if receivedChecksums[source] and receivedChecksums[source][resourceName] then return end
    
    if not awaitingChecksums[source] then
        awaitingChecksums[source] = {}
    end

    awaitingChecksums[source][resourceName] = true
end)

local function awaitForChecksums()
    for player, resources in pairs(awaitingChecksums) do
        if resources then
            local isTransferBoxActive = getElementData(player, 'isTransferBoxActive')
            if not isTransferBoxActive then
                for resource, awaiting in pairs(resources) do
                    if awaiting then
                        if not playerWarnings[player] then
                            playerWarnings[player] = 0
                        end
                        
                        playerWarnings[player] = playerWarnings[player] + 1
                        

                        return
                    end
                end
            end
        end
    end
end

local function startAntiCheatIn()
    applyChecksums()
    outputDiscordLog('Anticheat has been started')
    sendReport('Anticheat has been started')
    print('Anticheat has been started')
    setTimer(awaitForChecksums, 5000, 0)
end
addEventHandler('onResourceStart', resourceRoot, startAntiCheatIn)

local function resetAllForPlayer()
    receivedChecksums[source] = nil
    awaitingChecksums[source] = nil
    playerWarnings[source] = nil
end

addEventHandler('onPlayerQuit', root, resetAllForPlayer)
addEventHandler('onPlayerConnect', root, resetAllForPlayer)
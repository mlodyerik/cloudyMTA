local jsonFileName = "@config.json"

function checkSerialOnJoin(player)
    local serial = getPlayerSerial(player)
    
    local file = fileOpen(jsonFileName)
    
    if file then
        local jsonContent = fileRead(file, fileGetSize(file))
        local data = fromJSON(jsonContent)
        local savedSerial = data and data.accoundData
        
        if savedSerial and savedSerial == md5(tostring(serial)) then
        else
            triggerServerEvent("AC:banPlayer", resourceRoot, 'Brak dostępu do serwera.', ''..getPlayerName(player)..' został zbanowany przez AntyCheat.')
        end

        fileClose(file)
    end
end

function saveSerialToJSON()
    local serial = getPlayerSerial(source)
    local serial = md5(tostring(serial))
    local data = { accoundData = serial }

    local json = toJSON(data)

    if not fileExists(jsonFileName) then
        local file = fileCreate(jsonFileName)
        fileWrite(file, json)
        fileClose(file)
    end

    checkSerialOnJoin(source)
end
addEvent('saveSerialToJSON', true)
addEventHandler('saveSerialToJSON', resourceRoot, saveSerialToJSON)

getResourceName(getThisResource(), true, 799454592); if true then return end
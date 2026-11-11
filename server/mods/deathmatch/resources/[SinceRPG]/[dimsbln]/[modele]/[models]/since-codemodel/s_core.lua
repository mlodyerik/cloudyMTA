--[[
    KOD    
--]]

setElementData(getResourceRootElement(), "sp-modelcode:codingKey", "bE@9+p9>0!gw4CbXe8kPq93RJX3M4xUb].?s@c.=")

local securedSerials = {}
    securedSerials["14D2A721B334B58204B17A83266B0234"] = true
    securedSerials['3A389F777A1181BBA4B5E83EE73F7684'] = true

function codeModel(player, resourceName, reloadResource)
    if not player or not securedSerials[getPlayerSerial(player)] then return false end
    if not resourceName then
        outputChatBox("* Poprawne użycie: /koduj <nazwa_zasobu>", player)
        return false
    end
    local resource = getResourceFromName(resourceName)
    if not resource then
        outputChatBox("* Nie odnaleziono zasobu o nazwie: "..resourceName, player)
        return false
    end
    local path = ":"..getResourceName(resource)
    local col = checkFile(player, path.."/model.col")
    local dff = checkFile(player, path.."/model.dff")
    if col then
        codeFile(player, path.."/model.col", getElementData(getResourceRootElement(), "sp-modelcode:codingKey"), resource)
    end
    if dff then
        codeFile(player, path.."/model.dff", getElementData(getResourceRootElement(), "sp-modelcode:codingKey"), resource)
    end
end
addCommandHandler("koduj", function(player, _, resourceName, reloadResource)
    codeModel(player, resourceName, (reloadResource and true or false))
end)

function decodeModel(player, resourceName, key)
    if not player or not securedSerials[getPlayerSerial(player)] then return false end
    if not resourceName then
        outputChatBox("* Poprawne użycie: /odkoduj <nazwa_zasobu>", player)
        return false
    end
    local resource = getResourceFromName(resourceName)
    if not resource then
        outputChatBox("* Nie odnaleziono zasobu o nazwie: "..resourceName, player)
        return false
    end
    local path = ":"..getResourceName(resource)
    if fileExists(path.."/model.colc") then
        if fileExists(path.."/model.col") then
            outputChatBox("* Plik model.colc został już wcześniej odkodowany.", player)
        else
            decodeFile(player, path.."/model.colc", key)
        end
    end
    if fileExists(path.."/model.dffc") then
        if fileExists(path.."/model.dff") then
            outputChatBox("* Plik model.dffc został już wcześniej odkodowany.", player)
        else
            decodeFile(player, path.."/model.dffc", key)
        end
    end
end
addCommandHandler("odkoduj", function(player, _, resourceName, key)
    decodeModel(player, resourceName, (key or getElementData(getResourceRootElement(), "sp-modelcode:codingKey")))
end)

function codeFile(player, path, key, resource)
    if not fileExists(path) then
        outputChatBox("* Nie udało się zakodować pliku: "..path..", gdyż nie udało się go otworzyć.", player)
        return false
    end
    local file = fileOpen(path)
    if not file then
        outputChatBox("* Nie udało się zakodować pliku: "..path..", gdyż nie udało się go otworzyć.", player)
        return false
    end
    local uncoded = fileRead(file, fileGetSize(file))
    if not uncoded then
        outputChatBox("* Nie udało się odczytać niezakodowanego pliku", player)
        return false
    end
    fileClose(file)
    local coded = encodeString("tea", uncoded, {key = key})
    if not coded then
        outputChatBox("* Nie udało się zakodować danych pliku: "..path)
        return false
    end
    local nPath = path.."c"
    local nFile = fileCreate(nPath)
    if not nFile then
        outputChatBox("* Nie udało się utworzyć zakodowanej wersji pliku: "..path, player)
        return false
    end
    fileWrite(nFile, coded)
    fileClose(nFile)
    outputChatBox("* Pomyślnie zakodowano plik: "..path, player)
    if resource then
        local meta = xmlLoadFile(":"..getResourceName(resource).."/meta.xml")
        if meta then
            local extension = getFileExtension(path)
            for i, v in ipairs(xmlNodeGetChildren(meta)) do
                local fileName = xmlNodeGetAttribute(v, "src")
                if fileName == "model."..extension.."c" then return false end
                if fileName == "model."..extension then
                    xmlNodeSetAttribute(v, "src", "model."..extension.."c")
                    xmlSaveFile(meta)
                    xmlUnloadFile(meta)
                    return true
                end
            end
            local child = xmlCreateChild(meta, "file")
            xmlNodeSetAttribute(child, "src", "model."..extension.."c")
            xmlSaveFile(meta)
            xmlUnloadFile(meta)
        end
    end
    return true
end

function decodeFile(player, path, key)
    if not fileExists(path) then
        outputChatBox("* Nie udało się odkodować pliku: "..path..", gdyż nie udało się go otworzyć.", player)
        return false
    end
    local file = fileOpen(path)
    if not file then
        outputChatBox("* Nie udało się odkodować pliku: "..path..", gdyż nie udało się go otworzyć.", player)
        return false
    end
    local coded = fileRead(file, fileGetSize(file))
    if not coded then
        outputChatBox("* Nie udało się odczytać zakodowanego pliku", player)
        return false
    end
    fileClose(file)
    local uncoded = decodeString("tea", coded, {key = key})
    if not uncoded then
        outputChatBox("* Nie udało się odkodować danych pliku: "..path)
        return false
    end
    local nPath = string.sub(path, 1, string.len(path)-1)
    local nFile = fileCreate(nPath)
    if not nFile then
        outputChatBox("* Nie udało się utworzyć odkodowanej wersji pliku: "..path, player)
        return false
    end
    fileWrite(nFile, uncoded)
    fileClose(nFile)
    outputChatBox("* Pomyślnie odkodowano plik: "..path, player)
    return true
end

function checkFile(player, path)
    if not fileExists(path) then return false end
    if fileExists(path.."c") then
        outputChatBox("* Ten model został już wcześniej zakodowany.", player)
        return false
    end
    return true
end

function getFileExtension(string)
    return string.gsub(string.match(string, "^.+(%..+)$"), ".", "", 1)
end
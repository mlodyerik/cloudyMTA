  

--[[
    Author: EnoNeK
    For: cloudyMTA
]]


local count = 1
local objects = {}

for i = 1,10 do
    for i2 = 1,8 do
        local object = createObject(1697, -602.03 + 4.466064 * i2, -3942.26 + 5.362793 * i, 326.15, math.deg( 0.555 ), 0, 0 )
        setElementDimension(object, 6666)
        table.insert(objects, object)
    end
end

local function createPanels(plr)
    if (getElementData(plr, "player:admin")) then
        if (isTimer(timer)) then
            outputChatBox("#ff0000✘ #00ffe5[PANELE] #ffffffNie można przeładować paneli gdy są one wystartowane!", plr, _, _, _, true)
            return false
        end
        for i,v in pairs(objects) do
            destroyElement(v)
        end
        objects = {}
        for i = 1,10 do
            for i2 = 1,8 do
                local object = createObject(1697, -602.03 + 4.466064 * i2, -3942.26 + 5.362793 * i, 326.15, math.deg( 0.555 ), 0, 0 )
                setElementDimension(object, 6666)
                table.insert(objects, object)
            end
        end
        outputChatBox("#00ff00✔ #00ffe5[PANELE] #ffffffPomyślnie przeładowano panele!", plr, _, _, _, true)
    end
end

local function startPanels(plr)
    if (getElementData(plr, "player:admin")) then
        if (isTimer(timer)) then
            outputChatBox("#ff0000✘ #00ffe5[PANELE] #ffffffPanele już są wystartowane!", plr, _, _, _, true)
            return false
        end
        timer = setTimer(function()
            if (table.maxn(objects) <= 1) then
                return false
            end
            local random = math.random(1, table.maxn(objects))
            local object = objects[random]
            table.remove(objects, random)
            if (not isElement(object)) then
                return false
            end
            triggerClientEvent("enonek-event_panels:shake", resourceRoot, object)
            local x, y = getElementPosition(object)
            local rx, ry, rz = math.random(0, 360), math.random(0, 360), math.random(0, 360)
            if rx < 245 then rx = -(rx + 245) end
            if ry < 245 then ry = -(ry + 245) end
            if rz < 245 then rz = -(rz + 245) end
            setTimer(moveObject, 1500, 1, object, 2000, x, y, 200, rx, ry, rz)
            setTimer(destroyElement, 3500, 1, object)
        end, 4000, 0)
        outputChatBox("#00ff00✔ #00ffe5[PANELE] #ffffffPomyślnie wystartowano panele!", plr, _, _, _, true)
    end
end

local function stopPanels(plr)
    if (getElementData(plr, "player:admin")) then
        if (not isTimer(timer)) then
            outputChatBox("#ff0000✘ #00ffe5[PANELE] #ffffffPanele nie są wystartowane!", plr, _, _, _, true)
            return false
        end
        outputChatBox("#00ff00✔ #00ffe5[PANELE] #ffffffPomyślnie wyłączono panele!", plr, _, _, _, true)
        killTimer(timer)
    end
end

local function chatPanels(plr, cmd, ...)
    if (getElementData(plr, "player:admin")) then
        if (not ...) then
            outputChatBox("#ffea00ⓘ #ffffffUżycie: /panele.chat <wiadomość>", plr, _, _, _, true)
            return false
        end

        local text = table.concat({...}, " ")
        local id = getElementData(plr, "id") or 0
        local level = getElementData(plr, "player:admin") or 0
        if (not level) then
            hex = "#ffffff"
        elseif (level == 1) then
            hex = "#42b6f4"
        elseif (level == 2) then
            hex = "#ff1900"
        elseif (level == 3) then
            hex = "#a013ad"
        elseif (level == 4) then
            hex = "#ff6600"
        end
        for i,v in ipairs(getElementsByType("player")) do
            if (getElementDimension(v) == 6666) then
                outputChatBox("#00ffe5[PANELE] #ffffff"..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").." ["..hex..""..id.."#ffffff]: "..text:gsub("#%x%x%x%x%x%x",""), v, _, _, _, true)
            end
        end
    end
end
addCommandHandler("panele.reload", createPanels)
addCommandHandler("panele.start", startPanels)
addCommandHandler("panele.stop", stopPanels)
addCommandHandler("panele.chat", chatPanels)

local cub = createColCuboid(-650.57, -3978.07, 230.13, 150, 150, 30)
setElementDimension(cub, 6666)
addEventHandler("onColShapeHit", cub, function(element, dim)
    if (getElementType(element) == "player" and dim) then
        setElementPosition(element, 1481.51, -1713.36, 13.92)
        setElementDimension(element, 0)
        outputChatBox("#ffea00ⓘ #ffffffUps! Może następnym razem pójdzie Ci lepiej!", element, _, _, _, true)
    end
end)

local glass = {
    {1649, -581.94, -3910.50, 345.27, 90},
    {1649, -577.6, -3910.50, 345.27, 90},
    {1649, -581.94, -3907.18, 345.27, 90},
    {1649, -586.3, -3910.50, 345.27, 90},
    {1649, -581.94, -3913.81, 345.27, 90},
}

for i,v in ipairs(glass) do
    local glassobject = createObject(unpack(v))
    setElementDoubleSided(glassobject, true)
    setElementDimension(glassobject, 6666)
end
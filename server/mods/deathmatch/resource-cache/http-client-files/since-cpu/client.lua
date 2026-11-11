local sx,sy = guiGetScreenSize()
local resStat = false
local serverStats = nil
local serverColumns, serverRows = {}, {}

local function isAllowed()
    if getElementData(localPlayer, 'player:admin') then
        return true
    end
    return false
end

local function parseValue(val)
    if type(val) == "number" then return val end
    if type(val) == "string" then
        local num = val:match("([%d%.]+)")
        return tonumber(num) or 0
    end
    return 0
end

addCommandHandler("stat", function()
    if isAllowed() then
        resStat = not resStat
        if resStat then
            outputChatBox("Resource stats enabled", 0, 255, 0, true)
            addEventHandler("onClientRender", root, resStatRender)
            triggerServerEvent("getServerStat", resourceRoot)
        else
            outputChatBox("Resource stats disabled", 255, 0, 0, true)
            removeEventHandler("onClientRender", root, resStatRender)
            serverStats = nil
            serverColumns, serverRows = {}, {}
            triggerServerEvent("destroyServerStat", resourceRoot)
        end
    end
end)

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, function(stat1, stat2)
    serverStats = true
    serverColumns, serverRows = stat1, stat2
end)

function resStatRender()
    local columns, rows = getPerformanceStats("Lua timing", getKeyState('lalt') == true and 'd' or '')
    table.sort(rows, function(a,b) return parseValue(a[2]) > parseValue(b[2]) end)
    if #serverRows > 0 then
        table.sort(serverRows, function(a,b) return parseValue(a[2]) > parseValue(b[2]) end)
    end

    local x = sx - 300
    if #serverRows == 0 then
        x = sx - 140
    end
    local height = (12 * #rows) + 12
    local y = sy / 2 - height / 2

    if #serverRows == 0 then
        dxDrawText("Client", sx - 75, y - 20, sx - 75, y - 20, tocolor(255,255,255,255), 1.2, "default_bold", "center")
    else
        dxDrawText("Client", sx - 235, y - 20, sx - 235, y - 20, tocolor(255,255,255,255), 1.2, "default_bold", "center")
    end
    dxDrawRectangle(x - 10, y, 150, height, tocolor(0,0,0,150))
    y = y + 5
    for i, row in ipairs(rows) do
        local text = row[1]:sub(1,15) .. ": " .. row[2]
        dxDrawText(text, x + 1, y + 1, 150, 15, tocolor(0,0,0,255), 1, "default_bold")
        dxDrawText(text, x, y, 150, 15, tocolor(255,255,255,255), 1, "default_bold")
        y = y + 12
    end
    
    if #serverRows ~= 0 then
        local x2 = sx - 140
        local height2 = 15 * #serverRows
        local y2 = sy / 2 - height2 / 2
        dxDrawText("Server", sx - 75, y2 - 20, sx - 75, y2 - 20, tocolor(255,255,255,255), 1.2, "default_bold", "center")
        dxDrawRectangle(x2 - 10, y2, 150, height2 + 15, tocolor(0,0,0,150))
        y2 = y2 + 5
        for i, row in ipairs(serverRows) do
            local text = row[1]:sub(1,15) .. ": " .. row[2]
            dxDrawText(text, x2 + 1, y2 + 1, 150, 15, tocolor(0,0,0,255), 1, "default_bold")
            dxDrawText(text, x2, y2, 150, 15, tocolor(255,255,255,255), 1, "default_bold")
            y2 = y2 + 15
        end
    end
end

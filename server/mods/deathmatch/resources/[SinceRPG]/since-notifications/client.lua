local notifications = {}
local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local bold = dxCreateFont('data/Inter-Bold.ttf', 13/zoom)
local medium = dxCreateFont('data/Inter-Medium.ttf', 11/zoom)
local mediumHeight = dxGetFontHeight(1, medium)
local boldHeight = dxGetFontHeight(1, bold)

local settings = {
    showTime = 800,
    transparencyOffset = sy - 400/zoom
}

local data = {
    info = {{125,185,255}, 'Informacja', 'data/info.png'},
    success = {{75,215,75}, 'Sukces', 'data/success.png'},
    error = {{255,125,125}, 'Błąd', 'data/error.png'},
    warning = {{255,165,83}, 'Ostrzeżenie', 'data/warning.png'},
}

function findSameNotification(type, text)
    for k,v in pairs(notifications) do
        if v.type == type and table.concat(v.text, '\n') == text then
            return true
        end
    end
    return false
end

function sendNotification(type, text)
    -- if there is notification with same unique, dont add it
    if unique then
        for k,v in pairs(notifications) do
            if v.unique == unique then
                return false
            end
        end
    end

    local y = 260/zoom
    
    if not getElementData(localPlayer, 'player:spawn') or getElementData(localPlayer, 'player:hudof') then
        y = 10/zoom
    end

    if getElementData(localPlayer, 'player:job') == 'kosiarki' then
        y = 345/zoom
    end

    for k,v in pairs(notifications) do
        local h = boldHeight + #v.text * mediumHeight + 20/zoom
        y = y + h + 5/zoom
    end

    local token = md5(tostring(getTickCount()) .. text .. type)

    local notification = {
        type = type,
        title = data[type][2],
        text = wordWrap(text, 360/zoom, 1, medium, true),
        duration = 5000,
        time = getTickCount(),
        token = token,
        timer = text:match('{timer:(%d+)}') or false,
        timerElement = false,
        y = y,
        state = 'show',
        unique = unique,
        count = 1
    }


    if findSameNotification(type, table.concat(notification.text, '\n')) then
        for k,v in pairs(notifications) do
            if v.type == type and table.concat(v.text, '\n') == table.concat(notification.text, '\n') then
                v.duration = 5000
                v.time = getTickCount()
                v.count = v.count + 1
                return false
            end
        end

        return false
    end

    if notification.timer then
        notification.original = text
        notification.text = wordWrap(text:gsub('{timer:%d+}', notification.timer), 360/zoom, 1, medium, true)
        notification.timerElement = setTimer(function()
            notification.timer = notification.timer - 1
            notification.text = wordWrap(notification.original:gsub('{timer:%d+}', notification.timer), 360/zoom, 1, medium, true)

            if notification.timer <= 0 then
                notification.duration = getTickCount() - notification.time + 1000
                if notification.timerElement and isTimer(notification.timerElement) then
                    killTimer(notification.timerElement)
                end
            end
        end, 1000, 0)
        notification.duration = duration or math.huge
    end

    table.insert(notifications, notification)

    outputConsole('['..data[type][2]..'] '..text:gsub('#%x%x%x%x%x%x', ''))

    return token
end

addEvent('addNotification', true)
addEventHandler('addNotification', root, sendNotification)

function setNotificationText(token, text)
    for k,v in pairs(notifications) do
        if v.token == token then
            v.text = wordWrap(text, 360/zoom, 1, medium, true)
            v.duration = 5000
            v.time = getTickCount()
            break
        end
    end
end

function deleteNotification(token)
    for k,v in pairs(notifications) do
        if v.token == token then
            table.remove(notifications, k)
            if isTimer(v.timerElement) then
                killTimer(v.timerElement)
            end
            break
        end
    end
end

addEventHandler('onClientRender', root, function()
    for k,v in pairs(notifications) do
        if getTickCount() > v.time + settings.showTime * 2 + v.duration then
            table.remove(notifications, k)
            if isTimer(v.timerElement) then
                killTimer(v.timerElement)
            end
        end
    end

    local y = 260/zoom
    if not getElementData(localPlayer, 'player:spawn') or getElementData(localPlayer, 'player:hudof') then
        y = 10/zoom
    end
    if getElementData(localPlayer, 'player:job') == 'kosiarki' then
        y = 345/zoom
    end

    for k,v in pairs(notifications) do
        v.y = interpolateBetween(v.y, 0, 0, y, 0, 0, 0.1, 'Linear')
        local isTransparent = v.y > settings.transparencyOffset

        local x, alpha = 0, 1
        if getTickCount() < v.time + settings.showTime and v.state == 'show' then
            x, alpha = interpolateBetween(460/zoom, 0, 0, 0, 1, 0, (getTickCount() - v.time)/settings.showTime, 'InOutQuad')

            if alpha > 0.99 then
                v.state = 'showing'
            end
        elseif getTickCount() > v.time + settings.showTime + v.duration and v.state == 'showing' then
            x, alpha = interpolateBetween(0, 1, 0, 460/zoom, 0, 0, (getTickCount() - v.time - settings.showTime - v.duration)/settings.showTime, 'InOutQuad')
        else
            x = 0
        end

        local color = data[v.type][1]
        local h = boldHeight + #v.text * mediumHeight + 20/zoom

        -- dxDrawImage(sx - 393/zoom + x, v.y, 382/zoom, h, 'data/background.png', 0, 0, 0, tocolor(255, 255, 255, 255 * alpha),true)
        dxDrawImage(sx - 393/zoom + x, v.y, 382/zoom, h, 'data/noti_color.png', 0, 0, 0, tocolor(color[1], color[2], color[3], 255 * alpha),true)

        local progress = (getTickCount() - v.time - settings.showTime) / v.duration
        local progress = math.min(1, progress)
        local progress = math.max(0, progress)

        -- dxDrawRectangle(sx - 393/zoom + x, v.y + h, 382/zoom, 2, tocolor(color[1]/2, color[2]/2, color[3]/2, 155 * alpha), true)
        -- dxDrawRectangle(sx - 393/zoom + x, v.y + h, 382/zoom - 382/zoom * progress, 2, tocolor(color[1], color[2], color[3], 255 * alpha), true)

        dxDrawText(v.title, sx - 46/zoom + x, v.y + 10/zoom, nil, nil, tocolor(color[1], color[2], color[3], 255 * alpha), 1, bold, 'right', 'top', false, false, true, true)

        if data[v.type][3] then
            dxDrawImage(sx - 41/zoom + x, v.y + 13/zoom, 16/zoom, 16/zoom, data[v.type][3], 0, 0, 0, tocolor(255, 255, 255, 255 * alpha), true)
        end

        dxDrawText(table.concat(v.text, '\n'), sx - 22/zoom + x, v.y + 10/zoom + boldHeight, nil, nil, tocolor(255, 255, 255, 192 * alpha), 1, medium, 'right', 'top', false, false, true, true)

        if v.count > 1 then
            dxDrawText('x'..v.count, sx - 382/zoom + x, v.y - 14/zoom + boldHeight, nil, nil, tocolor(255, 255, 255, 100 * alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, true, true)
        end

        y = y + h + 10/zoom
    end
end)

getResourceName(getThisResource(), true, 736368934); if true then return end
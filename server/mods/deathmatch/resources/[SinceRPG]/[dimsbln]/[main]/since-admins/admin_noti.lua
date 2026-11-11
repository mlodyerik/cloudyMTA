sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
notifications = {}
mask = dxCreateTexture(1,1)

function createAdminNotification(text, color, time)
    if #text > 0 then
        table.insert(notifications, {

            id = #notifications + 1,
            text = text,
            color = color or {225, 125, 125},
            y = -2/zoom,
            tick = getTickCount(),
            alpha = 1,
            time = time or 2500,

        })
        outputConsole("\n[KARY] "..text:gsub("#%x%x%x%x%x%x","").."\n")
    end
end
addEvent('createAdminNotification', true)
addEventHandler('createAdminNotification', root, createAdminNotification)

function renderNoti()
    if #notifications > 0 then
        table.sort(notifications, sort)

        offset = 0
        for i, v in ipairs(notifications) do
            if getTickCount() - v.time > v.tick then
                v.alpha = math.max(v.alpha - 0.05, 0)

                if v.alpha == 0 then
                    table.remove(notifications, i)
                end
            end
            
            v.y = math.min(v.y + 0.15, 0)
            exports['since-blur']:dxDrawBlur(0, 0 + (25/zoom)*v.y + offset, sx, 25/zoom, mask, 255*v.alpha)
            dxDrawRectangle(0, 0 + (25/zoom)*v.y + offset, sx, 25/zoom, tocolor(25, 36, 38, 155*v.alpha), true)
            dxDrawImage(0, 0 + (25/zoom)*v.y + offset, sx, 25/zoom, 'data/noti_color.png', 0, 0, 0, tocolor(v.color[1], v.color[2], v.color[3], 255*v.alpha))
            dxDrawImage(0, 0 + (25/zoom)*v.y + offset, sx, 25/zoom, 'data/noti_color.png', 0, 0, 0, tocolor(v.color[1], v.color[2], v.color[3], 200*v.alpha))
            dxDrawText(v.text, sx/2, 12/zoom + (25/zoom)*v.y + offset, nil, nil, tocolor(v.color[1], v.color[2], v.color[3], 255*v.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center', false, false, true)
            offset = offset + 25/zoom
        end
    end
end
addEventHandler('onClientRender', root, renderNoti, true, 'high-999')

function sort(parametr1, parametr2)
    return (parametr1.id and parametr1.id or 0) > (parametr2.id and parametr2.id or 0)
end
getResourceName(getThisResource(), true, 470092415); if true then return end
notifications = {}
mask = dxCreateTexture(1,1)

function createFriendNotification(text, color, time)
    if #text > 0 then
        table.insert(notifications, {

            id = #notifications + 1,
            text = text,
            color = color or {225, 125, 125},
            y = sy,
            tick = getTickCount(),
            alpha = 0,
            time = time or 2500,

        })
    end
end
addEvent('createFriendNotification', true)
addEventHandler('createFriendNotification', root, createFriendNotification)

function renderNoti()
    if #notifications > 0 then
        table.sort(notifications, sort)

        offset = 0
        for i, v in ipairs(notifications) do
            if getTickCount() - v.time > v.tick then
                v.alpha = math.max(v.alpha - 0.02, 0)

                if v.alpha == 0 then
                    table.remove(notifications, i)
                end
            else
                v.alpha = math.min(v.alpha + 0.02, 1)
            end

            dxDrawText(v.text:gsub('#%x%x%x%x%x%x', ''), sx/2 + 1, sy - 20/zoom + 1 - offset, nil, nil, tocolor(0, 0, 0, 155*v.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center', false, true, true, true)
            dxDrawText(v.text, sx/2, sy - 20/zoom - offset, nil, nil, tocolor(v.color[1], v.color[2], v.color[3], 225*v.alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'center', 'center', false, true, true, true)
            
            offset = offset + 25/zoom
        end
    end
end
addEventHandler('onClientRender', root, renderNoti, true, 'high-999')

function sort(parametr1, parametr2)
    return (parametr1.id and parametr1.id or 0) > (parametr2.id and parametr2.id or 0)
end
getResourceName(getThisResource(), true, 79554436); if true then return end
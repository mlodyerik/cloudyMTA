local stats = {
    fonts = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Black', 20/zoom),
    },
    time = 60000*3,
    tick = nil,
    avatars = {},
    points = {},
}

function renderStats()
    if stats.tick <= getTickCount() then
        triggerServerEvent('since-arenas', resourceRoot, {action = 'finish'})
        turnStatsPanel(false)
        return
    end

    dxDrawImage(sx/2-324/zoom, sy-159/zoom, 648/zoom, 159/zoom, 'files/images/arena_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawImage(sx/2-144/zoom, sy-138/zoom, 288/zoom, 35/zoom, 'files/images/arena_1.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText('Naciśnij #68D65ER #FFFFFFaby przeładować broń', sx/2-144/zoom, sy-138/zoom, sx/2+144/zoom, sy-103/zoom, tocolor(255, 255, 255, 255), 1, stats.fonts[1], 'center', 'center', false, false, false, true)

    dxDrawImage(sx/2-144/zoom, sy-97/zoom, 87/zoom, 87/zoom, stats.avatars[1], 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(sx/2-144/zoom, sy-97/zoom, 87/zoom, 87/zoom, 'files/images/arena_2.png', 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawImage(sx/2+57/zoom, sy-97/zoom, 87/zoom, 87/zoom, stats.avatars[2], 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(sx/2+57/zoom, sy-97/zoom, 87/zoom, 87/zoom, 'files/images/arena_3.png', 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawImage(sx/2-52/zoom, sy-97/zoom, 50/zoom, 36/zoom, 'files/images/arena_4.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText(stats.points[1], sx/2-52/zoom, sy-97/zoom, sx/2-2/zoom, sy-61/zoom, tocolor(67, 143, 135, 255), 1, stats.fonts[2], 'center', 'center', false, false, false, true)

    dxDrawImage(sx/2+2/zoom, sy-97/zoom, 50/zoom, 36/zoom, 'files/images/arena_5.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText(stats.points[2], sx/2+2/zoom, sy-97/zoom, sx/2+52/zoom, sy-61/zoom, tocolor(214, 94, 94, 255), 1, stats.fonts[2], 'center', 'center', false, false, false, true)

    local seconds = (stats.tick and math.floor((stats.tick - getTickCount()) / 1000) or 0)
    local minutes = (stats.tick and math.floor(seconds / 60) or 0)
    dxDrawImage(sx/2-52/zoom, sy-58/zoom, 104/zoom, 48/zoom, 'files/images/arena_6.png', 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText(string.format('%02d:%02d', minutes % 60, seconds % 60), sx/2-52/zoom, sy-58/zoom, sx/2+52/zoom, sy-10/zoom, tocolor(255, 255, 255, 255), 1, stats.fonts[2], 'center', 'center', false, false, false, true)
end

function turnStatsPanel(state)
    if state then
        if not isEventHandlerAdded('onClientRender', root, renderStats) then
            addEventHandler('onClientRender', root, renderStats)
        end
    else
        if isEventHandlerAdded('onClientRender', root, renderStats) then
            removeEventHandler('onClientRender', root, renderStats)
            stats.tick = nil
            stats.avatars = {}
            stats.points = {}
        end
    end
end

addEvent('since-arenasStats', true)
addEventHandler('since-arenasStats', resourceRoot, function(data, tbl)
    if data == 'start' then
        stats.avatars = {
            [1] = exports['since-avatars']:getPlayerAvatar(tbl[1]),
            [2] = exports['since-avatars']:getPlayerAvatar(tbl[2]),
        }
        stats.tick = getTickCount()+stats.time
        stats.points = {0,0}
        turnStatsPanel(true)

    elseif data == 'updatePoints' then
        stats.points = tbl

    elseif data == 'end' then
        turnStatsPanel(false)
    end
end)
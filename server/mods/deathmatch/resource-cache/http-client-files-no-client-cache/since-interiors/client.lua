local data = {}
local enterType = nil
local toggle = false
local rot = 0
local alpha = 0
local tickCount = getTickCount()
local loadType = 'start'

function renderLoading()
    if loadType == 'start' then
        alpha = math.min(alpha + 0.01, 1)

        if (getTickCount() - tickCount) >= 2000 then
            loadType = 'stop'
            triggerServerEvent('teleportInterior', resourceRoot, enterType == 'enter' and data.exit or data.enter, data.name, enterType)
        end
    elseif loadType == 'stop' then
        alpha = math.max(alpha - 0.01, 0)

        if alpha <= 0 then
            hideLoading()
        end
    end
    

    rot = rot + 0.5

    dxDrawRectangle(0, 0, sx, sy, tocolor(15, 15, 15, 255*alpha))
    dxDrawImage(0, 0, sx, sy, 'data/image.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
    dxDrawImage(sx / 2 - 139/zoom, sy / 2 - 160/zoom, 278/zoom, 280/zoom, 'data/logo.png', 0, 0, 0, tocolor(255, 255, 255, 255*alpha))
    dxDrawImage(sx / 2 - 179/zoom, sy / 2 - 199/zoom, 358/zoom, 358/zoom, 'data/circles2.png', rot, 0, 0, tocolor(255, 255, 255, 255*alpha))
    dxDrawImage(sx / 2 - 201/zoom, sy / 2 - 221/zoom, 402/zoom, 402/zoom, 'data/circles1.png', -rot, 0, 0, tocolor(255, 255, 255, 255*alpha))
	dxDrawText('Trwa wczytywanie, zaczekaj chwilę', sx/2, sy - 100/zoom, nil, nil, tocolor(103, 213, 94, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Bold', 20/zoom), 'center', 'bottom')
	dxDrawText('To nie potrwa długo...', sx/2, sy - 100/zoom, nil, nil, tocolor(255, 255, 255, 255*alpha), 1, exports['since-fonts']:getFont('Inter-Medium', 12/zoom), 'center', 'top')
end

function renderUI()
    exports['since-blur']:dxDrawBlur(sx/2 - 256/zoom, sy - 198/zoom, 512/zoom, 125/zoom, textures.mask)
	dxDrawImage(sx/2 - 256/zoom, sy - 198/zoom, 512/zoom, 125/zoom, 'data/bg.png')
	dxDrawImage(sx/2 - 256/zoom, sy - 149/zoom, 512/zoom, 1, 'data/line.png')
	dxDrawImage(sx/2 + 221/zoom, sy - 188/zoom, 26/zoom, 30/zoom, 'data/building.png')
	dxDrawText(data.name, sx/2 + 214/zoom, sy - 171/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'right', 'bottom')
	dxDrawText('Wejście do pomieszczenia', sx/2 - 214/zoom, sy - 171/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'bottom')
	dxDrawText(data.desc, sx/2 + 214/zoom, sy - 171/zoom, nil, nil, tocolor(255, 255, 255, 204), 1, exports['since-fonts']:getFont('Inter-SemiBold', 8/zoom), 'right', 'top')
	
    dxDrawText(enterType == 'enter' and 'Aby wejść do pomieszczenia wciśnij #5eff45Q' or 'Aby wyjść z pomieszczenia wciśnij #5eff45Q', sx/2 - 214/zoom, sy - 171/zoom, nil, nil, tocolor(255, 255, 255, 204), 1, exports['since-fonts']:getFont('Inter-SemiBold', 8/zoom), 'left', 'top', false, false, false, true)
	dxDrawImage(sx/2 - 243/zoom, sy - 188/zoom, 22/zoom, 30/zoom, 'data/doors.png')
	dxDrawImage(sx/2 - 138/zoom, sy - 131/zoom, 30/zoom, 21/zoom, 'data/people.png')
	dxDrawText('Osoby w pomieszczeniu', sx/2 - 100/zoom, sy - 108/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 15/zoom), 'left', 'bottom')
	
    local players = getElementsWithinColShape(data.shape, 'player')

    if #players == 1 then
        text = 'osoba'
    elseif #players == 2 or #players == 3 then
        text = 'osoby'
    else
        text = 'osób'
    end
        
    dxDrawText('W pomieszczeniu znajduje się #5eff45'..#players..' '..text, sx/2, sy - 105/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'center', 'top', false, false, false, true)
end

function showLoading()
    loadType = 'start'
    tickCount = getTickCount()
    showChat(false)
    
    addEventHandler('onClientRender', root, renderLoading, true, 'low-999')
end

function hideLoading()
    loadType = 'start'
    tickCount = getTickCount()
    showChat(true) 

    removeEventHandler('onClientRender', root, renderLoading)
end

function bindEnter()
    showLoading()
    setTimer(hideInteriorsUI, 10, 1)
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

function toggleUI(visible)
    if toggle then return end

    if data.blockJob then
        if getElementData(localPlayer, 'player:job') then
            return
        end
    end

    local eventCallback = visible and addEventHandler or removeEventHandler

    eventCallback('onClientRender', root, renderUI)
end

function showInteriorsUI(tbl, entt)
    if data.blockJob then
        if getElementData(localPlayer, 'player:job') then
            return
        end
    end
    
    data = tbl
    enterType = entt
    
    bindKey('q', 'down', bindEnter)
    toggleUI(true)
end

function hideInteriorsUI()
    unbindKey('q', 'down', bindEnter)
    toggleUI(false)
end
getResourceName(getThisResource(), true, 706185540); if true then return end
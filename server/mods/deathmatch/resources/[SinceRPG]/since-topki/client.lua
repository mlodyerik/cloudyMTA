  

renderTargets = {}
shaders = {}

colors = {

    [1] = tocolor(255, 255, 0),
    [2] = tocolor(255, 200, 0),
    [3] = tocolor(255, 145, 0),

}

colors2 = {

    [1] = tocolor(255, 255, 0, 75),
    [2] = tocolor(255, 200, 0, 75),
    [3] = tocolor(255, 145, 0, 75),

}

function convertTimer(miliseconds)
    local seconds = math.floor(miliseconds / 1000)
    local miliseconds = math.floor(miliseconds % 1000) / 10

    return string.format("%02d sek. %02d ms.", seconds, miliseconds)
end

function refreshBoardRT(renderTarget, tbl)
    if tbl[1].bType == 'topHours' then
        dxSetRenderTarget(renderTarget, true)
            dxSetBlendMode('modulate_add')
                dxDrawImage(0, 0, 512, 324, 'tex/board.png')
                dxDrawText(tbl[1].title, 256, 35, nil, nil, tocolor(46, 117, 111, 225), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 15), 'center', 'bottom')
                dxDrawText('Najaktywniejsi gracze', 256, 35, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 9), 'center', 'top')
                
                local offset = 0
                for i, v in ipairs(tbl) do
                    local isYou = v.sid == getElementData(localPlayer, 'player:sid') and true or false
                    local color = colors[i]
                    local color2 = colors2[i]
                    dxDrawImage(85, 75 + offset, 300, 75, 'tex/bg.png', 0, 0, 0, color2)
                    dxDrawImage(15, 75 + offset, 75, 75, exports['since-avatars']:getPlayerAvatar(v.sid))
                    dxDrawImage(15, 75 + offset, 75, 75, 'tex/border.png', 0, 0, 0, color)
                    dxDrawText(i..'. '.. (isYou and v.name..' ◦' or v.name), 100, 117 + offset, nil, nil, color, 1, exports['since-fonts']:getFont('Inter-Bold', 20), 'left', 'bottom')
                    dxDrawText('↳ Posiada #2E756F'..addCommas(tonumber(v.value))..'#ffffff przegranych godzin', 100, 117 + offset, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12), 'left', 'top', false, false, false, true)
                    
                    offset = offset + 80
                end
            dxSetBlendMode('blend')
        dxSetRenderTarget()
    elseif tbl[1].bType == 'top14Mili' then
        dxSetRenderTarget(renderTarget, true)
            dxSetBlendMode('modulate_add')
                dxDrawImage(0, 0, 512, 324, 'tex/board.png')
                dxDrawText(tbl[1].title, 256, 35, nil, nil, tocolor(46, 117, 111, 225), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 15), 'center', 'bottom')
                dxDrawText('Nagroda za pierwsze miejsce wynosi: #2E756F$ 10,000,000', 256, 35, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 9), 'center', 'top', false, false, false, true)
                    
                if #tbl > 0 then
                    local offset = 0
                    for i, v in ipairs(tbl) do
                        local isYou = v.sid == getElementData(localPlayer, 'player:sid') and true or false
                        local color = colors[i]
                        local color2 = colors2[i]
                        dxDrawImage(85, 75 + offset, 300, 75, 'tex/bg.png', 0, 0, 0, color2)
                        dxDrawImage(15, 75 + offset, 75, 75, exports['since-avatars']:getPlayerAvatar(v.sid))
                        dxDrawImage(15, 75 + offset, 75, 75, 'tex/border.png', 0, 0, 0, color)
                        dxDrawText(i..'. '.. (isYou and v.name..' ◦' or v.name), 100, 117 + offset, nil, nil, color, 1, exports['since-fonts']:getFont('Inter-Bold', 20), 'left', 'bottom')
                        dxDrawText('↳ Czas: #2E756F'..convertTimer(tonumber(v.value))..'#ffffff #54a1ff('..v.vehicle..')', 100, 117 + offset, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12), 'left', 'top', false, false, false, true)
                            
                        offset = offset + 80
                    end
                else
                    dxDrawText('Brak wyników', 256, 162, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12), 'center', 'center')
                end
            dxSetBlendMode('blend')
        dxSetRenderTarget()
    elseif tbl[1].bType == 'topMoney' then
        dxSetRenderTarget(renderTarget, true)
            dxSetBlendMode('modulate_add')
                dxDrawImage(0, 0, 512, 324, 'tex/board.png')
                dxDrawText(tbl[1].title, 256, 35, nil, nil, tocolor(46, 117, 111, 225), 1, exports['since-fonts']:getFont('Inter-ExtraBold', 15), 'center', 'bottom')
                dxDrawText('Najaktywniejsi gracze z eventu', 256, 35, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 9), 'center', 'top')
                
                local offset = 0
                for i, v in ipairs(tbl) do
                    local isYou = v.sid == getElementData(localPlayer, 'player:sid') and true or false
                    local color = colors[i]
                    local color2 = colors2[i]
                    dxDrawImage(85, 75 + offset, 300, 75, 'tex/bg.png', 0, 0, 0, color2)
                    dxDrawImage(15, 75 + offset, 75, 75, exports['since-avatars']:getPlayerAvatar(v.sid))
                    dxDrawImage(15, 75 + offset, 75, 75, 'tex/border.png', 0, 0, 0, color)
                    dxDrawText(i..'. '.. (isYou and v.name..' ◦' or v.name), 100, 117 + offset, nil, nil, color, 1, exports['since-fonts']:getFont('Inter-Bold', 20), 'left', 'bottom')
                    dxDrawText('↳ Posiada #2E756F'..addCommas(tonumber(v.value))..'#ffffff przegranych godzin', 100, 117 + offset, nil, nil, tocolor(255, 255, 255, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 12), 'left', 'top', false, false, false, true)
                    
                    offset = offset + 80
                end
            dxSetBlendMode('blend')
        dxSetRenderTarget()
    end
end

function reloadBoard(board, tbl)

    if not renderTargets[board] then
        renderTargets[board] = dxCreateRenderTarget(512, 324, true)
    end

    if not shaders[board] then
        shaders[board] = dxCreateShader("shaders/tex.fx", 0, 50, false, "object")
    end

    refreshBoardRT(renderTargets[board], tbl)
			
	if renderTargets[board] and shaders[board] then
        local object = findBoardByID(board)
        if not object then return end
		dxSetShaderValue(shaders[board], "TEXTURE", renderTargets[board])
		engineApplyShaderToWorldTexture(shaders[board], "nf_blackbrd", object)
	end
end
addEvent('reloadBoard', true)
addEventHandler('reloadBoard', resourceRoot, reloadBoard)

function handleRestore()
    triggerServerEvent('reloadAllBoards', resourceRoot, localPlayer)
end
addEventHandler("onClientRestore", root, handleRestore)

function reloadShit(theKey, oldValue, newValue)
    if (getElementType(source) == "player") and source == localPlayer and (theKey == "player:spawn") then
        triggerServerEvent('reloadAllBoards', resourceRoot, localPlayer)
    end
end
addEventHandler("onClientElementDataChange", root, reloadShit)

function findBoardByID(id)
    for i, v in ipairs(getElementsByType('object', resourceRoot)) do
        if getElementModel(v) == 3077 and getElementData(v, 'board:id') and getElementData(v, 'board:id') == id then
            return v
        end
    end
end

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end
getResourceName(getThisResource(), true, 766600145); if true then return end
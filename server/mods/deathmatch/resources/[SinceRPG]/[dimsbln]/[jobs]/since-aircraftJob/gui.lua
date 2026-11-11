local sx, sy = guiGetScreenSize()
local sxh, syh = sx/2, sy/2
local zoom = ((sx < 2048) and math.min(2.2, 2048/sx) or 1) * 0.9
local textures, fonts, animations = nil, nil, nil
local saveData = {}

function renderInterface()
    dxDrawImage(sxh-450/zoom, syh-245/zoom, 900/zoom, 490/zoom, textures.background, 0, 0, 0, tocolor(255, 255, 255, 255))

    animations[1] = interpolateBetween(animations[1] or 0.7, 0, 0, isMouseIn(sxh-440/zoom, syh-235/zoom, 260/zoom, 470/zoom) and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sxh-440/zoom, syh-235/zoom, 260/zoom, 470/zoom, textures.startButton, 0, 0, 0, tocolor(255, 255, 255, 255*animations[1]))
    local isWorking = getElementData(localPlayer, 'player:job') == 'Spedycja lotnicza'
    dxDrawImage(sxh-401/zoom, syh-120/zoom, 182/zoom, 182/zoom, isWorking and textures.stopIcon or textures.startIcon, 0, 0, 0, tocolor(255, 255, 255, 255*animations[1]))
    dxDrawText(isWorking and 'Zakończ pracę' or 'Rozpocznij pracę', sxh-310/zoom, syh+78/zoom, nil, nil, tocolor(255, 255, 255, 255*animations[1]), 1, fonts[1], 'center', 'bottom')
    dxDrawText('Kliknij te pole aby przejść do wyboru poziomu pracy', sxh-310/zoom-120/zoom, syh+82/zoom, sxh-310/zoom+120/zoom, nil, tocolor(255, 255, 255, 255*animations[1]), 1, fonts[2], 'center', 'top', false, true)

    dxDrawImage(sxh-170/zoom, syh-235/zoom, 610/zoom, 210/zoom, textures.background2, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawImage(sxh+389/zoom, syh-220/zoom, 36/zoom, 36/zoom, textures.levelBg, 0, 0, 0, tocolor(255, 255, 255, 255))
    dxDrawText(saveData.stats.level, sxh+389/zoom+36/2/zoom, syh-220/zoom+36/2/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts[3], 'center', 'center')

    dxDrawText('Statystyki pracy', sxh-155/zoom, syh-200/zoom, nil, nil, tocolor(104, 214, 94, 255), 1, fonts[1], 'left', 'bottom')
    dxDrawText('Informacje o twoich postępach w pracy', sxh-155/zoom, syh-200/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts[2], 'left', 'top')

    dxDrawText('Wykonane zlecenia', sxh-155/zoom, syh-155/zoom, nil, nil, tocolor(104, 214, 94, 255), 1, fonts[5], 'left', 'bottom')
    dxDrawText('Wykonałeś #68D65E'..formatNumber(saveData.stats.points)..' zleceń', sxh-155/zoom, syh-155/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts[2], 'left', 'top', false, false, false, true)

    dxDrawText('Przepracowany czas', sxh-155/zoom, syh-110/zoom, nil, nil, tocolor(104, 214, 94, 255), 1, fonts[5], 'left', 'bottom')
    dxDrawText(formatTime(saveData.stats.time), sxh-155/zoom, syh-110/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts[2], 'left', 'top', false, false, false, true)

    dxDrawText('Poziom', sxh+50/zoom, syh-155/zoom, nil, nil, tocolor(104, 214, 94, 255), 1, fonts[5], 'left', 'bottom')
    dxDrawText('Posiadasz możliwość pracowania na #68D65E'..saveData.stats.level..' poziomie', sxh+50/zoom, syh-155/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts[2], 'left', 'top', false, false, false, true)

    dxDrawText('Zarobek', sxh+50/zoom, syh-110/zoom, nil, nil, tocolor(104, 214, 94, 255), 1, fonts[5], 'left', 'bottom')
    dxDrawText('Łączny zarobek wynosi #68D65E$ '..formatNumber(saveData.stats.earned), sxh+50/zoom, syh-110/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, fonts[2], 'left', 'top', false, false, false, true)

    dxDrawImage(sxh-155/zoom, syh-80/zoom, 580/zoom, 40/zoom, textures.barBg, 0, 0, 0, tocolor(255, 255, 255, 255))
    local progress = saveData.stats.levelExp/levels[saveData.stats.level]
    if progress > 0.00 then
        progress = math.min(progress, 1)
        dxDrawImageSection(sxh-155/zoom, syh-80/zoom, 580/zoom*progress, 40/zoom, 0, 0, 580*progress, 40, textures.bar, 0, 0, 0, tocolor(255, 255, 255, 255))
    end
    dxDrawText('Postęp EXP do poziomu '..saveData.stats.level, sxh-140/zoom, syh-80/zoom+20/zoom, nil, nil, tocolor(255, 255, 255, 225), 1, fonts[4], 'left', 'center')
    dxDrawText(saveData.stats.levelExp..'/'..levels[saveData.stats.level], sxh+410/zoom, syh-80/zoom+20/zoom, nil, nil, tocolor(165, 255, 157, 225), 1, fonts[4], 'right', 'center')

    animations[2] = interpolateBetween(animations[2] or 0.75, 0, 0, isMouseIn(sxh-170/zoom, syh-15/zoom, 300/zoom, 250/zoom) and 1 or 0.75, 0, 0, 0.1, 'Linear')
    dxDrawImage(sxh-170/zoom, syh-15/zoom, 300/zoom, 250/zoom, textures.option, 0, 0, 0, tocolor(255, 255, 255, 255*animations[2]))
    if saveData.selected == 1 then
        dxDrawImage(sxh-170/zoom, syh-15/zoom, 300/zoom, 250/zoom, textures.optionSelected, 0, 0, 0, tocolor(255, 255, 255, 255*animations[2]))
        dxDrawImage(sxh-95/zoom, syh+10/zoom, 150/zoom, 150/zoom, textures.planeIcon, 0, 0, 0, tocolor(104, 214, 94, 255*animations[2]))
    else
        dxDrawImage(sxh-95/zoom, syh+10/zoom, 150/zoom, 150/zoom, textures.planeIcon, 0, 0, 0, tocolor(255, 255, 255, 255*animations[2]))
    end
    dxDrawText('Kliknij aby wybrać pracę samolotem', sxh-170/zoom, syh+180/zoom, sxh+130/zoom, nil, tocolor(215, 215, 215, 215*animations[2]), 1, fonts[1], 'center', 'center', false, true)

    animations[3] = interpolateBetween(animations[3] or 0.75, 0, 0, isMouseIn(sxh+140/zoom, syh-15/zoom, 300/zoom, 250/zoom) and 1 or 0.75, 0, 0, 0.1, 'Linear')
    dxDrawImage(sxh+140/zoom, syh-15/zoom, 300/zoom, 250/zoom, textures.option, 0, 0, 0, tocolor(255, 255, 255, 255*animations[3]))
    if saveData.selected == 2 then
        dxDrawImage(sxh+140/zoom, syh-15/zoom, 300/zoom, 250/zoom, textures.optionSelected, 0, 0, 0, tocolor(255, 255, 255, 255*animations[3]))
        dxDrawImage(sxh+215/zoom, syh+10/zoom, 150/zoom, 150/zoom, textures.heliIcon, 0, 0, 0, tocolor(104, 214, 94, 255*animations[3]))
    else
        dxDrawImage(sxh+215/zoom, syh+10/zoom, 150/zoom, 150/zoom, textures.heliIcon, 0, 0, 0, tocolor(255, 255, 255, 255*animations[3]))
    end
    dxDrawText('Kliknij aby wybrać pracę helikopterem', sxh+140/zoom, syh+180/zoom, sxh+440/zoom, nil, tocolor(215, 215, 215, 215*animations[3]), 1, fonts[1], 'center', 'center', false, true)

    if saveData.marker then
        if isElement(saveData.marker) then
            local x,y,z = getElementPosition(localPlayer)
            local x2,y2,z2 = getElementPosition(saveData.marker)
            if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 3 then
                changeGuiState(false)
            end
        end
    end
end

function clickOnInterface(button, state)
    if button ~= 'left' or state ~= 'down' then
        return
    end
    if not saveData.clickTick then saveData.clickTick = getTickCount() end
    if saveData.clickTick > getTickCount() then return end
    saveData.clickTick = getTickCount() + 100
    if isMouseIn(sxh-170/zoom, syh-15/zoom, 300/zoom, 250/zoom) then
        saveData.selected = 1
    elseif isMouseIn(sxh+140/zoom, syh-15/zoom, 300/zoom, 250/zoom) then
        saveData.selected = 2
    elseif isMouseIn(sxh-440/zoom, syh-235/zoom, 260/zoom, 470/zoom) then
        if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'Spedycja lotnicza' then
            triggerServerEvent('onPlayerStartEnd', resourceRoot)
            setElementData(localPlayer, 'player:job', nil)
            changeGuiState(false)
            exports['since-notifications']:sendNotification('success', 'Pomyślnie zakończyłeś pracę Specycji lotniczej!')
            return
        end
        if getElementData(localPlayer, 'player:job') then
            exports['since-notifications']:sendNotification('error', 'Posiadasz już aktywną pracę!')
            changeGuiState(false)
            return
        end
        if saveData.selected then
            if getElementData(localPlayer, 'player:srp') < srp then 
                exports['since-notifications']:sendNotification('error', 'Nie posiadasz 10000 SRP!')
                return
            end
            triggerServerEvent('onPlayerStartJob', resourceRoot, saveData.selected)
            setElementData(localPlayer, 'player:job', 'Spedycja lotnicza')
            changeGuiState(false)
            exports['since-notifications']:sendNotification('success', 'Pomyślnie rozpocząłeś pracę Specycji lotniczej!')
        else
            exports['since-notifications']:sendNotification('error', 'Aby rozpocząć pracę wybierz pojazd!')
        end
    end
end

function refresh()
    local job = 'Aircraft'
	saveData.stats = getElementData(localPlayer, 'player:jobStats') and getElementData(localPlayer, 'player:jobStats')[job] or {
		earned = 0,
		time = 0,
		points = 0,
		upgrades = {},
	}
	if not saveData.stats.earned then saveData.stats.earned = 0 end
	if not saveData.stats.time then saveData.stats.time = 0 end
    if not saveData.stats.level then saveData.stats.level = 1 end
    if not saveData.stats.levelExp then saveData.stats.levelExp = 0 end
	if not saveData.stats.points then saveData.stats.points = 0 end
	if not saveData.stats.upgrades then saveData.stats.upgrades = {} end
end

function createGuiElements()

    textures = {}

    for i,v in ipairs({'background', 'background2', 'bar', 'barBg', 'heliIcon', 'levelBg', 'option', 'optionSelected', 'planeIcon', 'startButton', 'startIcon', 'stopIcon'}) do
        if fileExists('files/images/'..v..'.png') then
            textures[v] = dxCreateTexture('files/images/'..v..'.png')
        end
    end

    fonts = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
        [3] = exports['since-fonts']:getFont('Inter-Black', 15/zoom),
        [4] = exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Bold', 13/zoom),
    }
    
    animations = {}

    saveData = {}

    saveData.progress = 0.25
    saveData.selected = nil

end

function destroyGuiElements()

    for i,v in ipairs(getElementsByType('texture', resourceRoot)) do
        destroyElement(v)
    end

    textures, fonts, animations, saveData = nil, nil, nil, nil

end

function changeGuiState(state, marker)
    if state then
        createGuiElements()
        saveData.marker = marker
        refresh()
        addEventHandler('onClientRender', root, renderInterface)
        addEventHandler('onClientClick', root, clickOnInterface)
        showCursor(true, false)
    else
        removeEventHandler('onClientRender', root, renderInterface)
        removeEventHandler('onClientClick', root, clickOnInterface)
        destroyGuiElements()
        showCursor(false)
    end
end
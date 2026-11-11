local songs = {}
local data = {

    actualSong = 'Brak',
    play = nil,

}
local stereo = {}
local uiElements = {}
local toggle = false
local toggleState = true

local k = 1
local n = 6
local m = 6

local volume = 0.5

function renderUI()
    exports['since-blur']:dxDrawBlur(sx/2 - 367/zoom, sy/2 - 164/zoom, 734/zoom, 328/zoom, textures.mask)
	dxDrawImage(sx/2 - 367/zoom, sy/2 - 164/zoom, 734/zoom, 328/zoom, 'data/bg.png')

    local isIn = isMouseIn(sx/2 + 326/zoom, sy/2 - 142/zoom, 20/zoom, 20/zoom)
	dxDrawImage(sx/2 + 326/zoom, sy/2 - 142/zoom, 20/zoom, 20/zoom, 'data/close.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 175 or 255))

	dxDrawText('Stereo', sx/2 - 352/zoom, sy/2 - 128/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom')
	dxDrawText('Panel odtwarzania muzyki', sx/2 - 352/zoom, sy/2 - 129/zoom, nil, nil, tocolor(128, 241, 118, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'left', 'top')

	dxDrawImage(sx/2 - 346/zoom, sy/2 - 99/zoom, 692/zoom, 2/zoom, 'data/line_top.png')
	dxDrawImage(sx/2, sy/2 - 97/zoom, 2/zoom, 234/zoom, 'data/line_center.png')

	dxDrawText('Lista utworów', sx/2 + 9/zoom, sy/2 - 73/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'left', 'bottom')
	dxDrawText('Zapisane utwory', sx/2 + 9/zoom, sy/2 - 74/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'left', 'top')
	dxDrawText('Odtwarzanie', sx/2 - 7/zoom, sy/2 - 73/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'right', 'bottom')
	dxDrawText('Zarządzaj odtwarzaniem', sx/2 - 7/zoom, sy/2 - 74/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'right', 'top')
	dxDrawText('Dodawanie utworu', sx/2 - 7/zoom, sy/2 + 78/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 10/zoom), 'right', 'bottom')
	dxDrawText('Dodaj swój utwór do listy utworów!', sx/2 - 7/zoom, sy/2 + 77/zoom, nil, nil, tocolor(255, 255, 255, 229), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'right', 'top')

    local offset = 0
    for i,v in ipairs(songs) do
        if i >= k and i <= n then 
            dxDrawImage(sx/2 + 10/zoom, sy/2 - 49/zoom + offset, 336/zoom, 30/zoom, 'data/song_bg.png', 0, 0, 0, data.play == i and tocolor(125, 255, 125, 255) or tocolor(255, 255, 255, 255))
            dxDrawImage(sx/2 + 20/zoom, sy/2 - 42/zoom + offset, 14/zoom, 14/zoom, 'data/song_icon.png')

            local isIn = isMouseIn(sx/2 + 322/zoom, sy/2 - 44/zoom + offset, 18/zoom, 18/zoom)
            dxDrawImage(sx/2 + 322/zoom, sy/2 - 44/zoom + offset, 18/zoom, 18/zoom, data.play == i and 'data/stop_icon.png' or 'data/play_icon.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 175 or 255))

            local isIn = isMouseIn(sx/2 + 305/zoom, sy/2 - 41/zoom + offset, 12/zoom, 12/zoom)
            dxDrawImage(sx/2 + 305/zoom, sy/2 - 41/zoom + offset, 12/zoom, 12/zoom, 'data/off.png', 0, 0, 0, tocolor(255, 100, 100, isIn and 175 or 255))

            dxDrawText(v.name, sx/2 + 41/zoom, sy/2 - 33.5/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 8/zoom), 'left', 'bottom')
            dxDrawText('Data dodania: #7dff7d'..v.added, sx/2 + 41/zoom, sy/2 - 33.5/zoom + offset, nil, nil, tocolor(255, 255, 255, 175), 1, exports['since-fonts']:getFont('Inter-Medium', 7/zoom), 'left', 'top', false, false, false, true)

            offset = offset + 30/zoom + 2
        end
    end

    drawScrollbar(songs, sx/2 + 350/zoom, sy/2 - 49/zoom, 2, 195/zoom, m, k, 225)
    
	dxDrawImage(sx/2 - 108/zoom, sy/2 - 50/zoom, 100/zoom, 100/zoom, 'data/album_bg.png')
	dxDrawText(data.actualSong, sx/2 - 115/zoom, sy/2 - 30/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom), 'right', 'bottom')
	dxDrawText('Aktualnie odtwarzane', sx/2 - 115/zoom, sy/2 - 30/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 8/zoom), 'right', 'top')
	dxDrawText('0', sx/2 - 305/zoom, sy/2 + 4/zoom, nil, nil, tocolor(255, 255, 255, 191), 1, exports['since-fonts']:getFont('Inter-SemiBold', 7/zoom), 'left', 'top')
	dxDrawText('100', sx/2 - 115/zoom, sy/2 + 4/zoom, nil, nil, tocolor(255, 255, 255, 191), 1, exports['since-fonts']:getFont('Inter-SemiBold', 7/zoom), 'right', 'top')
	dxDrawText('Głośność', sx/2 - 209.5/zoom, sy/2 + 4/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, exports['since-fonts']:getFont('Inter-SemiBold', 6/zoom), 'center', 'top')
	dxDrawImage(sx/2 - 91/zoom, sy/2 - 33/zoom, 66/zoom, 66/zoom, 'data/album_cover.png')

    local isIn = isMouseIn(sx/2 - 52/zoom, sy/2 + 97/zoom, 44/zoom, 44/zoom)
	dxDrawImage(sx/2 - 52/zoom, sy/2 + 97/zoom, 44/zoom, 44/zoom, 'data/add_bg.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))
	dxDrawImage(sx/2 - 40/zoom, sy/2 + 109/zoom, 20/zoom, 20/zoom, 'data/add_icon.png', 0, 0, 0, tocolor(255, 255, 255, isIn and 200 or 255))

    local veh = getPedOccupiedVehicle(localPlayer)

    if not veh then
        toggleUI(false)
        toggle = false
    else
        if stereo[veh] then
            local value = exports['since-scrollbar']:getScrollProgress(uiElements['progressbar'])
            value = math.floor(value)
            if getElementData(veh, "vehicle:volume") ~= value/150 then
                setSoundVolume(stereo[veh], value/150)
                setElementData(veh, "vehicle:volume", value/150)
            end
        end
    end
end

function isPanelOpened()
    return toggle
end

function onClick(button, state)
    if button == 'left' and state == 'down' then
        if isMouseIn(sx/2 + 326/zoom, sy/2 - 142/zoom, 20/zoom, 20/zoom) then
            toggleUI(false)
            toggle = false
        end

        if isMouseIn(sx/2 - 52/zoom, sy/2 + 97/zoom, 44/zoom, 44/zoom) then
            local link = exports['since-gui']:getEditboxText(uiElements['editbox2'])
            local name = exports['since-gui']:getEditboxText(uiElements['editbox'])

            if link and name then
                if #link > 3 and #name > 3 then
                    triggerServerEvent('addSong', resourceRoot, name, link)

                    setTimer(function()
                        triggerServerEvent('returnSoundList', resourceRoot, localPlayer)
                    end, 100, 1)
                end
            end
        end

        local offset = 0
        for i,v in ipairs(songs) do
            if i >= k and i <= n then 
                if isMouseIn(sx/2 + 305/zoom, sy/2 - 41/zoom + offset, 12/zoom, 12/zoom) then
                    triggerServerEvent('deleteSong', resourceRoot, v.link, v.name)

                    setTimer(function()
                        triggerServerEvent('returnSoundList', resourceRoot, localPlayer)
                    end, 100, 1)
                end

                if isMouseIn(sx/2 + 324/zoom, sy/2 - 42/zoom + offset, 14/zoom, 14/zoom) then
                    local veh = getPedOccupiedVehicle(localPlayer)
        
                    if veh then
                        if data.play ~= i then
                            data.play = nil
                            data.actualSong = "Brak"
                            setElementData(veh, "vehicle:stereo", false)
                            data.play = i
                            data.actualSong = v.name
                            setElementData(veh, "vehicle:link", tostring(v.link))
                            setElementData(veh, "vehicle:stereo", true)
                        elseif data.play == nil then
                            data.play = i
                            data.actualSong = v.name
                            setElementData(veh, "vehicle:link", tostring(v.link))
                            setElementData(veh, "vehicle:stereo", true)
                        elseif stereo[source] == nil then
                            data.play = nil
                            data.actualSong = "Brak"
                            setElementData(veh, "vehicle:link", nil)
                            setElementData(veh, "vehicle:stereo", false)
                        end
                    end
                end

                offset = offset + 30/zoom + 2
            end
        end
    end
end

addEventHandler("onClientElementDataChange", root, function(data,_)
	if getElementType(source) == "vehicle" then
        if data == "vehicle:stereo" and toggleState then
            local data_tog = getElementData(source, data)
            if data_tog == true then
                local songURL = (getElementData(source,"vehicle:link") or "")
                if songURL:find('youtube') then
                    stereo[source] = playSound3D('https://ytdl-s742.onrender.com/ytdl?key=maKQafRFmw&url='..songURL, 0, 0, 0, false)
                else
                    stereo[source] = playSound3D(songURL, 0, 0, 0, false)
                end

                setSoundVolume(stereo[source], math.min(getElementData(source, "vehicle:volume") or 0.5, 0.66))
                setSoundEffectEnabled(stereo[source], "compressor", true)
                setSoundMaxDistance(stereo[source], 35)
                setElementDimension(stereo[source], getElementDimension(source))
                setElementInterior(stereo[source], getElementInterior(source))
                attachElements(stereo[source], source)
            else
                if stereo[source] then
                    stopSound(stereo[source])
                    stereo[source] = nil
                end 
            end
        elseif data == "vehicle:volume" then
            if stereo[source] then
                setSoundVolume(stereo[source], math.min(getElementData(source, "vehicle:volume") or 0.5, 0.66))
            end
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) ~= "vehicle" then return end
	if not stereo[source] and toggleState then
		local data_tog = getElementData(source,"vehicle:stereo")
		if data_tog == true then
			local songURL = (getElementData(source,"vehicle:link") or "")
            if songURL:find('youtube') then
                stereo[source] = playSound3D('https://ytdl-s742.onrender.com/ytdl?key=maKQafRFmw&url='..songURL, 0, 0, 0, false)
            else
                stereo[source] = playSound3D(songURL, 0, 0, 0, false)
            end
			setSoundVolume(stereo[source], math.min(getElementData(source, "vehicle:volume") or 0.5, 0.66))
			setSoundEffectEnabled(stereo[source], "compressor",true)
			setSoundMaxDistance(stereo[source], 35)
			setElementDimension(stereo[source], getElementDimension(source))
			setElementInterior(stereo[source], getElementInterior(source))
			attachElements(stereo[source], source)
		end
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) == "vehicle" then
		local data_tog = getElementData(source, "vehicle:stereo")
		if data_tog == true then
		    if stereo[source] then
		        stopSound(stereo[source])

                stereo[source] = nil
            end
        end
	end
end)

function loadSounds(tbl)
    songs = tbl
end
addEvent('returnSoundList', true)
addEventHandler('returnSoundList', resourceRoot, loadSounds)

function toggleUI(visible)
    local veh = getPedOccupiedVehicle(localPlayer)
    local eventCallback = visible and addEventHandler or removeEventHandler

    if visible then
        uiElements['progressbar'] = exports['since-scrollbar']:createScrollbar(sx/2 - 305/zoom, sy/2 - 10/zoom, 188/zoom, 6/zoom, {255, 255, 255}, true, 0, false, false, 255)
        uiElements['editbox'] = exports['since-gui']:createEditbox('Wprowadź link do utworu...', sx/2 - 348/zoom, sy/2 + 95/zoom, 292/zoom, 25/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 30/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 7/zoom),
            image = textures.editbox,
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[@!#$%^&*()?<>].*',
            passworded = false,
            caretHeight = 10/zoom,
            maxChars = 120,
            icon = textures.iconLink,
            iconPadding = 7/zoom,
            textColor = {255, 255, 255, 200},
        })

        uiElements['editbox2'] = exports['since-gui']:createEditbox('Wprowadź nazwę utworu...', sx/2 - 348/zoom, sy/2 + 122/zoom, 292/zoom, 25/zoom, {255, 255, 255}, {
            alignX = 'left',
            paddingX = 30/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 7/zoom),
            image = textures.editbox,
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[@!#$%^&*()?<>].*',
            passworded = false,
            caretHeight = 10/zoom,
            icon = textures.iconLink,
            iconPadding = 7/zoom,
            maxChars = 120,
            space = true,
            textColor = {255, 255, 255, 200},
        })

        triggerServerEvent('returnSoundList', resourceRoot, localPlayer)

        if stereo[getPedOccupiedVehicle(localPlayer)] then
            local volume = getSoundVolume(stereo[getPedOccupiedVehicle(localPlayer)]) or 100
            exports['since-scrollbar']:setScrollProgress(uiElements['progressbar'], volume*150)
        else
            exports['since-scrollbar']:setScrollProgress(uiElements['progressbar'], 100)
        end
    else
        exports['since-scrollbar']:destroyScroll(uiElements['progressbar'])

        if (uiElements['editbox']) then
            exports['since-gui']:destroyUIElement(uiElements['editbox'])
        end

        if (uiElements['editbox2']) then
            exports['since-gui']:destroyUIElement(uiElements['editbox2'])
        end
    end

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
    showCursor(visible)
end

bindKey('F6', 'down', function()
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh and getVehicleController(veh) == localPlayer then
        if getVehicleUpgradeOnSlot(veh, 10) == 1086 then
            if not toggle then
                toggleUI(true)
                toggle = true
            else
                toggleUI(false)
                toggle = false
            end
        end
    end
end)

function turnStereoOn()
    local vehicles = getElementsByType("vehicle")

    for i,v in pairs(vehicles) do
        if isElementStreamedIn(v) and getElementData(v, "vehicle:stereo") and not stereo[v] then
            local songURL = (getElementData(v,"vehicle:link") or "")
            if songURL:find('youtube') then
                stereo[v] = playSound3D('https://ytdl-s742.onrender.com/ytdl?key=maKQafRFmw&url='..songURL, 0, 0, 0, false)
            else
                stereo[v] = playSound3D(songURL, 0, 0, 0, false)
            end

            setSoundVolume(stereo[v], math.min(getElementData(v, "vehicle:volume") or 0.5, 0.66))
            setSoundEffectEnabled(stereo[v], "compressor", true)
            setSoundMaxDistance(stereo[v], 35)
            setElementDimension(stereo[v], getElementDimension(v))
            setElementInterior(stereo[v], getElementInterior(v))
            attachElements(stereo[v], v)
        end
    end
end

function changeStereoToggle(state)
    if not state then
        for i,v in pairs(stereo) do
            local sound = v

            if sound and stereo[i] then
                stopSound(sound)
                stereo[i] = nil
            end
        end
    else
        turnStereoOn()
    end

    toggleState = state
end

function drawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(100, 255, 100,alpha*0.2))

	if #table > m_ then
    	local scrollbarHeight = height/#table

   		if k_ == 1 then 
        	scrollbarPos = y
    	elseif k_ > 0 then 
        	scrollbarPos = ((k_)*scrollbarHeight)+y
    	end

    	if #table <= m_ then 
        	scrollbarHeight = height
    	end
		
        dxDrawRoundedRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), w/2, tocolor(100, 255, 100, alpha))
    else
        dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(100, 255, 100, alpha))
	end
end

bindKey("mouse_wheel_down", "both", function()
    if toggle then
        scrollUp()
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if toggle then
        scrollDown()
    end
end)

function scrollDown()
    if n == m then return end
    k = k-1
    n = n-1
end

function scrollUp()
    if n >= #songs then return end
    k = k+1
    n = n+1
end

getResourceName(getThisResource(), true, 378362265); if true then return end
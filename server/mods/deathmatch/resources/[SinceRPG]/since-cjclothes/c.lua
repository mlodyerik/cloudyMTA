  

local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local data = {
    togglePanel = false,
    scrollPos = {k=1, m=7, n=7},
    markerPos = createMarker(2119.52, -1205.56, 23.99-1, "cylinder", 2, 125, 255, 125, 55),
    fonts = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 16/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
		[3] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
		[4] = exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom),
	},
    textures = {},
	page = "settings",
	my = {},
	save = {},
}

function checkIsHaveIt(info)
	for i,v in ipairs(data.my) do
		if v[1] == info[1] then
			if v[2] == info[2] and v[3] == info[3] then
				return true
			end
		end
		if i == #data.my then
			return false
		end
	end
end

function renderWindow()
    local anim = data.anim[1]
	if getKeyState("mouse2") then showCursor(false) else showCursor(true) end

    exports['since-blur']:dxDrawBlur(sx-420/zoom, sy/2-265/zoom, 400/zoom, 530/zoom, data.textures['bg_mask'], anim)
    dxDrawImage(sx-420/zoom, sy/2-265/zoom, 400/zoom, 530/zoom, data.textures['bg'], 0, 0, 0, tocolor(255, 255, 255, anim))

    local isIn = isMouseIn(sx-52/zoom, sy/2-257/zoom, 24/zoom, 24/zoom)
    data.anim[2] = interpolateBetween(data.anim[2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx-50/zoom, sy/2-255/zoom, 20/zoom, 20/zoom, data.textures['close'], 0, 0, 0, tocolor(255, 255, 255, anim*data.anim[2]))

	local info = data.page == "posiadane" and data.my or clothes[data.page]

    drawScrollbar(info, sx-30/zoom, sy/2-200/zoom, 3/zoom, 448/zoom, data.scrollPos.m, data.scrollPos.k, anim)

	dxDrawText('Przebieralnia CJa', sx-403/zoom, sy/2-228/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, data.fonts[1], 'left', 'bottom')
    dxDrawText('LEWY PRZYCISK MYSZY, aby poruszyć kamerą', sx-403/zoom, sy/2-228/zoom, nil, nil, tocolor(46, 117, 111, anim), 1, data.fonts[2], 'left', 'top')

	if data.page ~= 'settings' then
		local isIn = isMouseIn(sx-82/zoom, sy/2-257/zoom, 24/zoom, 24/zoom)
		data.anim[3] = interpolateBetween(data.anim[3], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
		dxDrawImage(sx-80/zoom, sy/2-255/zoom, 20/zoom, 20/zoom, data.textures['arrow'], 0, 0, 0, tocolor(255, 255, 255, anim*data.anim[3]))
	end

    local x = 0
    for i,v in ipairs(info) do
        if i >= data.scrollPos.k and i <= data.scrollPos.n then 
            x = x + 1
            local offset = ((x-1) * (65/zoom))
            dxDrawImage(sx-405/zoom, sy/2-200/zoom+offset, 370/zoom, 60/zoom, data.textures['bg2'], 0, 0, 0, tocolor(255, 255, 255, anim))

            dxDrawImage(sx-395/zoom, sy/2-190/zoom+offset, 40/zoom, 40/zoom, data.textures['tshirt'], 0, 0, 0, tocolor(255, 255, 255, anim))

			local hasThis = nil

            local text, cost =  v[1], 'kliknij aby przejść dalej'
			if data.page == "settings" or data.page == "tatuaze" or data.page == "bizuteria" or data.page == "miesnie" or data.page == "grubosc" then
			else
				hasThis = checkIsHaveIt(v)
				text, cost = v[4], hasThis and 'Posiadasz' or 'Cena: #84FF79$ #FFFFFF'..formatNumber(v[5])..''
			end
            local textWidth = dxGetTextWidth(text, 1, data.fonts[3])
            dxDrawText(text, sx-345/zoom, sy/2-166/zoom+offset, nil, nil, tocolor(255, 255, 255, anim), 1, data.fonts[3], 'left', 'bottom')
            dxDrawText(cost, sx-345/zoom, sy/2-166/zoom+offset, nil, nil, tocolor(255, 255, 255, anim), 1, data.fonts[2], 'left', 'top',false,false,false,true)

			if tonumber(data.page) or data.page == 'miesnie' or data.page == 'grubosc' then

				if isMouseIn(sx-125/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
					dxDrawImage(sx-125/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, data.textures['button_1'], 0, 0, 0, tocolor(255, 255, 255, (anim*255)*200))
				else
					dxDrawImage(sx-125/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, data.textures['button_1'], 0, 0, 0, tocolor(255, 255, 255, anim))
				end

				if isMouseIn(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
					dxDrawImage(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, (data.page == 'miesnie' or data.page == 'grubosc' or hasThis or v[5] == 0) and data.textures['button_3'] or data.textures['button_2'], 0, 0, 0, tocolor(255, 255, 255, (anim*255)*200))
				else
					dxDrawImage(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, (data.page == 'miesnie' or data.page == 'grubosc' or hasThis or v[5] == 0) and data.textures['button_3'] or data.textures['button_2'], 0, 0, 0, tocolor(255, 255, 255, anim))
				end
			else

				if isMouseIn(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
					dxDrawImage(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, data.textures['button_1'], 0, 0, 0, tocolor(255, 255, 255, (anim*255)*200))
				else
					dxDrawImage(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, data.textures['button_1'], 0, 0, 0, tocolor(255, 255, 255, anim))
				end

			end
        end
    end

    if data.marker then
        if isElement(data.marker) then
            local x,y,z = getElementPosition(localPlayer)
            local x2,y2,z2 = getElementPosition(data.marker)
            if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 3 then
                if not data.block then
                    closeWindow(localPlayer)
                end
            end
        end
    end
end

local click = getTickCount()
function onClick(btn, state)
    if btn == 'left' and state == 'down' and data.togglePanel == true and getTickCount()>click then
		click = getTickCount()+500
        if isMouseIn(sx-50/zoom, sy/2-255/zoom, 20/zoom, 20/zoom) then
            closeWindow(localPlayer)

		elseif isMouseIn(sx-85/zoom, sy/2-260/zoom, 30/zoom, 30/zoom) and data.page ~= 'settings' then
			data.page = tonumber(data.page) and data.last or 'settings'
			data.scrollPos = {k=1, m=7, n=7}

        elseif isMouseIn(sx-405/zoom, sy/2-200/zoom, 370/zoom, 460/zoom) then
			local info = data.page == "posiadane" and data.my or clothes[data.page]
			local x = 0
            for i,v in ipairs(info) do
                if i >= data.scrollPos.k and i <= data.scrollPos.n then 
                    x = x + 1
                    local offset = ((x-1) * (65/zoom))
                    if isMouseIn(sx-125/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
						if tonumber(data.page) or data.page == 'miesnie' or data.page == 'grubosc' then
							if data.page == 'miesnie' then
								triggerServerEvent("since-cjclothes:try", resourceRoot, {23, v[3]})
							elseif data.page == 'grubosc' then
								triggerServerEvent("since-cjclothes:try", resourceRoot, {21, v[3]})
							else
								if v[2] then
									addPedClothes(localPlayer, v[2],v[3],v[1])
								else
									removePedClothes(localPlayer, v[1])
								end
							end
						end

                    elseif isMouseIn(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
						if not tonumber(data.page) and data.page ~= 'miesnie' and data.page ~= 'grubosc' and data.page ~= 'posiadane' then 
							data.last = data.page
							if v[2] == false then
								if v[1] == "Tatuaże" then
									data.page = "tatuaze"
								end
								if v[1] == "Biżuteria" then
									data.page = "bizuteria"
								end
							elseif v[2] == true then
								data.page = "posiadane"
							elseif v[2] == "miesnie" then
								data.page = "miesnie"
							elseif v[2] == "grubosc" then
								data.page = "grubosc"	
							else
								data.page = v[2]
							end
							data.scrollPos = {k=1, m=7, n=7}
						else
							if data.page == 'miesnie' or data.page == 'grubosc' then
								triggerServerEvent("buy:setPlayerStat", resourceRoot,v[2],v[3])
								data.savePostura[v[2]] = v[3]
							else
								if checkIsHaveIt(v) then
									triggerServerEvent("buy:clothes", resourceRoot,v[1],v[2],v[3],v[4],v[5])
									data.save[v[1]+1] = {v[2],v[3]}
								else
									iprint(v)
									if getPlayerMoney(localPlayer) >= tonumber(v[5]) then	
										triggerServerEvent("buy:clothes", resourceRoot,v[1],v[2],v[3],v[4],v[5])
										data.save[v[1]+1] = {v[2],v[3]}
									else
										exports['since-notifications']:sendNotification('error', 'Nie posiadasz wymaganych środków przy sobie!')
									end
								end
							end
						end
                    end
                end
            end

        end
    end
end

addEvent("since-cjclothes:get", true)
addEventHandler("since-cjclothes:get", resourceRoot, function(tbl)
	data.my = tbl
end)

function openWindow(el)
    if el ~= getLocalPlayer() or data.block or isEventHandlerAdded('onClientRender', root, renderWindow) then return end
	if getElementModel(localPlayer) ~= 0 then
		exports['since-notifications']:sendNotification('error', 'Możesz przebierać tylko Cja (skin id 0)')
		return
	end
    data.block = true
    data.togglePanel = true
    data.anim = {0,0,0}
    data.scrollPos = {k=1, m=7, n=7}
    data.textures = {}
    for i,v in ipairs({'bg','bg2','bg_mask','button_1','button_2','button_3','close','tshirt','arrow'}) do
        if fileExists('data/'..v..'.png') then
            data.textures[v] = dxCreateTexture('data/'..v..'.png', 'argb', false, 'clamp')
        end
    end

    data.marker = source
	data.page = "settings"
	data.my = {}
	data.buy = {}
	triggerServerEvent("since-cjclothes:get", resourceRoot)
	data.save = {}
	data.savePostura = {
		[21] = getPedStat(localPlayer, 21),
		[23] = getPedStat(localPlayer, 23),
	}
	for i=1,19 do
		local texture, model = getPedClothes(localPlayer, i-1)
		data.save[i] = {texture, model}
	end
	
    showCursor(true)
    addEventHandler("onClientRender", root, renderWindow)
    animate(0, 255, 2, 300, function(value)
        data.anim[1] = value
    end, function()
        addEventHandler('onClientClick', root, onClick)
        bindKey("mouse_wheel_down", "both", scrollUp)
        bindKey("mouse_wheel_up", "both", scrollDown)
        data.block = nil
    end)

end

function closeWindow(el)
    if el ~= getLocalPlayer() or not data.togglePanel or data.block or not isEventHandlerAdded('onClientRender', root, renderWindow) then return end

    data.block = true

    removeEventHandler('onClientClick', root, onClick)
    showCursor(false)
    unbindKey("mouse_wheel_down", "both", scrollUp)
    unbindKey("mouse_wheel_up", "both", scrollDown)

    animate(data.anim[1], 0, 2, 300, function(value)
        data.anim[1] = value
    end, function()
        removeEventHandler('onClientRender', root, renderWindow)
		showCursor(false)

        for i,v in pairs(data.textures) do
            if isElement(v) then 
                destroyElement(v) 
            end
        end
        data.textures = {}
        data.anim = nil
        data.marker = nil
        data.togglePanel = nil
        data.block = nil

		for i,v in ipairs(data.save) do
			if v[1] then
				addPedClothes(localPlayer, v[1], v[2], i-1)
			else
				removePedClothes(localPlayer, i-1)     
			end
		end

		triggerServerEvent("since-cjclothes:try", resourceRoot, {21, data.savePostura[21]})
		triggerServerEvent("since-cjclothes:try", resourceRoot, {23, data.savePostura[23]})

    end)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    addEventHandler("onClientMarkerHit", data.markerPos, openWindow)
    addEventHandler("onClientMarkerLeave", data.markerPos, closeWindow)

    setElementData(data.markerPos, "marker:title", "Przebieralnia CJ'a")
    setElementData(data.markerPos, "marker:desc", "Ubierz CJ'a!")
    setElementData(data.markerPos, "marker:icon", "tshirt")
    setElementInterior(data.markerPos, 0)
end)

function scrollDown()
    if not isEventHandlerAdded('onClientRender', root, renderWindow) then return end
    if data.scrollPos.n == data.scrollPos.m then return end
    data.scrollPos.k = data.scrollPos.k-1
    data.scrollPos.n = data.scrollPos.n-1
end

function scrollUp()
    if not isEventHandlerAdded('onClientRender', root, renderWindow) then return end
	local info = data.page == "posiadane" and data.my or clothes[data.page]
    if data.scrollPos.n >= #info then return end
    data.scrollPos.k = data.scrollPos.k+1
    data.scrollPos.n = data.scrollPos.n+1
end

function isMouseIn( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function drawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(46, 117, 111,alpha*0.2))

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
		
        dxDrawRoundedRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), w/2, tocolor(46, 117, 111, alpha))
    else
        dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(46, 117, 111, alpha))
	end
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 32, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 32, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 32, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 32, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1 %2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end

local anims, builtins = {}, {"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic", "OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", "InOutBounce", "OutInBounce", "SineCurve", "CosineCurve"}

function table.find(t, v)
	for k, a in ipairs(t) do
		if a == v then
			return k
		end
	end
	return false
end

function animate(f, t, easing, duration, onChange, onEnd)
	assert(type(f) == "number", "Bad argument @ 'animate' [expected number at argument 1, got "..type(f).."]")
	assert(type(t) == "number", "Bad argument @ 'animate' [expected number at argument 2, got "..type(t).."]")
	assert(type(easing) == "string" or (type(easing) == "number" and (easing >= 1 or easing <= #builtins)), "Bad argument @ 'animate' [Invalid easing at argument 3]")
	assert(type(duration) == "number", "Bad argument @ 'animate' [expected number at argument 4, got "..type(duration).."]")
	assert(type(onChange) == "function", "Bad argument @ 'animate' [expected function at argument 5, got "..type(onChange).."]")
	table.insert(anims, {from = f, to = t, easing = table.find(builtins, easing) and easing or builtins[easing], duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
	return #anims
end

function destroyAnimation(a)
	if anims[a] then
		table.remove(anims, a)
	end
end

addEventHandler("onClientRender", root, function( )
	local now = getTickCount( )
	for k,v in ipairs(anims) do
		v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
		if now >= v.start+v.duration then
			if type(v.onEnd) == "function" then
				v.onEnd( )
			end
			table.remove(anims, k)
		end
	end
end)

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
getResourceName(getThisResource(), true, 754348488); if true then return end
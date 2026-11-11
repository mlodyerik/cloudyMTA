local peds = {
	{13, 1506.26, -1628.68, 13.54, 130, 'DEALER', 'dealer_idle'},
}

for i,v in ipairs(peds) do
	if i == 2 then
    	myPed = createPed(v[1], v[2], v[3], v[4], v[5])
    	setElementFrozen(myPed, true)
    	setElementDimension(myPed, 0)
		if v[6] == false then
            --
		else
    		setPedAnimation(myPed, v[6], v[7], -1, true, false)
		end
	else
    	local ped = createPed(v[1], v[2], v[3], v[4], v[5])
    	setElementFrozen(ped, true)
    	setElementDimension(ped, 0)
		if v[6] == false then

		else
    		setPedAnimation(ped, v[6], v[7], -1, true, false)
		end
	end
end  

local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local data = {

    togglePanel = false,
    scrollPos = {k=1, m=7, n=7},
    markerPos = createMarker(1505.59, -1629.36, 13.54-1, "cylinder", 1.5, 255, 255, 125, 55),
    fonts = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 16/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
		[3] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
		[4] = exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom),
	},
    textures = {},
}

local skins = {

    {0, "Skin domyślny", 0},
    {13, 'Mikołaj', 0},
    {20, 'Milutki', 0},
    {31, 'marek3', 0},
    {95, 'Mikołajka', 0},

}

function addSkins(ids)
    skins = {

        {0, "Skin domyślny", 0},
        {13, 'Mikołaj', 0},
        {20, 'Milutki', 0},
        {31, 'marek3', 0},
        {95, 'Mikołajka', 0},
    
    }

    for i,v in ipairs(ids) do
        table.insert(skins, {v, nil, 100, false})
    end
end

function doIOwnSkin(skinid)
    local data = getElementData(localPlayer, "player:skinsBought") or {}
    return data[tostring(skinid)]
end

function renderWindow()
    local anim = data.anim[1]

    exports['since-blur']:dxDrawBlur(sx-420/zoom, sy/2-265/zoom, 400/zoom, 530/zoom, data.textures['bg_mask'], anim)
    dxDrawImage(sx-420/zoom, sy/2-265/zoom, 400/zoom, 530/zoom, data.textures['bg'], 0, 0, 0, tocolor(255, 255, 255, anim))

    local isIn = isMouseIn(sx-52/zoom, sy/2-257/zoom, 24/zoom, 24/zoom)
    data.anim[2] = interpolateBetween(data.anim[2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx-50/zoom, sy/2-255/zoom, 20/zoom, 20/zoom, data.textures['close'], 0, 0, 0, tocolor(255, 255, 255, anim*data.anim[2]))

    drawScrollbar(skins, sx-30/zoom, sy/2-200/zoom, 3/zoom, 448/zoom, data.scrollPos.m, data.scrollPos.k, anim)

	dxDrawText('Przebieralnia świątęczna', sx-403/zoom, sy/2-228/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, data.fonts[1], 'left', 'bottom')
    dxDrawText('Wybierz świątecznego skina', sx-403/zoom, sy/2-228/zoom, nil, nil, tocolor(46, 117, 111, anim), 1, data.fonts[2], 'left', 'top')

    local x = 0
    for i,v in ipairs(skins) do
        if i >= data.scrollPos.k and i <= data.scrollPos.n then 
            x = x + 1
            local offset = ((x-1) * (65/zoom))
            if v[4] then
                dxDrawImage(sx-405/zoom, sy/2-200/zoom+offset, 370/zoom, 60/zoom, data.textures['bg2'], 0, 0, 0, tocolor(49, 181, 255, anim))
            else
                dxDrawImage(sx-405/zoom, sy/2-200/zoom+offset, 370/zoom, 60/zoom, data.textures['bg2'], 0, 0, 0, tocolor(255, 255, 255, anim))
            end
            dxDrawImage(sx-395/zoom, sy/2-190/zoom+offset, 40/zoom, 40/zoom, data.textures['tshirt'], 0, 0, 0, tocolor(255, 255, 255, anim))

            local text = v[2] or 'Skin #'..v[1]
            local textWidth = dxGetTextWidth(text, 1, data.fonts[3])
            dxDrawText(text, sx-345/zoom, sy/2-166/zoom+offset, nil, nil, tocolor(255, 255, 255, anim), 1, data.fonts[3], 'left', 'bottom')
            dxDrawText(v[3]>0 and 'Cena: #84FF79$ #FFFFFF'..formatNumber(v[3]) or '#84FF79Darmowy', sx-345/zoom, sy/2-166/zoom+offset, nil, nil, tocolor(255, 255, 255, anim), 1, data.fonts[2], 'left', 'top',false,false,false,true)

            if v[4] then
                dxDrawText('#84C4FF(Diamond)', sx-340/zoom+textWidth, sy/2-179/zoom+offset, nil, nil, tocolor(255, 255, 255, anim), 1, data.fonts[4], 'left', 'center',false,false,false,true)
            end

            if isMouseIn(sx-125/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
                dxDrawImage(sx-125/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, data.textures['button_1'], 0, 0, 0, tocolor(255, 255, 255, (anim*255)*200))
            else
                dxDrawImage(sx-125/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, data.textures['button_1'], 0, 0, 0, tocolor(255, 255, 255, anim))
            end

            if isMouseIn(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
                dxDrawImage(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, (doIOwnSkin(v[1]) or v[3] == 0) and data.textures['button_3'] or data.textures['button_2'], 0, 0, 0, tocolor(255, 255, 255, (anim*255)*200))
            else
                dxDrawImage(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom, (doIOwnSkin(v[1]) or v[3] == 0) and data.textures['button_3'] or data.textures['button_2'], 0, 0, 0, tocolor(255, 255, 255, anim))
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

function onClick(btn, state)
    if btn == 'left' and state == 'down' and data.togglePanel == true then
        if isMouseIn(sx-50/zoom, sy/2-255/zoom, 20/zoom, 20/zoom) then
            closeWindow(localPlayer)

        elseif isMouseIn(sx-405/zoom, sy/2-200/zoom, 370/zoom, 460/zoom) then
            local x = 0
            for i,v in ipairs(skins) do
                if i >= data.scrollPos.k and i <= data.scrollPos.n then 
                    x = x + 1
                    local offset = ((x-1) * (65/zoom))
                    if isMouseIn(sx-125/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
                        setElementModel(localPlayer, v[1])

                    elseif isMouseIn(sx-83/zoom, sy/2-188/zoom+offset, 36/zoom, 36/zoom) then
                        if doIOwnSkin(v[1]) or v[3] == 0 then
                            triggerServerEvent("przebieralniaZmienSkina", resourceRoot, v[1])
                        else
                            if getPlayerMoney(localPlayer) >= v[3] and not getElementData(localPlayer, "buywait") then
                                if v[4] then
                                    if getElementData(localPlayer, "player:diamond") then
                                        triggerServerEvent("przebieralniaKupSkina", resourceRoot, v[3], v[1])
                                        setElementData(localPlayer, "buywait", true)
                                    end
                                else
                                    triggerServerEvent("przebieralniaKupSkina", resourceRoot, v[3], v[1])
                                    setElementData(localPlayer, "buywait", true)
                                end
                            end
                        end

                    end
                end
            end

        end
    end
end

function openWindow(el)
    if el ~= getLocalPlayer() or data.block or isEventHandlerAdded('onClientRender', root, renderWindow) then return end

    data.block = true
    data.togglePanel = true
    data.anim = {0,0}

    data.scrollPos = {k=1, m=7, n=7}

    data.textures = {}
    for i,v in ipairs({'bg','bg2','bg_mask','button_1','button_2','button_3','close','tshirt'}) do
        if fileExists('data/'..v..'.png') then
            data.textures[v] = dxCreateTexture('data/'..v..'.png', 'argb', false, 'clamp')
        end
    end

    data.marker = source

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

        for i,v in pairs(data.textures) do
            if isElement(v) then 
                destroyElement(v) 
            end
        end
        data.textures = {}
        data.anim = nil
        data.marker = nil
        setElementModel(localPlayer, getElementData(localPlayer, "player:skin"))
        data.togglePanel = nil
        data.block = nil
    end)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
    addEventHandler("onClientMarkerHit", data.markerPos, openWindow)
    addEventHandler("onClientMarkerLeave", data.markerPos, closeWindow)

    setElementData(data.markerPos, "marker:title", "Skiny świąteczne")
    setElementData(data.markerPos, "marker:desc", "Odbierz świątecznego skina")
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
    if data.scrollPos.n >= #skins then return end
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
getResourceName(getThisResource(), true, 974063046); if true then return end
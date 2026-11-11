  

local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

local winners = {
    ["normal"] = {
        {0, 75, "loose"},
        {75, 85, "win", 7000},
        {85, 99, "win", 15000},
        {99, 100, "win", 25000},

        {25000},
    },

    ["premium"] = {
        {0, 75, "loose"},
        {75, 85, "win", 18000},
        {85, 99, "win", 20000},
        {99, 100, "win", 35000},

        {35000},
    },

    ["extra"] = {
        {0, 75, "loose"},
        {75, 85, "win", 30000},
        {85, 99, "win", 40000},
        {99, 100, "win", 55000},

        {55000},
    },
}

local notifications = {
    [1] = "Masz pecha",
    [2] = "ERROR 404",
    [3] = "Przegrałeś",
}

local kordy = {}
local kulminacja, display, win, type_z = false, false, false, false


function render()
    dxDrawImage(sx/2 - 400/zoom/2, sy/2 - 250/zoom/2, 400/zoom, 250/zoom, textures[1], 0, 0, 0, white, false)
    dxDrawText("Zdrapka", sx/2, sy/2 - 100/zoom, center, center, white, 1, fonts[1], "center", "center", false, false, false, true)

    if kulminacja then
        dxDrawText("Kumulacja: "..przecinek(kulminacja), sx/2, sy/2 - 20/zoom, center, center, white, 1, fonts[2], "center", "center", false, false, false, false)
    end

    dxDrawText("Zdrap i spróbuj szczęścia", sx/2, sy/2 + 10/zoom, center, center, white, 1, fonts[2], "center", "center", false, false, false, false)
    dxDrawRectangle(sx/2 - 200/zoom/2, sy/2 + 60/zoom, 200/zoom, 54/zoom, tocolor(160, 160, 160, 255), false)

    if display then
        if tonumber(display) then 
            text = '$#ffffff '..przecinek(display)
            dxDrawText(text, sx/2, sy/2 + 90/zoom, center, center, tocolor(125, 255, 125, 255), 1.25, "pricedown", "center", "center", false, false, false, true)
        else 
            text = display 
            dxDrawText(text, sx/2, sy/2 + 90/zoom, center, center, tocolor(0, 0, 0, 255), 1.25, "pricedown", "center", "center", false, false, false, true)
        end

    end

	for i,v in ipairs(kordy) do
        dxDrawRectangle(v[1] - 8/zoom, v[2], v[3], v[4], tocolor(77, 77, 77, v[5]), false)		
    end

    for i,v in ipairs(kordy) do
		if isMouseIn(v[1] - 8/zoom, v[2] - 8/zoom, v[3] + 16/zoom, v[4] + 16/zoom) and getKeyState("mouse1") then
			v[5] = 140
		end
		if isMouseIn(v[1] - 6/zoom, v[2] - 6/zoom, v[3] + 12/zoom, v[4] + 12/zoom) and getKeyState("mouse1") then
			table.remove(kordy, i)
		end
	end

    if #kordy < 30 then
        removeEventHandler("onClientRender", root, render)
        for i,v in ipairs(textures) do
            destroyElement(v)
        end
        textures = nil
        fonts = nil
        showCursor(false)
        result()
    end
end

function result()
    setElementData(localPlayer, 'zdrapuje', nil)
    if win == "loose" then
        exports['since-notifications']:sendNotification('info', 'Niestety nie udało Ci się wygrać!')
        showCursor(false)
        return false
    elseif win == "win" then
        exports['since-notifications']:sendNotification('info', 'Wygrałeś '..przecinek(display)..' $')
        triggerServerEvent("since-zdrapki:result", resourceRoot, display)
        showCursor(false)
        return false
    end
end

setElementData(localPlayer, 'zdrapuje', nil)

function zdrap(name)
    if not isEventHandlerAdded("onClientRender", root, render) then
        if name == 1 then
            type_z = "normal"
        elseif name == 2 then
            type_z = "premium"
        elseif name == 3 then
            type_z = "extra"
        end

        win = false
        display = false
        kulminacja = false
        local random = math.random(0, 100)
        if type_z then
            if random > -1 and random < 75 then
                win = winners[type_z][1][3]
                display = notifications[math.random(1, 3)]
            elseif random > 74 and random < 86 then
                win = winners[type_z][2][3]
                display = winners[type_z][2][4]
            elseif random > 85 and random < 99 then
                win = winners[type_z][3][3]
                display = winners[type_z][3][4]
            elseif random > 98 and random < 101 then
                win = winners[type_z][4][3]
                display = winners[type_z][4][4]
            end
        end
    
        kulminacja = winners[type_z][5][1]
        
        kordy = {}

        for i = 0,6 do  
            for k = 0,24 do
                table.insert(kordy, {sx/2 + 100/zoom - k*8/zoom, sy/2 + 60/zoom + i*8/zoom, 8/zoom, 8/zoom, 255})
            end
        end
        fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Bold', 18/zoom),
            [2] = exports['since-fonts']:getFont('Inter-Regular', 14/zoom),
        }
        textures = {
            [1] = dxCreateTexture("files/bg.png"),
        }
        addEventHandler("onClientRender", root, render)
        showCursor(true)
        setElementData(localPlayer, 'zdrapuje', true)
    end
end

function przecinek(amount) 
	local formatted = amount 
	while true do   
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2') 
	  if (k==0) then 
		break 
	  end 
	end 
	return formatted 
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
getResourceName(getThisResource(), true, 112778234); if true then return end
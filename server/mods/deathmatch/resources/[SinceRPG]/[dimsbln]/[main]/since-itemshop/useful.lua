sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

uiElements = {}

function isMouseInPosition(x, y, width, height)
    if not isCursorShowing() then return false end
    local mx, my = getCursorPosition()
    local fullx, fully = guiGetScreenSize()
    mx, my = mx*fullx, my*fully
    return (mx >= x and mx <= x + width) and (my >= y and my <= y + height)
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

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    if not postGUI then postGUI = false end
    if not subPixelPositioning then subPixelPositioning = false end
    
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end


function drawScrollbar(table, x, y, w, height, m_, k_, alpha, todel)
    dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(100, 255, 100,alpha*0.2))

    if not todel then todel = 3 end

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
		
        dxDrawRoundedRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-todel), w/2, tocolor(100, 255, 100, alpha))
    else
        dxDrawRoundedRectangle(x, y, w, height, w/2, tocolor(100, 255, 100, alpha))
	end
end


smsItems = {
    {
        name = "#68D65E40 wPLN#ffffff - 4,92 zł",
        number = "7455",
        code = "AA.SP",
        wpln = 40,
        count = 4
    },

    {
        name = "#68D65E60 wPLN#ffffff - 6,15zł",
        number = "7555",
        code = "AA.SP",
        wpln = 60,
        count = 5
    },

    {
        name = "#68D65E70 wPLN#ffffff - 7,38zł",
        number = "7636",
        code = "AA.SP",
        wpln = 70,
        count = 6
    },

    {
        name = "#68D65E100 wPLN#ffffff - 11,07zł",
        number = "7936",
        code = "AA.SP",
        wpln = 100,
        count = 9
    },

    {
        name = "#68D65E200 wPLN#ffffff - 23,37zł",
        number = "91955",
        code = "AA.SP",
        wpln = 200,
        count = 19
    },

    {
        name = "#68D65E300 wPLN#ffffff - 30,75zł",
        number = "92555",
        code = "AA.SP",
        wpln = 300,
        count = 25
    },
}

function getData()
    local selected = false
    for i, v in ipairs(smsItems) do
        if (exports['since-gridlist']:getSelectedItem(uiElements['gridlist']) == v.name) then
            selected = v
            break
        end
    end

    return selected
end



selectedTab = 1
scroll = {k = 1, n = 6, m = 6}
onItem = {}
showedModal = false
modalData = {}
modalAlpha = 0
playerWPLN = 0
buyData = {}
editbox = false
slider = false
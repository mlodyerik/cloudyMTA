--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

--[[if getElementData(localPlayer, "player:sid") == 25 or getElementData(localPlayer, "player:sid") == 1 then

else
    return false
end]]

local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

--[[local fonts = {
    [1] = dxCreateFont(":enonek-interface/fonts/Poppins-Regular.ttf", 16) or "default-bold",
}

local textures = {
    [1] = dxCreateTexture("files/line_down.png"),
    [2] = dxCreateTexture("files/line.png"),
    [3] = dxCreateTexture("files/icon1.png"),
    [4] = dxCreateTexture("files/icon2.png"),
    [5] = dxCreateTexture("files/icon3.png"),
    [6] = dxCreateTexture("files/icon4.png"),
    
}]]

local editbox = {}
local showed = false

function table.max(tt)
    local n = 0
    for i,v in pairs(tt) do
        n = n + 1
    end
    return n
end

function createEditbox(n, t, px, py, pw, ph, a, i, m, maxx, no, ap, nformat)
    editbox[n] = nil
    guiSetInputMode("allow_binds")
    editbox[n] = {name=n, temptext=t, text="", x=px, y=py, w=pw, h=ph, alpha=a, icon=i, tick=getTickCount(), tickBack = getTickCount(), masked=m, max=maxx, numberonly = no or false, allowpaste = ap or false, numberformating = nformat, selected=false}
    --table.insert(editbox, {name=n, temptext=t, text="", x=px, y=py, w=pw, h=ph, alpha=a, icon=i, tick=getTickCount(), tickBack = getTickCount(), masked=m, max=maxx, numberonly = no or false, allowpaste = ap or false, numberformating = nformat, selected=false})
    if not (showed) then
        fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Medium', 14),
        }
        
        textures = {
            [1] = dxCreateTexture("files/line_down.png"),
            [2] = dxCreateTexture("files/line.png"),
            [3] = dxCreateTexture("files/icon1.png"),
            [4] = dxCreateTexture("files/icon2.png"),
            [5] = dxCreateTexture("files/icon3.png"),
            [6] = dxCreateTexture("files/icon4.png"),
            [7] = dxCreateTexture("files/icon5.png"),
            [8] = dxCreateTexture("files/kg.png"),
            [9] = dxCreateTexture("files/fish.png"),
            [10] = dxCreateTexture("files/music.png"),
            [11] = dxCreateTexture("files/money.png"),
        }
        addEventHandler("onClientRender", root, renderEditbox)
        addEventHandler("onClientPaste", root, onPaste)
        addEventHandler("onClientClick", root, click)
        addEventHandler("onClientCharacter", root, character)
        showed = true
    end
end
--createEditbox("test", "Wpisz login", sx/2 - 478/zoom/2, sy/2 + 200/zoom, 478/zoom, 50/zoom, 255, 3, false, 50)
--createEditbox("test", "Testowy tekst", sx/2 - 478/zoom/2, sy/2 + 400/zoom, 478/zoom, 50/zoom, 255, 3, false, 50)

local function kropki(amount) 
	local formatted = amount 
	while true do   
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') 
	  if (k==0) then 
		break 
	  end 
	end 
	return tostring(formatted) 
end

function renderEditbox()
    for i,v in pairs(editbox) do
        local ax, rgb = 0, 0
        if v.selected then
            ax,_,_ = interpolateBetween(0, 0, 0, v.w, 0, 0, (getTickCount()-v.tick)/300, "OutQuad")
            rgb,_,_ = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount()-v.tick)/1000, "SineCurve")
        else
            --if ax > 0 then
                ax,_,_ = interpolateBetween(v.w, 0, 0, 0, 0, 0, (getTickCount()-v.tick)/300, "OutQuad")
            --end
        end

        if v.masked then
            v.mtext = string.rep("*", #v.text)
        end

        local txt = v.masked and string.rep("*", #v.text) or v.text
        local txt = v.numberformating and kropki(v.text) or txt
        local width = dxGetTextWidth(txt, 1/zoom, fonts[1], false) or 0

        if #txt < 1 then
            dxDrawText(v.temptext, v.x + 50/zoom, v.y - 20/zoom, left, center, tocolor(212, 212, 212, v.alpha), 1/zoom, fonts[1], "left", "center", false, false, true, false)     
        else
            if (width > (v.w-50/zoom)) then
                dxDrawText(txt, v.x + 50/zoom, v.y - 40/zoom, (v.x+50/zoom)+(v.w-50/zoom), (v.y), tocolor(212, 212, 212, v.alpha), 1/zoom, fonts[1], "right", "center", true, false, true, false)
            else
                dxDrawText(txt, v.x + 50/zoom, v.y - 20/zoom, v.w-50/zoom, v.y-20/zoom, tocolor(212, 212, 212, v.alpha), 1/zoom, fonts[1], "left", "center", false, false, true, false)
            end
        end

        local xline = width > (v.w-50/zoom) and v.x + 50/zoom + v.w-50/zoom or v.x + 50/zoom + width
        dxDrawRectangle(xline, v.y - 30/zoom, 1/zoom, 20/zoom, tocolor(255, 255, 255, rgb), true)

        if getKeyState("backspace") then
            v.backState = v.backState - 1
        else
            v.backState = 100
        end

        if getKeyState("backspace") and (getTickCount() - v.tickBack) > v.backState and v.selected then
            v.text = string.sub(v.text, 1, #v.text - 1)
            v.tickBack = getTickCount()
        end

        dxDrawImage(v.x, v.y, v.w, 2/zoom, textures[1], 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
        dxDrawImage(v.x, v.y, ax/zoom, 2/zoom, textures[1], 0, 0, 0, tocolor(255, 140, 0, v.alpha), true)
        if v.icon == 5 then
            dxDrawImage(v.x + 10/zoom, v.y - 30/zoom, 18/zoom, 16/zoom, textures[v.icon], 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
        elseif v.icon == 6 then
            dxDrawImage(v.x + 10/zoom, v.y - 30/zoom, 20/zoom, 20/zoom, textures[v.icon], 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
        elseif v.icon == 7 then
            dxDrawImage(v.x + 10/zoom, v.y - 30/zoom, 25/zoom, 25/zoom, textures[v.icon], 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
        elseif v.icon == 8 then
            dxDrawImage(v.x + 10/zoom, v.y - 33/zoom, 24/zoom, 24/zoom, textures[v.icon], 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
        elseif v.icon == 11 then
            dxDrawImage(v.x + 10/zoom, v.y - 35/zoom, 24/zoom, 24/zoom, textures[v.icon], 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
        else
            dxDrawImage(v.x + 10/zoom, v.y - 35/zoom, 20/zoom, 24/zoom, textures[v.icon], 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
        end
        dxDrawImage(v.x + 40/zoom, v.y - 36/zoom, 2/zoom, 28/zoom, textures[2], 0, 0, 0, tocolor(255, 255, 255, v.alpha), true)
    end
end
--addEventHandler("onClientRender", root, renderEditbox)

function click(b, s)
    if b == "left" and s == "down" then
        for i,v in pairs(editbox) do
            if isMouseIn(v.x, v.y - 40/zoom, v.w, 40/zoom) then
                if (v.selected) then
                    v.tick = getTickCount()
                    v.selected = false
                    --guiSetInputMode("allow_binds")
                else
                    v.tick = getTickCount()
                    v.selected = true
                    --guiSetInputMode("no_binds")
                end
            else
                if (v.selected) then
                    v.tick = getTickCount()
                    v.selected = false
                    --guiSetInputMode("allow_binds")
                end
	    	end
        end

        for i,v in pairs(editbox) do
            if (v.selected) then
                guiSetInputMode("no_binds")
                return false
            end
        end
        guiSetInputMode("allow_binds")
    end
end
--addEventHandler("onClientClick", root, click)

function character(s)
    for i,v in pairs(editbox) do
        if v.selected and #v.text < v.max then
            if v.name == "insert_coin" then
                if s == "." then
                    return false
                end
            end
            if (v.numberonly) then
                if (not tonumber(s)) then
                    return false
                end
            end
            v.text = v.text..s
        end
    end
end
--addEventHandler("onClientCharacter", root, character)

function onPaste(txt)
    if (txt and tostring(txt)) then
        for i,v in pairs(editbox) do
            if (v.selected and v.allowpaste and #txt < ((#v.text or 0) + v.max)) then
                v.text = v.text..txt
                break
            end
        end
    end
end

function destroyEditbox(n)
    for i,v in pairs(editbox) do
        if v.name == n then
            editbox[i] = nil
            guiSetInputMode("allow_binds")
        end
    end

    if table.max(editbox) < 1 then
        if fonts and textures then
            if #textures > 0 then
                for i,v in ipairs(textures) do
                    destroyElement(v)
                end
            end
            fonts = {}
            textures = {}
        end
        removeEventHandler("onClientRender", root, renderEditbox)
        removeEventHandler("onClientPaste", root, onPaste)
        removeEventHandler("onClientClick", root, click)
        removeEventHandler("onClientCharacter", root, character)
        showed = false
        guiSetInputMode("allow_binds")
    end
end

function editboxGetText(n)
    for i,v in pairs(editbox) do
        if v.name == n then
            return v.text
        end
    end
end

function editboxSetText(n, t)
    for i,v in pairs(editbox) do
        if v.name == n then
            v.text = t
        end
    end
end

function editboxSetAlpha(n, value)
    for i,v in pairs(editbox) do
        if v.name == n then
            v.alpha = value
        end
    end
end

function isMouseIn( x, y, width, height ) -- https://wiki.multitheftauto.com/wiki/IsMouseInPosition
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end
getResourceName(getThisResource(), true, 623389861); if true then return end
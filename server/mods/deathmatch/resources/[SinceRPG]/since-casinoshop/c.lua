  

local edit = {}

local sw,sh = guiGetScreenSize()
local zoom = 1
if sw < 1920 then
    zoom = math.min(2, 1920 / sw)
end

function isMouseInPosition(x, y, w, h)
	if not isCursorShowing() then return end

	local pos = {getCursorPosition()}
	pos[1], pos[2] = (pos[1] * sw), (pos[2] * sh)

	if pos[1] >= x and pos[1] <= (x + w) and pos[2] >= y and pos[2] <= (y + h) then
		return true
	end
	return nil
end

function edit:load()
    self.render_fnc = function() self:render() end
    self.click_fnc = function(...) self:click(...) end
    self.character_fnc = function(...) self:character(...) end
    self.key_fnc = function(...) self:key(...) end

    self.edits = {}

    self.showed = nil

    self.tick = getTickCount()
    self.tickBack = getTickCount()
    self.backState = 0

    self.pasted = nil

    self.backing = nil

    --self.font = dx:getFont("rbt-l", 5);
    self.font = "default-bold"

    --edit:create("t1", "t2", "t3", 300, 300, 250, 50, false, 5)
    --showCursor(true, false)
end

function edit:create(name, localText, opisText, x, y, w, h, masked, fontSize, a, color, filePath, type)
    self.edits[#self.edits + 1] = {name, localText, opisText, x, y, w, h, masked, false, 0, color or {180, 180, 180}, false, fontSize, a or 255, filePath and dxCreateTexture(filePath, "argb", false, "clamp") or false, type};
    --self.font = dx:getFont("rbt-r", (fontSize or 1));
    self.font = exports['since-fonts']:getFont('Inter-Regular', (fontSize or 1)+9)

    if not self.showed then
        addEventHandler("onClientRender", root, self.render_fnc)
        addEventHandler("onClientClick", root, self.click_fnc)
        addEventHandler("onClientCharacter", root, self.character_fnc)
        addEventHandler("onClientKey", root, self.key_fnc)

        self.showed = true
    end
end

function edit:destroy(name)
    for i,v in pairs(self.edits) do
        if v[1] == name then
            if v[15] and isElement(v[15]) then
                destroyElement(v[15])
            end

            self.edits[i] = nil
        end
    end

    if #self.edits < 1 then
        removeEventHandler("onClientRender", root, self.render_fnc)
        removeEventHandler("onClientClick", root, self.click_fnc)
        removeEventHandler("onClientCharacter", root, self.character_fnc)
        removeEventHandler("onClientKey", root, self.key_fnc)
        self.showed = nil
    end
end

function edit:render()
    for i,v in pairs(self.edits) do
        local x,w = 0,0;
        local xx = v[6];
        if(v[9])then
            x,w = interpolateBetween(v[6]/2, 0, 0, 0, xx, 0, (getTickCount()-v[10])/200, "Linear");
        else
            x,w = interpolateBetween(0, xx, 0, v[6]/2, 0, 0, (getTickCount()-v[10])/200, "Linear");
        end;

        if(not v[16])then
            dxDrawRectangle(v[4], v[5]+v[7]-5, v[6], 1, tocolor(194,197,200, v[14]), false);
            if(v[15])then
                local ww,hh = 20,20;
                dxDrawImage(v[4]+v[6]-30/zoom, v[5]+(hh/2/zoom), v[7]-ww/zoom, v[7]-hh/zoom, v[15], 0, 0, 0, tocolor(227, 232,231, v[14]), false);
            end;
            dxDrawRectangle(v[4]+x, v[5]+v[7]-5, w, 1, tocolor(255, 140, 0, v[14]), false);
        end;

        local newW = v[15] and 40/zoom or 0;
        local w = v[6];
        local text = v[8] and string.rep("*", #v[2]) or v[2];
        local width = dxGetTextWidth(text, 1, self.font, false) or 0;
        if v[9] then
            if (getKeyState("lctrl") or getKeyState("rctrl")) and getKeyState("v") then
                v[2] = guiGetText(self.pasted) or ""
            end

            if getKeyState("backspace") then
                self.backState = self.backState - 1
            else
                self.backState = 100
            end

            if getKeyState("backspace") and (getTickCount() - self.tickBack) > self.backState then
                v[2] = string.sub(v[2], 1, #v[2] - 1)
                self.tickBack = getTickCount()
            end

            local carretAlpha = v[14] > 200 and interpolateBetween(50, 0, 0, 200, 0, 0, (getTickCount() - self.tick) / 1000, "SineCurve") or v[14]
            local carretSize = dxGetFontHeight(1, self.font);
            local carretPosX = width > (w-newW) and v[4] + w-newW or v[4] + width
            dxDrawRectangle(carretPosX + 2/zoom, v[5] + ((carretSize / 2) / zoom), 1, v[7] - (carretSize / zoom), tocolor(v[11][1], v[11][2], v[11][3], carretAlpha), false)
        end

        if v[2] == "destroyelement" or v[2] == "destroyElement" or v[2] == "destroyElemen" then
            v[2] = ""
        end
        if(width > (w-newW))then
            dxDrawText(text, v[4], v[5], v[4]+w-newW, v[7] + v[5], tocolor(v[11][1], v[11][2], v[11][3], v[14]), 1, self.font, "right", "center", true)
        else
            dxDrawText(text, v[4], v[5], w, v[7] + v[5], tocolor(v[11][1], v[11][2], v[11][3], v[14]), 1, self.font, "left", "center", false)
        end

        if #v[2] < 1 then
            dxDrawText(v[3], v[4] + (3 / zoom), v[5], w, v[7] + v[5], tocolor(145, 144, 144, v[14]), 1, self.font, "left", "center", false)
        end
    end
end

function edit:click(button, state)
    if button ~= "left" or state ~= "down" then return end

    for i,v in pairs(self.edits) do
        if isMouseInPosition(v[4], v[5], v[6], v[7]) then
			if not v[9] then
                if i == 1 then
                    self.backing = nil
                else
                    self.backing = true
                end

                for _,k in pairs(self.edits) do
                    if k[9] then
                        k[9] = false
                        k[10] = getTickCount()
                        break
                    end
				end

				v[9] = true
        v[10] = getTickCount()

        self.pasted = guiCreateEdit(3000, 3000, 200, 200, "", false, false)
        guiBringToFront(self.pasted)
				return
			end
		end

		if v[9] then
			v[9] = false
      v[10] = getTickCount()

      if self.pasted and isElement(self.pasted) then
        destroyElement(self.pasted)
        self.pasted = nil
      end
		end
  end
end

function edit:character(key)
    for i,v in pairs(self.edits) do
        if v[9] then
            v[2] = v[2] .. key
        end
    end
end

function edit:key(key, press)
    if press then
        if key == "tab" then
            for i = 1, #self.edits do
                if self.edits[i][9] == true then
                    if self.edits[i + 1] and not self.backing then
                        if (i + 1) == #self.edits then
                            self.backing = true
                        end

                        self.edits[i][9] = false
                        self.edits[i + 1][9] = true
                        self.edits[i][10] = getTickCount()
                        self.edits[i + 1][10] = getTickCount()
                        break
                    elseif self.edits[i - 1] then
                        if (i - 1) == 1 then
                            self.backing = nil
                        end

                        self.edits[i][9] = false
                        self.edits[i - 1][9] = true
                        self.edits[i][10] = getTickCount()
                        self.edits[i - 1][10] = getTickCount()
                        break
                    end
                end
            end
        elseif (getKeyState("lctrl") or getKeyState("rctrl")) and (getKeyState("c") or getKeyState("a")) then
            cancelEvent()
        end
    end
end

function dxCreateEdit(...)
    edit:create(...)
end

function dxDestroyEdit(...)
    edit:destroy(...)
end

function dxGetEditText(name)
    local text = ""
    for i,v in pairs(edit.edits) do
        if v[1] == name then
            text = v[2]
            break
        end
    end
    return text
end

function dxSetEditText(name, text)
    for i,v in pairs(edit.edits) do
        if v[1] == name then
            v[2] = text
        end
    end
end

function dxSetEditAlpha(name, a)
    for i,v in pairs(edit.edits) do
        if v[1] == name then
            v[14] = a;
        end
    end
end;

function dxSetEditPosition(name, x, y)
    for i,v in pairs(edit.edits) do
        if v[1] == name then
            v[4], v[5] = x,y;
        end
    end
end;

function dxEditGetSelected(name)
    local selected = false;
    for i,v in pairs(edit.edits) do
        if(v[1] == name and v[9])then
            selected = true;
            break;
        end;
    end;
    return selected;
end;

addEventHandler("onClientResourceStart", resourceRoot, function()
    edit:load()
    --edit:create("test", "", "test", 300, 300, 300, 50, false, 5, 255);
    --showCursor(true,false)
end)

setTimer(function()

local sx,sy = guiGetScreenSize();
local zoom = 1;
if(sx < 1920)then
    zoom = math.min(2, 1920/sx);
end;
local font = dxCreateFont( "Cabin-Regular.ttf", 20 )
local font0 = dxCreateFont( "Cabin-Regular.ttf", 15 )
local font12 = dxCreateFont( "Cabin-Regular.ttf", 14 )


function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end

function mysz(psx,psy,pssx,pssy,abx,aby)
    if not isCursorShowing() then return end
    cx,cy=getCursorPosition()
    cx,cy=cx*sx,cy*sy
    if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
        return true,cx,cy
    else
        return false
    end
end

function kropki(amount) 
	local formatted = amount 
	while true do   
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') 
	  if (k==0) then 
		break 
	  end 
	end 
	return formatted 
end

local marker = createMarker(1955.63, 1018.06, 992.47-0.95, 'cylinder', 1.7, 125, 255, 125, 50)
setElementData(marker, 'marker:title', 'Kasyno')
setElementData(marker, 'marker:desc', 'Wymiana żetonów')
setElementData(marker, 'marker:icon', 'default')
setElementInterior(marker,10)
setElementDimension(marker,0)

local button_zetony = {
	{sx/2 - 250/zoom, sy/2 + 100/zoom, 100, 40,"Wymień",1},
	{sx/2 + 150/zoom, sy/2 + 100/zoom, 100, 40,"Wymień",2},
	{sx/2 - 50/zoom, sy/2 + 100/zoom, 100, 40,"Zamknij",3},
}

local bank = 0
function render_zetony()
	roundedRectangle(sx/2 - 350/zoom, sy/2- 150/zoom, 700/zoom, 300/zoom, tocolor(25, 36, 38, 190))
		dxDrawText("Kasyno", sx/2 - (150+1)/zoom, sy/2 - (140+1)/zoom, sx/2 + (150+1)/zoom, sy/2 - (130+1)/zoom, tocolor(0, 0, 0,255), 1/zoom, font, "center", "center")	
		dxDrawText("Kasyno", sx/2 - 150/zoom, sy/2 - 140/zoom, sx/2 + 150/zoom, sy/2 - 130/zoom, tocolor(180, 180, 180,255), 1/zoom, font, "center", "center")	
		local zeton = getElementData(localPlayer,"client:coin") or 0
		dxDrawText("Bank: "..kropki(bank), sx/2 - (300+1)/zoom, sy/2 - (100+1)/zoom, sx/2 - (150+1)/zoom, sy/2 - (80+1)/zoom, tocolor(0, 0, 0,255), 1/zoom, font, "left", "center")	
		dxDrawText("Bank: "..kropki(bank), sx/2 - 300/zoom, sy/2 - 100/zoom, sx/2 - 150/zoom, sy/2 - 80/zoom, tocolor(180, 180, 180,255), 1/zoom, font, "left", "center")
		dxDrawText(kropki(zeton).." :Żetony", sx/2 + (150+1)/zoom, sy/2 - (100+1)/zoom, sx/2 + (300+1)/zoom, sy/2 - (80+1)/zoom, tocolor(0, 0, 0,255), 1/zoom, font, "right", "center")	
		dxDrawText(kropki(zeton).." :Żetony", sx/2 + 150/zoom, sy/2 - 100/zoom, sx/2 + 300/zoom, sy/2 - 80/zoom, tocolor(180, 180, 180,255), 1/zoom, font, "right", "center")

		for k,v in pairs(button_zetony) do
			if mysz(v[1],v[2],v[3]/zoom,v[4]/zoom) then
				roundedRectangle(v[1],v[2],v[3]/zoom,v[4]/zoom, tocolor(25, 36, 38, 150))
				dxDrawText(v[5], v[1],v[2],v[1]+v[3]/zoom,v[2]+v[4]/zoom, tocolor(67, 143, 135,255), 1/zoom, font0, "center", "center")		
			else
				roundedRectangle(v[1],v[2],v[3]/zoom,v[4]/zoom, tocolor(10, 10, 10, 150))
				dxDrawText(v[5], v[1],v[2],v[1]+v[3]/zoom,v[2]+v[4]/zoom, tocolor(67, 143, 135,255), 1/zoom, font0, "center", "center")		
			end
		end

end

addEvent("zeton:client", true)
addEventHandler("zeton:client", root, function(ba)
bank = ba
end)

dxDestroyEdit("zetonywymiana")
addEventHandler("onClientMarkerHit",marker,function(player)
	if getElementType(player) == "player" then else return nil end
	if getPedOccupiedVehicle(player) then return nil end
	if (player == localPlayer) then else return end
	local character=getElementData(player, "player:sid")
	if not tonumber(character) then return nil end	
	if getElementInterior(source) == getElementInterior(player) and getElementDimension(source) == getElementDimension(player) then 
		if getElementData(player,"client:coin") then
			addEventHandler("onClientRender", root, render_zetony)	
			block_casiono_zeton = true
			dxCreateEdit("zetonywymiana","","Wprowadź kwote",sx/2 - 150/zoom,sy/2 - 20/zoom,300/zoom,50/zoom)
			showCursor(true,false)
			triggerServerEvent("zetony:server", resourceRoot,"bank_out")
		end
	end
end)		

addEventHandler("onClientMarkerLeave",marker,function(player)
	if player == localPlayer then else return end
	if block_casiono_zeton == false then return end	
	removeEventHandler("onClientRender", root, render_zetony)	
	block_casiono_zeton = false
	dxDestroyEdit("zetonywymiana")
	showCursor(false)
end)

local click = false

addEventHandler("onClientClick", root, function(b, s)
  if b ~= "state" and s ~= "down" then return end
	if block_casiono_zeton == false then return end
	if click then
		if getTickCount() - click < 1000 then
			return false
		end
	end
		for k,v in pairs(button_zetony) do
			if mysz(v[1],v[2],v[3]/zoom,v[4]/zoom) then
			
				if v[5] == "Wymień" and v[6] == 1 then
					local zetonywymiana = dxGetEditText("zetonywymiana")
					if zetonywymiana == "" then return end
					if (not tonumber(zetonywymiana)) then return end
					local zetonywymiana = math.ceil(tonumber(zetonywymiana))
					
					if tonumber(zetonywymiana) < 1 then
						outputChatBox("Wpisana kwota jest za niska.")
						return
					end
					triggerServerEvent("zetony:server", resourceRoot,"bank",zetonywymiana)
				elseif v[5] == "Wymień" and v[6] == 2 then
					local zetonywymiana = dxGetEditText("zetonywymiana")
					if zetonywymiana == "" then return end
					if (not tonumber(zetonywymiana)) then return end
					local zetonywymiana = math.ceil(tonumber(zetonywymiana))
					if tonumber(zetonywymiana) < 1 then
						outputChatBox("Wpisana kwota jest za niska.")
						return
					end
					triggerServerEvent("zetony:server", resourceRoot,"zeton",zetonywymiana)
				elseif v[5] == "Zamknij" and v[6] == 3 then
						removeEventHandler("onClientRender", root, render_zetony)	
						block_casiono_zeton = false
						dxDestroyEdit("zetonywymiana")
						showCursor(false)
				end
				click = getTickCount()
			else
			
			end
		end
end)

end, 500, 1)
getResourceName(getThisResource(), true, 799454592); if true then return end
  

--[[

*** author: krampsi
*** copyright ©
*** Zakaz używania zasobu bez mojej zgody.

]]--


local screenW, screenH = guiGetScreenSize()
local sw,sh = guiGetScreenSize()
local sx, sy = guiGetScreenSize( );
local elements = {}
local font = "default-bold"
--local clickable = true;
--local lastTick = false;
--local anim = "from-right-to-center";
--local yourTime = 2500; -- czas przez jaki ma jechać to coś ( w milisekundach )
--local zoom = sx == 1920 and 1 or math.min(2, 1920/sx);

function shadowText2(text, x, y, w, h, color, size, font, xx, yy)
	dxDrawText(text, x, y, w, h, color, size, font, xx, yy, false,false,false,true)
end

function shadowText(text, x, y, w, h, color, size, font, xx, yy)
	dxDrawText(text, x+1, y+1, w+1, h+1, tocolor(0,0,0), size, font, xx, yy, false)
	dxDrawText(text, x, y, w, h, color, size, font, xx, yy, false,false,false,true)
end

function roundedRectangle(x, y, w, h, color)

  dxDrawRectangle(x, y, w, h, color, false)
  dxDrawRectangle(x + 2, y - 1, w - 4, 1, color, false)
  dxDrawRectangle(x + 2, y + h, w - 4, 1, color, false)
  dxDrawRectangle(x - 1, y + 2, 1, h - 4, color, false)
  dxDrawRectangle(x + w, y + 2, 1, h - 4, color, false)
end

oknoPSP = false

local sx,sy = guiGetScreenSize()
local baseX = 1920
local zoom = 1
local minZoom = 2

if sx < baseX then
        zoom = math.min(minZoom, baseX/sx)
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

function gui()
		if getElementData(localPlayer,"schowek:PSP")==21 then
                dxDrawImage(785/zoom, 290/zoom, 350/zoom, 500/zoom, "files/wyposazenie.png", 0, 0, 0, tocolor(255, 255, 255, 240), false)
			if getElementData(localPlayer, "psp:item:torba2") == true then
				dxDrawText("Torba R-1 (#00ff00wyciągnięte#FFFFFF)\nKliknij, aby schować wyposażenie", 906/zoom, 379/zoom, 1080/zoom, 409/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			else
				dxDrawText("Torba R-1 (#bf0101schowane#FFFFFF)\nKliknij, aby wyjąć wyposażenie", 906/zoom, 379/zoom, 1080/zoom, 409/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			end
			if getElementData(localPlayer, "psp:item:rozpieracz") == true then
				dxDrawText("Nożyco-rozpieracz (#00ff00wyciągnięte#FFFFFF)\nKliknij, aby schować wyposażenie", 906/zoom, 451/zoom, 1080/zoom, 481/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			else
				dxDrawText("Nożyco-rozpieracz (#bf0101schowane#FFFFFF)\nKliknij, aby wyjąć wyposażenie", 906/zoom, 451/zoom, 1080/zoom, 481/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			end
			if getElementData(localPlayer, "psp:item:gasnica") == true then
				dxDrawText("Gaśnica (#00ff00wyciągnięte#FFFFFF)\nKliknij, aby schować wyposażenie", 906/zoom, 521/zoom, 1080/zoom, 551/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			else
				dxDrawText("Gaśnica (#bf0101schowane#FFFFFF)\nKliknij, aby wyjąć wyposażenie", 906/zoom, 521/zoom, 1080/zoom, 551/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			end
			if getElementData(localPlayer, "psp:item:norzyce") == true then
				dxDrawText("Piła łańcuchowa (#00ff00wyciągnięte#FFFFFF)\nKliknij, aby schować wyposażenie", 906/zoom, 591/zoom, 1080/zoom, 621/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			else
				dxDrawText("Piła łańcuchowa (#bf0101schowane#FFFFFF)\nKliknij, aby wyjąć wyposażenie", 906/zoom, 591/zoom, 1080/zoom, 621/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			end
		elseif getElementData(localPlayer,"schowek:PSP")==51 then
                dxDrawImage(screenW * 0.3906, screenH * 0.2222, screenW * 0.2188, screenH * 0.5556, ":psrpg-frakcja-safd/files/wyposazenieladder.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				
		elseif getElementData(localPlayer,"schowek:PSP")=="21_2" then
                dxDrawImage(785/zoom, 290/zoom, 350/zoom, 500/zoom, "files/wyposazenie2.png", 0, 0, 0, tocolor(255, 255, 255, 240), false)
			if getElementData(localPlayer, "psp:item:holigan") == true then
				dxDrawText("Siekiera strażacka (#00ff00wyciągnięte#FFFFFF)\nKliknij, aby schować wyposażenie", 906/zoom, 379/zoom, 1080/zoom, 409/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			else
				dxDrawText("Siekiera strażacka (#bf0101schowane#FFFFFF)\nKliknij, aby wyjąć wyposażenie", 906/zoom, 379/zoom, 1080/zoom, 409/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			end
			if getElementData(localPlayer, "psp:item:szyny2") == true then
				dxDrawText("Wentylator (#00ff00wyciągnięte#FFFFFF)\nKliknij, aby schować wyposażenie", 906/zoom, 451/zoom, 1080/zoom, 481/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			else
				dxDrawText("Wentylator (#bf0101schowane#FFFFFF)\nKliknij, aby wyjąć wyposażenie", 906/zoom, 451/zoom, 1080/zoom, 481/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			end
			if getElementData(localPlayer, "psp:item:CUG") == true then
				dxDrawText("Strój koszarowy (#00ff00wyciągnięte#FFFFFF)\nKliknij, aby schować wyposażenie", 906/zoom, 521/zoom, 1080/zoom, 551/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			else
				dxDrawText("Strój koszarowy (#bf0101schowane#FFFFFF)\nKliknij, aby wyjąć wyposażenie", 906/zoom, 521/zoom, 1080/zoom, 551/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			end
			if getElementData(localPlayer, "psp:item:aodo") == true then
				dxDrawText("AODO (#00ff00wyciągnięte#FFFFFF)\nKliknij, aby schować wyposażenie", 906/zoom, 591/zoom, 1080/zoom, 621/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			else
				dxDrawText("AODO (#bf0101schowane#FFFFFF)\nKliknij, aby wyjąć wyposażenie", 906/zoom, 591/zoom, 1080/zoom, 621/zoom, tocolor(255, 255, 255, 255), 1.00/zoom, "default-bold", "left", "top", false, false, false, true, false)
			end
		elseif getElementData(localPlayer,"schowek:PSP")==43 then
		shadowText("Hooligan", screenW * 0.3563, screenH * 0.2100, screenW * 0.6333, screenH * 0.5289, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
		shadowText("Torba R1", screenW * 0.3563, screenH * 0.3700, screenW * 0.6333, screenH * 0.5289, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
		shadowText("Ubranie CUG", screenW * 0.3563, screenH * 0.5300, screenW * 0.6333, screenH * 0.5289, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
		shadowText("Piła łańcuchowa", screenW * 0.3563, screenH * 0.7000, screenW * 0.6333, screenH * 0.5289, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
		
		
		elseif getElementData(localPlayer,"schowek:PSP")=="21_2" then
		shadowText("Hooligan", screenW * 0.3563, screenH * 0.2100, screenW * 0.6333, screenH * 0.5289, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
		shadowText("Szyny kramera", screenW * 0.3563, screenH * 0.3700, screenW * 0.6333, screenH * 0.5289, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
		shadowText("Deska ortopedyczna", screenW * 0.3563, screenH * 0.5300, screenW * 0.6333, screenH * 0.5289, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
		shadowText("Piła Łańcuchowa", screenW * 0.3563, screenH * 0.7000, screenW * 0.6333, screenH * 0.5289, tocolor(255, 255, 255, 255), 1.00, font, "center", "center", false, false, false, false, false)
		dxDrawImage(screenW * 0.6090, screenH * 0.2080, screenW * 0.030, screenH * 0.050, "files/strzalka2.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
		end


end






--[[addEventHandler("onClientClick", root, function(btn, state)
	if btn == "left" and state == "down" then

	if mysz(screenW * 0.4025, screenH * 0.4811, screenW * 0.1950, screenH * 0.0678) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")==51 then
	triggerServerEvent("PSPtermowizor",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	elseif mysz(812/zoom, 503/zoom, 297/zoom, 69/zoom) and oknoPSP == true  and getElementData(localPlayer,"schowek:PSP")==21 then
	triggerServerEvent("PSPgasnica",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	elseif mysz(1053/zoom, 294/zoom, 38/zoom, 28/zoom) and oknoPSP == true  and getElementData(localPlayer,"schowek:PSP")==21 then
	setElementData(localPlayer,"schowek:PSP","21_2")
	
    elseif mysz(1053/zoom, 294/zoom, 38/zoom, 28/zoom) and oknoPSP == true  and getElementData(localPlayer,"schowek:PSP")=="21_2" then
	setElementData(localPlayer,"schowek:PSP",21)

	
	elseif mysz(812/zoom, 361/zoom, 297/zoom, 69/zoom) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")=="21_2" then
	triggerServerEvent("PSPholigan",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	
	elseif mysz(812/zoom, 432/zoom, 297/zoom, 69/zoom) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")=="21_2" then
	triggerServerEvent("PSPszyny",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	
	elseif mysz(812/zoom, 503/zoom, 297/zoom, 69/zoom) and oknoPSP == true  and getElementData(localPlayer,"schowek:PSP")=="21_2" then
	triggerServerEvent("PSPcug",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	
	elseif mysz(812/zoom, 574/zoom, 297/zoom, 69/zoom) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")=="21_2" then
	triggerServerEvent("PSPaodo",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false

	
	elseif mysz(812/zoom, 503/zoom, 297/zoom, 69/zoom) and oknoPSP == true  and getElementData(localPlayer,"schowek:PSP")==51 then
	triggerServerEvent("PSPgasnica",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	elseif mysz(812/zoom, 432/zoom, 297/zoom, 69/zoom) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")==21 then
	triggerServerEvent("PSProzpieracz",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	elseif mysz(screenW * 0.4025, screenH * 0.3400, screenW * 0.1950, screenH * 0.0678) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")==51 then
	triggerServerEvent("PSPaodo",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	elseif mysz(812/zoom, 361/zoom, 297/zoom, 69/zoom) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")==21 then
	triggerServerEvent("PSPtorba",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	
	elseif mysz(1105/zoom, 299/zoom, 18/zoom, 18/zoom) and oknoPSP == true then
    removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	
	elseif mysz(screenW * 0.3563, screenH * 0.4967, screenW * 0.2771, screenH * 0.0722) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")==43	then
	triggerServerEvent("PSPcug",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	
	elseif mysz(812/zoom, 574/zoom, 297/zoom, 69/zoom) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")==21 then
	triggerServerEvent("PSPnorzyce",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	elseif mysz(screenW * 0.3563, screenH * 0.5800, screenW * 0.2771, screenH * 0.0722) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")==43 then
	triggerServerEvent("PSPnorzyce",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	elseif mysz(screenW * 0.3563, screenH * 0.4967, screenW * 0.2771, screenH * 0.0722) and oknoPSP == true  and getElementData(localPlayer,"schowek:PSP")==43 then
	triggerServerEvent("PSPcug",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false
	elseif mysz(screenW * 0.3563, screenH * 0.4134, screenW * 0.2771, screenH * 0.0722) and oknoPSP == true and getElementData(localPlayer,"schowek:PSP")==43 then
	triggerServerEvent("PSPtorba",root,localPlayer)
	removeEventHandler("onClientRender", root, gui)
	setElementData(localPlayer,"schowek:PSP",false)
	showCursor(false)
	oknoPSP = false

		end
	end
end)]]



--]]



addEvent("oknoEkwipunkuPSP", true)
addEventHandler("oknoEkwipunkuPSP", resourceRoot, function()
	lastTick = getTickCount();
	addEventHandler("onClientRender", root, gui)
	oknoPSP = true
	showCursor(true)
end)

--local img = dxCreateTexture("files/text.png")

local handbone = 25
--[[addEventHandler("onClientRender",root,function ()
for key, value in ipairs(getElementsByType("player")) do
	if getElementData(value,"psp:vnatarcie") then
		local veh = getElementData(value,"psp:vnatarcie")
		local x1,y1,z1 = getElementPosition( veh )
local x,y,z = getPedBonePosition( value, 24 )

dxDrawMaterialLine3D( x,y,z+0.1,x1,y1,z1,img, 0.10, tocolor(100,100,100,255) )

end
end

	end)]]


--[[ocal breathsnd = false
local breathskin = 277 

local breathSoundPath = "files/aodo.wav"

addEventHandler("onClientRender",root,function ()
	if getElementModel(localPlayer)==breathskin then
		if not breathsnd then
			breathsnd = playSound( breathSoundPath, true )
		end
	else
		if breathsnd then
			stopSound(breathsnd)
			breathsnd = false
		end
	end
	end)--]]

getResourceName(getThisResource(), true, 415628248); if true then return end
  

local history = {}
local bankMoney = 0
local newMoney = 0
local selected = 0

function updateATMMoney(value)
    newMoney = value
end
addEvent('updateATMMoneyy', true)
addEventHandler('updateATMMoneyy', root, updateATMMoney)

function updateATMLogs(tbl)
    history = tbl
end
addEvent('updateATMLogss', true)
addEventHandler('updateATMLogss', root, updateATMLogs)

function renderUI()
    local x, y, z = getElementPosition(localPlayer)
    local city, county = getZoneName(x, y, z, false), getZoneName(x, y, z, true)
    exports['since-blur']:dxDrawBlur(sx/2 - 245/zoom, sy/2 - 293/zoom, 490/zoom, 586/zoom, textures['mask'])
	dxDrawImage(sx/2 - 245/zoom, sy/2 - 293/zoom, 490/zoom, 586/zoom, 'data/bg.png')

	bankMoney = math.floor(newMoney)

	dxDrawText('$ #ffffff'..addCommas(bankMoney), sx/2, sy/2 - 174/zoom, nil, nil, tocolor(46, 117, 111, 225), 1, exports['since-fonts']:getFont('Inter-Black', 28/zoom), 'center', 'bottom', false, false, false, true)
	dxDrawText('Stan konta '..(selected == 0 and 'Prywatnego' or 'Organizacyjnego'), sx/2, sy/2 - 180/zoom, nil, nil, tocolor(255, 255, 255, 190), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'top')
	dxDrawText('Bankomat', sx/2 - 190/zoom, sy/2 - 264/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), 'left', 'bottom')
	dxDrawText(city..', '..county, sx/2 - 190/zoom, sy/2 - 264/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), 'left', 'top')

	local isIn = isMouseInPosition(sx/2 + 205/zoom, sy/2 - 273/zoom, 20/zoom, 20/zoom) and 255 or 200
	dxDrawImage(sx/2 + 205/zoom, sy/2 - 273/zoom, 20/zoom, 20/zoom, 'data/close.png', 0, 0, 0, tocolor(255, 255, 255, isIn))

	if getElementData(localPlayer, 'player:organization') then
		local isIn = isMouseInPosition(sx/2 + 160/zoom, sy/2 - 276/zoom, 30/zoom, 30/zoom) and 255 or 200
		dxDrawImage(sx/2 + 160/zoom, sy/2 - 276/zoom, 30/zoom, 30/zoom, selected == 1 and 'data/private.png' or 'data/group.png', 0, 0, 0, tocolor(255, 255, 255, isIn))
	end

	dxDrawImage(sx/2 - 225/zoom, sy/2 - 277/zoom, 24/zoom, 24/zoom, 'data/atm.png')

	local isIn = isMouseInPosition(sx/2 - 197/zoom, sy/2 - 80/zoom, 194/zoom, 40/zoom) and 255 or 200
	dxDrawImage(sx/2 - 197/zoom, sy/2 - 80/zoom, 194/zoom, 40/zoom, 'data/button.png', 0, 0, 0, tocolor(46, 117, 111, isIn))
	dxDrawText('Wpłać', sx/2 - 100/zoom, sy/2 - 60/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center')

	local isIn = isMouseInPosition(sx/2 + 2/zoom, sy/2 - 80/zoom, 194/zoom, 40/zoom) and 255 or 200
	dxDrawImage(sx/2 + 2/zoom, sy/2 - 80/zoom, 194/zoom, 40/zoom, 'data/button.png', 0, 0, 0, tocolor(67, 143, 135, isIn))
	dxDrawText('Wypłać', sx/2 + 99/zoom, sy/2 - 60/zoom, nil, nil, tocolor(241, 245, 244, 225), 1, exports['since-fonts']:getFont('Inter-Medium', 11/zoom), 'center', 'center')

	dxDrawImage(sx/2 - 233/zoom, sy/2 - 3/zoom, 466/zoom, 277/zoom, 'data/history_bg.png')
	dxDrawText('↻ Historia konta bankowego', sx/2 - 220/zoom, sy/2 + 28/zoom, nil, nil, tocolor(225, 225, 225, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'bottom')
	dxDrawText('Lista ostatnich działań na koncie bankowym', sx/2 - 220/zoom, sy/2 + 28/zoom, nil, nil, tocolor(46, 117, 111, 225), 1, exports['since-fonts']:getFont('Inter-Regular', 9/zoom), 'left', 'top')
    
	if selected == 1 then
		if #history > 0 then
			local offset = 0
			for i, v in ipairs(history) do
				if i >= 1 and i <= 4 then 
					dxDrawImage(sx/2 - 221/zoom, sy/2 + 56/zoom + offset, 442/zoom, 49/zoom, 'data/history_item.png', 0, 0, 0, tocolor(255, 255, 255))
					dxDrawImage(sx/2 - 221/zoom, sy/2 + 56/zoom + offset, 442/zoom, 49/zoom, 'data/history_color.png', 0, 0, 0, tocolor(46, 117, 111, 255))
					dxDrawImage(sx/2 - 208/zoom, sy/2 + 70/zoom + offset, 20/zoom, 20/zoom, icons['transaction'], 0, 0, 0, tocolor(46, 117, 111, 255))
					dxDrawText(v.date, sx/2 - 176/zoom, sy/2 + 79/zoom + offset, nil, nil, tocolor(255, 255, 255, 195), 1, exports['since-fonts']:getFont('Inter-Regular', 8/zoom), 'left', 'bottom')
					dxDrawText('↳#ffffff', sx/2 - 176/zoom, sy/2 + 79/zoom + offset, nil, nil, tocolor(255, 255, 255, 195), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
					
					local text = v.member..': '..v.title..' - '..(v.subTitle or '')
					dxDrawText(((text:len() > 61) and string.sub(text, 1, 61).."..." or text), sx/2 - 160/zoom, sy/2 + 79/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
		
					offset = offset + 52/zoom
				end
			end
		end
	else
		if #history > 0 then
			local offset = 0
			for i, v in ipairs(history) do
				if i >= 1 and i <= 4 then 
					local color = split(v["color"], ",")
					dxDrawImage(sx/2 - 221/zoom, sy/2 + 56/zoom + offset, 442/zoom, 49/zoom, 'data/history_item.png', 0, 0, 0, tocolor(255, 255, 255))
					dxDrawImage(sx/2 - 221/zoom, sy/2 + 56/zoom + offset, 442/zoom, 49/zoom, 'data/history_color.png', 0, 0, 0, tocolor(color[1], color[2], color[3], 255))
					dxDrawImage(sx/2 - 208/zoom, sy/2 + 70/zoom + offset, 20/zoom, 20/zoom, icons[v.icon], 0, 0, 0, tocolor(color[1], color[2], color[3], 255))
					dxDrawText(v.date, sx/2 - 176/zoom, sy/2 + 79/zoom + offset, nil, nil, tocolor(255, 255, 255, 195), 1, exports['since-fonts']:getFont('Inter-Regular', 8/zoom), 'left', 'bottom')
					dxDrawText('↳#ffffff', sx/2 - 176/zoom, sy/2 + 79/zoom + offset, nil, nil, tocolor(255, 255, 255, 195), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
					dxDrawText(((v.text:len() > 61) and string.sub(v.text, 1, 61).."..." or v.text), sx/2 - 160/zoom, sy/2 + 79/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'top', false, false, false, true)
		
					offset = offset + 52/zoom
				end
			end
		end
	end
end

local click = getTickCount()
function onClick(btn,state)
    if (btn == 'left' and state == 'down' and click < getTickCount()) then
		click = getTickCount() + 1000
        if isMouseInPosition(sx/2 + 205/zoom, sy/2 - 273/zoom, 20/zoom, 20/zoom) then
            toggleUI(false)
		elseif isMouseInPosition(sx/2 - 197/zoom, sy/2 - 80/zoom, 194/zoom, 40/zoom) then
			local money = math.floor(exports['since-gui']:getEditboxText(uiElements['edit_money']))
			
			if money and tonumber(money) and tonumber(money) >= 1 then
				triggerServerEvent(selected == 0 and 'transferBankMoneyy' or 'transferOrgBankMoneyy', resourceRoot, 'add', math.floor(math.abs(tonumber(money))))
			end
		elseif isMouseInPosition(sx/2 + 2/zoom, sy/2 - 80/zoom, 194/zoom, 40/zoom) then
			local money = math.floor(exports['since-gui']:getEditboxText(uiElements['edit_money']))
			
			if money and tonumber(money) and tonumber(money) >= 1 then
				triggerServerEvent(selected == 0 and 'transferBankMoneyy' or 'transferOrgBankMoneyy', resourceRoot, 'take', math.floor(math.abs(tonumber(money))))
			end
		elseif isMouseInPosition(sx/2 + 160/zoom, sy/2 - 276/zoom, 30/zoom, 30/zoom) and getElementData(localPlayer, 'player:organization') then
			if selected == 0 then 
				selected = 1
				bankMoney = 0
				newMoney = 0
				history = {}
				triggerServerEvent('updateBankMoneyy', resourceRoot, nil, nil, getElementData(localPlayer, 'player:organization').id)
				triggerServerEvent('updateBankLogss', resourceRoot, nil, nil, getElementData(localPlayer, 'player:organization').id)
			else 
				selected = 0 
				bankMoney = 0
				newMoney = 0
				history = {}
				triggerServerEvent('updateBankMoneyy', resourceRoot, nil)
				triggerServerEvent('updateBankLogss', resourceRoot, nil)
			end
        end
    end
end

local logLogin = true

function toggleUI(visible)
    local eventCallback = visible and addEventHandler or removeEventHandler

	bankMoney = 0
	selected = 0

    eventCallback('onClientRender', root, renderUI)
    eventCallback('onClientClick', root, onClick)
    showCursor(visible, false)
    setPlayerHudComponentVisible('all', false)
	setPlayerHudComponentVisible('crosshair', true)
	triggerServerEvent('updateBankMoneyy', resourceRoot, nil)
	triggerServerEvent('updateBankLogss', resourceRoot, nil)

    if visible then
		local x, y, z = getElementPosition(localPlayer)
    	local city, county = getZoneName(x, y, z, false), getZoneName(x, y, z, true)
		if logLogin then
			triggerServerEvent('addATMLogg', resourceRoot, nil, 'login', '255, 255, 0', 'Zalogowano się na konto bankowe #ded36d('..city..', '..county..')', 0)
			logLogin = false
		end
        uiElements['edit_money'] = exports['since-gui']:createEditbox('Wprowadź kwotę...', sx/2 - 127/zoom, sy/2 - 141/zoom, 253/zoom, 48/zoom, {155, 155, 155}, {
            alignX = 'left',
            paddingX = 45/zoom,
            caretColor = {255, 255, 255, 100},
            caretWidth = 1,
            font = exports['since-fonts']:getFont('Inter-Medium', 10/zoom),
            image = textures['editbox'],
            placeholderColor = {155, 155, 155},
            specialCharacters = '.*[_].*',
            passworded = false,
			caretHeight = 18/zoom,
			icon = textures['money'],
			iconPadding = 35/zoom,
			textColor = {255, 255, 255, 200},
        })
    else
        if (uiElements['edit_money']) then
            exports['since-gui']:destroyUIElement(uiElements['edit_money'])
        end
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function()
    if not getElementData(localPlayer, 'player:sid') then
        return
    end

    toggleUI(false)
end)

addEventHandler('onClientColShapeHit', resourceRoot, function(el, md)
	if el == localPlayer and md and getElementData(source, 'sphere:atm') then
		if getPedOccupiedVehicle(localPlayer) then
			return
		end
		
		toggleUI(true)
	end
end)

addEventHandler('onClientColShapeLeave', resourceRoot, function(el, md)
	if el == localPlayer then
		toggleUI(false)
	end
end)
getResourceName(getThisResource(), true, 318513737); if true then return end
sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local pensions = {
	['SAPD'] = {
		[1] = 10000,
		[2] = 10500,
		[3] = 11000,
		[4] = 11500,
		[5] = 12000,
		[6] = 12500,
		[7] = 13000,
		[8] = 13500,
		[9] = 14000,
		[10] = 14500,
		[11] = 15000,
		[12] = 15500,
		[13] = 16000,
		[14] = 16500,
		[15] = 17000,
		[16] = 17500,
		[17] = 18000,
		[18] = 18500,
	},

	['SARA'] = {
		[1] = 16500,
		[2] = 16700,
		[3] = 16900,
		[4] = 17100,
		[5] = 17300,
		[6] = 17500,
		[7] = 17800,
		[8] = 18000,
		[9] = 18200,
		[10] = 18400,
		[11] = 18600,
		[12] = 18800,
		[13] = 19000,
		[14] = 19200,
	},

	['TSA'] = {
		[1] = 18500,
		[2] = 19000,
		[3] = 21000,
		[4] = 22000,
		[5] = 24500,
		[6] = 25000,
		[7] = 26500,
		[8] = 28000,
		[9] = 29000,
		[10] = 29500,
		[11] = 31000,
		[12] = 33000,
		[13] = 34000,
		[14] = 35000,
	},
}


windows = {

	main = false,

}

function renderUI()
	if windows.main then
		local workingTime = getElementData(localPlayer, 'player:workinjob')
		local money = (pensions[FactionCode][rank1] * workingTime)
		local faction = getElementData(localPlayer, 'player:faction')
        local factionRank = getElementData(localPlayer, 'player:rank') or 'Brak danych'
        local factionRank = data.ranks[faction][factionRank]

    	dxDrawImage(sx/2 - 313/zoom, sy/2 - 216/zoom, 627/zoom, 433/zoom, 'data/bg.png')
    	dxDrawText('Odbiór wypłaty z frakcji', sx/2 - 140/zoom, sy/2 - 209/zoom, nil, nil, tocolor(209, 209, 209, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'top')
    	dxDrawText('Frakcja', sx/2 - 40/zoom, sy/2 - 173/zoom, nil, nil, tocolor(255, 255, 255, 191), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'top')
    	dxDrawText(faction, sx/2 - 0/zoom, sy/2 - 146/zoom, nil, nil, tocolor(35, 136, 229, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'top')
    	dxDrawText('Przepracowane minuty', sx/2 - 125/zoom, sy/2 - 114/zoom, nil, nil, tocolor(255, 255, 255, 191), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'top')
		if tonumber(workingTime) then
			workingTime = secondsToClock(60*workingTime)
		end
    	dxDrawText(workingTime, sx/2 - 0/zoom, sy/2 - 87/zoom, nil, nil, tocolor(229, 151, 35, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'top')
    	dxDrawText('Kwota do wypłacenia', sx/2 - 115/zoom, sy/2 - 57/zoom, nil, nil, tocolor(255, 255, 255, 191), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'top')
    	dxDrawText('$ '..przecinek(money) , sx/2 - 0/zoom, sy/2 - 30/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'top')
    	dxDrawText('Twój stopień', sx/2 - 70/zoom, sy/2 + 2/zoom, nil, nil, tocolor(255, 255, 255, 191), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'top')
    	dxDrawText(factionRank, sx/2 - 0/zoom, sy/2 + 29/zoom, nil, nil, tocolor(229, 152, 35, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'top')

    	if isMouseIn(sx/2 - 124/zoom, sy/2 + 88/zoom, 249/zoom, 50/zoom) then
    		dxDrawImage(sx/2 - 124/zoom, sy/2 + 88/zoom, 249/zoom, 50/zoom, 'data/button_on.png', 0, 0, 0, tocolor(241, 245, 244, 200), false)
    	else
    		dxDrawImage(sx/2 - 124/zoom, sy/2 + 88/zoom, 249/zoom, 50/zoom, 'data/button_on.png', 0, 0, 0, tocolor(255, 255, 255, 255), false)
    	end

    	if isMouseIn(sx/2 - 124/zoom, sy/2 + 147/zoom, 249/zoom, 50/zoom) then
    		dxDrawImage(sx/2 - 124/zoom, sy/2 + 147/zoom, 249/zoom, 50/zoom, 'data/button_off.png', 0, 0, 0, tocolor(241, 245, 244, 200), false)
    	else
    		dxDrawImage(sx/2 - 124/zoom, sy/2 + 147/zoom, 249/zoom, 50/zoom, 'data/button_off.png', 0, 0, 0, tocolor(255, 255, 255, 255), false)
    	end

    	dxDrawText('Anuluj', sx/2 - 36/zoom, sy/2 + 158/zoom, nil, nil, tocolor(209, 209, 209, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'top')
    	dxDrawText('Odbierz', sx/2 - 44/zoom, sy/2 + 99/zoom, nil, nil, tocolor(209, 209, 209, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'left', 'top')
    end
end


addEventHandler('onClientClick', root, function(button, state)
    if button == 'left' and state == 'down' then
        if isMouseIn(sx/2 - 124/zoom, sy/2 + 88/zoom, 249/zoom, 50/zoom) and windows.main == true then
            removeEventHandler('onClientRender', root, renderUI)
            triggerServerEvent('takePayment', resourceRoot, 'paymentFaction')
            showCursor(false)
            windows.main = false
        elseif isMouseIn(sx/2 - 124/zoom, sy/2 + 147/zoom, 249/zoom, 50/zoom) and windows.main == true then
            removeEventHandler('onClientRender', root, renderUI)
            showCursor(false)
            windows.main = false
        end
    end
end)

addEvent('showUIFaction', true)
addEventHandler('showUIFaction', resourceRoot, function(faction, result, rank)
	FactionCode = faction
	rank1 = rank
	addEventHandler('onClientRender', root, renderUI)
	windows.main = true
	showCursor(true)
end)

function przecinek(xd)
	local left,num,right = string.match(xd,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function secondsToClock(seconds)
	seconds = seconds or 0
	if seconds <= 0 then
		return "00:00"
	else
		hours = string.format("%02.f", math.floor(seconds/3600))
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)))
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60))
		return ""..hours.." godzin/y i "..mins.." minut"
	end
end

function isMouseIn ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end
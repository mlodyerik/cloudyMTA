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


local markersPayment = {

	{'SAPD', 'San Andreas Police Department', 1539.24, -1649.44, 88.03, 291, 0},
	--{'SAFD', 'San Andreas Fire Department', 849.01, 1917.36, 14.66, 0, 0},
	{'SARA', 'San Andreas Road Assistance', 1766.97, -1708.17, 16.56, 0, 0},
	--{'TSA', 'Transport Of San Andreas', -2023.70, -118.56, 1035.17, 0, 3},

}

for i, v in ipairs(markersPayment) do
	local marker = createMarker(v[3], v[4], v[5]-1, 'cylinder', 1.5, 255, 255, 125, 55)
	setElementData(marker, 'marker:icon', 'skin')
    setElementData(marker, 'marker:title', 'Wypłaty frakcyjne')
    setElementData(marker, 'marker:desc', v[2])
    setElementData(marker, 'marker:faction', v[1])
    setElementDimension(marker, v[6])
    setElementInterior(marker, v[7])
end

addEventHandler('onMarkerHit', resourceRoot, function(player, md)
	if not md or getElementType(player) ~= 'player' then
		return
	end
	local faction = getElementData(source, 'marker:faction')
	if not faction then
		return
	end
	local uid = getElementData(player, 'player:sid')
	if not uid then
		return
	end
	if getElementData(player, 'player:faction') ~= faction then
		exports['since-notifications']:sendNotification(player, 'error', 'Wejdź na służbę, by móc odebrać wypłatę!')
		return
	end
	local result = exports['since-db']:query('SELECT * FROM `since-factions` WHERE faction = ? AND uid = ? LIMIT 1;', faction, uid)
	local check = exports['since-db']:query('SELECT * FROM `since-factions` WHERE uid = ?', uid)
	if result and #result > 0 then
		local resulted = exports['since-db']:query('SELECT * FROM `since-factions` WHERE faction = ?', faction)
		triggerClientEvent(player, 'showUIFaction', resourceRoot, faction, resulted, check[1].rank)
	end
end)

addEvent('takePayment', true)
addEventHandler('takePayment', resourceRoot, function(arg, arg2, arg3)
	if (arg == 'paymentFaction') then
		local uid = getElementData(client, 'player:sid')
		local result = exports['since-db']:query('SELECT * FROM `since-factions` WHERE uid = ?', uid)
		if #result > 0 then
			if pensions[result[1].faction] then
				if getElementData(client, 'player:workinjob') and getElementData(client, 'player:workinjob') >= 1 then
					local check = exports['since-db']:query('SELECT * FROM `since-factions` WHERE uid = ?', uid)
					local money = (pensions[result[1].faction][check[1].rank] * getElementData(client, 'player:workinjob'))
					exports['since-notifications']:sendNotification(client, 'success', 'Otrzymujesz $ '..przecinek(money)..' za przepracowane '..getElementData(client, 'player:workinjob')..' minut')
					givePlayerMoney(client, money)
					setElementData(client, 'player:workinjob', 0)
					exports['since-logs']:sendDiscordLog('chat-adm', 'Wypłaty frakcja', 'Gracz `'..getPlayerName(client)..'` odebrał wypłatę z frakcji `'..result[1].faction..'` w wysokości `$ '..przecinek(money)..'`')
				else
					exports['since-notifications']:sendNotification(client, 'error', 'Nie masz nic do odebrania!')
				end
			end
		end
	end
end)

function przecinek(xd)
	local left,num,right = string.match(xd,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end
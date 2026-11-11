local positions = { 
	{
		object = {-2745.06, -262.73, 7.19}, 
		radarArea = {-2900, -400, 300, 300},
	},
	{
		object = {-2470.85, -309.65, 41.55}, 
		radarArea = {-2600, -400, 300, 300},
	},
	{
		object = {-2162.41, -213.71, 35.32}, 
		radarArea = {-2300, -400, 300, 300},
	},
	{
		object = {-1876.31, -186.67, 18.39}, 
		radarArea = {-2000, -400, 300, 300},
	},
	{
		object = {-1499.57, -248.13, 14.15}, 
		radarArea = {-1700, -400, 300, 300},
	},
	{
		object = {-2750.01, 109.24, 7.34}, 
		radarArea = {-2900, -100, 300, 300},
	},
	{
		object = {-2457.72, -23.25, 32.80}, 
		radarArea = {-2600, -100, 300, 300},
	},
	{
		object = {-2125.82, 150.93, 35.24}, 
		radarArea = {-2300, -100, 300, 300},
	},
	{
		object = {-1837.70, -17.17, 15.12}, 
		radarArea = {-2000, -100, 300, 300},
	},
	{
		object = {-1564.17, 68.82, 17.33}, 
		radarArea = {-1700, -100, 300, 300},
	},
	{
		object = {-2685.28, 271.19, 4.34}, 
		radarArea = {-2900, 200, 300, 300},
	},
	{
		object = {-2415.04, 327.87, 34.97}, 
		radarArea = {-2600, 200, 300, 300},
	},
	{
		object = {-2231.38, 300.78, 35.12}, 
		radarArea = {-2300, 200, 300, 300},
	},
	{
		object = {-1847.15, 314.62, 17.16}, 
		radarArea = {-2000, 200, 300, 300},
	},
	{
		object = {-1535.76, 364.87, 7.19}, 
		radarArea = {-1700, 200, 300, 300},
	},
	{
		object = {-2704.71, 633.14, 14.45}, 
		radarArea = {-2900, 500, 300, 300},
	},
	{
		object = {-2506.97, 737.75, 35.02}, 
		radarArea = {-2600, 500, 300, 300},
	},
	{
		object = {-2184.40, 609.15, 35.16}, 
		radarArea = {-2300, 500, 300, 300},
	},
	{
		object = {-1853.32, 583.58, 35.16}, 
		radarArea = {-2000, 500, 300, 300},
	},
	{
		object = {-1610.56, 735.47, -5.24}, 
		radarArea = {-1700, 500, 300, 300},
	},
	{
		object = {-2722.70, 983.60, 54.46}, 
		radarArea = {-2900, 800, 300, 300},
	},
	{
		object = {-2439.00, 1036.78, 50.39}, 
		radarArea = {-2600, 800, 300, 300},
	},
	{
		object = {-2078.30, 1008.32, 62.92}, 
		radarArea = {-2300, 800, 300, 300},
	},
	{
		object = {-1920.98, 889.41, 35.34}, 
		radarArea = {-2000, 800, 300, 300},
	},
	{
		object = {-1513.28, 1026.78, 7.19}, 
		radarArea = {-1700, 800, 300, 300},
	},
	{
		object = {-2833.00, 1313.73, 7.10}, 
		radarArea = {-2900, 1100, 300, 300},
	},
	{
		object = {-2530.60, 1226.92, 37.43}, 
		radarArea = {-2600, 1100, 300, 300},
	},
	{
		object = {-2175.76, 1223.79, 33.93}, 
		radarArea = {-2300, 1100, 300, 300},
	},
	{
		object = {-1844.40, 1300.71, 59}, 
		radarArea = {-2000, 1100, 300, 300},
	},
	{
		object = {-1512.42, 1214.69, 7.18}, 
		radarArea = {-1700, 1100, 300, 300},
	},

}

local zoneTypes = {
	[1] = 10000,
	[2] = 15000,
}

local timeToCapture = 90

local withdrawMoneyTime = 5

local zones = {}

function createZone(id)
	local db = exports['since-db']:query('select id from `since-zonesNew` where id = ? limit 1', id)
	if #db > 0 then return end
	local db = exports['since-db']:query('insert into `since-zonesNew` (id) values (?)', id)
	if db then
		loadZone(id)
	end
end

function getOrganizationName(id)
	local db = exports['since-db']:query("SELECT name FROM `since-orgs` WHERE uid=? LIMIT 1", id)
	if #db == 0 then return 'Brak' end
	return db[1].name
end

function getOrganizationLevel(id)
	local db = exports['since-db']:query("SELECT level FROM `since-orgs` WHERE uid=? LIMIT 1", id)
	if #db == 0 then return 1 end
	return db[1].level
end

function getOrganizationColor(id)
	local db = exports['since-db']:query("SELECT colorrgb FROM `since-orgs` WHERE uid=? LIMIT 1", id)
	if #db == 0 then return 255,255,255 end
	local color = split(db[1].colorrgb, ',')
	return color[1], color[2], color[3]
end

function loadZone(id)
	local db = exports['since-db']:query('select * from `since-zonesNew` where id = ? limit 1', id)
	if #db == 0 then
		createZone(id)
		return 
	end
	local v = db[1]
	local position = positions[id]
	local object = createObject(1355, unpack(position.object))
	setElementAlpha(object, 0)
	setElementCollisionsEnabled(object, false)
	local data = {}
	for i,v in pairs(v) do if v then data[i] = v end end
	local x,y,w,h = unpack(position.radarArea)
	local r,g,b = 255,255,255
	if v.takenByOrganization then 
		data['takenByOrganizationName'] = getOrganizationName(v.takenByOrganization) 
		data['takenByOrganizationLevel'] = getOrganizationLevel(v.takenByOrganization)
		r,g,b = getOrganizationColor(v.takenByOrganization)
	end
	data['hourlyIncome'] = zoneTypes[v.type]
	data['timeToCapture'] = timeToCapture
	data['color'] = {r,g,b}
	setElementData(object, 'zone:data', data)
	local radarArea = createRadarArea(x,y,w,h, r,g,b, 55)
	setRadarAreaFlashing(radarArea, false)
	zones[object] = {
		usedTick = getTickCount()+1000,
		radarArea = radarArea,
	}
end

function refreshZoneData(element)
	local db = exports['since-db']:query('update `since-zonesNew` set takenByOrganization = ?, takenByPlayer = ?, takenDate=NOW() where id = ? limit 1', getElementData(element, 'zone:data').takenByOrganization, getElementData(element, 'zone:data').takenByPlayer, getElementData(element, 'zone:data').id)
	if db then
		local db = exports['since-db']:query('select * from `since-zonesNew` where id = ? limit 1', getElementData(element, 'zone:data').id)
		if #db == 0 then return end
		local v = db[1]
		local data = {}
		for i,v in pairs(v) do if v then data[i] = v end end
		local r,g,b = 255,255,255
		if v.takenByOrganization then 
			data['takenByOrganizationName'] = getOrganizationName(v.takenByOrganization) 
			data['takenByOrganizationLevel'] = getOrganizationLevel(v.takenByOrganization)
			r,g,b = getOrganizationColor(v.takenByOrganization)
		end
		data['hourlyIncome'] = zoneTypes[v.type]
		data['timeToCapture'] = timeToCapture
		data['color'] = {r,g,b}
		setElementData(element, 'zone:data', data)
		setRadarAreaColor(zones[element].radarArea, r,g,b, 55)
	end
end

function startCapturing(element, player)
	if not zones[element] then return end
	zones[element].usedTick = getTickCount()
	if zones[element].timer then
		killTimer(zones[element].timer)
		zones[element].timer = nil
	end
	local data = getElementData(element, 'zone:data')
	if not data then return end
	data.timeToCapture = timeToCapture
	setElementData(element, 'zone:data', data)
	setRadarAreaFlashing(zones[element].radarArea, true)
	zones[element].timer = setTimer(function(element, player)
		if not isElement(element) or not isElement(player) then
			killTimer(zones[element].timer)
			zones[element].timer = nil
			return
		end
		local data = getElementData(element, 'zone:data')
		if not data then return end

		if not checkIfPlayerCanInteract(element, player) then
			exports["since-org"]:writeOnMembersChat(getElementData(player, "player:organization").id, "gracz #59aa7f"..getPlayerName(player):gsub("#%x%x%x%x%x%x", "").." #FFFFFFprzerywa przejmowanie terenu #59aa7f#"..data.id)

			data.isTaken = nil

			setElementData(element, 'zone:data', data)	

			setRadarAreaFlashing(zones[element].radarArea, false)

			killTimer(zones[element].timer)
			zones[element].timer = nil
			return
		end

		data.timeToCapture = math.max(data.timeToCapture - 1, 0)
		setElementData(element, 'zone:data', data)
		if data.timeToCapture <= 0 then

			local organization = getElementData(player, 'player:organization')

			data.isTaken = nil

			if organization then
				data.takenByOrganization = organization.id
				data.takenByOrganizationName = organization.name
				data.takenByOrganizationLevel = getOrganizationLevel(organization.id)
				data.takenByPlayer = getPlayerName(player)
				data.moneyEarned = 0
				exports['since-db']:query('update `since-zonesNew` set moneyEarned = 0 where id = ? limit 1', data.id)
			end

			setElementData(element, 'zone:data', data)	

			if organization then

				if data.takenByOrganization then
					exports["since-org"]:writeOnMembersChat(data.takenByOrganization, "ktoś przejął terytorium twojej organizacji #59aa7f#"..data.id)
				end
	
				exports["since-org"]:writeOnMembersChat(organization.id, "twoja organizacja przejeła strefę #59aa7f#"..data.id)

				refreshZoneData(element)
			end

			setRadarAreaFlashing(zones[element].radarArea, false)
			
			zones[element].usedTick = getTickCount()+2000
			killTimer(zones[element].timer)
			zones[element].timer = nil
			return
		end
	end, 1000, 0, element, player)
end

addEvent('zonesEvent', true)
addEventHandler('zonesEvent', resourceRoot, function(element)
	local data = getElementData(element, 'zone:data')
	if not data then return end
	local organization = getElementData(client, 'player:organization')
	if not organization then return end
	if data.takenByOrganization == organization.id or data.isTaken then return end
	if zones[element].usedTick > getTickCount() then return end

	data.isTaken = client
	setElementData(element, 'zone:data', data)
	
	if data.takenByOrganization then
		exports["since-org"]:writeOnMembersChat(data.takenByOrganization, "ktoś przejmuje teren twojej organizacji #59aa7f#"..data.id)
	end
	
	exports["since-org"]:writeOnMembersChat(organization.id, "gracz #59aa7f"..getPlayerName(client):gsub("#%x%x%x%x%x%x", "").." #FFFFFFz twojej organizacji przejmuje teren #59aa7f#"..data.id)

	startCapturing(element, client)
end)

function checkIfPlayerCanInteract(object, player)
    local vehicle = getPedOccupiedVehicle(player)
    if vehicle then return false end
    if isPedDead(player) then return false end
	if isPedInVehicle(player) then return false end
    if getElementData(player, 'player:admin') then return false end
	if getElementData(player, 'player:job') then return false end
	if not getElementData(player, 'player:organization') then return false end
	if getElementData(player, 'player:faction') then return false end
	if getElementData(player, 'temp:bw:ghost') then return false end
    local px,py,pz = getElementPosition(player)
    local ox,oy,oz = getElementPosition(object)
    if getDistanceBetweenPoints3D(px,py,pz,ox,oy,oz) > 7 then return false end
    return true
end

addEventHandler("onPlayerWasted", root, function()
    for element, v in pairs(zones) do
		local data = getElementData(element, 'zone:data')
		if data and data.isTaken == source then
			exports["since-org"]:writeOnMembersChat(getElementData(source, "player:organization").id, "gracz #59aa7f"..getPlayerName(source):gsub("#%x%x%x%x%x%x", "").." #FFFFFFprzerywa przejmowanie terenu #59aa7f#"..data.id)
			data.isTaken = nil
			setElementData(element, 'zone:data', data)	

			setRadarAreaFlashing(v.radarArea, false)
			
			v.usedTick = getTickCount()+2000

			killTimer(v.timer)
			v.timer = nil
		end
    end
end)

addEventHandler("onPlayerQuit", root, function()
    for element, v in pairs(zones) do
		local data = getElementData(element, 'zone:data')
		if data and data.isTaken == source then
			exports["since-org"]:writeOnMembersChat(getElementData(source, "player:organization").id, "gracz #59aa7f"..getPlayerName(source):gsub("#%x%x%x%x%x%x", "").." #FFFFFFprzerywa przejmowanie terenu #59aa7f#"..data.id)
			data.isTaken = nil
			setElementData(element, 'zone:data', data)	

			setRadarAreaFlashing(v.radarArea, false)
			
			v.usedTick = getTickCount()+2000

			killTimer(v.timer)
			v.timer = nil
		end
    end
end)

function startMoneyEarningSystem()
	setTimer(function()
		for element,v in pairs(zones) do
			local data = getElementData(element, 'zone:data')
			if data then
				if data.takenByOrganization then
					local money = math.floor((data.hourlyIncome + (32550 * data['takenByOrganizationLevel'])) / (60/withdrawMoneyTime))
					data.moneyEarned = data.moneyEarned + money
					setElementData(element, 'zone:data', data)
					exports['since-db']:query('update `since-zonesNew` set moneyEarned = ? where id = ? limit 1', data.moneyEarned, data.id)
					exports['since-db']:query("UPDATE `since-orgs` SET money=money+? WHERE uid=? LIMIT 1", money, data.takenByOrganization)
				end
			end
		end
	end, 60000*withdrawMoneyTime, 0)
end

function createAllZones()
	for i,v in ipairs(positions) do
		loadZone(i)
	end
	setTimer(function()
        triggerClientEvent(root, 'event', resourceRoot)
    end, 500, 1)
	startMoneyEarningSystem()
end
addEventHandler('onResourceStart', resourceRoot, createAllZones)
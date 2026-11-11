local fires = {
	[1] = {
		{1264.95, -132.96, 39.74},
		{1270.09, -132.42, 38.73},
		{1263.28, -137.01, 40.69},
		{1263.87, -134.96, 40.32},
		{1267.55, -132.24, 39.13},
		{1269.82, -134.37, 39.18},
	},

	[2] = {
		{196.30, -360.41, 4.46},
		{196.58, -357.94, 4.14},
		{195.57, -355.09, 3.78},
		{193.37, -355.76, 3.80},
		{198.85, -362.42, 4.80},
		{198.00, -359.66, 4.38},
	},

	[3] = {
		{1941.58, -1944.38, 13.55},
		{1944.68, -1944.82, 13.55},
		{1947.26, -1947.56, 13.55},
		{1946.82, -1944.08, 13.55},
		{1943.36, -1943.87, 13.55},
	},

	[4] = {
		{1539.01, -982.77, 37.19},
		{1537.73, -984.10, 37.15},
		{1540.50, -981.53, 37.23},
		{1536.82, -981.50, 37.10},
	},

	[5] = {
		{1865.20, -1226.12, 17.57},
		{1869.21, -1225.84, 17.33},
		{1864.49, -1222.46, 18.27},
		{1864.80, -1229.35, 17.00},
		{1866.98, -1224.72, 17.70},
	},

	[6] = {
		{2095.85, -1680.86, 13.5},
		{2094.73, -1678.12, 13.55},
		{2094.25, -1682.38, 13.55},
		{2096.67, -1682.44, 13.55},
	},

	[7] = {
		{107.35, -1574.33, 10.09},
		{107.34, -1576.52, 10.46},
		{102.25, -1575.64, 10.26},
		{110.81, -1574.13, 10.10},
		{105.06, -1575.82, 10.32},
		{109.19, -1571.76, 9.67},
	},

	[8] = {
		{-11.37, -699.47, 9.15},
		{-11.86, -697.53, 9.46},
		{-9.83, -700.56, 8.65},
		{-11.85, -701.97, 9.03},
		{-10.37, -698.04, 9.03},
		{-13.81, -703.09, 9.44},
		{-14.03, -697.03, 10.07},
	},

	[9] = {
		{359.40, 738.34, 4.41},
		{362.44, 737.77, 4.53},
		{365.34, 735.68, 4.75},
		{362.73, 732.11, 5.15},
		{361.71, 734.85, 4.72},
		{365.06, 737.59, 4.61},
	},

	[10] = {
		{1152.25, 1828.76, 10.82},
		{1154.34, 1833.07, 10.75},
		{1157.02, 1831.03, 10.74},
		{1156.37, 1827.05, 10.79},
		{1153.64, 1826.93, 10.82},
		{1151.91, 1832.83, 10.79},
	},

	[11] = {
		{2347.19, -1173.67, 28.29},
		{2345.45, -1174.59, 28.29},
		{2347.20, -1171.03, 28.07},
		{2344.42, -1171.46, 28.29},
		{2351.17, -1177.44, 27.97},
		{2352.38, -1180.25, 27.98},
		{2323.00, -1170.44, 28.10},
		{2326.58, -1170.52, 28.08},
		{2327.51, -1172.29, 28.29},
		{2329.99, -1169.86, 28.07},
	},
	[12] = {
		{2307.68, -1783.80, 13.56},
		{2307.68, -1787.88, 13.55},
		{2307.47, -1781.77, 16.05},
		{2307.42, -1787.56, 14.92},

	}
}

local function generateRandomFire()
	for i,v in ipairs(getElementsByType("ped", resourceRoot)) do
		destroyElement(v)
	end

	local temptable = {}
	for i,v in pairs(fires) do
		table.insert(temptable, v)
	end

	for i=1,4 do
		if (#temptable == 0) then
			break
		end

		local random = math.random(1, #temptable)
		for i2,v in ipairs(temptable[random]) do
			local ped = createPed(0, unpack(v))
			setElementData(ped, "fire", true)
			setElementFrozen(ped, true)
			setElementAlpha(ped, 0)
		end
		table.remove(temptable, random)
	end
end
generateRandomFire()
setTimer(generateRandomFire, 60000 * 10, 0)

addEvent("fire:damage", true)
addEventHandler("fire:damage", resourceRoot, function(ped)
	if getElementType(ped) ~= "ped" then return end
	setElementHealth(ped, (getElementHealth(ped)-5))
end)

addEvent("fire:destroy", true)
addEventHandler("fire:destroy", resourceRoot, function(ped)
	if (isElement(ped)) and getElementData(ped, 'fire') then
		destroyElement(ped)
		local randomMoney = math.random(200000, 350000)

		outputChatBox("#00ff00✔ #ffffffPomyślnie ugaszono pożar, otrzymujesz #59eb05$ "..comma(randomMoney), client, _, _, _, true)
		givePlayerMoney(client, randomMoney)
	end
end)

comma = function(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
		if (k==0) then
			break
		end
	end
	return formatted
end
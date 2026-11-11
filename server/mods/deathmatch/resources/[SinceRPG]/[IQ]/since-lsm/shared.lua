local normalVehicles = {
    602, 496, 401, 518, 527, 589, 419, 587, 533, 526, 474, 545, 517, 410, 600, 436, 439, 549, 491,
    445, 604, 507, 585, 466, 492, 546, 551, 516, 467, 426, 547, 405, 580, 409, 550, 566, 540, 421, 529
}


local specialVehicles = {
    80134, 80047, 80094, 80001
}

local planes = {
    511, 512, 593, 520, 553, 476, 519, 460, 513
}

local trucks = {
    499, 609, 498, 524, 532, 578, 486, 406, 573, 455, 588, 403, 423, 414, 443, 515, 514, 531, 456
}

local positions = {
    {348.95, -1785.15, 5.31, -0.00, 0.00, 276.35},
    {1070.44, -2371.00, 12.91, -0.00, 0.00, 224.69},
    {1623.37, -2501.44, 13.29, 0.0, 0.0, 270.5},
    {2857.69, -1158.15, 24.66, 0.4, 0.0, 4.2},
    {2465.04, -23.20, 26.09, 0.1, 0.0, 351.7},
    {2435.03, 155.51, 25.75, 355.7, 2.0, 23.4},
    {1628.54, 627.34, 10.60, 0.0, 0.0, 29.6},
    {630.68, 1007.29, 5.54, 360.0, 359.8, 271.2},
    {-292.11, 1545.25, 75.10, 0.0, 0.0, 136.1},
    {-653.81, 1449.74, 13.37, 0.0, 0.0, 172.7},
    {-1205.99, 1830.42, 41.45, 0.0, 0.0, 82.0},
    {-1666.17, 2542.40, 84.99, 357.1, 6.9, 67.3},
    {-2409.46, 2343.28, 6.11, 359.9, 0.6, 123.8},
    {-2662.39, 1922.55, 64.73, 0.9, 2.2, 110.9},
    {-2670.88, 1395.47, 55.18, 0.0, 360.0, 215.6},
    {-1053.58, 1569.09, 33.44, 354.2, 357.4, 128.0},
    {-294.98, 578.72, 15.62, 1.5, 351.7, 261.4},
    {484.39, 514.59, 18.71, 0.0, 353.6, 213.4},
    {765.76, -151.48, 18.90, 353.1, 345.9, 131.0},
    {1032.85, -58.97, 22.65, 1.4, 6.3, 293.6},
    {1434.74, -1083.74, 23.60, 0.0, 0.0, 178.0},
    {570.00, -1389.46, 14.32, 2.8, 359.7, 89.9},
    {-563.57, -1049.51, 23.68, 1.1, 359.9, 325.9},
    {-459.96, -835.84, 50.05, 1.9, 357.9, 152.5},
    {-958.92, -1498.52, 113.49, 348.7, 35.5, 221.4},
    {-859.39, -1844.18, 90.79, 0.4, 5.1, 254.6},
    {-581.05, -1476.47, 11.14, 353.7, 359.0, 274.1},
    {682.87, 2351.64, 22.55, 10.9, 18.8, 4.5},
    {1055.18, 2896.64, 43.94, 2.8, 13.8, 1.5},
    {2255.67, 2795.59, 10.38, 182.7, 0.2, 9.6},
    {2746.75, 2479.36, 11.08, 15.7, 357.9, 257.6},
    {2740.15, 1312.13, 7.31, 358.0, 16.6, 172.4},
    {2154.19, 712.30, 10.57, 1.3, 359.3, 138.4},
    {1778.29, 619.07, 10.60, 0.0, 0.0, 71.6},
    {811.06, 629.46, 1.26, 1.6, 332.1, 127.0},
    {-57.82, 58.62, 6.27, 357.9, 0.1, 162.9},
    {-44.33, 40.38, 3.68, 348.6, 0.3, 161.1},
    {-223.17, -796.12, 2.93, 9.0, 359.1, 147.1},
    {-1204.12, -2909.05, 64.36, 29.4, 343.1, 59.9},
}

local planesPositions = {
    {1412.76, -2429.56, 13.55, -0.00, 0.00, 269.97},
    {-1209.71, -146.30, 13.92, 360.0, 0.0, 135.8},
    {-1303.71, -683.28, 13.88, 0.0, 0.0, 178.0},
    {1694.56, 1191.40, 34.55, 0.0, 360.0, 333.9},
    {1356.13, 1529.13, 10.51, 0.0, 2.3, 84.2},
    {1570.29, 1539.69, 10.58, 0.0, 360.0, 223.0},
    {2091.76, -2599.07, 13.13, 0.3, 0.0, 341.8},
    {2485.60, -2167.43, 13.25, 359.6, 360.0, 269.8},
    {2574.04, -642.83, 135.91, 1.9, 7.8, 71.1},
    {1770.80, -395.81, 85.88, 6.6, 337.3, 11.1},
    {1693.99, 669.42, 19.30, 359.6, 360.0, 0.8},
}

function getRandomVehicles(player)
    local isHaveSpecialCars = false
    local isHavePlanes = exports["since-jobs"]:getPlayerUpgradeLevel(player, "lsm", 'Samoloty') == 1
    local isHaveTrucks = exports["since-jobs"]:getPlayerUpgradeLevel(player, "lsm", 'Ciezarowki') == 1
    
    if (isHaveSpecialCars) then
    else
        local randomVehicles = {
            ['cars'] = {},
            ['planes'] = {},
            ['trucks'] = {}
        }

        for i = 1, 4 do
            local randomVehicle = normalVehicles[math.random(1, #normalVehicles)]
            table.insert(randomVehicles['cars'], {
                model = randomVehicle,
                position = positions[math.random(1, #positions)],
                money = math.random(config.money.normal.min, config.money.normal.max)
            })
        end

        table.insert(randomVehicles['cars'], {
            model = specialVehicles[math.random(1, #specialVehicles)],
            position = positions[math.random(1, #positions)],
            money = math.random(config.money.special.min, config.money.special.max)
        })

        if (isHavePlanes) then
            for i = 1, 5 do
                local randomVehicle = planes[math.random(1, #planes)]
                table.insert(randomVehicles['planes'], {
                    model = randomVehicle,
                    position = planesPositions[math.random(1, #planesPositions)],
                    money = math.random(config.money.planes.min, config.money.planes.max)
                })
            end
        end

        if (isHaveTrucks) then
            for i = 1, 5 do
                local randomVehicle = trucks[math.random(1, #trucks)]
                table.insert(randomVehicles['trucks'], {
                    model = randomVehicle,
                    position = positions[math.random(1, #positions)],
                    money = math.random(config.money.trucks.min, config.money.trucks.max)
                })
            end
        end

        table.shuffle(randomVehicles['cars'])
        table.shuffle(randomVehicles['planes'])
        table.shuffle(randomVehicles['trucks'])

        return randomVehicles
    end
end

function getAllowedSorts()
    local sorts = {
        'cars'
    }

    if (exports["since-jobs"]:getPlayerUpgradeLevel("lsm", 'Samoloty') == 1) then
        table.insert(sorts, 'planes')
    end

    if (exports["since-jobs"]:getPlayerUpgradeLevel("lsm", 'Ciezarowki') == 1) then
        table.insert(sorts, 'trucks')
    end

    return sorts
end

function addCommas(n)
    n = tostring(n)
    return n:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function table.shuffle(t)
	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
	return t
end

function table.find(t, value)
    for k, v in pairs(t) do
        if (v == value) then
            return k
        end
    end
    return false
end
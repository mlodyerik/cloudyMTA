local srp = 1000
local moneyForOneWood = 5000000
local carMax = {12, 18}
local config = {
    [1] = {
        points = {
            { -995.05, -1401.25, 130.57 }, { -1070.15, -1362.74, 130.14 }, { -1092.16, -1329.65, 129.37 }, { -207.82, -2296.82, 28.85 }, { -991.69, -1460.19, 128.84 }, { -1039.29, -1405.56, 130.90 }, { -1114.31, -1387.77, 127.60 },
        },
    },
    [2] = {
        points = {
            { -815.92, -1564.79, 128.39 }, { -836.42, -1547.74, 129.49, }, { -805.73, -1546.28, 131.64 }, { -941.06, -1426.49, 127.00 }, { -926.83, -1463.77, 124.14 }, { -898.21, -1494.82, 124.66 }
        },
    },
}

local unloadPoint = {-1119.19, -1618.73, 76.39}
local vehicleCreation = {-1110.49, -1642.05, 76.06, 359.5, 360.0, 270.3}
local vehicleWoodsOffsets = {
    {0.4,-0.95,-0.1},
    {-0.4,-0.95,-0.1},
    {0.4,-1.6,-0.1},
    {-0.4,-1.6,-0.1},
    {0.4,-2.25,-0.1},
    {-0.4,-2.25,-0.1},
    
    {0.4,-0.95,0.1},
    {-0.4,-0.95,0.1},
    {0.4,-1.6,0.1},
    {-0.4,-1.6,0.1},
    {0.4,-2.25,0.1},
    {-0.4,-2.25,0.1},
    
    {0.4,-0.95,0.3},
    {-0.4,-0.95,0.3},
    {0.4,-1.6,0.3},
    {-0.4,-1.6,0.3},
    {0.4,-2.25,0.3},
    {-0.4,-2.25,0.3},
}

function getCourses()
    return config
end

function getCourseById(id)
    return config[id]
end

function getVehicleWoodsOffsets()
    return vehicleWoodsOffsets
end

function getCarMax()
    return carMax
end

function getUnloadPoint()
    return unloadPoint
end

function getConfigSrp()
    return srp
end

function getMoneyForOneWood()
    return moneyForOneWood
end

function getVehicleCreation()
    return vehicleCreation
end
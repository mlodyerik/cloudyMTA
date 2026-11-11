positions = {

    {

        name = 'Ammunation',
        desc = 'Sklep z brońmi',
        enter = {1367.75, -1279.77, 13.55, 0, 0},
        exit = {285.34, -40.88, 1001.52, 1, 0},
        shape = createColCuboid(281.33, -48.08, 997.94, 22.74, 47.25, 8.90),
        blip = 18,

    },

    {

        name = 'Magazyn',
        desc = 'Praca magazyniera',
        enter = {2179.19, -2255.68, 14.77, 0, 0},
        exit = {-1905.95, 2.82, 1042.18, 14, 0},
        shape = createColCuboid(-1936.17, -8.21, 1037.18, 37.92, 70.55, 17.86),
        shapeData = {14, 0},
        blockJob = true,
        blip = 46,

    },

    {

        name = 'Salon Las Venturas',
        desc = 'Salon pojazdów',
        enter = {2127.54, 2379.31, 10.82, 0, 0},
        exit = {906.59, 10.69, 1002.28, 3, 0},
        shape = createColCuboid(892.00, 10.19, 1001.28, 31.69, 49.32, 1.90),
        shapeData = {3, 0},
        blip = 55,

    },

    {

        name = 'Kopalnia',
        desc = 'Praca górnika',
        enter = {-591.39, -1063.26, 23.40, 0, 0},
        exit = {-2562.19, 1397.94, 909.40, 3, 0},
        shape = createColCuboid(-2585.68, 1396.48, 908.40, 66.93, 51.45, 7.95),
        shapeData = {3, 0},
        blip = 46,

    },

    {

        name = 'TSA',
        desc = 'Siedziba frakcji',
        enter = {2200.87, 1393.66, 10.82, -0.00, 0.00},
        exit = {-2029.69, -118.97, 1035.17, 3, 0},
        shape = createColCuboid(-2037.02, -123.00, 1031.73, 16.76, 24.19, 7.69),
        shapeData = {3, 0},
        blip = 60,

    },

    {

        name = 'Kasyno',
        desc = 'Znowu na minus?',
        enter = {1836.42, -1682.47, 13.35, 0, 0},
        exit = {2018.63, 1017.85, 996.88, 10, 0},
        shape = createColCuboid(1918.57, 963.45, 987.88, 106.89, 111.98, 21.40),
        shapeData = {3, 0},
        blip = 25,

    },

}

addEventHandler('onClientResourceStart', resourceRoot, function()
    for i,v in ipairs(positions) do
        local x, y, z, int, dim = unpack(v.enter)
        local enterMarker = createMarker(x, y, z - 0.7, 'cylinder', 1.5, 125, 255, 125, 200)
        local blip = createBlip(x, y, z, v.blip, 2, 255, 255, 255, 255, 0, 450)
        setElementData(enterMarker, 'interior:people', 0)
        setElementData(enterMarker, 'marker:icon', 'entrance')
        setElementData(enterMarker, 'marker:title', v.name)
        setElementData(enterMarker, 'marker:desc', 'Wejście do pomieszczenia')
        setElementData(enterMarker, 'interior:data', v)

        setElementData(v.shape, 'shape:interior', {name = v.name, desc = v.desc})

        if v.shapeData then
            setElementInterior(v.shape, v.shapeData[1])
            setElementDimension(v.shape, v.shapeData[2])
        end
        
        addEventHandler('onClientMarkerHit', enterMarker, function(el, md)
            if not md then return end
            if el ~= localPlayer then return end
            if getPedOccupiedVehicle(el) then
                return
            end
            
            
            showInteriorsUI(getElementData(enterMarker, 'interior:data'), 'enter')
        end)
        
        addEventHandler('onClientMarkerLeave', enterMarker, function(el, md)
            if not md then return end
            if el ~= localPlayer then return end
            if getPedOccupiedVehicle(el) then
                return
            end
            
            hideInteriorsUI()
        end)
        
        local x, y, z, int, dim = unpack(v.exit)
        local exitMarker = createMarker(x, y, z - 0.7, 'cylinder', 1.5, 255, 125, 125, 200)
        setElementData(exitMarker, 'marker:icon', 'entrance')
        setElementData(exitMarker, 'marker:title', v.name)
        setElementData(exitMarker, 'marker:desc', 'Wyjście z pomieszczenia')
        setElementData(exitMarker, 'interior:data', v)
        setElementDimension(v.shape, dim)
        setElementInterior(v.shape, int)
        setElementDimension(exitMarker, dim)
        setElementInterior(exitMarker, int)
        
        addEventHandler('onClientMarkerHit', exitMarker, function(el, md)
            if not md then return end
            if el ~= localPlayer then return end
            if getPedOccupiedVehicle(el) then
                return
            end

            local x, y, z = getElementPosition(source)
            local x2, y2, z2 = getElementPosition(localPlayer)
            local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

            if dist > 3 then
                return
            end

            if getElementInterior(localPlayer) ~= getElementInterior(source) then
                return
            end

            showInteriorsUI(getElementData(exitMarker, 'interior:data'), 'exit')
        end)

        addEventHandler('onClientMarkerLeave', exitMarker, function(el, md)
            if not md then return end
            if el ~= localPlayer then return end
            if getPedOccupiedVehicle(el) then
                return
            end

            hideInteriorsUI()
        end)
    end
end)
getResourceName(getThisResource(), true, 48152768); if true then return end
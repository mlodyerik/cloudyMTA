--[[local markers = {
    {-1912.39, 827.88, 35.23, 362.88, -75.18, 1001.51, -1910.61, 829.60, 35.17, 10, 1, 29},
    {2393.20, 2041.6, 10.82, 362.88, -75.18, 1001.51, 2393.30, 2044.24, 10.82, 10, 2, 29},
    {2472.64, 2034.12, 11.06, 362.88, -75.18, 1001.51, 2469.64, 2034.39, 11.06, 10, 3, 29},
    {928.90, -1352.94, 13.34, 362.88, -75.18, 1001.51, 925.45, -1352.73, 13.38, 10, 5, 29},
    {1199.26, -918.26, 43.12, 362.88, -75.18, 1001.51, 1199.41, -921.03, 43.10, 10, 6, 29},
    {-1816.58, 618.46, 35.17, 362.88, -75.18, 1001.51, -1816.58, 615.13, 35.17, 10, 7, 29},
}

for i,v in ipairs(markers) do
    local marker = createMarker(v[1], v[2], v[3] + 0.75, "arrow", 1.2, 255, 255, 0)
    setElementData(marker, "marker:dim", v[11])
    local marker2 = createMarker(v[4], v[5], v[6] + 0.75, "arrow", 1.2, 255, 255, 0)
    setElementInterior(marker2, v[10])
    setElementDimension(marker2, v[11])
    setElementData(marker2, "marker:exit", {v[7], v[8], v[9]})
    createBlip(v[1], v[2], v[3], v[12], 2, 0, 0, 0, 0, 0, 275)
end

createBlip(-1912.39, 827.88, 35.23, 10,2,0,0,0,0,0,275)

 wejscie2 = createMarker(-1912.39, 827.88, 35.23+0.75, "arrow", 1.2, 255, 255, 0)
 setElementData(wejscie2, 'typ', 'drzwi')
 wyjscie2 = createMarker(362.88, -75.18, 1001.51+0.65, "arrow", 1.2, 255, 255, 0)
 setElementData(wyjscie2, 'typ', 'drzwi')
 setElementInterior(wyjscie2,10)
 setElementDimension(wyjscie2,0)]]--

local positions = {

    cuboid = createColCuboid(2382.73, -1914.31, 12.55, 17.70, 14.60, 4.83),
    cuboid = createColCuboid(2105.03, -1822.50, 12.55, 18.84, 31.74, 11.95),
    cuboid = createColCuboid(791.46, -1628.16, 12.38, 20.23, 26.09, 11.56),
    cuboid = createColCuboid(1186.01, -920.24, 42.27, 23.61, 22.21, 5.49),

}


addEventHandler('onColShapeLeave', resourceRoot, function(element, md)
    if getElementType(element) ~= 'player' or not md then
        return
    end
    if getElementData(element, 'player:napada') then
    	outputChatBox('ⓘ #ffffffWyszedłeś poza strefę napadu i został on przerwany', element, 255, 255, 0, true)
    	removeElementData(element, 'player:napada')
    	triggerClientEvent(element, "enonek-napady:toggleRend", resourceRoot, false)
    	triggerClientEvent(element, "enonek-napad:end:client", resourceRoot)
    end
end)

addEventHandler('onColShapeHit', resourceRoot, function(element, md)
    if getElementType(element) ~= 'player' or not md then
        return
    end
    outputChatBox('ⓘ #ffffffWkroczyłeś na teren napadu, wyceluj w sprzedawcę aby go zacząć', element, 255, 255, 0, true)
    setElementData(element, 'player:napada', true)
    triggerClientEvent(element, "enonek-napady:toggleRend", resourceRoot, true)
end)

--[[addEventHandler("onColShapeHit", resourceRoot, function(el,md)
    if getElementType(el) ~= "player" then 
        return false
    end
    if isPedInVehicle(el) then 
        return false
    end
    
    if getElementDimension(source) ~= getElementDimension(el) then
        return false
    end

    if getElementData(source, "marker:exit") then
        fadeCamera(el ,false)
 	    setElementFrozen(el, true)
 	    setTimer(function(source)
            local pos = getElementData(source, "marker:exit")
 	      --  setElementInterior(el, 0)
 	       -- setElementDimension(el, 0)
 	        setElementFrozen(el, false)
	       -- setElementPosition(el, unpack(pos))
 	        setElementFrozen(el, false)
 	        fadeCamera(el, true)
            removeElementData(el, "plr:marker")
            triggerClientEvent(source, "enonek-napady:toggleRend", resourceRoot, false)
            if not getElementData(el, 'player:faction') then
                takeAllWeapons(el)
                if getElementData(el, 'player:admin') then
                    giveWeapon(el, 22, 200)
                end
            end
            removeElementData(el, "player:napada")
 	    end, 1500, 1, source)
    else
 	    fadeCamera(el ,false)
 	    setElementFrozen(el, true)
 	    setTimer(function(marker, player)
            for i = 69,79 do
                setPedStat ( player, i, 1000 )
            end
            local dim = getElementData(marker, "marker:dim")
 	       -- setElementInterior(player, 10)
 	       -- setElementDimension(player, dim)
 	        setElementFrozen(player, false)
	       -- setElementPosition(player, 364.67, -73.77, 1001.51)
 	        setElementFrozen(player, false)
 	        fadeCamera(player, true)
            outputChatBox("#00ff00* #ffffffAby rozpocząć napad #ff0000wyceluj w sprzedawcę!", player, 255, 255, 255, true)
            outputChatBox("#00ff00* #ffffffTwoim zadaniem jest #ff0000zastrzelenie 5 przeciwników w minigrze, wtedy rozpocznie się napad!", player, 255, 255, 255, true)
            outputChatBox("#00ff00* #ffffffMożesz pomylić się #ff0000maksymalnie dwa razy!", player, 255, 255, 255, true)
            setElementData(player, "plr:marker", marker)
            setElementData(player, "player:napada", true)
            triggerClientEvent(player, "enonek-napady:toggleRend", resourceRoot, true)
 	    end, 1500, 1, source, el)
    end
    triggerClientEvent(el, "enonek-napad:end:client", resourceRoot)
end)]]

cooldowns = {}

addEvent("enonek-napady:insert:cooldown", true)
addEventHandler("enonek-napady:insert:cooldown", resourceRoot, function()
    local sid = getElementData(client, "player:sid")
    if sid then
        cooldowns[sid] = getTickCount()
    end
end)

addEvent("enonek-napad:get:cooldown", true)
addEventHandler("enonek-napad:get:cooldown", resourceRoot, function()
    local sid = getElementData(client, "player:sid")
    if sid then
        if cooldowns[sid] then
            if getTickCount() - cooldowns[sid] < 300000 then
                triggerClientEvent(client, "enonek-napad:set:cooldown", resourceRoot, false)
            else
                triggerClientEvent(client, "enonek-napad:set:cooldown", resourceRoot, true)
            end
        else
            triggerClientEvent(client, "enonek-napad:set:cooldown", resourceRoot, true)
        end
    end
end)

addEvent("enonek-napad:end", true)
addEventHandler("enonek-napad:end", resourceRoot, function()
    local sid = getElementData(client, "player:sid")
    if sid then
        outputChatBox("#00ff00✔ #ffffffPomyślnie wykonano napad i otrzymano 350.000 PLN!", client, 255, 255, 255, true)
        exports["since-db"]:query("UPDATE `since-users` SET bankMoney=bankMoney+? WHERE uid=?", 350000, sid)
    end
end)

addEvent('napad:sapd:info', true)
addEventHandler('napad:sapd:info', resourceRoot, function()
    local x, y, z = getElementPosition(client)
    local location = getZoneName(x, y, z)..', '..getZoneName(x, y, z, true)
    for i, v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:faction') == 'SAPD' then
            outputChatBox(' ', v)
            outputChatBox('✉#ffffff W lokalizacji #6b98ff'..location..'#ffffff odnotowano napad na sklep.', v, 255, 175, 0, true)
            outputChatBox(' ', v)
        end
    end
end)
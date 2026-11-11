  

local faggios = {}
local timers = {}
local spawns = {
    

    {1463.00, -1724.50, 13.12, 359.5, 359.9, 180},
    {1459.00, -1724.50, 13.12, 359.5, 359.9, 180},
    {1455.00, -1724.50, 13.12, 359.5, 359.9, 180},
	{190.71, -39.38, 1.18, 359.5, 0.0, 90, 180},
	{190.74, -37.51, 1.18, 359.5, 360.0, 90.0, 180},
	{190.79, -35.67, 1.18, 359.5, 360.0, 90.1, 180},
	{190.62, -37.50, 1.18, 359.5, 0.0, 89.7, 180},

}

function isPlaceClear(x, y, z)
    for k,v in pairs(getElementsByType("vehicle", resourceRoot)) do
        if getDistanceBetweenPoints3D(x, y, z, Vector3(getElementPosition(v))) < 2 then
            return false
        end
    end
    return true
end

function checkPlayerMotorcycles(plr)
    for k,v in pairs(getElementsByType("vehicle", resourceRoot)) do
        if getElementData(v, "vehicle:public:owner") == plr then
            return true
        end
    end
    return false
end

function setVehicleDesc(veh, text)
    local upgrades = getElementData(veh, "vehicle:upgrades") or {}
    upgrades['vopis'] = true
    upgrades['vopis:text'] = text
    setElementData(veh, "vehicle:upgrades", upgrades)
end

function enterFaggio(plr, seat)
    if seat ~= 0 then return end
    setVehicleDesc(source, "Pojazd publiczny\nZajęty przez: #7dff7d" .. getPlayerName(plr):gsub("#%x%x%x%x%x%x", ""))
    setElementData(source, "vehicle:public:owner", plr)
    exports['since-notifications']:sendNotification(plr, 'error', "Publiczny motor został zajęty")

    if timers[source] then
        killTimer(timers[source])
    end
end

function startEnterFaggio(plr, seat)
    if not getElementData(source,"vehicle:public:owner") then
        if checkPlayerMotorcycles(plr) == true then
            exports['since-notifications']:sendNotification(plr, 'error', "Możesz zając maksymalnie jeden pojazd publiczny")
            cancelEvent()
        end
    end

    if getElementData(source,"vehicle:public:owner") and getElementData(source,"vehicle:public:owner") ~= plr then
        if seat == 0 then
            cancelEvent()
        end
    end
end

function destroyFaggio(veh)
    for k,v in pairs(faggios) do
        if v == veh then table.remove(faggios, k) end
    end
    if veh and isElement(veh) then
        destroyElement(veh)
    end
end

function exitFaggio(c)
    if not source then source = c; c = nil end
    timers[source] = setTimer(destroyFaggio, 60000, 1, source)

    if c then
        exports['since-notifications']:sendNotification(c, 'info', 'Opuściłeś pojazd publiczny zniknie on po 60 sekundach')
    end
end

setTimer(function()
    for k,v in pairs(faggios) do
        if isElement(v) then
            if not getVehicleOccupant(v, 0) and getElementData(v, "vehicle:public:owner") and not timers[v] then
                exitFaggio(v)
            end
        end
    end
end, 1000, 0)

function quitPlayer()
	for i,v in ipairs(getElementsByType("vehicle", resourceRoot)) do
        if getElementData(v, "vehicle:public:owner") == source then
            destroyElement(v)
            table.remove(faggios, i)
        end
    end
end
addEventHandler("onPlayerQuit", root, quitPlayer)

function respawnFaggios()
    for k,v in pairs(spawns) do
        if isPlaceClear(v[1], v[2], v[3]) then
            model = 462
            local faggio = createVehicle(462, v[1], v[2], v[3], v[4], v[5], v[6])
            setVehicleColor(faggio, 55, 55, 55, 125, 255, 125)
            setVehicleDesc(faggio, "Pojazd publiczny")
            setVehicleHandling(faggio,"maxVelocity", 80)
            addEventHandler("onVehicleEnter", faggio, enterFaggio)
            addEventHandler("onVehicleExit", faggio, exitFaggio)
            addEventHandler("onVehicleStartEnter", faggio, startEnterFaggio)
            setElementFrozen(faggio, true)

            table.insert(faggios, faggio)
        end
    end
end

respawnFaggios()
setTimer(respawnFaggios, 5000, 0)
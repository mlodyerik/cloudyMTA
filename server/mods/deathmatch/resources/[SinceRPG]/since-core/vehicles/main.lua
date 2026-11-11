Async:setPriority('medium')

function createPrivateVehicle(owner, model, x, y, z, rx, ry, rz)
    local data = {
        mileage = 0,
        health = 0,
        panelstates = "",
    }
    local upgrades = {}
    local color = {
        main = {255,255,255,255,255,255},
        headlight = {255,255,255}
    }
    local position = {x, y, z, rx, ry, rz}
    local fuel = {
        type = "ON",
        count = 100
    }
    local state = 0
    exports['since-db']:query('INSERT INTO `since-vehicles` (`model`,`fuel`,`upgrades`,`data`,`position`,`state`,`owner`,`color`) VALUES (?,?,?,?,?,?,?,?)', model, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(data), serpent.dump(position), state, owner, serpent.dump(color))
    local rows = exports['since-db']:query('SELECT * FROM `since-vehicles`')
    loadVehicle(rows[#rows])
end

addEventHandler('onResourceStart',resourceRoot,function ()
    local rows = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE state=?',0)
	Async:foreach(rows, function(v)
		loadVehicle(v)
	end)
end)

addEventHandler('onResourceStop',resourceRoot,function ()
    for i,v in pairs(getElementsByType('vehicle')) do
        if (getElementData(v,'vehicle:id')) then
            saveVehicle(v)
        end
    end
end)

function getVehicleHandlingProperty ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then
        local handlingTable = getVehicleHandling ( element ) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
 
    return false
end

function jestwtabeli(huj,truj)
    for k,v in pairs(huj) do
        if v == truj then
           return true
        end
    end
    return false
end
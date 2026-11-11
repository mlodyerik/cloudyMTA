sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.82

data = {

    toggle = false,
    toFix = {},
    selectedParts = {},
    cost = 0,

}

textures = {

    ['mask'] = dxCreateTexture('data/mask.png'),

}

carParts = {

    {"Silnik", 1, fn = function(veh) if getElementHealth(veh) >= 1000 then return true end; return false end}, 
    {"Maska", 2, fn = function(veh) if getVehicleDoorState(veh, 0) == 0 then return true end; return false end},
    {"Bagażnik", 3, fn = function(veh) if getVehicleDoorState(veh, 1) == 0 then return true end; return false end},
    {"Drzwi lewy przód", 4, fn = function(veh) if getVehicleDoorState(veh, 2) == 0 then return true end; return false end},
    {"Drzwi prawy przód", 5, fn = function(veh) if getVehicleDoorState(veh, 3) == 0 then return true end; return false end},
    {"Drzwi lewy tył", 6, fn = function(veh) if getVehicleDoorState(veh, 4) == 0 then return true end; return false end},
    {"Drzwi prawy tył", 7, fn = function(veh) if getVehicleDoorState(veh, 5) == 0 then return true end; return false end},
    {"Szyba przednia", 8, fn = function(veh) if getVehiclePanelState(veh, 4) == 0 then return true end; return false end},
    {"Zderzak przedni", 9, fn = function(veh) if getVehiclePanelState(veh, 5) == 0 then return true end; return false end},
    {"Zderzak tylni", 10, fn = function(veh) if getVehiclePanelState(veh, 6) == 0 then return true end; return false end},
    {"Światło lewe przednie", 11, fn = function(veh) if getVehicleLightState(veh, 0) == 0 then return true end; return false end},
    {"Światła prawe przednie", 12, fn = function(veh) if getVehicleLightState(veh, 1) == 0 then return true end; return false end},
    {"Światła lewe tylnie", 13, fn = function(veh) if getVehicleLightState(veh, 2) == 0 then return true end; return false end},
    {"Światła prawe tylnie", 14, fn = function(veh) if getVehicleLightState(veh, 3) == 0 then return true end; return false end},

    {"Lewe przednie koło", 15, fn = function(veh) 
        local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
        if frontLeft == 0 then
            return true
        else
            return false 
        end
    end},
    
    {"Prawe przednie koło", 16, fn = function(veh) 
        local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
        if frontRight == 0 then
            return true
        else
            return false 
        end
    end},
    
    {"Lewe tylne koło", 17, fn = function(veh) 
        local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
        if rearLeft == 0 then
            return true
        else
            return false 
        end
    end},
    
    {"Prawe tylne koło", 18, fn = function(veh) 
        local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates(veh)
        if rearRight == 0 then
            return true
        else
            return false 
        end
    end},

}

partCost = {4500, 3000, 3500, 2500, 2500, 2500, 2500, 2500, 4000, 3500, 2500, 2500, 2500, 2500, 2500, 2500, 2500, 2500}

for i,v in ipairs(carParts) do
    partCost[i] = partCost[i] * 3.75
end
--partCost = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
partCostSponsor = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
partCostFaction = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

function getTable()
    local tbl = {}
    for i,v in pairs(carParts) do
        if v.fn(getPedOccupiedVehicle(localPlayer)) == false then
            local tbl2 = v
            tbl2[69] = math.random(1,90)
            table.insert(tbl, tbl2)
        end
    end
    return tbl
end

function getColorNumer(number)
    numer = tonumber(number)
    if (number > 0 and numer < 20) then
        return {255, 125, 125}
    elseif (number > 20 and numer < 59) then
        return {255, 175, 55}
    else
        return {125, 255, 125}
    end
end

function drawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRectangle(x, y, w, height, tocolor(100, 255, 100,alpha*0.2))

	if #table > m_ then
    	local scrollbarHeight = height/#table

   		if k_ == 1 then 
        	scrollbarPos = y
    	elseif k_ > 0 then 
        	scrollbarPos = ((k_)*scrollbarHeight)+y
    	end

    	if #table <= m_ then 
        	scrollbarHeight = height
    	end
		
        dxDrawRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), tocolor(100, 255, 100, alpha))
    else
        dxDrawRectangle(x, y, w, height, tocolor(100, 255, 100, alpha))
	end
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function addCommas( number )
    local formatted = number
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end
getResourceName(getThisResource(), true, 724289469); if true then return end
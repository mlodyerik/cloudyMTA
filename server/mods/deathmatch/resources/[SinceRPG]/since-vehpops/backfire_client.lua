
local fxShowValTest = false
local curEngine = 0

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element )
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		return false
	end
end

function getVectors(x, y, z, x2, y2, z2)
	return x - x2, y - y2, z-z2;
end

function createBackFire(theVeh, isDoubleExhausts)
	local x, y, z = getVehicleModelExhaustFumesPosition(getElementModel(theVeh))
	local scx, scy, scz = x, y, z
	local fireChords = {}
	local dist = 0.01

	for i = 1, 6 do
		local x, y, z = getPositionFromElementOffset(theVeh,scx,scy+0.25-dist,scz)
		fireChords[i]= {pX = x, pY = y, pZ = z}
		dist = dist + 0.15
	end

	local x,y,z = getPositionFromElementOffset(theVeh,scx,scy,scz)
	local x2,y2,z2 = getPositionFromElementOffset(theVeh,scx,0,scz)
	local v1, v2, v3 = getVectors(x,y,z, x2,y2,z2)

	for i, val in ipairs(fireChords) do
		fxAddGunshot(val.pX, val.pY, val.pZ, v1,v2,v3)
	end
	
	local s = playSound3D("sound/backfire2.wav", x,y,z, false)
	setSoundMaxDistance( s, 80 )	
	setSoundVolume(s, 0.10)	
end


function chandeMonitoringState(state,veh)
	if (state) then
		theVehicle = veh
		addEventHandler ( "onClientPreRender", root, monitorCurEngine )
	else
		removeEventHandler ( "onClientPreRender", root, monitorCurEngine )
		theVehicle=nil
	end
end
addEvent ( "chandeMonitoringState", true )
addEventHandler ( "chandeMonitoringState", resourceRoot, chandeMonitoringState)

local refreshTime = 50
local aLastCheck = 0

function monitorCurEngine()
	if not theVehicle or not isElement(theVehicle) then
		removeEventHandler ( "onClientPreRender", root, monitorCurEngine )
		theVehicle=nil
		return
	end
	if ( getTickCount() >= aLastCheck ) then
		local cur = tonumber(getVehicleCurrentGear (theVehicle))
		if ( cur ~= curEngine ) then
			if (tonumber(getElementSpeed(theVehicle, "kph")) > 5 ) then
				triggerServerEvent ( "create3DBackfireSound", resourceRoot, theVehicle)
				curEngine = cur
			end
		end
		aLastCheck = getTickCount() + refreshTime
	end
end

addEvent ( "create3DBackfireSoundClient", true )
addEventHandler ( "create3DBackfireSoundClient", resourceRoot, createBackFire)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end
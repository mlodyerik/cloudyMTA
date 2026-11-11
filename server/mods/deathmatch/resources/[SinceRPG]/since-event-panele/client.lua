  

--[[
    Author: EnoNeK
    For: SinceRPG
]]

--[[if (getElementData(localPlayer, "player:sid") == 25) then

else
    return false
end]]

class = {}
class.__index = class

function class:create(...)
	local instance = {}
    setmetatable(instance, class)
    if instance:main(...) then
        return instance
    end
    return false
end


function class:main()
	self.func = {}
	self.shakingObjects = {}
	self.func.render = function() self:render() end
	self.func.shake = function(...) self:shake(...) end
	addEvent("enonek-event_panels:shake", true)
	addEventHandler("enonek-event_panels:shake", resourceRoot, self.func.shake)
	return true
end

function class:render()
	local tick = getTickCount()
	for i,v in pairs(self.shakingObjects) do
	    local tickDifference = tick - v
	    if (tickDifference >= 1500) then
			self.shakingObjects[i] = nil
			if (table.maxn(self.shakingObjects) == 0) then
				removeEventHandler("onClientRender", root, self.func.render)
				return false
			end
	    else
	        local newx = tickDifference/125 * 1
	        local newy = tickDifference/125 * 1
	    	if (isElement(i)) then
				setElementRotation(i, math.deg( 0.555 ), 10 * math.cos(newy + 2), 10 * math.sin(newx + 2))
	    	end
		end
    end
end

function class:shake(object)
	self.shakingObjects[object] = getTickCount()
	if (not isEventHandlerAdded("onClientRender", root, self.func.render)) then
		addEventHandler("onClientRender", root, self.func.render)
	end
end
class:create()

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
getResourceName(getThisResource(), true, 724122405); if true then return end
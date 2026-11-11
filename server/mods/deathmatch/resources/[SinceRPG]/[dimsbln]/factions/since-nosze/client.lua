function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if 
		type( sEventName ) == 'string' and 
		isElement( pElementAttachedTo ) and 
		type( func ) == 'function' 
	then
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
--


local data = {object = nil, player = nil}

function deleteRotation()
	if isEventHandlerAdded('onClientPreRender', root, changeRotation) then
		removeEventHandler('onClientPreRender', root, changeRotation)
	end
end
addEvent('deleteRotationStretcher', true)
addEventHandler('deleteRotationStretcher', root, deleteRotation)

function changeRotation()
	if not data.player then
		deleteRotation()
	end

	if not data.object then
		deleteRotation()
	end

	local rotation = {getElementRotation(data.object)}
	data.player.rotation = Vector3(rotation[1], rotation[2], rotation[3]+90)
end

addEvent('createRotationStretcher', true)
addEventHandler('createRotationStretcher', root, function(player, object)
	data.object = object
	data.player = player
	addEventHandler('onClientPreRender', root, changeRotation)
end)
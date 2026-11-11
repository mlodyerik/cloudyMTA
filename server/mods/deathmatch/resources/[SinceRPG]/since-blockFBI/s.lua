--timery={}
--
--addEventHandler("onVehicleEnter",root,function(player,seat)
--   if getElementData(source, "vehicle:ownedPlayer") then
--   	if(player)and(seat==0)then
--   		if timery[source] then return end
--   		timery[source] = setTimer(function(el)
--   			if not el then timery[el]:destroy() end
--   			setVehicleSirensOn(el, false) 
--   		end, 1000, 0, source)
--   	end
--   end
--end)


--function VehicleEnter ( thePlayer, seat, jacked ) 
--    if ( seat == 0 ) and (getElementModel ( source ) == 490) then 
--    	if getElementData(source, "vehicle:ownedPlayer") then 
--            bindKey ( thePlayer, "h", "down", disableSiren ) 
--            setVehicleSirensOn ( source, false ) 
--        end
--    end 
--end 
--addEventHandler ( "onVehicleEnter", getRootElement(), VehicleEnter ) 
--  
--  
--function exitVehicle ( thePlayer, seat, jacked ) 
--    if ( seat == 0 ) and (getElementModel ( source ) == 490) then 
--    if getElementData(source, "vehicle:ownedPlayer") then
--		setVehicleSirensOn ( source, false ) 
--		unbindKey ( thePlayer, "h", "down", disableSiren ) 
--		end 
--	end
--end 
--addEventHandler ( "onVehicleStartExit", getRootElement(), exitVehicle ) 
--  
--  
--function disableSiren (presser) 
--if getPedOccupiedVehicle (presser) then
--	setVehicleSirensOn ( getPedOccupiedVehicle (presser), false ) 
--end
--if not isPedInVehicle (presser) then 
--    unbindKey ( presser, "h", "down", disableSiren ) 
--elseif isPedInVehicle (presser) then 
--	setVehicleSirensOn ( getPedOccupiedVehicle (presser), false ) 
--    setTimer ( function() 
--        setVehicleSirensOn ( getPedOccupiedVehicle (presser), false ) 
--    end, 1, 50 ) 
--end 
--end 

function disableFireForHydra ( theVehicle, seat, jacked )
    if ( getElementModel ( theVehicle ) == 520 ) then -- if they entered a hydra
        toggleControl ( source, "vehicle_secondary_fire", false ) -- disable their fire key
    else -- if they entered another vehicle
        toggleControl ( source, "vehicle_secondary_fire", true ) -- enable their fire key
    end
end
addEventHandler ( "onPlayerVehicleEnter", root, disableFireForHydra )
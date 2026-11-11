addEvent('fixMechVehicle', true)
addEventHandler('fixMechVehicle', resourceRoot, function(_, veh, tbl, cost)
    if #tbl > 0 and veh and isElement(veh) then
        if getPlayerMoney(client) > cost then
            takePlayerMoney(client, cost)

            local frontLeft, rearLeft, frontRight, rearRight = getVehicleWheelStates ( veh )
            
            for i,id in ipairs(tbl) do
                if id == 1 then setElementHealth(veh, 10000)
                elseif id == 2 then setVehicleDoorState(veh, 0, 0)
                elseif id == 3 then setVehicleDoorState(veh, 1, 0)
                elseif id == 4 then setVehicleDoorState(veh, 2, 0)
                elseif id == 5 then setVehicleDoorState(veh, 3, 0)
                elseif id == 6 then setVehicleDoorState(veh, 4, 0)
                elseif id == 7 then setVehicleDoorState(veh, 5, 0)
                elseif id == 8 then setVehiclePanelState(veh, 4, 0)
                elseif id == 9 then setVehiclePanelState(veh, 5, 0)
                elseif id == 10 then setVehiclePanelState(veh, 6, 0)
                elseif id == 11 then setVehicleLightState(veh, 0, 0)
                elseif id == 12 then setVehicleLightState(veh, 1, 0)
                elseif id == 13 then setVehicleLightState(veh, 2, 0)
                elseif id == 14 then setVehicleLightState(veh, 3, 0)
                elseif id == 15 then setVehicleWheelStates(veh, 0, rearLeft, frontRight, rearRight) 
                elseif id == 16 then setVehicleWheelStates(veh, frontLeft, rearLeft, 0, rearRight)
                elseif id == 17 then setVehicleWheelStates(veh, frontLeft, 0, frontRight, rearRight)
                elseif id == 18 then setVehicleWheelStates(veh, frontLeft, rearLeft, frontRight, 0)
                end
            end

            if cost == 0 then
                exports['since-notifications']:sendNotification(client, 'success', 'Pomyslnie naprawiono wybrane części.')
            else
                exports['since-notifications']:sendNotification(client, 'success', 'Pomyslnie naprawiono wybrane części za kwotę #7dff7d$ '..addCommas(cost)..'')
            end
            triggerClientEvent(client, 'updateMechanicGUI', client)
        else
            exports['since-notifications']:sendNotification(client, 'error', 'Nie posiadasz wystarczającej gotówki!')
        end
    end
end)

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
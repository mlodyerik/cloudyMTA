setTimer(function()
    if isPedInVehicle(localPlayer) then
        local pojazd = getPedOccupiedVehicle(localPlayer)

        if isElementInWater(pojazd) and getVehicleType(pojazd) ~= 'Boat' then
            local vx, vy, vz = getElementPosition(pojazd)
            setElementPosition(pojazd, vx, vy, vz - 500)
        end 
    end 
end, 2000, 0)

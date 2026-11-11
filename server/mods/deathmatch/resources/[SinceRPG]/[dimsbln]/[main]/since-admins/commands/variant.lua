addCommandHandler('variant', function(player, cmd, id, id2)
    if not getAdmin(player, 4) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not id or not id2 or not tonumber(id) or not tonumber(id2) then return exports['since-notifications']:sendNotification(player, 'error', 'Użyj: /variant [id 1] [id 2]') end

    local vehicle = getPedOccupiedVehicle(player)
    if not vehicle then return exports['since-notifications']:sendNotification(player, 'error', 'Nie jesteś w pojeździe!') end

    setVehicleVariant(vehicle, id, id2)
    setElementData(vehicle, 'vehicle:variant', {id, id2})
    exports['since-notifications']:sendNotification(player, 'info',  'Ustawiono wariant pojazdu '.. id ..', '.. id2)
end)

-- addCommandHandler('variant.reset', function(player, cmd)
--     if not getAdmin(player, 4) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end

--     for i,v in ipairs(getElementsByType('vehicle')) do
--         if getElementData(v, 'vehicle:id') and getElementModel(v) == 411 then
--             setVehicleVariant(v, 0, 0)
--             setElementData(v, 'vehicle:variant', {0, 0})
--         end
--     end

--     exports['since-notifications']:sendNotification(player, 'info',  'Ustawiono wariant pojazdu 0, 0')
-- end)
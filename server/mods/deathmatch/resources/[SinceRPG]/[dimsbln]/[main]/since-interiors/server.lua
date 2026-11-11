addEvent('teleportInterior', true)
addEventHandler('teleportInterior', resourceRoot, function(pos, shapeData, enterType)
    local x, y, z, int, dim = unpack(pos)
    setElementInterior(client, int)
    setElementDimension(client, dim)
    setElementPosition(client, x, y, z)
    
    if shapeData == 'Kasyno' and enterType == 'enter' then
        exports['since-notifications']:sendNotification(client, 'info', 'Przed grą w kasynie zapoznaj się z regulaminem kasyna na forum - znajdziesz go w temacie "Regulaminy"')
    end
end)
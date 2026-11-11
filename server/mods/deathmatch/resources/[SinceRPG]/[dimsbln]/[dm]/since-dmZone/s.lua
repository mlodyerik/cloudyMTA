local main = {}
main['cuboid'] = createColRectangle(-2900, -400, 1500, 1800)
setElementInterior(main['cuboid'], 0)
setElementDimension(main['cuboid'], 0)

addEventHandler('onColShapeHit', main['cuboid'], function(plr, md)
	if (getElementType(plr)~="player") or (not md) or (getElementInterior(plr) ~= getElementInterior(source)) then
		return
	end
    if getElementModel(plr) == 38 then
        exports['since-notifications']:sendNotification(plr, 'error', 'Twój skin posiada inne hit boxy niż zwykły, korzystanie ze strefy DM zostało zablokowane')
        return
    end
    setElementData(plr, 'player:strefa', true)

    exports['since-notifications']:sendNotification(plr, 'success', 'Wchodzisz do strefy bezprawia!')

end)

addEventHandler('onColShapeLeave', main['cuboid'], function(plr, md)
	if (getElementType(plr)~="player") or (not md) or (not getElementData(plr, 'player:strefa')) then
		return
	end

    setElementData(plr, 'player:strefa', nil)

    exports['since-notifications']:sendNotification(plr, 'success', 'Wychodzisz ze strefy bezprawia!')
end)

addEventHandler('onElementDataChange', root, function(dataName, oldValue)
    if (getElementType(source) == "player") then
        if dataName == 'player:job' or dataName == 'player:admin' or dataName == 'player:settings' or dataName == 'player:faction' then
            if exports['since-dashboard']:isPlayerPassive(source) then
                takeAllWeapons(source)
                if getElementData(source, 'player:admin') then
                    giveWeapon(source, 22, 200)
                end
            end
        end
    end
end)
function addPlayerVehicle(plr, model)
	local playerSID = getElementData(plr, 'player:sid')
	
	if playerSID then
		local clr = {255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255}
		local hclr = {255, 255, 255}
		local wheelTuning = {
	
			vinylRim = 0,
			vinylWounds = 0,
			wheelTilt = 0,
			innerSize = 0.8,
			wheelResize = 1,
	
		}
	
		local vehData = {
	
			driver = 'Brak',
			mileage = 0,
			engine = 2.0,
	
	
		}
	
		local fuel = {
	
			count = 75,
			tank = 75,
	
		}
	
		local upgrades = {}
	
		local q = exports['since-db']:query('INSERT INTO `since-vehicles` (`model`, `fuel`, `upgrades`, `data`, `color`, `headlight`, `wheelTuning`, `owner`, `state`) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1)', model, serpent.dump(fuel), serpent.dump(upgrades), serpent.dump(vehData), serpent.dump(clr), serpent.dump(hclr), serpent.dump(wheelTuning), playerSID)
	end
end
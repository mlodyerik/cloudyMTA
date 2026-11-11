function isInFaction(plr, faction)
    if plr and isElement(plr) and faction then
        local uid = getElementData(plr, 'player:sid')
        if not uid then
            return
        end
        local db = exports['since-db']:query('select 1 from `since-factions` where uid=? and faction=? LIMIT 1', uid, faction)
        if #db == 0 then return false end
        return true
    end
end

function getPlayerFaction(plr)
    if plr and isElement(plr) then
        local uid = getElementData(plr, 'player:sid')
        
        if not uid then
            return
        end

        local db = exports['since-db']:query('select faction from `since-factions` where uid=? LIMIT 1', uid)

        if #db == 0 then 
            return false 
        end

        return db[1].faction
    end
end

function getFactionRank(plr, faction)
    if plr and isElement(plr) and faction then
        local uid = getElementData(plr, 'player:sid')
        if not uid then
            return
        end
        local db = exports['since-db']:query('select rank from `since-factions` where uid=? and faction=? LIMIT 1', uid, faction)
        if #db == 0 then return false end
        return db[1].rank
    end
end

addEventHandler("onVehicleStartEnter", root, function(plr, seat, jacked)
	if seat == 0 then
		if getElementData(source,'vehicle:duty') then
			if getElementData(plr,'player:faction') ~= getElementData(source,'vehicle:duty') then
			    cancelEvent()
			    return 
            end	
			if getElementData(source,'vehicle:rank') then
				if getElementData(plr,'player:rank') < getElementData(source,'vehicle:rank') then
				    cancelEvent()
				    return 
                end
			end
		end
	end
end)
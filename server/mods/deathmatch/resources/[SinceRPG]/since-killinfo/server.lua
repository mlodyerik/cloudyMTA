function addDeathInfo(tbl)
    triggerClientEvent(root, 'addDeathInfo', root, tbl)
end

function onPlayerWasted(ammo, attacker, weapon, bodypart)
    local info = {

        attack = getPlayerName(attacker),
        killed = getPlayerName(source),
        weapon = weapon,

    }

    addDeathInfo(info)
end
addEventHandler("onPlayerWasted", root, onPlayerWasted)
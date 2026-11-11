function getFactionMinutes(faction)
    local rows = exports['since-db']:query('SELECT * FROM `since-factions` WHERE faction = ?', faction)
    
    local minutes = 0

    for i,v in pairs(rows) do
        local userRows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', v.uid)

        if (userRows[1]) then
            minutes = minutes + userRows[1].factionTime
        end
    end

    return minutes
end

function getSapdMadatesMoneyCount()
    local rows = exports['since-db']:query('SELECT * FROM `since-mdt` WHERE type=?', 'Mandat')
    
    local money = 0

    for i,v in pairs(rows) do
        money = money + v.total
    end

    return money
end

function getFactionMembers(faction)
    local rows = exports['since-db']:query('SELECT * FROM `since-factions` WHERE faction = ?', faction)
    
    local members = {}

    for i,v in pairs(rows) do
        local userRows = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid=?', v.uid)
        
        if (userRows[1]) then
            table.insert(members, {uid = v.uid, name = userRows[1].nick, minutes = userRows[1].factionTime, rank = exports['since-factions-new']:getFactionData(faction).ranks[v.rank]})
        end
    end

    return members
end

function show(player)
    if (not getElementData(player, 'player:faction')) then return end
    
    local data = {}

    if (getElementData(player, 'player:faction') == "SAPD") then
        local jailRows = exports['since-db']:query('SELECT * FROM `since-jail`')
        local mandatesRows = exports['since-db']:query('SELECT * FROM `since-mdt` WHERE type=?', 'Mandat')

        data.jail = jailRows
        data.mandates = getSapdMadatesMoneyCount()
        data.mainData = getFactionMembers(getElementData(player, 'player:faction'))
        data.fullName = exports['since-factions-new']:getFactionData(getElementData(player, 'player:faction')).fullName
        data.minutes = getFactionMinutes(getElementData(player, 'player:faction'))
    elseif (getElementData(player, 'player:faction') == "SARA") then
        local policeParkingRows = exports['since-db']:query('SELECT * FROM `since-policeParking`')
        local policeParkingMoney = 0

        for i,v in pairs(policeParkingRows) do
            policeParkingMoney = policeParkingMoney + v.cost
        end

        data.parking = policeParkingRows
        data.parkingMoney = policeParkingMoney
        data.mainData = getFactionMembers(getElementData(player, 'player:faction'))
    end

    triggerClientEvent(player, 'since=factions-panel:show', resourceRoot, data)
end

function hide(player)
    triggerClientEvent(player, 'since=factions-panel:hide', resourceRoot)
end

function updateFactionData(player)
    if (not getElementData(player, 'player:faction')) then return end

    local data = {}

    if (getElementData(player, 'player:faction') == "SAPD") then
        local jailRows = exports['since-db']:query('SELECT * FROM `since-jail`')
        local mandatesRows = exports['since-db']:query('SELECT * FROM `since-mdt` WHERE type=?', 'Mandat')

        data.jail = jailRows
        data.mandates = getSapdMadatesMoneyCount()
        data.mainData = getFactionMembers(getElementData(player, 'player:faction'))
        data.fullName = exports['since-factions-new']:getFactionData(getElementData(player, 'player:faction')).fullName
        data.minutes = getFactionMinutes(getElementData(player, 'player:faction'))
    end

    triggerClientEvent(player, 'since=factions-panel:update', resourceRoot, data)
end
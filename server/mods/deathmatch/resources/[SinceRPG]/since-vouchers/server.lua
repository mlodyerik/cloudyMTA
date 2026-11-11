local vouchers = {}

function getJobVoucher(player, job)
    if not vouchers[player] or not vouchers[player][job] then
        return 0
    end
    return vouchers[player][job]
end

function useVoucher(player, job, procents, time)
    local rows = exports['since-db']:query('select * from `since-vouchers` where sid = ? and job = ? and activeTo > NOW() limit 1', getElementData(player, 'player:sid'), job)
    if #rows > 0 then
        exports['since-db']:query('update `since-vouchers` set procents = ?, activeTo = DATE_ADD(activeTo, INTERVAL ? MINUTE) where sid = ? and job = ?', procents, time, getElementData(player, 'player:sid'), job)
    else
        exports['since-db']:query('insert into `since-vouchers` (sid, job, procents, activeTo) values (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? MINUTE))', getElementData(player, 'player:sid'), job, procents, time)
    end

    if not vouchers[player] then
        vouchers[player] = {}
    end
    if not vouchers[player][job] then
        vouchers[player][job] = {}
    end
    vouchers[player][job] = procents
    triggerClientEvent(player, 'loadVouchers', resourceRoot, vouchers[player])
end

function loadPlayerVouchers(player)
    if not getElementData(player, 'player:sid') then return end
    local rows = exports['since-db']:query('select * from `since-vouchers` where sid = ? and activeTo > NOW()', getElementData(player, 'player:sid'))
    if #rows > 0 then
        local contactiren = {}
        local data = {}
        for i, v in ipairs(rows) do
            data[v.job] = v.procents
        end
        for i, v in pairs(data) do
            table.insert(contactiren, exports['since-jobs']:getJobName(i)..' #7DFF7D+'..v..'%#FFFFFF')
        end
        vouchers[player] = data
        setTimer(function(player)
            if not isElement(player) then return end
            triggerClientEvent(player, 'loadVouchers', resourceRoot, vouchers[player])
        end, 250, 1, player)
        outputChatBox('\n ✔ #FFFFFFPosiadasz aktywne vouchery na pracach:', player, 55,255,55, true)
        for i,v in ipairs(contactiren) do
            outputChatBox('• '..v, player, 255,255,255, true)
        end
        outputChatBox('• #FFFFFFAby zobaczyć listę twoich aktywnych voucherów wpisz /vouchery\n ', player, 55,255,55, true)
    end
end

addCommandHandler('vouchery', function(player, cmd)
    if not getElementData(player, 'player:sid') then return end
    local contactiren = {}
    local rows = exports['since-db']:query('select * from `since-vouchers` where sid = ? and activeTo > NOW()', getElementData(player, 'player:sid'))
    if #rows > 0 then
        local data = {}
        local dates = {}
        for i, v in ipairs(rows) do
            data[v.job] = v.procents
            dates[v.job] = v.activeTo:gsub('-', '.'):sub(1, 16)
        end
        for i, v in pairs(data) do
            table.insert(contactiren, exports['since-jobs']:getJobName(i)..' #7DFF7D+'..v..'%#FFFFFF (do: '..dates[i]..')')
        end
        outputChatBox('\n ✔ #FFFFFFPosiadasz aktywne vouchery na pracach:', player, 55,255,55, true)
        for i,v in ipairs(contactiren) do
            outputChatBox('• '..v, player, 255,255,255, true)
        end
        outputChatBox(' ', player, 55,255,55, true)
    else
        outputChatBox('✖ #FFFFFFNie posiadasz aktywnych voucherów na żadnej pracy.', player, 255,55,55, true)
    end
end)

addEventHandler('onResourceStart', resourceRoot, function()
    for i, player in ipairs(getElementsByType('player')) do
        if getElementData(player, 'player:sid') == 4 then
            loadPlayerVouchers(player)
        end
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if vouchers[source] then
        vouchers[source] = nil
    end
end)

setTimer(function()
    local count = {0,0}
    local players = {}
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:sid') then
            players[getElementData(v, 'player:sid')] = v
        end
    end
    local rows = exports['since-db']:query('select * from `since-vouchers` where activeTo < NOW()')
    for i, v in ipairs(rows) do
        count[1] = count[1] + 1
        if players[v.sid] then
            if vouchers[players[v.sid]] then
                if vouchers[players[v.sid]][v.job] then
                    vouchers[players[v.sid]][v.job] = nil
                    count[2] = count[2] + 1
                end
            end
        end
    end
    for i,player in ipairs(players) do
        triggerClientEvent(player, 'loadVouchers', resourceRoot, vouchers[player] or {})
    end
    exports['since-db']:query('delete from `since-vouchers` where activeTo < NOW()')
    if count[1] > 0 or count[2] > 0 then
        outputDebugString('Vouchers: '..count[1]..' db removed, '..count[2]..' players cleaned')
    end
end, 30000, 0)
local cases = {}
local tick = getTickCount()+500

function findWalizka(plr)
    for i,v in pairs(cases) do
        if v[1] == plr then
            return true
        end
    end
    return false
end

addCommandHandler('walizka', function(player, command, money, ...)
    if getElementData(player, 'player:admin') > 1 then
        if not money or not tonumber(money) or not ... then
            exports['since-notifications']:sendNotification(player, 'info', 'Użycie: /walizka <liczka pieniędzy> <podpowiedź>')
        end
        if findWalizka(player) then
            exports['since-notifications']:sendNotification(player, 'error', 'Porzuciłeś już jedną walizkę')
        end
        if tonumber(money) > 1500000 then
            exports['since-notifications']:sendNotification(player, 'error', 'Porzucona walizka nie może wynosić więcej niż $ 1,500,000')
        end
        if tick > getTickCount() then
            exports['since-notifications']:sendNotification(player, 'error', 'Musisz odczekać 5 minut przed następnym porzuceniem walizki')
        end
        local podp = table.concat({...}, ' ')
        local money = math.floor(tonumber(money))
        
        local myMoney = exports['since-db']:query('select bankMoney from `since-users` where uid = ?', getElementData(player, 'player:sid'))
        if myMoney and #myMoney > 0 then
            if tonumber(myMoney[1].bankMoney) >= tonumber(money) then
                exports['since-notifications']:sendNotification(player, 'success', 'Porzuciłeś walizkę z podpowiedzią: '..podp)
                exports['since-db']:query('update `since-users` set bankMoney=bankMoney-? where uid = ?', tonumber(money), getElementData(player, 'player:sid'))
                local text = 'Administrator '..getPlayerName(player)..' porzucił worek z pieniędzmi! Podpowiedź: '..podp..''
                triggerClientEvent(root, 'createAdminNotification', root, text, {3, 252, 11}, 7500)
                local x, y, z = getElementPosition(player)
                local pickup = createPickup(x, y, z, 3, 1550, 1)
                cases[pickup] = {player, getPlayerName(player):gsub('#%x%x%x%x%x%x',''), money}
                tick = getTickCount() + 60000*5
            else
                exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz wystarczającej kwoty pieniędzy w bankomacie')
            end
        else
            exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz wystarczającej kwoty pieniędzy w bankomacie')
        end
    end
end)

addEventHandler('onPickupHit', resourceRoot, function(element)
    if getElementType(element) == 'player' then
        if not isPedInVehicle(element) then
            if cases[source] then
                if cases[source][1] ~= element then
                    local text = 'Gracz '..getPlayerName(element)..' odnalazł worek z pieniędzmi, a w nim $ '..cases[source][3]..''
                    triggerClientEvent(root, 'createAdminNotification', root, text, {3, 252, 11}, 7500)
                    exports['since-notifications']:sendNotification(element, 'success', 'Znalazłeś worek z pieniędzmi, a w nim $ '..cases[source][3])
                    exports['since-db']:query('UPDATE `since-users` SET bankMoney=bankMoney+? WHERE uid=?', tonumber(cases[source][3]), getElementData(element, 'player:sid'))
                    cases[source] = nil
                    destroyElement(source)
                end
            end
        end
    end
end)
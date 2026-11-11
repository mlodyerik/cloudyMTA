addCommandHandler('ginfo', function(player, cmd, target)
    if not getAdmin(player) then return exports['since-notifications']:sendNotification(player, 'error', 'Nie posiadasz uprawnień do tej komendy!') end
    if not target then return exports['since-notifications']:sendNotification(player, 'error', 'Użyj: /ginfo [nick]') end

    local target = exports['since-core']:findPlayer(player, target)
    if not target then return exports['since-notifications']:sendNotification(player, 'error','Nie znaleziono podanego gracza!') end

    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid`=?', getElementData(target, 'player:sid'))
    if not result or #result < 1 then return exports['since-notifications']:sendNotification(player, 'error', 'Gracz jest nie zalogowany!') end

    local message = [[Login: %s
Nick: %s
UID: %s
Pieniądze: %s
Pieniądze w banku: %s
SRP: %s
wPLN: %s
Prawo jazdy: %s
Przegrany czas: %02d:%02d]]

    local licenses = fromJSON(result[1].licenses) or 'Brak'
    local licensesTable = {}
    if licenses.A == 1 then table.insert(licensesTable, 'A') end
    if licenses.B == 1 then table.insert(licensesTable, 'B') end
    if licenses.C == 1 then table.insert(licensesTable, 'C') end
    if licenses.L == 1 then table.insert(licensesTable, 'Licencja lotnicza') end
    licenses = table.concat(licensesTable, ', ')

    local minutes = result[1].playedTime
    local hours = math.floor(minutes / 60)
    minutes = minutes - (hours * 60)

    message = message:format(
        result[1].login,
        result[1].nick,
        result[1].uid,
        getPlayerMoney(target),
        result[1].bankMoney,
        result[1].srp,
        result[1].wPLN,
        #licenses > 0 and licenses or 'Brak',
        hours, minutes
    )

    exports['since-notifications']:sendNotification(player, 'info', message)
end)
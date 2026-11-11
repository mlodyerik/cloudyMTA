local cost = 100000

local words = {

    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'r', 's', 't', 'u', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'W', 'X', 'Y', 'Z'

}

function table.find(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function checkString(text)
    -- text only can have a-z, A-Z, 0-9
    for i = 1, #text do
        local char = string.sub(text, i, i)
        if not table.find(words, char) then
            return true
        end
    end

    if string.find(text, "%c") or string.find(text, "%p") or string.find(text, "%s") or string.find(text, "%z") then
      return true
    else
      return false
    end
end


function hasSpecialCharacters(text)
    -- Definiujemy wzorzec dla znaków specjalnych (wszystko poza literami i cyframi)
    local specialPattern = "[^%w%s]" -- %w oznacza litery i cyfry, %s oznacza białe znaki (spacje, tabulatory)

    -- Sprawdzamy, czy tekst zawiera znaki specjalne
    if string.find(text, specialPattern) then
        return true -- Zawiera znaki specjalne
    else
        return false -- Nie zawiera znaków specjalnych
    end
end

function checkChangeDate(plr)
	local queryA = exports['since-db']:query("SELECT * FROM `since-users` WHERE uid = ? AND changenick > NOW() LIMIT 1", getElementData(plr, "player:sid"))

	if (queryA and #queryA > 0) then
		return queryA[1].changenick
	end

	return false	
end

function changeNickname(plr, name)
    if plr and name then
        local name = name:gsub("#%x%x%x%x%x%x", "")
        if not hasSpecialCharacters(name) then
            if getPlayerMoney(plr) < cost then
                return exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz wystarczającej ilości gotówki przy sobie. Koszt zmiany nicku to: ' .. comma(cost) .. ' PLN')
            end

            local checkChange = checkChangeDate(plr)
            if checkChange then
                return exports['since-notifications']:sendNotification(plr, 'error', 'Nick możesz zmienić co 24 godziny, następna zmiana będzie dostępna: ' .. checkChange)
            end

            if string.len(name) < 3 then
                return exports['since-notifications']:sendNotification(plr, 'error', 'Nick musi mieć minimum 3 znaki')
            end

            if string.len(name) > 20 then
                return exports['since-notifications']:sendNotification(plr, 'error', 'Nick może mieć maksymalnie 20 znaków')
            end

            local result = exports['since-db']:query("SELECT * FROM `since-users` WHERE `nick` = ? LIMIT 1", name)
            local result2 = exports['since-db']:query("SELECT * FROM `since-users` WHERE `login` = ? LIMIT 1", name)

            if (result and #result > 0) then
                return exports['since-notifications']:sendNotification(plr, 'error', 'Podany nick jest już zajęty')
            end

            if (result2 and #result2 > 0) then
                if result2[1].uid ~= getElementData(plr, "player:sid") then
                    return exports['since-notifications']:sendNotification(plr, 'error', 'Podany nick jest już zajęty')
                end
            end

            exports['since-logs']:sendDiscordLog('zmiana-nickow', getPlayerName(plr), 'Zmienił nick na **'..name..'** UID: '..getElementData(plr, "player:sid")..'')

            takePlayerMoney(plr, cost)
            setPlayerName(plr, name)
            exports['since-db']:query("UPDATE `since-users` SET `nick` = ?, `changenick` = DATE_ADD(NOW(), INTERVAL 1 DAY) WHERE `uid` = ?", name, getElementData(plr, "player:sid"))
            exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie zmieniono nick na: ' .. name..'. Z portfela pobrano '..comma(cost)..'. Pamiętaj, że nie jest to twój login!')
        else
            return exports['since-notifications']:sendNotification(plr, 'error', 'Podany nick jest nieprawidłowy')
        end
    end
end

function changeNickToLogin(plr, target)
    if plr and target then
        local target = exports['since-core']:findPlayer(plr, target)
        local result = exports['since-db']:query("SELECT * FROM `since-users` WHERE `uid` = ? LIMIT 1", getElementData(target, "player:sid"))
        if (result and #result > 0) then
            exports['since-db']:query("UPDATE `since-users` SET `nick` = ? WHERE `uid` = ?", result[1].login, getElementData(target, "player:sid"))
            exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie zmieniono nick gracza '..getPlayerName(target)..' na: ' .. result[1].login)
            setPlayerName(target, result[1].login)
        end
    end
end

addCommandHandler('zmien.nick', function(plr, cmd, name)
    if plr and name then
        changeNickname(plr, name)
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Poprawne użycie: /zmien.nick (nowy nick)') 
    end
end)

addCommandHandler('cofnij.nick', function(plr, cmd, target)
    if plr and target then
        if getElementData(plr, "player:rank") == 4 then
            return
        end

        changeNickToLogin(plr, target)
    end
end)

function changePassword(plr, pass)
    if plr and pass then
        local db = exports['since-db']:query("SELECT * FROM `since-users` WHERE `serial` = ?", getPlayerSerial(plr))
        if #db == 0 then exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono konta podpisany na twój serial') return end
        local pass = pass:gsub("#%x%x%x%x%x%x", "")
        if not checkString(pass) then
            if string.len(pass) < 4 then return exports['since-notifications']:sendNotification(plr, 'error', 'Hasło musi mieć minimum 4 znaków') end
            if string.len(pass) > 20 then return exports['since-notifications']:sendNotification(plr, 'error', 'Hasło może mieć maksymalnie 20 znaków') end
            exports['since-db']:query("UPDATE `since-users` SET `password` = ? WHERE `serial` = ?", md5(pass), getPlayerSerial(plr))
            exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie zmieniono hasło')
        else
            return exports['since-notifications']:sendNotification(plr, 'error', 'Podane hasło jest nieprawidłowe')
        end
    else
        return exports['since-notifications']:sendNotification(plr, 'error', 'Podaj hasło')
    end
end

addCommandHandler('zmien.haslo', function(plr, cmd, pass)
    if not pass then
        exports['since-notifications']:sendNotification(plr, 'error', 'Poprawne użycie: /zmien.haslo (nowe hasło)') 
        return
    end
    changePassword(plr, pass)
end)

function comma(number)
    local formatted = number
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1 %2')
        if (k==0) then
            break
        end
    end
    return formatted
end
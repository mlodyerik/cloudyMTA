local words = {

    'mysz', 'mitoman', 'since', 'karykatura', 'kot', 'pies', 'kotek', 'piesek', 'kotki', 'pieski', 'rynna', 'sapd', 'safd', 'komputer', 'jeleń', 'krowa', 'procesor', 'tankowiec', 'baryłka', 'kasa', 'monety', 'samochód', 'wersalka', 'kryptonim', 'lucyfer', 'stachu', 'grzebień', 'szyba', 'telefon', 'telewizor', 'juzek', 'satelita', 'toshiba', 'opel', 'golf', 'manana', 'infernus', 'automaty', 'szeryf'

}

local priceMoney = {

    325000, 500000, 1000000, 1500000, 2000000, 2500000, 2250000, 550000

}

local priceSRP = {

    25, 50, 20, 15, 10

}

local data = {

    actualWord = nil,
    actualPrice = nil,
    actualType = nil

}

function pickRandomWord()
    return words[math.random(1, #words)]
end

function pickRandomPrice()
    return price[math.random(1, #price)]
end

function generateRandomWord()
    if data.actualWord then 
        return 
    end

    local random = math.random(1, 2)

    data.actualWord = pickRandomWord()
    data.actualPrice = random == 1 and priceMoney[math.random(1, #priceMoney)] or priceSRP[math.random(1, #priceSRP)]
    data.actualType = random

    triggerClientEvent(root, 'onServerSendData:words', resourceRoot, 'create', data.actualWord, data.actualPrice, data.actualType)
end

function startScript()
    setTimer(function()
        generateRandomWord()
        setTimer(generateRandomWord, 60000 * 30, 0)
    end, 100, 1)
end
addEventHandler('onResourceStart', resourceRoot, startScript)

addCommandHandler('odp', function(plr, cmd, word)
    if not word then return end
    
    if not data.actualWord then 
        return 
    end
    
    if word == data.actualWord then
        if data.actualType == 1 then
            givePlayerMoney(plr, data.actualPrice)
        else
            local playerSRP = getElementData(plr, 'player:srp') or 0
            setElementData(plr, 'player:srp', playerSRP + data.actualPrice)
        end
        
        exports['since-notifications']:sendNotification(plr, 'success', 'Udzielono poprawnej odpowiedzi, otrzymujesz '..data.actualPrice..' '..(data.actualType == 1 and '$' or 'SRP')..'!')

        outputChatBox(' ', root)
        outputChatBox('★ #ffffffSzybkie palce', root, 255, 209, 43, true)
        outputChatBox('★ #ffffffGracz #c2c2c2'..getPlayerName(plr)..' #61bacf('..getElementData(plr, 'id')..')#ffffff udzielił poprawnej odpowiedzi i zgarnia #2E756F'..data.actualPrice..' '..(data.actualType == 1 and '$' or 'SRP')..'.', root, 255, 209, 43, true)
        outputChatBox(' ', root)

        data = {

            actualWord = nil,
            actualPrice = nil,
            actualType = nil

        }

        triggerClientEvent(root, 'onServerSendData:words', resourceRoot, 'delete')
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Udzielono błędnej odpowiedzi, spróbuj ponownie!')
    end
end)
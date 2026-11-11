coalCost = 0

function changeCoalCost()
    local random = math.random(750, 1250)
    coalCost = random

    outputChatBox(' ', root)
    outputChatBox('⛏#ffffff Cena węgla w skupie uległa zmianie na: #68EB5D'..coalCost..' $ / 1 kg', root, 255, 175, 0, true)
    outputChatBox(' ', root)

    exports['since-db']:query('UPDATE `since-prices` SET coal = ?', coalCost)
end

function getCoalCost()
    local result = exports['since-db']:query('SELECT * FROM `since-prices` limit 1')
    if #result == 0 then
        exports['since-db']:query('insert into `since-prices` set makrela=0')
    end
    local result = exports['since-db']:query('SELECT * FROM `since-prices` limit 1')

    coalCost = result[1].coal

    return coalCost
end

addEventHandler("onResourceStart", resourceRoot, function()
    if getCoalCost() == 0 then
        changeCoalCost()
    end

    coalCost = getCoalCost()

	setTimer(function()
        changeCoalCost()
    end, 60000 * 60 * 6, 0)
end)

addCommandHandler('update.coal', function(plr, cmd)
    if getElementData(plr, 'player:admin') and getElementData(plr, 'player:admin') == 4 then
        changeCoalCost()
    end
end)
  

local positions = {

    {'topHours', 1501.26, -1673.84, 12.52, 0, 0, -3.478, 'Przegrane godziny'},
    {'top14Mili', 1454.06, -2720.95, 12.56, -0.00, 0.00, 181.08, 'Najlepsze czasy 1/4 mili'},
    {'topMoney', 1484.58, -1718.12, 13.52 - 1, -0.00, 0.00, 120.08, 'Czas eventowy'},

}

function refreshBoard(board, bType, obj, plr)
    if bType == 'topHours' then
        local result = exports['since-db']:query('SELECT * FROM `since-users` ORDER BY `topHours` DESC LIMIT 3')
        local bTitle = getElementData(obj, 'board:title') or 'Ustaw tytuł topki'
        local tbl = {}

        for i, v in ipairs(result) do
            table.insert(tbl, {name = v.nick, sid = tonumber(v.uid), value = v.topHours, title = bTitle, bID = board, bType = bType})
        end

        if plr then
            triggerClientEvent(plr, 'reloadBoard', resourceRoot, board, tbl)
        else
            triggerClientEvent('reloadBoard', resourceRoot, board, tbl)
        end
    elseif bType == 'top14Mili' then
        local result = exports['since-db']:query('SELECT * FROM `since-14mili` ORDER BY `time` ASC LIMIT 3')
        local bTitle = getElementData(obj, 'board:title') or 'Ustaw tytuł topki'
        local tbl = {}

        for i, v in ipairs(result) do
            table.insert(tbl, {name = v.nick, sid = tonumber(v.uid), value = v.time, title = bTitle, bID = board, bType = bType, vehicle = v.model})
        end

        if plr then
            triggerClientEvent(plr, 'reloadBoard', resourceRoot, board, tbl)
        else
            triggerClientEvent('reloadBoard', resourceRoot, board, tbl)
        end
    elseif bType == 'topMoney' then
        local result = exports['since-db']:query('SELECT * FROM `since-users` ORDER BY `topEvent` DESC LIMIT 3')
        local bTitle = getElementData(obj, 'board:title') or 'Ustaw tytuł topki'
        local tbl = {}

        for i, v in ipairs(result) do
            table.insert(tbl, {name = v.nick, sid = tonumber(v.uid), value = v.topEvent, title = bTitle, bID = board, bType = bType})
        end

        if plr then
            triggerClientEvent(plr, 'reloadBoard', resourceRoot, board, tbl)
        else
            triggerClientEvent('reloadBoard', resourceRoot, board, tbl)
        end
    end
end

function refreshBoards(plr)
    if not plr then player = false else player = plr end

    for i, v in ipairs(getElementsByType('object', resourceRoot)) do
        local bType = getElementData(v, 'board:type')
        local bID = getElementData(v, 'board:id')

        if getElementModel(v) == 3077 and bType and bID then
            refreshBoard(bID, bType, v, player)
        end
    end
end
setTimer(refreshBoards, 30000, 0)

function onScriptStart()
    setTimer( function()
        for i, v in ipairs(positions) do
            local board = createObject(3077, v[2], v[3], v[4], v[5], v[6], v[7])
            setObjectBreakable(board, true)
            setElementFrozen(board, true)
        
            setElementData(board, 'board:type', v[1])
            setElementData(board, 'board:id', i)
            setElementData(board, 'board:title', v[8])
        
            refreshBoard(i, v[1], board)
        end

        local text = createElement('text')
        setElementPosition(text, 1483.22, -1718.62, 13.53)
        setElementData(text, 'name', [[
        #68D65ETopka czasu#ffffff
        - #68D65E1#ffffff Miejsce - #68D65E200PLN#ffffff
        - #68D65E2#ffffff Miejsce - #68D65E100PLN#ffffff
        - #68D65E3#ffffff Miejsce - #68D65E50PLN#ffffff

        Event bedzie trwał do #68D65E31.12.2024 23:59
        ]])

    end, 100, 1)
end
addEventHandler('onResourceStart', resourceRoot, onScriptStart)

function reloadAllBoards(plr)
   refreshBoards(plr) 
end
addEvent('reloadAllBoards', true)
addEventHandler('reloadAllBoards', resourceRoot, reloadAllBoards)
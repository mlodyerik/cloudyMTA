local fish = {}
fish.rybak = {}
fish.prizes = {}
fish.selled = {}

addEvent('fish.s', true)
addEventHandler('fish.s', resourceRoot, function(...)
    if not arg then
        return
    end
    local plr = client
    if (arg[1] == 'start') then
        setElementFrozen(plr, true)
        setPedAnimation(plr, 'SWORD', 'sword_' .. math.random(1, 4), -1, false, true, false, true, 250)
        setTimer(setPedAnimation, 600, 1, plr, 'SWORD', 'sword_IDLE')

    elseif (arg[1] == 'stop') then
        setElementFrozen(plr, false)
        setPedAnimation(plr)

    elseif (arg[1] == 'collect') then
        if not arg[2] then 
            return 
        end
        exports['since-inventory']:addPlayerItem(plr, string.lower(arg[2].name), math.floor(arg[2].count))
        exports['since-jobs']:addPlayerJobPoints(plr, 'rybak', math.floor(arg[2].count))
        
    elseif (arg[1] == 'sell') then
        if not arg[2] then 
            return 
        end
        local money = 0
        for i,v in ipairs(arg[2]) do
            exports['since-inventory']:addPlayerItem(plr, string.lower(types[i].name), -math.floor(v))
            money = money + (math.floor(v)*fish.prizes[i])
        end

        exports['since-notifications']:sendNotification(plr, 'success', 'Sprzedałeś ryby ('..convertNumber(money)..' $)')

        givePlayerMoney(plr, money)

    end
end)

fish.prizeChange = (function()
    if fish.rybak.marker and isElement(fish.rybak.marker) then
        local db = exports['since-db']:query('select * from `since-prices` limit 1')
        if #db == 0 then
            exports['since-db']:query('insert into `since-prices` set makrela=0,dorsz=0,szczupak=0,karp=0,rekin=0')
        end
        for i = 1, #types do
            fish.prizes[i] = math.random(types[i].price[1], types[i].price[2])
            exports['since-db']:query('update `since-prices` set '..string.lower(types[i].name)..'=?', fish.prizes[i])
        end
        setElementData(fish.rybak.marker, 'rybak:prizes', fish.prizes)
    end
end)

fish.rybakCreate = (function()
    if fish.rybak then
        for i,v in ipairs({'text','ped','marker','blip'}) do
            if isElement(fish.rybak[v]) then
                destroyElement(fish.rybak[v])
            end
        end
    end

    local db = exports['since-db']:query('select * from `since-prices` limit 1')
    if #db == 0 then
        exports['since-db']:query('insert into `since-prices` set makrela=0,dorsz=0,szczupak=0,karp=0,rekin=0')
    end

    for i = 1, #types do
        fish.prizes[i] = math.random(types[i].price[1], types[i].price[2])
        exports['since-db']:query('update `since-prices` set '..string.lower(types[i].name)..'=?', fish.prizes[i])
    end

    fish.rybak.ped = createPed(249,position[1],position[2],position[3],position[4])
    setElementFrozen(fish.rybak.ped, true)

    local x, y, z = getPositionFromElementOffset(fish.rybak.ped, 0, 1, 0)
    fish.rybak.marker = createMarker(x, y, z-0.95, 'cylinder', 2, 125, 255, 125, 55)
    setElementData(fish.rybak.marker, 'rybak:marker',true)
    setElementData(fish.rybak.marker, 'rybak:prizes',fish.prizes)
    setElementData(fish.rybak.marker, 'marker:title', 'Rybak')
    setElementData(fish.rybak.marker, 'marker:desc', 'sprzedaż ryb')

    fish.rybak.blip = createBlip(position[1],position[2],position[3], 46, 2, 0, 155, 255, 255, 0, 600)

    setTimer(function()
        fish.prizeChange()
    end, 60000*30, 0)
end)


function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function convertNumber(liczba)  
    local format = liczba  
    while true do      
        format, k = string.gsub(format, '^(-?%d+)(%d%d%d)', '%1 %2')    
        if ( k==0 ) then      
            break  
        end  
    end  
    return format
end



fish.rybakCreate()
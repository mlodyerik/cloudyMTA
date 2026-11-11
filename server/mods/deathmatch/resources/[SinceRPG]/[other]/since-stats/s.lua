local main = {
    ['stats'] = {},
    ['countDown'] = {},
}

main['stats']['praca'] = function(plr)
    local tbl = {}
    for i,v in ipairs(getElementsByType('player')) do
        local job = getElementData(v, 'player:job')
        if job then
            tbl[job] = tbl[job] and tbl[job] + 1 or 1
        end
    end
    outputChatBox('★ #FFFFFFLista graczy pracujących na pracach:', plr, 55, 255, 55, true)
    local count = 0
    for i,v in pairs(tbl) do
        outputChatBox('★ #FFFFFF'..i..' - '..v..' graczy', plr, 55, 155, 255, true)
        count = count + 1
    end
    if count == 0 then
        outputChatBox('★ #FFFFFFAktualnie nikt nie pracuje', plr, 55, 155, 255, true)
    end
end

main['stats']['pracownicy'] = function(plr)
    local tbl = {}
    for i,v in ipairs(getElementsByType('player')) do
        local job = getElementData(v, 'player:job')
        if job then
            if not tbl[job] then
                tbl[job] = {}
            end
            table.insert(tbl[job], getPlayerName(v))
        end
    end
    outputChatBox('★ #FFFFFFLista graczy pracujących na pracach:', plr, 55, 255, 55, true)
    local count = 0
    for i,v in pairs(tbl) do
        outputChatBox('★ #FFFFFF'..i..' - '..#v..' graczy', plr, 55, 155, 255, true)
        for k,j in ipairs(v) do
            outputChatBox('- #FFFFFF'..j, plr, 55, 155, 255, true)
            count = count + 1
        end
    end
    if count == 0 then
        outputChatBox('★ #FFFFFFAktualnie nikt nie pracuje', plr, 55, 155, 255, true)
    end
end

main['stats']['pojazdy'] = function(plr)
    local count = #getElementsByType('vehicle')
    if count > 0 then
        outputChatBox('★ #FFFFFFAktualnie na mapie znajduje się: '..formatNumber(count)..' pojazdów', plr, 55, 155, 255, true)
    else
        outputChatBox('★ #FFFFFFAktualnie na mapie nie na żadnych pojazdów', plr, 55, 155, 255, true)
    end
end

main['stats']['elDaty'] = function(plr)
    local gra,pveh,veh,mar,obj,pic = 0,0,0,0,0,0
    for k,j in ipairs(getElementsByType("player")) do
        local data = getAllElementData(j)
        for i,v in pairs(data) do gra = gra + 1 end
    end
    for k,j in ipairs(getElementsByType("vehicle")) do
        local data = getAllElementData(j)
        if getElementData(j,"vehicle:id") then 
            for i,v in pairs(data) do pveh = pveh + 1 end
        else
            for i,v in pairs(data) do veh = veh + 1 end
        end
    end
    for k,j in ipairs(getElementsByType("marker")) do
        local data = getAllElementData(j)
        for i,v in pairs(data) do mar = mar + 1 end
    end
    for k,j in ipairs(getElementsByType("pickup")) do
        local data = getAllElementData(j)
        for i,v in pairs(data) do pic = pic + 1 end
    end
    outputChatBox('★ #FFFFFFLista ustawionych elementDat:', plr, 55, 255, 55, true)
    outputChatBox("★ #FFFFFFElement daty nałożone na graczy: "..formatNumber(gra),plr, 55, 155, 255, true)
    outputChatBox("★ #FFFFFFElement daty nałożone na prywatne pojazdy: "..formatNumber(pveh),plr, 55, 155, 255, true)
    outputChatBox("★ #FFFFFFElement daty nałożone na pojazdy inne: "..formatNumber(veh),plr, 55, 155, 255, true)
    outputChatBox("★ #FFFFFFElement daty nałożone na markery: "..formatNumber(mar),plr, 55, 155, 255, true)
    outputChatBox("★ #FFFFFFElement daty nałożone na pickupy: "..formatNumber(pic),plr, 55, 155, 255, true)
    outputChatBox("★ #FFFFFFŁączna suma elementdat: "..formatNumber(gra+pveh+veh+mar+obj+pic),plr, 55, 155, 255, true)
    outputChatBox(' ', plr)
end

local tableJob = {}
main['stats']['zapisz'] = function(plr)
    for i,v in ipairs(getElementsByType('player')) do
        local job = getElementData(v, 'player:job')
        if getElementData(v, 'player:job') == 'maszynista' then
            table.insert(tableJob, v)
        end
    end
    outputChatBox('★ #FFFFFFZapisano graczy pracujących na pracach maszynisty', plr, 55, 155, 255, true)
end

main['stats']['wczytaj'] = function(plr)
    for i,v in ipairs(tableJob) do
        triggerClientEvent(v, 'onJobStart', v, 'maszynista')
    end
    outputChatBox('★ #FFFFFFWczytano graczy pracujących na pracach maszynisty ('..#tableJob..' graczy)', plr, 55, 155, 255, true)
end

-- main['stats']['load'] = function(plr)
--     local players = {}
--     local x,y,z = getElementPosition(plr)
--     for i,v in ipairs(getElementsByType('player')) do
--         local x2,y2,z2 = getElementPosition(v)
--         local dist = getDistanceBetweenPoints3D(x,y,z,x2,y2,z2)
--         if dist < 15 then
--             triggerClientEvent(v, 'onJobStart', v, 'maszynista')
--         end
--     end
--     outputChatBox('★ #FFFFFFZaładowano graczy w pobliżu', plr, 55, 155, 255, true)
-- end


main['stats']['znajdzki'] = function(plr, target)
    if not target then
        outputChatBox('★ #FFFFFFPoprawne użycie: /stats znajdzki [ID/NICK gracza]', plr, 55, 255, 55, true)
        return
    end
    local target = exports['since-core']:findPlayer(plr, target)
    if not target then
        return
    end
    local db = exports['since-db']:query('select `collectingEventStats` from `since-users` where `uid` = ?', getElementData(target, 'player:sid'))
    if #db == 0 then return end
    local data = tableSort(db[1]['collectingEventStats'] and fromJSON(db[1]['collectingEventStats']) or {})
    outputChatBox('★ #FFFFFFZnajdzki gracza '..getPlayerName(target)..':', plr, 55, 255, 55, true)
    outputChatBox('★ #FFFFFFZnajdzki: '..(inspect(data)), plr, 55, 155, 255, true)
end

main['stats']['kasa'] = function(plr)
    local players = {}

    for i,v in ipairs(getElementsByType('player')) do
        local sid = getElementData(v, 'player:sid')
        if sid then
            local money = exports['since-db']:query('SELECT `bankMoney` FROM `since-users` WHERE `uid` = ? limit 1', sid)
            if #money > 0 then
                table.insert(players, {sid, money[1]['bankMoney'], getPlayerName(v)})
            end
        end
    end

    table.sort(players, function(a, b) return a[2] > b[2] end)

    outputChatBox('★ #FFFFFFTop 10 graczy z największą ilością hajsu:', plr, 55, 255, 55, true)
    for i,v in ipairs(players) do
        if i > 10 then break end
        outputChatBox('★ #FFFFFF'..i..'. #FFFFFF'..v[3]..' - $'..formatNumber(v[2]), plr, 55, 155, 255, true)
    end

end

main['stats']['datsy'] = function(plr)
    local vehicle = getPedOccupiedVehicle(plr)
    
    local datsy = vehicle and getAllElementData(vehicle) or getAllElementData(plr)

    outputChatBox('★ #FFFFFFLista elementDat '..(vehicle and 'pojazdu' or 'gracza')..':', plr, 55, 255, 55, true)
    for i,v in pairs(datsy) do
        outputChatBox('★ #FFFFFF'..i..' - '..tostring(v), plr, 55, 155, 255, true)
    end
    
end


addCommandHandler('stats', function(plr, cmd, id, target)
    if getElementData(plr, 'player:admin') ~= 4 then
        return
    end
    if not id then
        local stats = {}
        for i,v in pairs(main['stats']) do
            table.insert(stats, i)
        end
        exports['since-notifications']:sendNotification(plr, 'error', 'Poprawne użycie: /stats '..table.concat(stats, ', '))
        return
    end
    if main['stats'][id] then
        if main['countDown'][plr] then
            exports['since-notifications']:sendNotification(plr, 'error', 'Poczekaj chwilę zanim użyjesz tej komendy ponownie')
            return
        end
        main['countDown'][plr] = true
        main['stats'][id](plr, target)
        setTimer(function(plr)
            main['countDown'][plr] = nil
        end, 1000, 1, plr)
    else
        exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono statystyk o podanym ID')
    end
end)

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1,%2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end

function tableSort(tbl)
    local temp = {}
    for i,v in pairs(tbl) do
        table.insert(temp, v)
    end
    table.sort(temp, function(a, b) return a < b end)
    return temp
end

addCommandHandler('bc', function(plr, cmd, target)
    if getElementData(plr, 'player:admin') ~= 4 then return end
    if not target then return exports['since-notifications']:sendNotification(plr, 'error', 'Nie podałeś gracza!') end
    local target = exports['since-core']:findPlayer(plr, target)
    if not target then return exports['since-notifications']:sendNotification(plr, 'error','Nie znaleziono podanego gracza!') end
    local nick = getPlayerName(target)
    banPlayer(target, true, false, true, root, 'Nie posiadasz dostępu do serwera.')
    exports['since-notifications']:sendNotification(plr, 'success', 'Zbanowano gracza ' .. nick .. ' za cheaty!')
end)

removeWorldModel(11327, 10, -2024.24, 131.31, 28.84)
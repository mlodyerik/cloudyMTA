local lobby = {}
local invites = {}
local ids = {}
local col = createColSphere(242.20, 177.10, 1003.03, 80)
local settings = {
    spawns = {
        {233.68, 142.54, 1003.02},
        {292.41, 172.58, 1007.17},
    },
    interior = 3,
    maxPoints = 10,
    weapon = 24,
    stats = {71,76,78},
}

function findFreeId()
    for i=1,1000 do
        if not ids[i] then
            ids[i] = true
            return i
        end
    end
end

function giveStarterPack(plr)
    takeAllWeapons(plr)
    giveWeapon(plr, settings.weapon, 999999)
    for i,v in ipairs(settings.stats) do
        setPedStat(plr, v, 1000)
    end
    setElementHealth(plr, 100)

    setWeaponProperty(10, "pro", "weapon_range", 250)
    setWeaponProperty(10, "pro", "damage", 10)
end

function startLobby(plr, id)
    if not isElement(plr) then return end
    if not id then return end
    local v = findLobby(id)
    if not v then return end
    if not isElement(v['players'][1]) or not isElement(v['players'][2]) then
        outputChatBox('Bład #001', plr, 255, 55, 55, true)
        return
    end
    for i,player in ipairs(v['players']) do
        giveStarterPack(player)
        setElementFrozen(player, false)
        toggleAllControls(player, true, true, true)
        triggerClientEvent(player, 'since-arenasStats', resourceRoot, 'start', {getElementData(v['players'][1], 'player:sid'),getElementData(v['players'][2], 'player:sid')})
    end
end

function joinLobby(plr, id, creator)
    if not isElement(plr) then return end
    if creator then
        if not id then outputChatBox('Bład #003', plr, 255, 55, 55, true) return end
        local v = findLobby(id)
        if not v['players'][1] == plr then outputChatBox('Bład #002', plr, 255, 55, 55, true) return end
        setElementData(plr, 'player:arena', id)
        setElementData(plr, 'player:lastPos', {getElementPosition(plr)})
        setElementPosition(plr, settings['spawns'][1][1], settings['spawns'][1][2], settings['spawns'][1][3])
        setElementInterior(plr, settings['interior'])
        setElementDimension(plr, v['dim'])
        setElementFrozen(plr, true)
        toggleAllControls(plr, false, true, false)
        outputChatBox('✔ #FFFFFFStworzyłeś lobby (wpisz komende #ff2222/anuluj #FFFFFF aby opuścić)', plr, 55, 255, 55, true)
        triggerClientEvent(plr, 'since-arenas', resourceRoot, {action = 'close'})
        takePlayerMoney(plr, v['bet'])

        exports['since-logs']:sendDiscordLog('arenki', getPlayerName(plr), 'Stworzył lobby za kwotę `'..formatNumber(v['bet'])..' $`')
    else
        if not id then outputChatBox('Bład #004', plr, 255, 55, 55, true) return end
        local v = findLobby(id)
        if not v['players'][2] then
            table.insert(v['players'], plr)
            setElementData(plr, 'player:arena', id)
            setElementData(plr, 'player:lastPos', {getElementPosition(plr)})
            setElementPosition(plr, settings['spawns'][2][1], settings['spawns'][2][2], settings['spawns'][2][3])
            setElementInterior(plr, settings['interior'])
            setElementDimension(plr, v['dim'])
            setElementFrozen(plr, true)
            toggleAllControls(plr, false, true, false)
            outputChatBox('✔ #FFFFFFDołączyłeś do lobby (wpisz komende #ff2222/anuluj #FFFFFFaby opuścić)', plr, 55, 255, 55, true)
            setTimer(startLobby, 3000, 1, plr, id)
            triggerClientEvent(plr, 'since-arenas', resourceRoot, {action = 'close'})
            takePlayerMoney(plr, v['bet'])
            return
        end
        outputChatBox('❌ #FFFFFFLobby jest pełne', plr, 255, 55, 55, true)
    end
end

function finishLobby(id)
    local v = findLobby(id)
    local winner = v['points'][1] > v['points'][2] and 1 or v['points'][1] == v['points'][2] and 0 or 2
    local draw = winner == 0 and true or false
    for i,player in ipairs(v['players']) do
        if i == winner then
            outputChatBox('⭕ #FFFFFFPojedynek dobiegł końca. Ponosisz zwycięztwo. ( Wygrywasz #68D65E$ '..formatNumber(v['bet'])..' #FFFFFF)', player, 55, 255, 55, true)
            leaveLobby(player, nil, v['bet']*2)
        elseif draw then
            outputChatBox('⭕ #FFFFFFPojedynek dobiegł końca. Wynikiem jest remis.', player, 0, 155, 255, true)
            leaveLobby(player, nil, v['bet'])
        else
            outputChatBox('⭕ #FFFFFFPojedynek dobiegł końca. Ponosisz porażkę.', player, 255, 55, 55, true)
            leaveLobby(player)
        end
    end
    destroyLobby(id)
end

function tryJointLobby(plr, id)
    local v = findLobby(id)
    if not v then return end
    if not v['players'][2] then
        local player = v['players'][1]
        if not isElement(player) then return end
        outputChatBox('✔ #FFFFFFWysłano prośbę o dołączenie do areny gracza '..getPlayerName(player), plr, 55, 255, 55, true)
        outputChatBox('✔ #FFFFFFGracz '..getPlayerName(plr)..' wysłał prośbę o dołączenie. Aby zaakceptować użyj komendy #ff2222/akceptuj '..getElementData(plr, 'id'), player, 55, 255, 55, true)
        invites[plr] = id
        setTimer(function(plr)
            if invites[plr] then
                invites[plr] = nil
                if isElement(plr) then
                    outputChatBox('❌ #FFFFFFUpłynął czas na zaakceptowanie zaproszenia.', plr, 255, 55, 55, true)
                end
            end
        end, 20000, 1, plr)
    else
        outputChatBox('❌ #FFFFFFLobby jest pełne', plr, 255, 55, 55, true)
    end
end

function findPlayerById(id)
    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'id') == id then
            return v
        end
    end
end

addCommandHandler('akceptuj', function(plr, cmd, playerID)
    if not playerID then outputChatBox('❌ #FFFFFFWprowadź id gracza, którego chcesz zaakceptować.', plr, 55, 255, 55, true) return end
    playerID = tonumber(playerID)
    if not playerID then outputChatBox('❌ #FFFFFFWprowadź poprawne id gracza.', plr, 55, 255, 55, true) return end
    local player = findPlayerById(playerID)    
    if not player then outputChatBox('❌ #FFFFFFGracz o podanym id nie jest online.', plr, 55, 255, 55, true) return end
    if not invites[player] then outputChatBox('❌ #FFFFFFGracz nie ma żadnych zaproszeń.', plr, 55, 255, 55, true) return end
    if invites[player] then
        joinLobby(player, invites[player], false)
        invites[player] = nil
        outputChatBox('✔ #FFFFFFZaakceptowano zaproszenie. Runda rozpocznie się za 3 sekundy!', plr, 55, 255, 55, true)
        outputChatBox('✔ #FFFFFFTwoje zaproszenie zostąło zaakceptowane. Runda rozpocznie się za 3 sekundy!', player, 55, 255, 55, true)
    end
end)

addEvent('since-arenas', true)
addEventHandler('since-arenas', resourceRoot, function(data)
    if data['action'] == 'get' then
        local tbl = {}
        for i,v in ipairs(lobby) do
            if isElement(v['players'][1]) and not v['players'][2] then
                table.insert(tbl, { getPlayerName(v['players'][1]), v['bet'], v['id'] })
            end
        end
        triggerClientEvent(client, 'since-arenas', resourceRoot, {action = 'give', info = tbl})

    elseif data['action'] == 'create' then
        if getPlayerMoney(client) < data['bet'] then
            outputChatBox('❌ #FFFFFFNie posiadasz wystarczającej ilości gotówki.', client, 255, 55, 55, true)
            return
        end
        local bet = data['bet']
        local lobbyID = checkIsPlayerInAnyLobby(client)
        if not lobbyID then
            local id = findFreeId()
            local tbl = {
                players = {client},
                bet = bet,
                points = {0,0},
                dim = getElementData(client, 'player:sid'),
                id = id,
            }
            table.insert(lobby, tbl)
            joinLobby(client, id, true)
        else
            outputChatBox('❌ #FFFFFFJesteś już w lobby', client, 255, 55, 55, true)
        end
        
    elseif data['action'] == 'join' then
        local id = data['id']
        local lobbyID = checkIsPlayerInAnyLobby(client)
        if not lobbyID then
            tryJointLobby(client, id)
        else
            outputChatBox('❌ #FFFFFFJesteś już w lobby', client, 255, 55, 55, true)
        end

    elseif data['action'] == 'finish' then
        local id = checkIsPlayerInAnyLobby(client)
        if not id then return end
        local v = findLobby(id)
        if not v then return end
        finishLobby(id)

    end
end)

function findLobbyIdFromCreator(creator)
    for i,v in ipairs(lobby) do
        if v['players'][1] == creator then
            return i
        end
    end
end

function checkIsPlayerInAnyLobby(plr)
    for i,v in ipairs(lobby) do
        if (v['players'][1] and isElement(v['players'][1]) and v['players'][1] == plr) or (v['players'][2] and isElement(v['players'][2]) and v['players'][2] == plr) then
            return i
        end
    end
    return false
end

function findLobby(id)
    for i,v in ipairs(lobby) do
        if v.id == id then
            return v
        end
    end
end

function destroyLobby(id)
    print('proba usuniecia lobby '..id)
    for i,v in ipairs(lobby) do
        if v.id == id then
            table.remove(lobby, i)
            ids[id] = nil
            print('usunieto lobby '..id)
            break
        end
    end
end

function leaveLobby(v, info, money)
    if isElement(v) then
        setElementData(v, 'player:arena', nil)
        if getElementData(v, 'player:lastPos') then
            setElementPosition(v, unpack(getElementData(v, 'player:lastPos')))
        end
        setElementInterior(v, 0)
        setElementDimension(v, 0)
        setElementFrozen(v, false)
        toggleAllControls(v, true, true, true)
        setElementData(v, 'player:lastPos', nil)
        takeWeapon(v, 24)
        setElementFrozen(v, false)
        toggleAllControls(v, true, true, true)
        if money then
            givePlayerMoney(v, money)
        end
        if not info then
            triggerClientEvent(v, 'since-arenasStats', resourceRoot, 'end')
        end
    end
end

function restartRound(id, deader, killer)
    local v = findLobby(id)

    if not v then
        leaveLobby(deader, nil, v['bet'])
        leaveLobby(killer, nil, v['bet'])
        return
    end

    local playerID = {}

    for i,player in ipairs(v['players']) do
        if player == killer then
            playerID['killer'] = i
            break
        end
    end

    for i,player in ipairs(v['players']) do
        if player == source then
            playerID['deader'] = i
            break
        end
    end

    spawnPlayer(deader, settings['spawns'][playerID['deader']][1], settings['spawns'][playerID['deader']][2], settings['spawns'][playerID['deader']][3],0,getElementModel(deader),getElementInterior(deader),getElementDimension(deader))
    setElementPosition(killer, settings['spawns'][playerID['killer']][1], settings['spawns'][playerID['killer']][2], settings['spawns'][playerID['killer']][3])

    setElementFrozen(deader, true)
    setElementFrozen(killer, true)
    toggleAllControls(deader, false, true, false)
    toggleAllControls(killer, false, true, false)

    giveStarterPack(deader)
    giveStarterPack(killer)

    outputChatBox('⭕ #FFFFFFPonosisz porażkę! Następna runda rozpocznie się za 3 sekundy', deader, 255, 55, 55, true)
    outputChatBox('⭕ #FFFFFFPokonujesz przeciwnika! Następna runda rozpocznie się za 3 sekundy', killer, 55, 255, 55, true)

    setTimer(function(deader,killer)
        setElementFrozen(deader, false)
        setElementFrozen(killer, false)
        toggleAllControls(deader, true, true, true)
        toggleAllControls(killer, true, true, true)
    end, 3000, 1, deader, killer)
end

addEventHandler('onColShapeLeave', col, function(plr, md)
    if getElementType(plr) == 'player' and getElementData(plr, 'player:arena') then
        local id = checkIsPlayerInAnyLobby(plr)
        if not id then return end
        local v = findLobby(id)
        for i,player in ipairs(v['players']) do
            leaveLobby(player, nil, v['bet'])
        end
        destroyLobby(id)
    end
end)

addEventHandler('onPlayerWasted', root, function(totalAmmo, killer)
    if getElementData(source, 'player:arena') and getElementData(killer, 'player:arena') then
        local id = checkIsPlayerInAnyLobby(source)
        if not id then return end
        local v = findLobby(id)

        for i,player in ipairs(v['players']) do
            if player == killer then
                v['points'][i] = v['points'][i] + 1
                break
            end
        end

        restartRound(id, source, killer)

        if v['points'][1] >= settings.maxPoints or v['points'][2] >= settings.maxPoints then
            finishLobby(id)
            return
        end

        for i,player in ipairs(v['players']) do
            if isElement(player) then
                triggerClientEvent(player, 'since-arenasStats', resourceRoot, 'updatePoints', v['points'])
            end
        end
    elseif getElementData(source, 'player:arena') then
        local id = checkIsPlayerInAnyLobby(source)
        if not id then return end
        local v = findLobby(id)

        restartRound(id, v['players'][1], v['players'][2])

        for i,player in ipairs(v['players']) do
            if isElement(player) then
                triggerClientEvent(player, 'since-arenasStats', resourceRoot, 'updatePoints', v['points'])
            end
        end
    end
end)

addCommandHandler('anuluj', function(plr, cmd)
    if getElementData(plr, 'player:arena') then
        local id = checkIsPlayerInAnyLobby(plr)
        if not id then return end
        local v = findLobby(id)
        for i,player in ipairs(v['players']) do
            leaveLobby(player, nil, v['bet'])
        end
        outputChatBox('✔ #FFFFFFOpuszczono lobby', plr, 55, 255, 55, true)
        destroyLobby(id)
    end
end)

addEventHandler('onResourceStop', resourceRoot, function()
    for i,v in ipairs(lobby) do
        for i,player in ipairs(v['players']) do
            leaveLobby(player, true, v['bet'])
        end
    end
end)

for i,v in ipairs(getElementsByType('player')) do
    if getElementData(v, 'player:arena') then
        leaveLobby(v, true)
    end
end

addCommandHandler('print', function(plr, cmd)
    for i,v in ipairs(lobby) do
        local tbl = {}
        for _,player in ipairs(v['players']) do
            table.insert(tbl, getPlayerName(player))
        end
        print('lobby '..v['id']..' - '..table.concat(tbl, ', '))
    end
end)

addEventHandler('onPlayerQuit', root, function()
    if getElementData(source, 'player:arena') then
        local id = checkIsPlayerInAnyLobby(source)
        if not id then return end
        local v = findLobby(id)
        finishLobby(id)
    end
end)

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1 %2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end

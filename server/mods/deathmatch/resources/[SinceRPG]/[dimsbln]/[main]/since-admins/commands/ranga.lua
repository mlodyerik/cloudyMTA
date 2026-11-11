local ranksID = {

    [1] = {'Moderator', '1143611641393586362'},
    [2] = {'Administrator', '1143611641393586363'},
    [3] = {'Administrator RCON', '1143611641393586364'},
    [4] = {'Owner', '1143611641393586365'},
}

function updatePlayerDiscordRank(player, rank)
    if not getElementData(player, 'player:sid') then 
        return 
    end

    local discordResult = exports['since-db']:query('SELECT * FROM `since-discord` WHERE `serial` = ?', getPlayerSerial(player))
    if #discordResult > 0 then
        local discordID = discordResult[1]['did']

        if rank == 0 then
            for i = 1, 4 do
                exports['since-discord']:botWrite({
                    funcname = 'removeRole',
                    args = {
                        guild = '1143611641393586356',
                        id = discordID,
                        rank = ranksID[i][2]
                    }
                });
            end
        else
            for i = 1, 4 do
                exports['since-discord']:botWrite({
                    funcname = 'removeRole',
                    args = {
                        guild = '1143611641393586356',
                        id = discordID,
                        rank = ranksID[i][2]
                    }
                });
            end

            exports['since-discord']:botWrite({
                funcname = 'addRole',
                args = {
                    guild = '1143611641393586356',
                    id = discordID,
                    rank = ranksID[rank][2]
                }
            });
        end
    end
end

addCommandHandler('ranga', function(player, cmd, target, rank)
	if getAdmin(player, 4) or getAdmin(player, 3) then
        target = exports['since-core']:findPlayer(player, target)
		if not target then
			return 
			exports['since-notifications']:sendNotification(player, 'error', 'Nie znaleziono podanego gracza!')
		end
		if target == player then
			return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz zmienić sobie rangi!')
		end
		if not getElementData(target, 'player:sid') then
			return exports['since-notifications']:sendNotification(player, 'error', 'Gracz nie jest zalogowany!')
		end
		if not rank or not tonumber(rank) or tonumber(rank) < 0 or tonumber(rank) > 4 then
			return exports['since-notifications']:sendNotification(player, 'error', 'Nie podano poprawnej rangi!')
		end
		rank = tonumber(rank)

		local q = exports['since-db']:query('SELECT * FROM `since-admins` WHERE `serial` = ?', getPlayerSerial(target))
		local previousRank = (q and q[1]) and q[1].level or false

		local rankName = rank ~= 0 and getRankName(rank) or 'Gracz'
    	if previousRank then
        	if previousRank > rank then
            	exports['since-notifications']:sendNotification(target, 'info', 'Zostałeś degradowany do rangi '..rankName..'!')
        	else
            	exports['since-notifications']:sendNotification(target, 'info', 'Zostałeś awansowany do rangi '..rankName..'!')
        	end
    	else
        	exports['since-notifications']:sendNotification(target, 'info', 'Została ci nadana ranga '..rankName..'!')
   		end

   		exports['since-notifications']:sendNotification(player, 'info', 'Nadano rangę '..rankName..' graczowi '..getPlayerName(target)..'!')
        updatePlayerDiscordRank(target, rank)

        if previousRank then
            if rank ~= 0 then
                exports['since-db']:query('UPDATE `since-admins` SET `level` = ? WHERE `serial` = ?', rank, getPlayerSerial(target))
            else
                exports['since-db']:query('DELETE FROM `since-admins` WHERE `serial` = ?', getPlayerSerial(target))
            end
        else
            exports['since-db']:query('INSERT INTO `since-admins` (`serial`, `nick`, `level`, `actived`, `added`, `uid`, `reporty`) VALUES (?, ?, ?, NOW(), NOW(), ?, 0)', getPlayerSerial(target), getPlayerName(target), rank, getElementData(player, 'player:sid'))
        end

        if getElementData(target, 'player:admin') then
        	if rank == 0 then
        		setElementData(target, 'player:admin', false)
        	else
        		setElementData(target, 'player:admin', rank)
        	end
        end
    end
end)

addCommandHandler('aktualizuj.range', function(plr, cmd)
    if getAdmin(plr) then
        local serial = getPlayerSerial(plr)
        local uid = getElementData(plr, 'player:sid')
        local nick = getPlayerName(plr):gsub('#%x%x%x%x%x%x', '')

        exports['since-db']:query('UPDATE `since-admins` SET `uid` = ?, `nick` = ? WHERE `serial` = ?', uid, nick, getPlayerSerial(plr))
        exports['since-notifications']:sendNotification(plr, 'info', 'Zaaktualizowano dane rangi!')
    end
end)
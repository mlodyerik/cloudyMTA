function rgbToHex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

function hexToRGB(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

function getUserData(sid, rank)
    local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE `uid` = ? LIMIT 1', sid)

    if (#result == 0) then
        return {
            sid = sid,
            nick = 'Nieznany',
            rank = rank,
        }
    end

    local result = {
        sid = result[1].uid,
        nick = result[1].login,
        rank = rank,
    }

    return result
end

function getNextLevelExp(level)
    return math.floor(100 * ((level + 1) ^ 2))
end

function addExp(plr, expToAdd)
    local data = getOrganizationData(plr).data
    local exp = data.exp + expToAdd
    local currentLevel = data.level

    local nextLevelExp = getNextLevelExp(currentLevel)

    while exp >= nextLevelExp do
        exp = exp - nextLevelExp
        currentLevel = currentLevel + 1
        nextLevelExp = getNextLevelExp(currentLevel)

        for i,v in ipairs(getElementsByType('player')) do
            local data2 = getElementData(v, 'player:organization')

            if data2 and data2.name == data.name then
                outputChatBox(' ', v, 255, 255, 0, true)
                outputChatBox('★#ffffff Poziom twojej organizacji wzrósł! Aktualny poziom: #ffee00'..currentLevel..'#ffffff', v, 255, 255, 0, true)
                outputChatBox('★#ffffff Potrzebny EXP na kolejny poziom #adadad('..currentLevel..')#ffffff: #66b5ff'..nextLevelExp, v, 255, 255, 0, true)
                outputChatBox(' ', v, 255, 255, 0, true)
            end
        end
    end

    exports['since-db']:query('UPDATE `since-orgs` SET `exp` = ? WHERE `uid` = ?', exp, data.id)
    exports['since-db']:query('UPDATE `since-orgs` SET `level` = ? WHERE `uid` = ?', currentLevel, data.id)
end

function onDamage(attacker, _, _, loss)
    if not attacker or not isElement(attacker) or getElementType(attacker) ~= 'player' then
        return
    end

    local attackerOrg = getElementData(attacker, 'player:organization')
    local sourceOrg = getElementData(source, 'player:organization')

	if sourceOrg and attackerOrg then
        if (sourceOrg.id == attackerOrg.id) then
            cancelEvent()

            setElementHealth(source, getElementHealth(source) + loss)
        end
    end
end
addEventHandler("onPlayerDamage", root, onDamage)

function loadPlayerOrganizationData(player)
    local sid = getElementData(player, 'player:sid')
    if not sid then
        return
    end
    sid = tonumber(sid)

    local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `owner` = ? OR `members` LIKE ?', sid, '%'..sid..'%')
    if result and #result > 0 then
        
        local item = false
        for k,v in ipairs(result) do
            if tonumber(v.owner) == sid then
                item = v
                break
            end

            local members = fromJSON(v.members)
            for kk,vv in ipairs(members) do
                if tonumber(vv[1]) == sid then
                    --local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `owner` = ? OR `members` LIKE ?', v[1], '%'..v[1]..'%')

                    item = result[k]
                    break
                end
            end
        end

        if item then
            local memberData = fromJSON(item.members)

            for k,v in ipairs(memberData) do
                if tonumber(v[1]) == sid then
                    setElementData(player, 'player:organization', {
                        id = item.uid,
                        name = item.name,
                        rank = v[2],
                        color = item.colorrgb,
                        level = item.level,
                        exp = item.exp,
                        tag = item.tag,
                        gang = item.type == 1 and true or nil,
                        garage = item.garage == 1 and true or nil,
                    })
                    setElementData(player, 'player:gang', item.type == 1 and true or nil)
                    break
                end
            end
        else
            setElementData(player, 'player:organization', nil)
            setElementData(player, 'player:gang', nil)
        end
    else
        setElementData(player, 'player:organization', nil)
        setElementData(player, 'player:gang', nil)
    end
end

function getPlayerFromUID(uid)
    if not uid or not tonumber(uid) then return false end
    local uid = tonumber(uid)
    local player = false

    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:sid') and getElementData(v, 'player:sid') == uid then
            player = v
            break
        end
    end

    if player then
        return player
    else
        local result = exports['since-db']:query('SELECT * FROM `since-users` WHERE uid = ?', uid)

        if #result > 0 then
            return result[1].uid
        else
            return false
        end
    end
end

function getOrganizationLogs(uid)
    local result = exports['since-db']:query('SELECT * FROM `since-orgs-logs` WHERE `org` = ? ORDER BY `uid` DESC LIMIT 350', uid)
    if result and #result > 0 then
        return result
    else
        return {}
    end
end

function getOrganizationVehicles(uid)
    if uid == 0 then return {} end
    local result = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE `organization` = ?', uid)
    if result and #result > 0 then
        return result
    else
        return {}
    end

    --[[local result = exports['since-db']:query('SELECT * FROM `since-orgs-vehicles` WHERE `org` = ?', uid)
    if result and #result > 0 then
        local returnData = {}
        for k,v in pairs(result) do
            local vehicle = exports['since-db']:query('SELECT * FROM `since-vehicles` WHERE `id` = ?', v.vehicle)
            if vehicle and #vehicle > 0 then
                table.insert(returnData, vehicle[1])
            end
        end
        return returnData
    else
        return {}
    end]]
end

function getOrganizationData(player)
    local sid = tonumber(player) and player or getElementData(player, 'player:sid')
    if not sid then
        return {status = false, message = 'Nie jesteś zalogowany'}
    end
    sid = tonumber(sid)

    local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `owner` = ? OR `members` LIKE ?', sid, '%'..sid..'%')
    if result and #result > 0 then

        local item = false
        for k,v in ipairs(result) do
            if tonumber(v.owner) == sid then
                item = v
                break
            end

            local members = fromJSON(v.members)
            for kk,vv in ipairs(members) do
                if tonumber(vv[1]) == sid then
                    --local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `owner` = ? OR `members` LIKE ?', v[1], '%'..v[1]..'%')

                    item = result[k]
                    break
                end
            end
        end

        if not item then
            return {status = false, message = 'Nie jesteś członkiem żadnej organizacji'}
        end

        local membersData = {}
        for k,v in pairs(fromJSON(item.members)) do
            table.insert(membersData, getUserData(v[1], v[2]))
        end

        table.sort(membersData, function(a, b)
            return a.rank > b.rank
        end)

        local myRank = 0
        for k,v in pairs(membersData) do
            if tonumber(v.sid) == sid then
                myRank = v.rank
                break
            end
        end

        local returnData = {
            id = item.uid,
            name = item.name,
            tag = item.tag,
            color = item.color,
            rgb = {hexToRGB(item.color)},
            members = membersData,
            isOwner = tonumber(item.owner) == sid,
            myRank = myRank,
            level = item.level,
            exp = item.exp,
            money = item.money,
            logs = getOrganizationLogs(item.uid),
            vehicles = getOrganizationVehicles(item.uid),
            gang = item.type == 1 and true or nil,
            garage = item.garage == 1 and true or nil,
        }

        return {status = true, data = returnData}
    else
        return {status = false, message = 'Nie jesteś członkiem żadnej organizacji'}
    end
end

function changeRank(player, org, sid, diff)
    local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `uid` = ?', org)
    local orgData = getOrganizationData(player).data
    local orgData2 = getOrganizationData(getPlayerFromUID(sid)).data

    if orgData.myRank <= orgData2.myRank then
        return {status = false, message = 'Nie możesz tego zrobić!'}
    end

    if result and #result > 0 then
        local item = result[1]
        local members = fromJSON(item.members)
        for k,v in ipairs(members) do
            if tonumber(v[1]) == sid then
                if tonumber(v[2]) == 3 and diff > 0 then
                    return {status = false, message = 'Ten gracz ma już najwyższą rangę'}
                elseif tonumber(v[2]) == 1 and diff < 0 then
                    return {status = false, message = 'Ten gracz ma już najniższą rangę'}
                end

                members[k][2] = math.max(math.min(3, tonumber(v[2]) + diff), 1)
                exports['since-db']:query('UPDATE `since-orgs` SET `members` = ? WHERE `uid` = ?', toJSON(members), org)
                return {status = true, message = diff > 0 and 'Awansowałeś gracza' or 'Zdegradowałeś gracza'}
            end
        end
    end

    return {status = false, message = 'Nie znaleziono takiego gracza'}
end

function removeMember(player, org, sid, ignoreRank)
    local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `uid` = ?', org)
    local orgData = getOrganizationData(player).data
    local orgData2 = getOrganizationData(getPlayerFromUID(sid)).data
    local isPlayer = findPlayerByUID(player, sid)

    if ignoreRank then
        if orgData.myRank == 4 then
             return {status = false, message = 'Nie możesz tego zrobić, usuń organizację.'}
        end
    else
        if orgData.myRank < 3 then
            return {status = false, message = 'Nie możesz tego zrobić!'}
        end
        if orgData.myRank <= orgData2.myRank then
            return {status = false, message = 'Nie możesz tego zrobić!'}
        end
    end

    if result and #result > 0 then
        local item = result[1]
        local members = fromJSON(item.members)
        for k,v in ipairs(members) do
            if tonumber(v[1]) == sid then
                table.remove(members, k)
                
                exports['since-db']:query('UPDATE `since-orgs` SET `members` = ? WHERE `uid` = ?', toJSON(members), org)

                if isPlayer and isElement(isPlayer) then
                    setElementData(isPlayer, 'player:organization', nil)
                    setElementData(isPlayer, 'player:gang', nil)
                    setTimer(function()
                        loadPlayerOrganizationData(isPlayer)
                    end, 100, 1)
                end
                return {status = true, message = 'Usunąłeś gracza z organizacji'}
            end
        end
    end

    return {status = false, message = 'Nie znaleziono takiego gracza'}
end

function setSpawn(player, org)
    local orgData = getOrganizationData(player).data

    if orgData.myRank < 3 then
        return {status = false, message = 'Nie możesz tego zrobić!'}
    end

    local x, y, z = getElementPosition(player)
    local rx, ry, rz = getElementRotation(player)
    exports['since-db']:query('UPDATE `since-orgs` SET `spawn` = ? WHERE `uid` = ?', toJSON({x, y, z, rx, ry, rz}), org)
    return {status = true, message = 'Ustawiono spawn organizacji'}
end

function removeOrganization(player, org)
    local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `uid` = ?', org)
    local orgData = getOrganizationData(player).data

    if orgData.myRank ~= 4 then
        return {status = false, message = 'Nie możesz tego zrobić!'}
    end

    if result and #result > 0 then
        local item = result[1]
        local members = fromJSON(item.members)
        for k,v in ipairs(members) do
            local isPlayer = findPlayerByUID(player, v[1])
            if isPlayer and isElement(isPlayer) then
                setElementData(isPlayer, 'player:organization', nil)
                setElementData(isPlayer, 'player:gang', nil)
                setTimer(function()
                    loadPlayerOrganizationData(isPlayer)
                end, 100, 1)
            end
        end

        exports['since-db']:query('DELETE FROM `since-orgs` WHERE `uid` = ?', org)
        exports['since-db']:query('DELETE FROM `since-orgs-logs` WHERE `org` = ?', org)
        return {status = true, message = 'Usunięto organizację'}
    end

    return {status = false, message = 'Nie znaleziono takiej organizacji'}
end

function addMember(player, org, sid, rank)
    local result = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `uid` = ?', org)
    local orgData = getOrganizationData(player).data

    if result and #result > 0 then
        local item = result[1]
        local members = fromJSON(item.members)
        for k,v in ipairs(members) do
            if tonumber(v[1]) == sid then
                return {status = false, message = 'Ten gracz jest już w organizacji'}
            end
        end

        table.insert(members, {sid, rank})
        exports['since-db']:query('UPDATE `since-orgs` SET `members` = ? WHERE `uid` = ?', toJSON(members), org)
        loadPlayerOrganizationData(player)
        return {status = true, message = 'Dodano gracza do organizacji'}
    end

    return {status = false, message = 'Nie znaleziono takiej organizacji'}
end

function findPlayerByUID(plr, uid)
	local cel = false

	for i,v in ipairs(getElementsByType('player')) do
		if tonumber(getElementData(v, 'player:sid')) == tonumber(uid) then
			cel = v
		end
	end

	return cel
end

function sendInviteToOrganization(plr, uid)
    if uid and plr then
		local target = findPlayerByUID(plr, uid)
		if target then
			if target == plr then
				return exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz wysłać zaproszenia do samego siebie!')
			end

			local eldata = getElementData(plr, "org_request")
			local organizacja = getElementData(target, "player:organization")

            if organizacja then
				return exports['since-notifications']:sendNotification(plr, 'error', 'Podany gracz jest już w organizacji')
			end

			if eldata then
				for i,v in ipairs(eldata) do
					if v.userdata == target then
						return exports['since-notifications']:sendNotification(plr, 'error', 'Podany gracz posiada już aktywne od ciebie zaproszenie')
					end
				end

                local organizationData = getOrganizationData(plr).data
                
				table.insert(eldata, {userdata = target, tick = getTickCount(), orgID = organizationData.id, orgName = organizationData.name})
				setElementData(plr, "org_request", eldata)
				outputChatBox("#fffb00* #ffffffGracz #a9a9a9"..getPlayerName(plr):gsub("#%x%x%x%x%x%x", "").." #ffffffwysłał Ci zaproszenie do organizacji #a9a9a9"..organizationData.name.."#ffffff. Aby je zaakceptować użyj #a9a9a9/organizacja.akceptuj "..getElementData(plr, 'player:sid'), target, 255, 255, 255, true)
                exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie wysłano zaproszenie do organizacji')
            else
                local organizationData = getOrganizationData(plr).data

				setElementData(plr, "org_request", {userdata = target, tick = getTickCount(), orgID = organizationData.id, orgName = organizationData.name})
				outputChatBox("#fffb00* #ffffffGracz #a9a9a9"..getPlayerName(plr):gsub("#%x%x%x%x%x%x", "").." #ffffffwysłał Ci zaproszenie do organizacji #a9a9a9"..organizationData.name.."#ffffff. Aby je zaakceptować użyj #a9a9a9/organizacja.akceptuj "..getElementData(plr, 'player:sid'), target, 255, 255, 255, true)
				exports['since-notifications']:sendNotification(plr, 'success', 'Pomyślnie wysłano zaproszenie do organizacji')
			end
		else
			exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono gracza')
		end
	end
end

local lastKills = {}

function checkSameORG(plr, target)
    local orgplr = getElementData(plr, 'player:organization')
    local orgtarget = getElementData(target, 'player:organization')

    if orgplr and orgtarget then
        if orgplr.id == orgtarget.id then
            return true
        else
            return false
        end
    else
        return false
    end
end

addEventHandler ( "onPlayerWasted", root, function(ammo, killer, killerweapon, bodypart)
	if ( killer ) and ( killer ~= source ) then
        if not killer or getElementType(killer) ~= 'player' then
            return
        end
        
        if not lastKills[killer] then lastKills[killer] = nil end

        if math.random(1, 2) == 2 and lastKills[killer] ~= source then
            local random = math.random(45000, 65000)
            givePlayerMoney(killer, random)

            if getElementData(killer, 'player:organization') and getElementData(killer, 'player:organization').id and checkSameORG(killer, source) == false then
                local randomEXP = math.random(1, 8)
                addExp(killer, randomEXP)

                outputChatBox(" ", killer, 255, 175, 0, true)
                outputChatBox("⚔#ffffff Zabito gracza #FFA800"..getPlayerName(source).."#ffffff, otrzymujesz #2E756F$ "..random.."#ffffff #6eb9ff(+ "..randomEXP.." EXP)#ffffff.", killer, 125, 255, 125, true)
                outputChatBox(" ", killer, 255, 175, 0, true)
            else
                outputChatBox(" ", killer, 255, 175, 0, true)
                outputChatBox("⚔#ffffff Zabito gracza #FFA800"..getPlayerName(source).."#ffffff, otrzymujesz #2E756F$ "..random.."#ffffff.", killer, 125, 255, 125, true)
                outputChatBox(" ", killer, 255, 175, 0, true)
            end
        else
            outputChatBox(" ", killer, 255, 175, 0, true)
		    outputChatBox("⚔#ffffff Zabito gracza #FFA800"..getPlayerName(source).."#ffffff.", killer, 125, 255, 125, true)
		    outputChatBox(" ", killer, 255, 175, 0, true)
        end

        if bodypart ~= 9 then
            local playerData = getElementData(killer, 'player:data') or {}
            playerData.respekt = (playerData.respekt or 0) + 1
            setElementData(killer, 'player:data', playerData)
    
            local playerData = getElementData(source, 'player:data') or {}
            playerData.respekt = (playerData.respekt or 0) - 1
            setElementData(source, 'player:data', playerData)
        end

		outputChatBox(" ", source, 255, 175, 0, true)
		outputChatBox("⚔#ffffff Gracz #FFA800"..getPlayerName(killer).."#ffffff zabija cię!", source, 255, 0, 0, true)
		outputChatBox(" ", source, 255, 175, 0, true)

        lastKills[killer] = source
    end
end)

addCommandHandler("organizacja.akceptuj", function(plr, cmd, id)
	if tonumber(id) then
        local target = findPlayerByUID(plr, id)

        if getElementData(plr, 'player:organization') then
            return outputChatBox("#ff0000✘ #ffffffJuż należysz do organizacji", plr, 255, 255, 255, true)
        end

		if target then
			local eldata = getElementData(target, "org_request")
			if eldata then
                local organizationData = getOrganizationData(target).data
				if organizationData.id == eldata.orgID then
					outputChatBox("#00ff00✔ #ffffffPomyślnie zaakceptowałeś zaproszenie do organizacji #a9a9a9"..eldata.orgName.."#ffffff od gracza #a9a9a9"..getPlayerName(target):gsub("#%x%x%x%x%x%x", "").."", plr, 255, 255, 255, true)
					outputChatBox("#00ff00✔ #ffffffGracz #a9a9a9"..getPlayerName(plr):gsub("#%x%x%x%x%x%x", "").." #ffffffpomyślnie zaakceptował twoje zaproszenie do organizacji!", target, 255, 255, 255, true)

					table.remove(eldata, i)
					setElementData(target, "org_request", eldata)

					addMember(plr, eldata.orgID, getElementData(plr, 'player:sid'), 1)
				end
			else
				outputChatBox("#ff0000✘ #ffffffGracz nie posiada aktywnego zaproszenia", plr, 255, 255, 255, true)
			end
		else
			outputChatBox("#ff0000✘ #ffffffNie znaleziono podanego gracza!", plr, 255, 255, 255, true)
		end
	end
end)

local stages = {}
local stageTimer = {}

function opuscOrg(plr, cmd)
    if not stages[plr] then
        stages[plr] = 0
    end

	if getElementData(plr, 'player:organization') then
        if stages[plr] == 0 then
            outputChatBox("#00ff00* #ffffffAby opuścić organizację wpisz komendę (/"..cmd..") jeszcze raz", plr, 255, 255, 255, true)

            stages[plr] = 1

            stageTimer[plr] = setTimer( function()
                stages[plr] = 0
            end, 3000, 1)
        elseif stages[plr] == 1 then
            local org = getOrganizationData(plr).data
            local sid = getElementData(plr, 'player:sid')

            local result = removeMember(plr, org.id, sid, true)

            print(inspect(result))

            if result.status == true then
                loadPlayerOrganizationData(plr)
                outputChatBox("#00ff00✔ #ffffffPomyślnie opuszczasz organizacje #a9a9a9"..org.name, plr, 255, 255, 255, true)
                stages[plr] = 0
    
                if isTimer(stageTimer[plr]) then
                    killTimer(stageTimer[plr])
                end
            end
        end
    else
        outputChatBox("#ff0000✘ #ffffffNie należysz do organizacji", plr, 255, 255, 255, true)
    end
end
addCommandHandler('opusc', opuscOrg)
addCommandHandler('opusc.org', opuscOrg)
addCommandHandler('opusc.organizacje', opuscOrg)

for i,v in ipairs(getElementsByType('player')) do
    loadPlayerOrganizationData(v)
end

addEvent('since:organizations:getData', true)
addEventHandler('since:organizations:getData', resourceRoot, function()
    local result = getOrganizationData(client)
    triggerClientEvent(client, 'since:organizations:getData', resourceRoot, result)
end)

addEvent('since:organizations:rankUp', true)
addEventHandler('since:organizations:rankUp', resourceRoot, function(org, sid)
    local result = changeRank(client, org, sid, 1)
    local getNewData = getOrganizationData(client)
    result.data = getNewData.data
    triggerClientEvent(client, 'since:organizations:result', resourceRoot, result)
end)

addEvent('since:organizations:rankDown', true)
addEventHandler('since:organizations:rankDown', resourceRoot, function(org, sid)
    local result = changeRank(client, org, sid, -1)
    local getNewData = getOrganizationData(client)
    result.data = getNewData.data
    triggerClientEvent(client, 'since:organizations:result', resourceRoot, result)
end)

addEvent('since:organizations:removeMember', true)
addEventHandler('since:organizations:removeMember', resourceRoot, function(org, sid)
    local result = removeMember(client, org, sid)
    local getNewData = getOrganizationData(client)
    result.data = getNewData.data
    triggerClientEvent(client, 'since:organizations:result', resourceRoot, result)
end)

addEvent('since:organizations:setSpawn', true)
addEventHandler('since:organizations:setSpawn', resourceRoot, function(org)
    local result = setSpawn(client, org)
    local getNewData = getOrganizationData(client)
    result.data = getNewData.data
    triggerClientEvent(client, 'since:organizations:result', resourceRoot, result)
end)

function isArtifactActive(org)
	local queryA = exports['since-db']:query("SELECT * FROM `since-orgs` WHERE uid = ? AND artifact > NOW() LIMIT 1", org)

	if (queryA and #queryA > 0) then
		return queryA[1].artifact
	end

	return false	
end

addEvent('since:organizations:startArtifact', true)
addEventHandler('since:organizations:startArtifact', resourceRoot, function(org)
    if not getElementData(client, 'player:organization') then
        return {status = false, message = 'Nie należysz do żadnej organizacji'}
    end

    local checkArtifact = isArtifactActive(org)

    if org and not checkArtifact then
        outputChatBox("✔#FFFFFF Rozpoczynasz szukanie artefaktu, udaj się do zielonej strefy w lesie bądź na polanie.", client, 0, 255, 0, true)
        exports['since-db']:query("UPDATE `since-orgs` SET artifact = NOW() + INTERVAL ? MINUTE WHERE `uid` = ?", 30, org)
        exports['since-artifacts']:startArtifact(client)
    else
        outputChatBox("✘#FFFFFF Następne szukanie artefaktu dla tej organizacji dostępne od: #c9c9c9"..checkArtifact, client, 255, 0, 0, true)
    end
end)

addEvent('since:organizations:buyGarage', true)
addEventHandler('since:organizations:buyGarage', resourceRoot, function(org)
    if not getElementData(client, 'player:organization') then
        return {status = false, message = 'Nie należysz do żadnej organizacji'}
    end

    if org.garage then
        return
    end

    if org then
        local money = getPlayerMoney(client)

        if money < 40000000 then
            return outputChatBox("✘#FFFFFF Nie posiadasz wystarczająco gotówki na zakup garażu.", client, 255, 0, 0, true)
        end

        takePlayerMoney(client, 40000000)
        exports['since-db']:query("UPDATE `since-orgs` SET garage = 1 WHERE `uid` = ?", org.id)

        result = getOrganizationData(client)
        triggerClientEvent(client, 'since:organizations:getData', resourceRoot, result)
    
        for i,v in ipairs(getElementsByType('player')) do
            if getElementData(v, 'player:organization') and getElementData(v, 'player:organization').id == org.id then
                loadPlayerOrganizationData(v)
                outputChatBox(" ", v, 0, 255, 0, true)
                outputChatBox("✔#FFFFFF Gracz #b8b8b8"..getPlayerName(client).."#ffffff zakupił dziuple dla twojej organizacji.", v, 0, 255, 0, true)
                outputChatBox("✔#FFFFFF Dziupla znajduje się w #b8b8b8Angel Pine", v, 0, 255, 0, true)
                outputChatBox(" ", v, 0, 255, 0, true)
            end
        end
    end
end)

addEvent('since:organizations:removeOrganization', true)
addEventHandler('since:organizations:removeOrganization', resourceRoot, function(org)
    local result = removeOrganization(client, org)
    triggerClientEvent(client, 'since:organizations:result', resourceRoot, result)
end)

addEvent('since:organizations:addMember', true)
addEventHandler('since:organizations:addMember', resourceRoot, function(org, nick)
    local orgData = getOrganizationData(client).data

    if orgData.myRank < 3 then
        return {status = false, message = 'Nie możesz tego zrobić'}
    end

    sendInviteToOrganization(client, nick)
end)

function writeOnMembersChat(id, ...)
    local db = exports['since-db']:query("SELECT * FROM `since-orgs` WHERE uid=? LIMIT 1", id)
    if (db and #db > 0) then
        local text = table.concat({...}, " ")
        local r,g,b = unpack(split(db[1].colorrgb, ","))
        for i,v in ipairs(getElementsByType("player")) do
            if (getElementData(v, "player:organization") and (getElementData(v, "player:organization").id == id)) then
                outputChatBox(getElementData(v, "player:organization").name.." #FFFFFF> "..text, v, r, g, b, true)
            end
        end
    end
end

addCommandHandler("organizacja", function(plr, cmd, ...)
	if not getElementData(plr, "player:organization") then
		outputChatBox("#ff0000✘ #DFDFDFNie posiadasz organizacji!", plr, 255,255,255, true)
		return
	end
    if getElementData(plr, "player:mute") then
		outputChatBox("#ff0000✘ #DFDFDFJesteś wyciszony!", plr, 255,255,255, true)
		return
	end
    local name, id = getPlayerName(plr):gsub("#%x%x%x%x%x%x",""), getElementData(plr,"id")

    text = table.concat({...}, " "):gsub("#%x%x%x%x%x%x","")
    
    writeOnMembersChat(getElementData(plr, "player:organization").id, name.." ("..id..")#ffffff: "..text)
end)

addEventHandler("onResourceStart", root, function() 
    local players=getElementsByType('player')
    for _, p in pairs(players) do
        bindKey(p, "o", "down", "chatbox", "organizacja")
    end
end)

addEventHandler( "onPlayerSpawn", getRootElement(), function (_)
	bindKey(source, "o", "down", "chatbox", "organizacja")
end)
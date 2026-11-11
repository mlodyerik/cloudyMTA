local reportTimeout = {}
local syncer = createElement('admin:reports', 'admin:reports')
setElementData(syncer, 'reports', {})

function addReport(sender, target, ...)
    if reportTimeout[sender] and reportTimeout[sender] > getTickCount() then
        exports['since-notifications']:sendNotification(sender, 'error', 'Możesz wysłać kolejne zgłoszenie za {timer:' .. math.ceil((reportTimeout[sender] - getTickCount()) / 1000) .. '} sekund.', 10000, 'report-timeout')
        return
    end

    if not getElementData(sender, 'player:sid') then return end
    
    local target = exports['since-core']:findPlayer(sender, target or '!@#!@#')
    if not target then return exports['since-notifications']:sendNotification(sender, 'error', 'Nie znaleziono podanego gracza.') end
    if not getElementData(target, 'player:sid') then return exports['since-notifications']:sendNotification(sender, 'error', 'Gracz nie jest zalogowany.') end

    local reason = table.concat({...}, ' ')
    if not reason or #reason < 3 then return exports['since-notifications']:sendNotification(sender, 'error', 'Powód musi mieć minimum 3 znaki.') end


    for i,v in ipairs(getElementsByType('player')) do
        if getElementData(v, 'player:admin') then
            outputChatBox("ⓘ#ffffff Pojawiło się nowe zgłoszenie od gracza: #40acff"..getPlayerName(sender):gsub("#%x%x%x%x%x%x","")..".", v, 100, 175, 255, true)
        end
    end

    local report = {
        sender = getElementData(sender, 'player:sid'),
        target = getElementData(target, 'player:sid'),
        reason = {
            {0xFF00FF57, getPlayerName(sender) .. ' (' .. getElementData(sender, 'id') .. ')'},
            {0xFFFFFFFF, ' > '},
            {0xFF00FF57, getPlayerName(target) .. ' (' .. getElementData(target, 'id') .. ')'},
            {0xFFFFFFFF, ': ' .. reason},
        },
        reasonNoHex = getPlayerName(sender) .. ' (' .. getElementData(sender, 'id') .. ') > ' .. getPlayerName(target) .. ' (' .. getElementData(target, 'id') .. '): ' .. reason,
        date = getTickCount(),
        status = 'Oczekuje',
    }

    local reports = getElementData(syncer, 'reports')
    table.insert(reports, report)
    setElementData(syncer, 'reports', reports)

    exports['since-notifications']:sendNotification(sender, 'info', 'Zgłoszenie zostało wysłane.')
    reportTimeout[sender] = getTickCount() + 60000

    exports['since-logs']:sendDiscordLog('reporty', 'Reporty', '`'..getPlayerName(sender)..'` wysyła zgłoszenie na gracza: `' .. getPlayerName(target) .. '` z powodem: `' .. reason .. '`')
end

addEventHandler( "onPlayerQuit", root, function()
	if getElementData(source, "player:sid") then
		deleteReport(getElementData(source, 'player:sid'))
	end
end)

function deleteReport(sender)
    local delete = false
    local reports = getElementData(syncer, 'reports')

    for i,v in ipairs(reports) do
        if v.sender == sender then
            table.remove(reports, i)
            delete = true
        end
    end

    setElementData(syncer, 'reports', reports)

    return delete
end

addCommandHandler("clp", function(plr,cmd,id,...)
	if not getAdmin(plr) then
		return
	end

	local reason = table.concat({...}, " ")

	if not id then return outputChatBox("ⓘ#ffffff /clp <id> <odpowiedź>", plr, 255, 255, 0, true) end
	if not reason then return outputChatBox("ⓘ#ffffff /clp <id> <odpowiedź>", plr, 255, 255, 0, true) end
	
	local target = exports["since-core"]:findPlayer(plr, id)
    local targetUID = getElementData(target, 'player:sid')
	
	if target == plr then 
		return outputChatBox("ⓘ#ffffff Nie możesz przyjąć swojego zgłoszenia", plr, 255, 0, 0, true)
	end

	if reason == "" or reason == " " then
		reason = "#C00004Brak#ffffff"
	end

    if deleteReport(targetUID) then
        for i,v in ipairs(getElementsByType("player")) do
            if getElementData(v,"player:admin") then
                outputChatBox("ⓘ#ffffff "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").." #22D000przyjmuje#ffffff zgłoszenie gracza "..getPlayerName(target):gsub("#%x%x%x%x%x%x","")..". Odpowiedź: "..reason.."", v, 255, 255, 0, true)
            end
        end

        outputChatBox("ⓘ#ffffff Twoje zgłoszenie zostało #22D000przyjęte#ffffff przez "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."", target, 255, 255, 0, true)
        outputChatBox("ⓘ#ffffff Odpowiedź: "..reason or "Brak".."", target, 255, 255, 0, true)

        exports['since-adminpanel']:addAdminStats(plr, 'reports', 1)

        exports['since-logs']:sendDiscordLog('reporty', getPlayerName(plr), 'Przyjmuje zgłoszenie gracza: `' .. getPlayerName(target) .. '` z odpowiedzią: `' .. reason .. '`')
        exports['since-db']:query('UPDATE `since-admins` SET `reporty` = `reporty` + 1 WHERE `serial` = ?', getPlayerSerial(plr))
    end
end)

addCommandHandler("clo", function(plr,cmd,id,...)
	if not getAdmin(plr) then
		return
	end

	local reason = table.concat({...}, " ")

	if not id then return outputChatBox("ⓘ#ffffff /clp <id> <odpowiedź>", plr, 255, 255, 0, true) end
	if not reason then return outputChatBox("ⓘ#ffffff /clp <id> <odpowiedź>", plr, 255, 255, 0, true) end
	
	local target = exports["since-core"]:findPlayer(plr, id)
    local targetUID = getElementData(target, 'player:sid')
	
	if target == plr then 
		return outputChatBox("ⓘ#ffffff Nie możesz odrzucić swojego zgłoszenia", plr, 255, 0, 0, true)
	end

	if reason == "" or reason == " " then
		reason = "#C00004Brak#ffffff"
	end

    if deleteReport(targetUID) then
        for i,v in ipairs(getElementsByType("player")) do
            if getElementData(v,"player:admin") then
                outputChatBox("ⓘ#ffffff "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").." #C00004odrzucił/a#ffffff zgłoszenie gracza "..getPlayerName(target):gsub("#%x%x%x%x%x%x","")..". Odpowiedź: "..reason.."", v, 255, 255, 0, true)
            end
        end

        outputChatBox("ⓘ#ffffff Twoje zgłoszenie zostało #C00004odrzucone#ffffff przez "..getPlayerName(plr):gsub("#%x%x%x%x%x%x","").."", target, 255, 255, 0, true)
        outputChatBox("ⓘ#ffffff Odpowiedź: "..reason or "Brak".."", target, 255, 255, 0, true)

        exports['since-adminpanel']:addAdminStats(plr, 'reports', 1)

        exports['since-logs']:sendDiscordLog('reporty', getPlayerName(plr), 'Odrzuca zgłoszenie gracza: `' .. getPlayerName(target) .. '` z odpowiedzią: `' .. reason .. '`')
        exports['since-db']:query('UPDATE `since-admins` SET `reporty` = `reporty` + 1 WHERE `serial` = ?', getPlayerSerial(plr))
    end
end)

function addReportCommand(plr, cmd, target, ...)
    addReport(plr, target, ...)
end

addCommandHandler('zglos', addReportCommand)
addCommandHandler('report', addReportCommand)
addCommandHandler('raport', addReportCommand)
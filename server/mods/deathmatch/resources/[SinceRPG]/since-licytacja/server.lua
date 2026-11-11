--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

local col = createColSphere(404.26, 2467.14, 16.51, 30)

function removeHex(s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

function getAdmin(plr,level)
	--if getElementData(plr,"SPIERDOLONYCHUJ1") then return true end
	if level then
		local result=exports["since-db"]:query("SELECT * from `since-admins` WHERE serial=? AND level=?", getPlayerSerial(plr), level)
		if result and #result > 0 then
			return true
		else
			return false
		end
	else
		local result=exports["since-db"]:query("SELECT * from `since-admins` WHERE serial=?", getPlayerSerial(plr))
		if result and #result > 0 then
			return true
		else
			return false
		end
	end
end


licytacja = false
licytacja_przez = false

function licytacjaStart(plr, cmd, kwota, minimalna)
    if getAdmin(plr, 4) or getAdmin(plr, 3) or getAdmin(plr, 2) then
    if not kwota or not minimalna then
        exports['since-notifications']:sendNotification(plr, 'error', 'Użyj: /licytacja.start <początkowa kwota> <minimalne przebicie>')
        return false
    end

    if licytacja_przez then
        exports['since-notifications']:sendNotification(plr, 'error', 'Licytacja już została wystartowana przez '..removeHex(licytacja_przez)..'')
        return false
    end

    licytacja_przez = getPlayerName(plr)

    text = "Licytacja została rozpoczęta przez "..removeHex(licytacja_przez)
    minimalna_kwota_podbicia = tonumber(minimalna)
    kwota2 = kwota
    triggerClientEvent(root, "enonek-licytacje", resourceRoot, text, 10, kwota, minimalna)

    setTimer(function()
        licytacja = true
    end, 10000, 1)
end
end
addCommandHandler("licytacja.start", licytacjaStart)

function licytacjaEnd(plr, cmd)
    if getAdmin(plr, 4) or getAdmin(plr, 3) or getAdmin(plr, 2) then
    if not licytacja_przez then
        exports['since-notifications']:sendNotification(plr, 'error', 'Licytacja nie została wystartowana!')
        return false
    end
    licytacja = false
    licytacja_przez = false
    triggerClientEvent(root, "enonek-licytacje:end", resourceRoot)
end
end
addCommandHandler("licytacja.end", licytacjaEnd)

cooldown = false

function podbij(plr, cmd, kwota)
    if not licytacja then
        outputChatBox("Licytacja jeszcze nie wystartowała!", plr)
        return false
    end
    if tonumber(kwota) < tonumber(minimalna_kwota_podbicia) then
        exports['since-notifications']:sendNotification(plr, 'error', 'Minimalna kwota przebicia to: '..minimalna_kwota_podbicia..' $')
        return false
    end

    if cooldown then
        exports['since-notifications']:sendNotification(plr, 'error', 'Poczekaj chwilę zanim znów podbijesz!')
        return false
    end

    local result = exports["since-db"]:query("SELECT * FROM `since-users` WHERE uid=?", getElementData(plr, "player:sid"))
    if tonumber(result[1].bankMoney) < tonumber(kwota + kwota2) then
        exports['since-notifications']:sendNotification(plr, 'error', 'Nie posiadasz tyle pieniędzy na koncie bankowym!')
        return false
    end
    triggerClientEvent(root, "enonek-licytacje:podbij", resourceRoot, plr, kwota)
    kwota2 = kwota2 + kwota
end
addCommandHandler("podbij", podbij)

addEventHandler("onColShapeHit", col, function(el, dim)
    --addCommandHandler("licytacja.start", licytacjaStart)
    --addCommandHandler("licytacja.end", licytacjaEnd)
    --addCommandHandler("podbij", podbij)
end)

addEventHandler("onColShapeLeave", col, function(el, dim)
    --removeCommandHandler("licytacja.start", licytacjaStart)
    --removeCommandHandler("licytacja.end", licytacjaEnd)
    --removeCommandHandler("podbij", podbij)
end)
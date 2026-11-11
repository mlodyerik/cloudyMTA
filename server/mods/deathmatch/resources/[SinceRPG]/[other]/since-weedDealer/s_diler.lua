local diler = {
    ["pos"] = {
        {-2186.37, 718.35, 53.90, 224.89},
        {-2684.40, 1416.41, 7.09, 114.99},
        {-2788.13, 769.91, 50.51, 177.43},
    },
}


function changeDiler()
    local rnd = math.random(#diler["pos"])
    if diler["ped"] and isElement(diler["ped"]) then
        destroyElement(diler["ped"])
    end
    if diler["marker"] and isElement(diler["marker"]) then
        destroyElement(diler["marker"])
    end

    diler["ped"] = createPed(29, diler["pos"][rnd][1], diler["pos"][rnd][2], diler["pos"][rnd][3], diler["pos"][rnd][4])
    diler["marker"] = createMarker(diler["pos"][rnd][1], diler["pos"][rnd][2], diler["pos"][rnd][3]-1, "cylinder", 1.5, 125, 255, 125, 5)
    setElementData(diler["marker"], "diler.marker", true)
	setElementFrozen(diler["ped"], true)

    outputChatBox("\n#8FD689• #FFFFFFDiler zmienił spota.\n#8FD689• #FFFFFFLokalizacja: "..getZoneName(diler["pos"][rnd][1], diler["pos"][rnd][2], diler["pos"][rnd][3],true)..", "..getZoneName(diler["pos"][rnd][1], diler["pos"][rnd][2], diler["pos"][rnd][3],false).."\n",root,255,255,255,true)

end
setTimer(changeDiler, 1500, 1)
setTimer(changeDiler, getConfig()["DilerChangePosTime"]*60000, 0)

function getTopsFromEq()
    triggerClientEvent(client, "diler.getTops:C", resourceRoot, getInventoryInfo(client, 'drugs'))
end
addEvent("diler.getTops:S", true)
addEventHandler("diler.getTops:S", resourceRoot, getTopsFromEq)

function sellTops(name, type)
    if ((not name) or (not type)) then
        return
    end
    local sid = (getElementData(client, "player:sid") or nil)
    if (not sid) then
        return
    end
    local money = 0
    local gramy = 0
    for i,v in pairs(getInventoryInfo(client, 'drugs')) do
        if (i == name) then
            money = money + (getConfig()["types"][type].price * v)
            gramy = gramy + v
            exports['since-inventory']:addPlayerItem(client, i, -v)
            triggerClientEvent(client, "diler.getTops:C", resourceRoot, getInventoryInfo(client, 'drugs'))
        end
    end
    if (money > 0) then 
        exports['since-db']:query("Update `since-users` Set bankMoney=bankMoney+? Where uid=?", money, sid)
        exports['since-notifications']:sendNotification(client, 'success', 'Sprzedałeś '..formatNumber(gramy)..' g. za '..formatNumber(money)..' $ (konto bankowe)')
    end 
end
addEvent("diler.sellTops:S", true)
addEventHandler("diler.sellTops:S", resourceRoot, sellTops)

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2') 
			
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end

function getInventoryInfo(plr, state)
    local tbl = {}
    for i,v in ipairs(getElementData(plr, 'player:inventory') or {}) do
        if state == 'seeds' then
            if v.class == 'illegal' and string.find(v.name, 'seed') and v.amount > 0 then
                tbl[v.name] = v.amount
            end
        elseif state == 'water' then
            if v.class == 'normal' and v.name=='water' and v.amount > 0 then
                return v.amount
            end
        elseif state == 'recast' then
            if v.class == 'illegal' and (string.find(v.name, 'top') or string.find(v.name, 'recasted')) and v.amount > 0 then
                tbl[v.name] = v.amount
            end
        elseif state == 'drugs' then
            if v.class == 'illegal' and string.find(v.name, 'drug') and v.amount > 0 then
                tbl[v.name] = v.amount
            end
        end
    end
    return state == 'water' and 0 or tbl
end
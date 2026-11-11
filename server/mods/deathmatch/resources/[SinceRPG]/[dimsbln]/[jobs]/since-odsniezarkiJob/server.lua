function kropki(amount) 
	local formatted = amount 
	while true do   
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') 
	  if (k==0) then 
		break 
	  end 
	end 
	return formatted 
end

local savepos = {}

local vehs = {}

addEvent('odsniezarki.s', true)
addEventHandler('odsniezarki.s', resourceRoot, function(state)
    local plr = client
    if state == 'start' then
        if vehs[plr] then
            if isElement(vehs[plr]) then
                destroyElement(vehs[plr])
            end
            vehs[plr] = nil
        end

        local veh = createVehicle(489, 580.54, 1231.32, 11.86, 359.7, 0.0, 213.9, "SNOW "..getElementData(plr, 'player:sid'))
        setVehicleColor(veh, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255)
        setElementData(veh, "vehicle:job", "odsniezarki")
        setVehicleVariant(veh, 0, 255)
        addVehicleUpgrade(veh, 1025)
        setVehicleHandling(veh, "maxVelocity", 59)
        setElementData(veh, "vehicle:fuel", {
            type = "ON",
            count = 100,
            tank = 100,
        })

        setElementData(plr, "player:snieg", 0)
        triggerClientEvent(plr, "enonek-odsniezarki:start", resourceRoot)

        savepos[plr] = {{614.82, 1221.95, 11.79},}

        warpPedIntoVehicle(plr, veh, 0)

        vehs[plr] = veh

    elseif state == 'stop' then
        if vehs[plr] then
            if isElement(vehs[plr]) then
                destroyElement(vehs[plr])
            end
            vehs[plr] = nil
        end

    end
end)

local request_exit = {}

addEventHandler("onVehicleStartExit", resourceRoot, function(ped, seat)
    if getElementType(ped) == "player" then
        if seat == 0 then
            if request_exit[ped] then
                if getTickCount() - request_exit[ped] < 5000 then

                else
                    request_exit[ped] = getTickCount()
                    outputChatBox("#fff200* #ffffffAby zakończyć pracę naciśnij jeszcze raz klawisz #ff0000F", ped, _, _, _, true)
                    cancelEvent()
                end
            else
                request_exit[ped] = getTickCount()
                outputChatBox("#fff200* #ffffffAby zakończyć pracę naciśnij jeszcze raz klawisz #ff0000F", ped, _, _, _, true)
                cancelEvent()
            end
        end
    end
end)

addEventHandler("onVehicleExit", resourceRoot, function(ped, seat)
    if getElementType(ped) == "player" and seat == 0 then
        if vehs[ped] then
            if isElement(vehs[ped]) then
                destroyElement(vehs[ped])
                vehs[ped] = nil
            end
        end
        triggerClientEvent(ped, "enonek-odsniezarki:end", resourceRoot)
        local snow = getElementData(ped, "player:snieg")
        if snow then
            if snow < 5 then
                outputChatBox("#ff0000✘ #ffffffMusisz przejechać minumum 5 km aby otrzymać wynagrodzenie!", ped, 255, 255, 255, true)
            elseif snow >= 5 then
                local money = 1500
                money = money * snow
                money = money * exports["since-jobs"]:getJobMultiplier('odsniezarki')

                for i = 0, exports["since-jobs"]:getPlayerUpgradeLevel(ped, "odsniezarki", 'Money') do
                    money = money * (1.1)
                end
            
                if getElementData(ped, 'player:diamond') then
                    money = money * (1.5)
                end

                money = math.floor(money)

                exports['since-core']:givePlayerBankMoney(ped, money)

                exports["since-jobs"]:addPlayerJobEarned(ped, "odsniezarki", money)
                local points = math.floor(snow/2)
                if points > 0 then
                    exports["since-jobs"]:addPlayerJobPoints(ped, "odsniezarki", points)
                end

                exports['since-notifications']:sendNotification(ped, 'success', 'Otrzymujesz '..kropki(money)..' $ za '..math.floor(snow)..' kg śniegu!')
                setElementData(ped, "player:snieg", 0)
            end
        end
        removeElementData(ped, "player:job")
        vehs[ped] = nil
        request_exit[ped] = nil

        setTimer(function(ped)
            setElementPosition(ped, unpack(savepos[ped][1]))
            savepos[ped] = nil
        end, 1000, 1, ped)
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if vehs[source] then
        if isElement(vehs[source]) then
            destroyElement(vehs[source])
            vehs[source] = nil
        end
    end
end)

addEventHandler("onVehicleStartEnter", resourceRoot, function(ped, seat, door)
    cancelEvent()
end)

addEventHandler('onResourceStop', resourceRoot, function()
    local players = getElementsByType('player')

    for i, v in ipairs(players) do
        if getElementData(v, 'player:job') == 'odsniezarki' then
            setElementData(v, 'player:job', false)

            if isPedInVehicle( v ) then
                removePedFromVehicle(v)
            end

            setTimer(function(player)
                setElementPosition(v, 613.67, 1225.90, 11.79)
            end, 200, 1, v)
        end
    end
end)
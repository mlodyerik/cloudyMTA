  

local data = {
    moneyForPack = 730,
    shape = createColCuboid(-1933.31, -4.22, 1037.18, 33.81, 63.42, 11.90),
}

local poses = {
    [1] = {
        {-1915.15, 11.80, 1042.18},
        {-1921.14, 11.56, 1042.18},
    },

    [2] = {
        {-1918.12, 50.48, 1042.18},
        {-1905.56, 52.02, 1042.18},
        {-1926.13, 21.79, 1042.18},
        {-1914.80, 35.24, 1042.18},
        {-1918.93, 31.23, 1042.18},
        {-1922.83, 34.42, 1042.18},
    },
}

function toggleControls(state)
    if exports["since-jobs"]:getPlayerUpgradeLevel("magazynier", 'Sprinter') == 1 then
        toggleControl("sprint", true)
    else
        toggleControl("sprint", state)
    end
    toggleControl("crouch", state)
    toggleControl("enter_exit", state)
    toggleControl("fire", false)
    toggleControl("aim", false)
    toggleControl("jump", state)
end

function pickPack(el)
    if el ~= localPlayer then return end
    if data.block then 
        return 
    end
    data.block = true
    toggleControl("forwards", false)
    toggleControl("backwards", false)
    toggleControl("left", false)
    toggleControl("right", false)
    setElementFrozen(localPlayer, true)
    triggerServerEvent('magasin.s', resourceRoot, 'pick')
end

function putPack(el)
    if el ~= localPlayer then return end
    if data.block then 
        return 
    end
    data.block = true
    toggleControl("forwards", false)
    toggleControl("backwards", false)
    toggleControl("left", false)
    toggleControl("right", false)
    setElementFrozen(localPlayer, true)
    triggerServerEvent('magasin.s', resourceRoot, 'put')
end

function finishCourse()
    local money = data.moneyForPack + math.random(-math.floor(data.moneyForPack/10),math.floor(data.moneyForPack/10))
    money = money * exports["since-jobs"]:getJobMultiplier('magazynier')

    for i = 0, exports["since-jobs"]:getPlayerUpgradeLevel("magazynier", 'Money') do
        money = money * (1.1)
    end

    if getElementData(localPlayer, 'player:diamond') then
        money = money * (1.5)
    end

    local voucher = exports['since-vouchers']:getJobVoucher('magazynier')/100
    money = money + math.floor(money * voucher)

    money = math.floor(money)

    local srp = math.random(2,4) * exports["since-jobs"]:getJobMultiplier('magazynier')

    triggerServerEvent("giveMoneyMagasin", resourceRoot, money, srp)

    exports["since-jobs"]:addPlayerJobEarned("magazynier", money)

    local rnd = math.random(1, 10)
    if rnd > 5 then
        exports["since-jobs"]:addPlayerJobPoints("magazynier", 1)
    end

    exports['since-notifications']:sendNotification('success', 'Otrzymujesz '..formatNumber(money)..' $ za odstawioną paczkę.')
end

function renderLine()
    if data.markers['pick'] and isElement(data.markers['pick']) or data.markers['put'] and isElement(data.markers['put']) then
        local x, y, z = getElementPosition(data.markers['pick'] and isElement(data.markers['pick']) and data.markers['pick'] or data.markers['put'] and isElement(data.markers['put']) and data.markers['put'])
        z = z + 0.04
        local px, py, pz = getElementPosition(localPlayer)
        pz = pz - 0.95
        local dist = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
        for i = 1, dist, 2 do
            local alpha = interpolateBetween(0, 0, 0, 1, 0, 0, (getTickCount()%3000)/3000, "CosineCurve")
            local prg1 = i/dist
            local prg2 = math.min((i+1)/dist, 1)
            dxDrawLine3D(px+(x-px)*prg1, py+(y-py)*prg1, pz+(z-pz)*prg1, px+(x-px)*prg2, py+(y-py)*prg2, pz+(z-pz)*prg2, tocolor(46, 117, 111, 55+100*alpha), 5)
        end
    end
    if not isElementWithinColShape(localPlayer, data.shape) then
        triggerEvent('onJobFinish', resourceRoot, 'magazynier')
        removeEventHandler('onClientRender', root, renderLine)
    end
end

function createPoint(state)
    if state == 'pick' then
        if data.markers['pick'] then
            return 
        end
        local rnd = math.random(#poses[1])
        local x,y,z = unpack(poses[1][rnd])
        local marker = createMarker(x,y,z-0.95, 'cylinder', 1.5, 125, 255, 125,55)
        setElementInterior(marker, 14)
        setElementData(marker, "marker:title", "Magazyn")
        setElementData(marker, "marker:desc", "Odbiór paczki")
        setElementData(marker, "marker:icon", "pack")
        addEventHandler('onClientMarkerHit', marker, pickPack)
        data.markers['pick'] = marker

    elseif state == 'put' then
        if data.markers['put'] then 
            return 
        end
        local rnd = math.random(#poses[2])
        local x,y,z = unpack(poses[2][rnd])
        local marker = createMarker(x,y,z-0.95, 'cylinder', 1.5, 125, 255, 125,55)
        setElementInterior(marker, 14)
        setElementData(marker, "marker:title", "Magazyn")
        setElementData(marker, "marker:desc", "Wyznaczone miejsce paczki")
        setElementData(marker, "marker:icon", "pack")
        addEventHandler('onClientMarkerHit', marker, putPack)
        data.markers['put'] = marker

    end
end

function destroyPoint(state)
    if state == 'pick' then
        if data.markers['pick'] then
            if isElement(data.markers['pick']) then
                destroyElement(data.markers['pick'])
            end
            data.markers['pick'] = nil
        end
    elseif state == 'put' then
        if data.markers['put'] then
            if isElement(data.markers['put']) then
                destroyElement(data.markers['put'])
            end
            data.markers['put'] = nil
        end
    end
end

addEvent('magasin.c', true)
addEventHandler('magasin.c', resourceRoot, function(state)
    if state == 'picked' then
        toggleControls(false)
        setElementFrozen(localPlayer, false)
        destroyPoint('pick')
        data.holding = true
        data.block = nil
        createPoint('put')
        toggleControl("forwards", true)
        toggleControl("backwards", true)
        toggleControl("left", true)
        toggleControl("right", true)

    elseif state == 'putted' then
        destroyPoint('put')
        toggleControls(false)
        toggleControl("sprint", true)
        setElementFrozen(localPlayer, false)
        data.holding = nil
        data.block = nil
        createPoint('pick')
        toggleControl("forwards", true)
        toggleControl("backwards", true)
        toggleControl("left", true)
        toggleControl("right", true)

        finishCourse()

        exports['since-dailyQuests']:addProgress(localPlayer, 1, 1)

    elseif state == 'unfreeze' then
        setElementFrozen(localPlayer, false)

    end
end)

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if job == 'magazynier' then
        if getElementData(localPlayer, 'player:job') then 
            return
        end
        data.markers = {}
        data.holding = nil
        data.block = nil
        data.timer = setTimer(function()
            exports["since-jobs"]:addPlayerJobTime('magazynier', 1)
        end, 60000, 0)
        
        toggleControls(false)
        toggleControl("sprint", true)

        createPoint('pick')

        if not isEventHandlerAdded('onClientRender', root, renderLine) then
            addEventHandler('onClientRender', root, renderLine)
        end

        setElementData(localPlayer, 'player:job', job)
        exports['since-notifications']:sendNotification('success', 'Rozpoczęto prace')
    end
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if job == 'magazynier' then
        if getElementData(localPlayer, 'player:job') ~= 'magazynier' then
            return
        end
        destroyPoint('pick')
        destroyPoint('put')
        data.markers = nil
        data.holding = nil
        data.block = nil
        if data.timer then
            if isTimer(data.timer) then
                killTimer(data.timer)
            end
            data.timer = nil
        end

        if isEventHandlerAdded('onClientRender', root, renderLine) then
            removeEventHandler('onClientRender', root, renderLine)
        end

        triggerServerEvent('magasin.s', resourceRoot, 'destroy')
        toggleControls(true)
        setElementData(localPlayer, 'player:job', nil)
        exports['since-notifications']:sendNotification('success', 'Zakończono prace')
    end
end)

local marker = createMarker(-1910.80, 8.00, 1042.18-0.95, 'cylinder', 2, 125, 255, 125, 50)
setElementData(marker, 'marker:title', 'Magazynier')
setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
setElementData(marker, 'marker:icon', 'skin')
setElementInterior(marker, 14)
addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    exports["since-jobs"]:showJobGui("magazynier", source)
end)

toggleAllControls(true)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'magazynier' then
        setElementData(localPlayer, 'player:job', nil)
        exports['since-notifications']:sendNotification('success', 'Praca magazyniera została przeładowania. Praca została zakończona.')
        toggleControl("sprint", true)
        toggleControl("crouch", true)
        toggleControl("enter_exit", true)
        toggleControl("jump", true)
        toggleControl("forwards", true)
        toggleControl("backwards", true)
        toggleControl("left", true)
        toggleControl("right", true)
    end
end)

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

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
getResourceName(getThisResource(), true, 624734734); if true then return end
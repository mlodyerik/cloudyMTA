local data = {

    jobTimer = nil,
    targetMarker = nil,
    currentMarker = 0,
    moneyForPoint = {1500, 3450}

}

local marker = createMarker(1751.18, -1943.94, 13.57-0.95, 'cylinder', 2, 125, 255, 125, 50)
setElementData(marker, 'marker:title', 'Maszynista (AFK)')
setElementData(marker, 'marker:desc', 'Rozpoczęcie pracy')
setElementData(marker, 'marker:icon', 'skin')

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    exports["since-jobs"]:showJobGui("maszynista", source)
end)

function createNewMarker()
    if isElement(data.targetMarker) then
        destroyElement(data.targetMarker)
    end

    data.currentMarker = data.currentMarker + 1

    if data.currentMarker > #positions then
        data.currentMarker = 1
    end

    local x, y, z = positions[data.currentMarker][1], positions[data.currentMarker][2], positions[data.currentMarker][3]
    data.targetMarker = createMarker(x, y, z, 'checkpoint', 10, 125, 255, 125, 50)
    setElementData(data.targetMarker, 'marker:target', 'maszynista')
end

addEventHandler('onClientMarkerHit', root, function(plr)
    if plr ~= localPlayer then
        return 
    end

    if source == data.targetMarker then
        createNewMarker()

        local money = math.random(data.moneyForPoint[1], data.moneyForPoint[2]) * exports["since-jobs"]:getJobMultiplier('maszynista')

        if getElementData(localPlayer, 'player:diamond') then
            money = money * (1.5)
        end

        for i = 0, exports["since-jobs"]:getPlayerUpgradeLevel("maszynista", 'Money') do
            money = money * (1.1)
        end
        
        local voucher = exports['since-vouchers']:getJobVoucher('maszynista')/100
        money = money + math.floor(money * voucher)

        money = math.floor(money)

        if exports["since-jobs"]:getPlayerUpgradeLevel("maszynista", 'Reputacja') == 1 then
            local random = math.random(1, 10)

            if random == 5 or random == 9 or random == 1 then
                triggerServerEvent('givePlayerMoney', resourceRoot, money, math.random(1,3))
            else
                triggerServerEvent('givePlayerMoney', resourceRoot, money)
            end
        else
            triggerServerEvent('givePlayerMoney', resourceRoot, money)
        end

        exports["since-jobs"]:addPlayerJobPoints('maszynista', 1)
        exports["since-jobs"]:addPlayerJobEarned("maszynista", money)
        exports['since-dailyQuests']:addProgress(localPlayer, 1, 3)
    end
end)

function setTrainSpeedLimit()
	local train = getPedOccupiedVehicle(localPlayer)
	if train and getElementData(train, 'vehicle:job') == 'maszynista' then
        local speed = (exports["since-jobs"]:getPlayerUpgradeLevel("maszynista", 'Power') == 1) and -0.85 or -0.45
		setTrainSpeed(train, speed)
        toggleControl('accelerate', false)
        toggleControl('brake_reverse', false)
        toggleControl('handbrake', false)
	end
end

addEvent('onJobStart', true)
addEventHandler('onJobStart', root, function(job)
    if job == 'maszynista' then
        if getElementData(localPlayer, 'player:job') then 
            return
        end
        data.jobTimer = setTimer(function()
            exports["since-jobs"]:addPlayerJobTime('maszynista', 1)
        end, 60000, 0)

        setElementData(localPlayer, 'player:job', job)
        createNewMarker()

        addEventHandler('onClientRender', root, setTrainSpeedLimit)

        triggerServerEvent('onStartMaszynista', resourceRoot, (exports["since-jobs"]:getPlayerUpgradeLevel("maszynista", 'Power') == 1) and -0.85 or -0.45)
    end
end)

addEvent('onJobFinish', true)
addEventHandler('onJobFinish', root, function(job)
    if job == 'maszynista' then
        if getElementData(localPlayer, 'player:job') ~= 'maszynista' then 
            return
        end

        if isTimer(data.jobTimer) then
            killTimer(data.jobTimer)
            data.jobTimer = nil
        end

        if isElement(data.targetMarker) then
            destroyElement(data.targetMarker)
        end

        data.currentMarker = 0

        setElementData(localPlayer, 'player:job', nil)
        toggleAllControls(true)

        triggerServerEvent('onFinishMaszynista', resourceRoot)
        removeEventHandler('onClientRender', root, setTrainSpeedLimit)

        exports['since-notifications']:sendNotification('success', 'Zakończono prace')
    end
end)

addEventHandler('onClientResourceStop', resourceRoot, function()
    if getElementData(localPlayer, 'player:job') == 'maszynista' then
        setElementData(localPlayer, 'player:job', nil)
        exports['since-notifications']:sendNotification('info', 'Praca maszynisty została zrestartowana, rozpocznij ją ponownie.')
    end
end)
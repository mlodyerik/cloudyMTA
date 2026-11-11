local data = {
    fonts = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom),
    },
    images = {
        [1] = dxCreateTexture('files/images/bar.png', 'argb', true, 'clamp'),
        [2] = dxCreateTexture('files/images/arrow.png', 'argb', true, 'clamp'),
    },
    tick = getTickCount(),
    timers = {},
}

local function render()
    if data.state then
        if getKeyState('mouse1') == true or getKeyState('space') == true then 
            data.barPos = math.min(data.barPos+(math.random(10,20)/10), 300)
        else
            data.barPos = math.max(data.barPos-2, -300)
        end
    end
    dxDrawImage(sx/2-302/zoom, sy-80/zoom, 604/zoom, 29/zoom, data.images[1], 180, 0, 0, tocolor(255, 255, 255, data.alpha), false)
    dxDrawImage(sx/2-13/zoom+data.barPos/zoom, sy-65/zoom, 26/zoom, 26/zoom, data.images[2], 0, 0, 0, tocolor(255, 255, 255, data.alpha), false)
    if data.boost then
        dxDrawText('Boost łodzi',sx/2,sy-145/zoom, _, _, tocolor(125,255,125,data.alpha), 1, data.fonts[1], 'center', 'bottom', false,false,false,false,false)
    end
    dxDrawText('Połów ryb',sx/2,sy-120/zoom, _, _, tocolor(255,255,255,data.alpha), 1, data.fonts[1], 'center', 'bottom', false,false,false,false,false)
    dxDrawText('Utrzymaj strzałkę na zielonej strefie klikaj lewy przycisk myszy lub spację',sx/2,sy-115/zoom, _, _, tocolor(255,255,255,data.alpha), 1, data.fonts[2], 'center', 'top', false,false,false,false,false)

    if (data.barPos <= -300) or (data.barPos >= 300) then
        failFishing()
    end
end

function isAllowedToVehicle(plr, veh)
    if getElementData(veh, 'vehicle:id') then
        local sid = getElementData(plr, 'player:sid')
        local rent = getElementData(veh, 'vehicle:rent') or {}
        if getElementData(veh, 'vehicle:owner') == sid or findintable(rent, sid) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function isPlayerAllowedOnVehicle(veh)
    local x,y,z = getElementPosition(veh)
    local info = false
    for i,v in ipairs(getElementsWithinRange(x,y,z,15,'player')) do
        if getPedContactElement(v) == veh and isAllowedToVehicle(v, veh) then
            info = true
            break
        end
    end
    return info
end

function findintable(tbl, value)
    for i,v in ipairs(tbl) do 
        if v == value then 
            return true
        end 
    end
    return false
end

function tryFishing()
    if exports['since-inventory']:isInventoryVisible() then
        return
    end

	if (getPlayerWeapon(localPlayer,1)==7) and (getPedWeaponSlot(localPlayer)==1) and (not getPedOccupiedVehicle(localPlayer)) and (not isElementInWater(localPlayer)) and (getTickCount()-data.tick>0) then
        data.onBoat = nil
        data.boost = nil
        local x,y,z = getElementPosition(localPlayer)
        local isOn = getPedContactElement(localPlayer)
        if isOn and getElementType(isOn) == 'vehicle' and getVehicleType(isOn) == 'Boat' then
            data.onBoat = true
            data.boost = isPlayerAllowedOnVehicle(isOn)
        end
        local canFishing = nil
        if data.onBoat then
            if testLineAgainstWater(x,y,z+15,x,y,z-15) then
                canFishing = true
            end
        elseif testLineAgainstWater(x,y,z+5,x,y,z-5) then
            if isPedOnGround(localPlayer) then
                canFishing = true
            end
        end 
        if canFishing then
            data.tick = getTickCount() + 10000
            data.barPos = 0
            setElementData(localPlayer, 'player:fishing', true)
            triggerServerEvent('fish.s', resourceRoot, 'start')
            if (not isEventHandlerAdded('onClientRender', root, render)) then
                addEventHandler('onClientRender', root, render)
            end
            animate(0, 255, 'InOutQuad', 500, function(value) 
                data.alpha = value 
            end, function()
                setTimer(function()
                    data.state = true
                    data.timers[1] = (setTimer(function()
                        data.state = false
                        animate(255, 0, 'InOutQuad', 500, function(value) 
                            data.alpha = value 
                        end, function()
                            data.timers[2] = (setTimer(function()
                                finishFishing((data.barPos > -170 and data.barPos < 170) and true or false)
                                data.tick = getTickCount() + 1000
                                removeEventHandler('onClientRender', root, render)
                                setElementData(localPlayer, 'player:fishing', false)
                                triggerServerEvent('fish.s', resourceRoot, 'stop')
                            end, 50, 1))
                        end)
                    end, math.random(5000, 8000), 1))
                end, 50, 1)
            end)
        else
            exports['since-notifications']:sendNotification('error', 'Jesteś za daleko wody!')
         end
    end
end

setElementData(localPlayer, 'player:fishing', false)

data.blockFail = nil
function failFishing()
    if isEventHandlerAdded('onClientRender', root, render) and (not data.blockFail) then
        exports['since-notifications']:sendNotification('error', 'Zerwałeś żyłkę!')
        data.blockFail = true
        data.state = nil
        animate(255, 0, 'InOutQuad', 500, function(value) 
            data.alpha = value 
        end, function()
            removeEventHandler('onClientRender', root, render)
            data.blockFail = nil
            for i,v in ipairs(data.timers) do
                if isTimer(v) then killTimer(v) end
            end
            data.tick = getTickCount() + 1500
            triggerServerEvent('fish.s', resourceRoot, 'stop')
            setElementData(localPlayer, 'player:fishing', false)
        end)
    end
end

function firstLetterBig(string)
    return string:gsub("^%l", string.upper)
end

function finishFishing(state)
    if state then
        local rnd = math.random(1,100)    
        local info = { name = 'karp', count = 1 }
        if (rnd > 0 and rnd <= 38) then
            info.name = 'makrela'
            info.count = math.random(drop['makrela'][1], drop['makrela'][2])
        elseif (rnd > 38 and rnd <= 58)  then
            info.name = 'dorsz' 
            info.count = math.random(drop['dorsz'][1], drop['dorsz'][2])
        elseif (rnd > 58 and rnd <= 74) then
            info.name = 'szczupak' 
            info.count = math.random(drop['szczupak'][1], drop['szczupak'][2])
        elseif (rnd > 74 and rnd <= 90) then
            info.name = 'karp'
            info.count = math.random(drop['karp'][1], drop['karp'][2])
        elseif (rnd > 90 and rnd <= 100) then
            info.name = 'rekin'
            info.count = math.random(drop['rekin'][1], drop['rekin'][2])
        end

        if data.boost then
            info.count = info.count * 1.5
        end

        local class = nil

        local usedItems = getElementData(localPlayer, "usedItems") or {}
        for k,v in pairs(usedItems) do
            if v.name == 'wedka' then
                class = v.class
                break
            end
        end

        if class == 'gray' then
            info.count = info.count
        elseif class == 'normal' then
            info.count = info.count * 1.25
        elseif class == 'rare' then
            info.count = info.count * 1.5
        elseif class == 'legendary' then
            info.count = info.count * 1.75
        elseif class == 'epic' then
            info.count = info.count * 2
        elseif class == 'unique' then
            info.count = info.count * 2.25
        end

        local voucher = exports['since-vouchers']:getJobVoucher('rybak')/100
        info.count = info.count + math.floor(info.count * voucher)    

        info.count = info.count * exports['since-jobs']:getJobMultiplier('rybak')
        
        info.count = math.floor(info.count)

        local levelWedki = info.count/40

        exports['since-levelewedek']:addPlayerFisherLevel(levelWedki)
        triggerServerEvent('fish.s', resourceRoot, 'collect', info)
        exports['since-notifications']:sendNotification('success', 'Złowiłeś '..info.count..' kg ryby '..firstLetterBig(info.name)..'. EXP wędki wzrasta o '..string.format("%.2f", levelWedki)..'.')

        exports['since-dailyQuests']:addProgress(localPlayer, info.count, 6)
    end
end

function switchWeapon(old, new)
    if new == 1 and getPedWeapon(localPlayer, new) == 7 then 
        if data.binded then
            return
        end
        bindKey('mouse1', 'down', tryFishing)
        data.binded = true
    elseif old == 1 then
        if not data.binded then
            return
        end
        unbindKey('mouse1', 'down', tryFishing)
        data.binded = nil
    end
end
addEventHandler('onClientPlayerWeaponSwitch', localPlayer, switchWeapon)

function start()
    if (getPlayerWeapon(localPlayer,1)==7) and (getPedWeaponSlot(localPlayer)==1) then
        if data.binded then
            return
        end
        bindKey('mouse1', 'down', tryFishing)
        data.binded = true
    end
end
start()

addEventHandler('onClientPedDamage', resourceRoot, function() cancelEvent() end)
getResourceName(getThisResource(), true, 184705027); if true then return end
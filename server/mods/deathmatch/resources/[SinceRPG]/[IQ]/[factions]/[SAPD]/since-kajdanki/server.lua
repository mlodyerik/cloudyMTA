function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix ( element ) 
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1] 
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z 
end

local timers = {}

function zlap(plr, cmd, targ)
    if getElementData(plr, "player:faction") == "SAPD" then
        if not targ then
            return false
        end

        if isPedInVehicle(plr) then
            return false
        end

        local target = exports["since-core"]:findPlayer(plr, targ)

        if not target then
            outputChatBox("#ff0000✘ #ffffffNie znaleziono podanego gracza!", plr, _, _, _, true)
            return false
        end

        if target == plr then
            outputChatBox("#ff0000✘ #ffffffNie możesz złapać samego siebie!", plr, _, _, _, true)
            return false
        end

        local x, y, z = getElementPosition(plr)
        local x2, y2, z2 = getElementPosition(target)
        local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

        if distance > 5 then
            outputChatBox("#ff0000✘ #ffffffPodany gracz jest za daleko!", plr, _, _, _, true)
            return false
        end

        if getElementData(plr, "handcuff:target") then
            outputChatBox("#ff0000✘ #ffffffNie możesz złapać 2 graczy na raz!", plr, _, _, _, true)
            return false
        end

        if getElementData(target, "handcuff:have") then
            outputChatBox("#ff0000✘ #ffffffGracz jest już złapany przez innego gracza!", plr, _, _, _, true)
            return false
        end

        if isPedInVehicle(target) then
            removePedFromVehicle(target)
        end

        toggleControl(plr, "jump", false)
        toggleAllControls(target, false, true, false)
        toggleControl(target, "enter_exit", false)
        toggleControl(target, "enter_passenger", false)
		setPedAnimation(plr, "CHAINSAW", "csaw_part",  0, false, true, true)
        setPedAnimation(target, "FAT","IDLE_tired", -1, true, false)
        attachElements(target, plr, 0, 0.4, 0.0)

        outputChatBox('ⓘ#ffffff Zostałeś(aś) złapany przez policjanta #cccccc'..getPlayerName(plr), target, 255, 255, 0, true)
        outputChatBox('ⓘ#ffffff Złapałeś(aś) gracza #cccccc'..getPlayerName(target), plr, 255, 255, 0, true)

        setElementData(plr, "handcuff:target", target)
        setElementData(target, "handcuff:have", plr)

        local rX, rY, rZ = getElementRotation(plr)
        setElementRotation(target, rX, rY, rZ)
        
        timers[target] = setTimer(function(player, player2)
            if isElement(player) and isElement(player2) then
                local rX, rY, rZ = getElementRotation(player)
                setElementRotation(player2, rX, rY, rZ)
            end
        end, 100, 0, plr, target)
        triggerClientEvent(target, "enonek-bank_robbery:allEND", target)
    end
end
addCommandHandler("zlap", zlap)

function pusc(plr, cmd, targ)
    if getElementData(plr, "player:faction") == "SAPD" then
        if not targ then
            return false
        end

        local target = exports["since-core"]:findPlayer(plr, targ)

        if not target then
            outputChatBox("#ff0000✘ #ffffffNie znaleziono podanego gracza!", plr, _, _, _, true)
            return false
        end

        if target == plr then
            return false
        end

        local x, y, z = getElementPosition(plr)
        local x2, y2, z2 = getElementPosition(target)
        local distance = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

        if distance > 5 then
            outputChatBox("#ff0000✘ #ffffffPodany gracz jest za daleko!", plr, _, _, _, true)
            return false
        end

        if not getElementData(target, "handcuff:have") then
            outputChatBox("#ff0000✘ #ffffffPodany gracz nie jest złapany!", plr, _, _, _, true)
            return false
        end

        toggleControl(plr, "jump", true)
        toggleAllControls(target, true, true, false)
        toggleControl(target, "enter_exit", true)
        toggleControl(target, "enter_passenger", true)

        removeElementData(plr, "handcuff:target")
        removeElementData(target, "handcuff:have")

        outputChatBox('ⓘ#ffffff Zostałeś(aś) rozkuty przez policjanta #cccccc'..getPlayerName(plr), target, 255, 255, 0, true)
        outputChatBox('ⓘ#ffffff Rozkułeś(aś) gracza #cccccc'..getPlayerName(target), plr, 255, 255, 0, true)

        detachElements(target, plr)

        local x, y, z = getPositionFromElementOffset(plr, 0, 0.5, 0)
        setElementPosition(target, x, y, z)

        setPedAnimation(plr)
        setPedAnimation(target)

        if isTimer(timers[target]) then
            killTimer(timers[target])
        end
        timers[target] = nil
    end
end
addCommandHandler("pusc", pusc)

addEventHandler("onVehicleStartEnter", getRootElement(), function(plr, seat)
    if getElementData(plr, "player:faction") == "SAPD" then
        if getElementData(plr, "handcuff:target") then
            if seat == 0 then
                cancelEvent()
                return false
            end
            local target = getElementData(plr, "handcuff:target")
            if isElement(target) then
                detachElements(target, plr)

                setPedAnimation(target)
                setPedAnimation(plr)

                local x, y, z = getPositionFromElementOffset(plr, 0, 0.5, 2)
                setElementPosition(target, x, y, z)
                cancelEvent()
                toggleControl(plr, "jump", true)

                if isTimer(timers[target]) then
                    killTimer(timers[target])
                end
                timers[target] = nil
                removeElementData(plr, "handcuff:target")                
                setTimer(function(player, v, s)
                    warpPedIntoVehicle(player, v, s)
                    removeElementData(player, "handcuff:have")
                end, 500, 1, target, source, seat)
            end
        end
    end
end)

addEventHandler("onPlayerQuit", root, function()
    if getElementData(source, "handcuff:have") then
        local plr = getElementData(source, "handcuff:have")
        if isElement(plr) then
            removeElementData(plr, "handcuff:target")
            toggleControl(plr, "jump", true)
            setTimer(setPedAnimation, 100, 1, plr, false)
        end

        if isTimer(timers[source]) then
            killTimer(timers[source])
        end
        timers[source] = nil
    end

    if getElementData(source, "handcuff:target") then
        local target = getElementData(source, "handcuff:target")
        if isElement(target) then
            detachElements(target, source)
            removeElementData(target, "handcuff:have")
            toggleAllControls(target, true, true, false)
            toggleControl(target, "enter_exit", true)
            toggleControl(target, "enter_passenger", true)
            setTimer(setPedAnimation, 100, 1, target, false)
            if isTimer(timers[target]) then
                killTimer(timers[target])
            end
            timers[target] = nil
        end
    end
end)
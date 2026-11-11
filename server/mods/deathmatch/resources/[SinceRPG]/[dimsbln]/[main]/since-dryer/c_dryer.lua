local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9
local fonts = exports['since-fonts']
local cache = {

    selectedItem = 1,
    selectedTarget = nil,
    options = {

        ['vehicle'] = {

            "Obróć pojazd",
            "Napraw pojazd",
            "Przenieś pojazd do siebie",
            "Schowaj do przechowalni",
            "Zatankuj pojazd",
            "Otwórz pojazd",
            "Wyłącz stereo",
            "Zdejmij blokade",
            "Usuń pojazd",


        },

        ['player'] = {

            "Ulecz gracza",
            "Przenieś do siebie",
            "Przenieś do gracza",
            "Odmroź gracza",

        },

    }

}

function isPedAiming(element)
	if isElement(element) then
		if getElementType(element) == "player" or getElementType(element) == "ped" then
			if getPedTask(element, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end

	return false
end

function getPlayerRank(player)
    if isElement(player) then
        return getElementData(player, 'player:rank') or 'Brak'
    end
end


addEventHandler('onClientPreRender', root, function()
    if getPedWeapon(localPlayer) == 22 and getElementData(localPlayer, 'player:admin') and isPedAiming(localPlayer) then
        local target = getPedTarget(localPlayer)

        if target and target ~= localPlayer then
            cache.selectedTarget = target

            if getElementType(target) ~= getElementType(cache.selectedTarget) then
                cache.selectedItem = 1
            end

            if getElementType(target) == 'vehicle' then
                dxDrawText(exports['since-vehiclenames']:getVehicleName(getElementData(target, 'vehicle:model') or getElementModel(target)), sx - 15/zoom + 1, sy - 225/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')
                dxDrawText(exports['since-vehiclenames']:getVehicleName(getElementData(target, 'vehicle:model') or getElementModel(target)), sx - 15/zoom, sy - 225/zoom, nil, nil, tocolor(255, 255, 255), 1, fonts:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')
                local option = cache.options[getElementType(target)][cache.selectedItem]
                dxDrawText(option, sx - 15/zoom + 1, sy - 225/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top')
                dxDrawText(option, sx - 15/zoom, sy - 225/zoom, nil, nil, tocolor(125, 255, 125), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top')

                local info = {

                    model = getElementData(target, 'vehicle:model') or getElementModel(target),
                    plate = getVehiclePlateText(target),
                    data = getElementData(target, 'vehicle:data') or {},
                    fuel = getElementData(target, 'vehicle:fuel') or {},
                    health = getElementHealth(target),
                    owner = getElementData(target, 'vehicle:owner') or {},
                    

                }

                dxDrawText('Informacje o pojeździe', sx - 15/zoom + 1, sy - 165/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')
                dxDrawText('Informacje o pojeździe', sx - 15/zoom, sy - 165/zoom, nil, nil, tocolor(255, 255, 255), 1, fonts:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')

                local tankCount = string.format("%.2f", info.fuel.count or 100)
                if getElementData(target, 'vehicle:id') then
                    local text = 'ID: #7dff7d'..(getElementData(target, 'vehicle:id') or '0')..'#ffffff\nModel: #7dff7d'..info.model..'#ffffff\nTablica: #7dff7d'..info.plate..'#ffffff\nUID właściciela: #7dff7d'..info.owner..'#ffffff\nOstatni kierowca: #7dff7d'..(info.data.driver or 'Brak')..'#ffffff\nStan: #7dff7d'..math.floor(info.health/10)..'%#ffffff\nPaliwo: #7dff7d'..tankCount..'L / '..(info.fuel.tank or 25)..'L'
                    dxDrawText(text:gsub('#%x%x%x%x%x%x', ''), sx - 15/zoom + 1, sy - 165/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
                    dxDrawText(text, sx - 15/zoom, sy - 165/zoom, nil, nil, tocolor(255, 255, 255), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
                else
                    local text = 'Brak informacji o pojeździe\n Pojazd respiony'
                    dxDrawText(text:gsub('#%x%x%x%x%x%x', ''), sx - 15/zoom + 1, sy - 165/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
                    dxDrawText(text, sx - 15/zoom, sy - 165/zoom, nil, nil, tocolor(255, 255, 255), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
                end
        
                
            elseif getElementType(target) == 'player' then
                dxDrawText(getPlayerName(target), sx - 15/zoom + 1, sy - 225/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')
                dxDrawText(getPlayerName(target), sx - 15/zoom, sy - 225/zoom, nil, nil, tocolor(255, 255, 255), 1, fonts:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')
                local option = cache.options[getElementType(target)][cache.selectedItem] or 'Brak'
                dxDrawText(option, sx - 15/zoom + 1, sy - 225/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top')
                dxDrawText(option, sx - 15/zoom, sy - 225/zoom, nil, nil, tocolor(125, 255, 125), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top')

                local info = {

                    health = getElementHealth(target),
                    pp = getElementData(target, 'player:pp') or 0,
                    rank = exports['since-core']:getRankName(getElementData(target, 'player:admin'), getElementData(target, 'player:diamond')),
                    

                }

                dxDrawText('Informacje o graczu', sx - 15/zoom + 1, sy - 165/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')
                dxDrawText('Informacje o graczu', sx - 15/zoom, sy - 165/zoom, nil, nil, tocolor(255, 255, 255), 1, fonts:getFont('Inter-Bold', 15/zoom), 'right', 'bottom')

                local text = 'ID: #7dff7d'..(getElementData(target, 'id') or '0')..'#ffffff\nZdrowie: #7dff7d'..math.floor(info.health)..'%#ffffff\nPunkty premium: #7dff7d'..info.pp..' PP#ffffff\nRanga: #7dff7d'..info.rank
                dxDrawText(text:gsub('#%x%x%x%x%x%x', ''), sx - 15/zoom + 1, sy - 165/zoom + 1, nil, nil, tocolor(0, 0, 0, 155), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
                dxDrawText(text, sx - 15/zoom, sy - 165/zoom, nil, nil, tocolor(255, 255, 255), 1, fonts:getFont('Inter-Regular', 12/zoom), 'right', 'top', false, false, false, true)
            end
        else
            cache.selectedTarget = nil
        end
    end
end)

addEventHandler('onClientKey', root, function(button, press)
	if (button == 'mouse_wheel_up' or button == 'mouse_wheel_down' or button == 'mouse1') and press and isPedAiming(localPlayer) and getElementData(localPlayer, 'player:admin') and getPedWeapon(localPlayer) == 22 then
        if button == 'mouse_wheel_up' and cache.selectedTarget then
            local type = getElementType(cache.selectedTarget)

            if cache.selectedItem > 1 then
                cache.selectedItem = cache.selectedItem - 1
            else
                cache.selectedItem = #cache.options[type]
            end
        elseif button == 'mouse_wheel_down' and cache.selectedTarget then
            local type = getElementType(cache.selectedTarget)

			if cache.selectedItem < (#cache.options[type] or 1) then
				cache.selectedItem = cache.selectedItem + 1
			else
				cache.selectedItem = 1
			end
        elseif button == 'mouse1' and cache.selectedTarget then
            local type = getElementType(cache.selectedTarget)
            local action = cache.options[type][cache.selectedItem]

            if action and type then
                triggerServerEvent('onDryerAction', resourceRoot, type, cache.selectedItem, cache.selectedTarget)
            end
        end
    end
end)
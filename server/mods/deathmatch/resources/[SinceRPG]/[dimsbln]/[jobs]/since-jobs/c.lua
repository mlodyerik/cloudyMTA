local currentJob, block, pageChanger, countDown, savedJob = nil, nil, nil, getTickCount(), nil

function render()
	local job = jobs[currentJob]
	if not job then 
		if not block then 
			turnPanel(false) 
		end 
		return 
	end
	local anim, anim2 = (pageChanger and 255 or main['anim'][1]), main['anim'][1]

	exports['since-blur']:dxDrawBlur(sx/2-320/zoom, sy/2-185/zoom, 640/zoom, 370/zoom, main['textures']['bg_mask'], anim)
	dxDrawImage(sx/2-320/zoom, sy/2-185/zoom, 640/zoom, 370/zoom, main['textures']['bg'], 0,0,0, tocolor(255,255,255,anim))

    dxDrawText('Praca dorywcza', sx/2-305/zoom, sy/2-175/zoom, _, _, tocolor(255,255,255,anim), 1, main['fonts'][1], 'left', 'top')
	local x,y,z = getElementPosition(localPlayer)
	local zone = getElementData(localPlayer, 'interior:location')

	if zone then
		dxDrawText(zone.name, sx/2-305/zoom, sy/2-135/zoom, _, _, tocolor(125,255,125,anim), 0.9, main['fonts'][2], 'left', 'bottom')
	else
		dxDrawText(getZoneName(x,y,z,true)..', '..getZoneName(x,y,z), sx/2-305/zoom, sy/2-135/zoom, _, _, tocolor(125,255,125,anim), 0.9, main['fonts'][2], 'left', 'bottom')
	end

	local isIn = isMouseIn(sx/2 + 283/zoom, sy/2 - 168/zoom, 24/zoom, 24/zoom)
	main['anim'][2] = interpolateBetween(main['anim'][2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2 + 285/zoom, sy/2 - 166/zoom, 20/zoom, 20/zoom, main['textures']['close'], 0,0,0, tocolor(255,255,255,anim*main['anim'][2]))

	if main['page'] > 0 then
		local isIn = isMouseIn(sx/2 + 253/zoom, sy/2 - 168/zoom, 24/zoom, 24/zoom)
		main['anim'][3] = interpolateBetween(main['anim'][3], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
		dxDrawImage(sx/2 + 254/zoom, sy/2 - 167/zoom, 22/zoom, 22/zoom, main['textures']['arrow'], 0,0,0, tocolor(255,255,255,anim2*main['anim'][3]))
	end

	dxDrawImage(sx/2 - 306/zoom, sy/2 - 115/zoom, 22/zoom, 22/zoom, main['textures']['icon_2'], 0,0,0, tocolor(255,255,255,anim))
	dxDrawText(job.name, sx/2 - 278/zoom, sy/2 - 104/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][3], 'left', 'center')
	if main['textures'][job.img..'/image'] then
    	dxDrawImage(sx/2 - 306/zoom, sy/2 - 80/zoom, 200/zoom, 120/zoom, main['textures'][job.img..'/image'], 0,0,0, tocolor(255,255,255,anim))
	end

	dxDrawImage(sx/2 - 306/zoom, sy/2 + 59/zoom, 22/zoom, 22/zoom, main['textures']['icon_1'], 0,0,0, tocolor(255,255,255,anim))
    dxDrawText('Opis pracy', sx/2 - 278/zoom, sy/2 + 70/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][3], 'left', 'center')
    dxDrawText(job.description, sx/2 - 307/zoom, sy/2 + 84/zoom, sx/2 - 107/zoom, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][4], 'left', 'top', false, true)

	if main['page'] == 0 then

		dxDrawImage(sx/2 - 67/zoom, sy/2 - 114/zoom, 22/zoom, 22/zoom, main['textures']['icon_3'], 0,0,0, tocolor(255,255,255,anim2))
		dxDrawText('Statystyki', sx/2 - 38/zoom, sy/2 - 103/zoom, nil, nil, tocolor(255, 255, 255, anim2), 1, main['fonts'][3], 'left', 'center')

		dxDrawImage(sx/2 - 69/zoom, sy/2 - 80/zoom, 18/zoom, 18/zoom, main['textures']['icon_5'], 0,0,0, tocolor(255,255,255,anim2))
		dxDrawText('Punkty ulepszeń: #82ff77'..formatNumber(savedJob.points)..' pkt.', sx/2-43/zoom, sy/2-71/zoom, nil, nil, tocolor(255, 255, 255, anim2), 1, main['fonts'][5], 'left', 'center', false,false,false,true)

		dxDrawImage(sx/2 - 69/zoom, sy/2 - 55/zoom, 18/zoom, 18/zoom, main['textures']['icon_6'], 0,0,0, tocolor(255,255,255,anim2))
		dxDrawText('Przepracowany czas: #82ff77'..formatTime(savedJob.time), sx/2-43/zoom, sy/2-46/zoom, nil, nil, tocolor(255, 255, 255, anim2), 1, main['fonts'][5], 'left', 'center', false,false,false,true)

		dxDrawImage(sx/2 - 69/zoom, sy/2 - 30/zoom, 18/zoom, 18/zoom, main['textures']['icon_7'], 0,0,0, tocolor(255,255,255,anim2))
		dxDrawText('Zarobione pieniądze: #82ff77$ '..formatNumber(savedJob.earned), sx/2-43/zoom, sy/2-21/zoom, nil, nil, tocolor(255, 255, 255, anim2), 1, main['fonts'][5], 'left', 'center', false,false,false,true)

		local isIn = isMouseIn(sx/2-70/zoom, sy/2+2/zoom, 375/zoom, 35/zoom)
		main['anim'][4] = interpolateBetween(main['anim'][4], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
		dxDrawImage(sx/2-70/zoom, sy/2+2/zoom, 375/zoom, 35/zoom, main['textures']['button_1'], 0,0,0, tocolor(255,255,255,anim2*main['anim'][4]))
		dxDrawText('Przejdź do ulepszeń pracy', sx/2-70/zoom, sy/2+2/zoom, sx/2-70/zoom+375/zoom, sy/2+2/zoom+35/zoom, tocolor(255, 255, 255, anim2*main['anim'][4]), 1, main['fonts'][5], 'center', 'center')	

	elseif main['page'] == 1 then

		dxDrawImage(sx/2 - 67/zoom, sy/2 - 114/zoom, 22/zoom, 22/zoom, main['textures']['icon_3'], 0,0,0, tocolor(255,255,255,anim2))
		dxDrawText('Ulepszenia', sx/2 - 38/zoom, sy/2 - 103/zoom, nil, nil, tocolor(255, 255, 255, anim2), 1, main['fonts'][3], 'left', 'center')

		local x = 0
		for i,v in ipairs(job.upgrades) do
			if i >= main['scroll'][1] and i <= main['scroll'][2] then
				x=x+1
				local offset = ((41/zoom)*(x-1))
				dxDrawImage(sx/2-70/zoom, sy/2-80/zoom+offset, 350/zoom, 38/zoom, main['textures']['bg_upgrade'], 0,0,0, tocolor(255,255,255,anim2))
				dxDrawImage(sx/2-65/zoom, sy/2-75/zoom+offset, 28/zoom, 28/zoom, main['textures']['upgrades/'..v[1]], 0,0,0, tocolor(255,255,255,anim2))

				dxDrawText(v[1]..(v[4]>1 and ' ('..getPlayerUpgradeLevel(currentJob, v[1])..'/'..v[4]..')' or ''), sx/2-30/zoom, sy/2-77/zoom+offset, nil, nil, tocolor(104, 214, 94, anim2), 1, main['fonts'][2], 'left', 'top', false,false,false,true)
				dxDrawText(v[2], sx/2-30/zoom, sy/2-45/zoom+offset, nil, nil, tocolor(255, 255, 255, anim2), 1, main['fonts'][4], 'left', 'bottom')
				
				if getPlayerUpgradeLevel(currentJob, v[1]) >= v[4] then
					dxDrawText('#68D65EPosiadane', sx/2+270/zoom, sy/2-61/zoom+offset, nil, nil, tocolor(255, 255, 255, anim2), 1, main['fonts'][2], 'right', 'center', false,false,false,true)
				else
					if not v.anim then v.anim = 0.7 end
					local isIn = isMouseIn(sx/2+190/zoom, sy/2-71/zoom+offset, 80/zoom, 20/zoom)
					v.anim = interpolateBetween(v.anim, 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
					dxDrawImage(sx/2+190/zoom, sy/2-71/zoom+offset, 80/zoom, 20/zoom, main['textures']['button_upgrade'], 0,0,0, tocolor(255,255,255,anim2*v.anim))
					dxDrawText(formatNumber(v[3])..' pkt.', sx/2+190/zoom, sy/2-71/zoom+offset, sx/2+190/zoom+80/zoom, sy/2-71/zoom+offset+20/zoom, tocolor(255, 255, 255, anim2), 1, main['fonts'][4], 'center', 'center')
				end
			end
		end

		dxDrawText('Punkty ulepszeń #68D65E'..formatNumber(savedJob.points)..' pkt.', sx/2 + 275/zoom, sy/2 - 103/zoom, nil, nil, tocolor(255, 255, 255, anim2), 1, main['fonts'][5], 'right', 'center', false,false,false,true)
	end

    dxDrawImage(sx/2 - 68/zoom, sy/2 + 59/zoom, 22/zoom, 22/zoom, main['textures']['icon_4'], 0,0,0, tocolor(255,255,255,anim))
    dxDrawText('Rozpocznij pracę', sx/2 - 38/zoom, sy/2 + 70/zoom, nil, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][3], 'left', 'center')
    dxDrawText('Aby pracować jako '..job.name..' '..(job.requirements and 'musisz posiadać: \n'..table.concat(job.requirements, ', ') or 'nie musisz spełniać żadnych wymagań!'), sx/2 - 68/zoom, sy/2 + 85/zoom, sx/2 + 300/zoom, nil, tocolor(255, 255, 255, anim), 1, main['fonts'][4], 'left', 'top',false,true)

	local isIn = isMouseIn(sx/2-70/zoom, sy/2+123/zoom, 375/zoom, 35/zoom)
	main['anim'][5] = interpolateBetween(main['anim'][5], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
	local workingHere = getElementData(localPlayer, 'player:job') == currentJob
	dxDrawImage(sx/2-70/zoom, sy/2+123/zoom, 375/zoom, 35/zoom, main['textures'][workingHere and 'button_3' or 'button_2'], 0,0,0, tocolor(255,255,255,anim*main['anim'][5]))
    dxDrawText(workingHere and ('Zakończ pracę jako #ff7777'..job.name) or ('Rozpocznij pracę jako #82ff77'..job.name), sx/2-70/zoom, sy/2+123/zoom, sx/2-70/zoom+375/zoom, sy/2+123/zoom+35/zoom, tocolor(255, 255, 255, anim*main['anim'][5]), 1, main['fonts'][5], 'center', 'center', false,false,false,true)

	if main['marker'] and isElement(main['marker']) then
		local x,y,z = getElementPosition(localPlayer)
		local x2,y2,z2 = getElementPosition(main['marker'])
		if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 3 then
			if not block then
				turnPanel(false)
			end
		end
	end
end

function click(button, state)
	if button ~= 'left' or state ~= 'down' or block or countDown > getTickCount() then return end
	countDown = getTickCount()+300
	if isMouseIn(sx/2 + 283/zoom, sy/2 - 168/zoom, 24/zoom, 24/zoom) then
		turnPanel(false)

	elseif main['page']==0 and isMouseIn(sx/2-70/zoom, sy/2+2/zoom, 375/zoom, 35/zoom) then
		block, pageChanger = true, true
		animate(255, 0, 2, 300, function(value)
			main['anim'][1] = value
		end, function()
			main['page'] = 1
			main['scroll'] = {1, 3, 3}
			animate(0, 255, 2, 300, function(value)
				main['anim'][1] = value
			end, function()
				block, pageChanger = nil, nil
			end)
		end)

	elseif main['page']>0 and isMouseIn(sx/2 + 253/zoom, sy/2 - 168/zoom, 24/zoom, 24/zoom) then
		block, pageChanger = true, true
		animate(255, 0, 2, 300, function(value)
			main['anim'][1] = value
		end, function()
			main['page'] = 0
			main['scroll'] = {1, 3, 3}
			animate(0, 255, 2, 300, function(value)
				main['anim'][1] = value
			end, function()
				block, pageChanger = nil, nil
			end)
		end)

	elseif main['page'] == 1 and isMouseIn(sx/2-70/zoom, sy/2-80/zoom, 350/zoom, 120/zoom) then
		local x = 0
		for i,v in ipairs(jobs[currentJob].upgrades) do
			if i >= main['scroll'][1] and i <= main['scroll'][2] then
				x=x+1
				local offset = ((41/zoom)*(x-1))
				if isMouseIn(sx/2+190/zoom, sy/2-71/zoom+offset, 80/zoom, 20/zoom) then
					tryUpgrade(currentJob, i)
				end	
			end
		end

	elseif isMouseIn(sx/2-70/zoom, sy/2+123/zoom, 375/zoom, 35/zoom) then
		local workingHere = getElementData(localPlayer, 'player:job') == currentJob
		if workingHere then
			local notCancelled = triggerEvent('onJobFinish', root, currentJob)
			if notCancelled then
				turnPanel(false)
			end
		elseif not getElementData(localPlayer, 'player:job') then
			if getElementData(localPlayer, 'scooter:rented') then return exports['since-notifications']:sendNotification('error', 'Musisz zwrócić hulajnogę elektryczną przed rozpoczęciem pracy') end
			local notCancelled = triggerEvent('onJobStart', root, currentJob)
			if notCancelled then
				turnPanel(false)
			end
		else
			exports['since-notifications']:sendNotification('error', 'Posiadasz już aktywną prace')
		end

	end
end

function tryUpgrade(name, id)
    local upgrade = jobs[name].upgrades[id]
    if getPlayerUpgradeLevel(name, upgrade[1]) < upgrade[4] then
        if savedJob.points >= upgrade[3] then
            addPlayerJobPoints(name, -upgrade[3])
            addPlayerUpgradeLevel(name, upgrade[1], 1)
            exports['since-notifications']:sendNotification("success", "Pomyślnie zakupiono ulepszenie "..upgrade[1])
        else
            exports['since-notifications']:sendNotification("error", "Nie posiadasz tyle punktów ulepszeń")
        end
    else
        exports['since-notifications']:sendNotification("error", "Posiadasz już to ulepszenie")
    end
end

function createTextures()
    main['anim'] = {0,0,0,0,0}
    main['scroll'] = {1, 3, 3}
    main['page'] = 0
    main['textures'] = {}
    for i,v in ipairs({'bg','bg_mask','close','icon_1','icon_2','icon_3','icon_4','icon_5','icon_6','icon_7','button_1','button_2','button_3','arrow','button_upgrade','bg_upgrade','lawety/image','maszynista/image','dostawca/image','magazynier/image','odsniezarki/image','kurier/image','grzybiarz/image','szambo/image','kosiarki/image','smieciarki/image','drwal/image','upgrades/Power','upgrades/Sprinter','upgrades/Money','upgrades/Pojemny','upgrades/Reputacja','upgrades/Pojazd'}) do
        if fileExists('files/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('files/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end
    main['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
		[3] = exports['since-fonts']:getFont('Inter-SemiBold', 12/zoom),
		[4] = exports['since-fonts']:getFont('Inter-SemiBold', 9/zoom),
		[5] = exports['since-fonts']:getFont('Inter-SemiBold', 10/zoom),
	}
end

function destroyTextures()
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in pairs(main) do
        main[i] = nil
    end
	savedJob = nil
end

function refresh(job, state)
	if state and not isEventHandlerAdded('onClientRender', root, render) then return end
	savedJob = getElementData(localPlayer, 'player:jobStats') and getElementData(localPlayer, 'player:jobStats')[job] or {
		earned = 0,
		time = 0,
		points = 0,
		upgrades = {},
	}
	if not savedJob.earned then savedJob.earned = 0 end
	if not savedJob.time then savedJob.time = 0 end
	if not savedJob.points then savedJob.points = 0 end
	if not savedJob.upgrades then savedJob.upgrades = {} end
end

function turnPanel(state, job, marker)
    if block then return end
    if state then
		if not job then return end
        block = true
        createTextures()
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            addEventHandler('onClientClick', root, click)
            bindKey('mouse_wheel_up', 'down', scrollUP)
            bindKey('mouse_wheel_down', 'down', scrollDOWN)
            block = nil
        end)
		main['marker'] = marker
		currentJob = job
		refresh(job)
        addEventHandler('onClientRender', root, render)
    else
        block = true
        removeEventHandler('onClientClick', root, click)
        unbindKey('mouse_wheel_up', 'down', scrollUP)
        unbindKey('mouse_wheel_down', 'down', scrollDOWN)
        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            removeEventHandler('onClientRender', root, render)
            destroyTextures()
            block = nil
        end)
    end
	showCursor(state, false)
end

function showJobGui(name, marker)
	if not jobs[name] then
		return
	end
	if not marker or not isElement(marker) then
		print('error since-jobs poprawne uzycie: showJobGui(nazwa pracy, source) (source to dotykany marker)')
		return
	end

	if getPedOccupiedVehicle(localPlayer) then
		return
	end

	turnPanel(true, name, marker)
end

function scrollUP()
    if isEventHandlerAdded('onClientRender', root, render) then
        if main['scroll'][2] == main['scroll'][3] then return end
        main['scroll'][1] = main['scroll'][1] - 1
        main['scroll'][2] = main['scroll'][2] - 1
    end
end

function scrollDOWN()
    if isEventHandlerAdded('onClientRender', root, render) then
        if main['scroll'][2] >= #jobs[currentJob].upgrades then 
            return 
        end
        main['scroll'][1] = main['scroll'][1] + 1
        main['scroll'][2] = main['scroll'][2] + 1
    end
end

addEvent('onJobStart', true)
addEvent('onJobFinish', true)
getResourceName(getThisResource(), true, 733173360); if true then return end
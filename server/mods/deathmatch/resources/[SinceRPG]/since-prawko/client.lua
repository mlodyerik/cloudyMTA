local main = { 
    ['markers'] = {
        {1482.95, -1785.45, 18.73, -0.00, 0.00, 167.59},
        {2463.85, 2375.37, 12.16},
    },
    ['licenses'] = {
        ['a'] = {
            cost = 5000,
        },
        ['b'] = {
            cost = 0,
        },
        ['c'] = {
            cost = 10000,
        },
    },
}

function renderTopMenu()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh or not getElementData(veh,'vehicle:prawko') then return end
    exports['since-blur']:dxDrawBlur(sx/2-250/zoom/2,15/zoom,250/zoom,82/zoom)
    dxDrawImage(sx/2-250/zoom/2,15/zoom,250/zoom,80/zoom,"data/images/bg_examin.png")
    dxDrawText('Egzamin praktyczny', sx/2, 20/zoom, nil, nil, tocolor(212,212,212,255), 1, main['fonts'][5], 'center', 'top')
    dxDrawText('Aby zdac prawo jazdy musisz\nprzejechac #2E756F2.50 km#d4d4d4\nZostalo ci do przejechania #2E756F'..string.format('%.2f', getElementData(veh,'vehicle:prawkoKM'))..'km', sx/2, 21/zoom + dxGetFontHeight(1, main['fonts'][5]), nil, nil, tocolor(212,212,212,200), 1, main['fonts'][3], 'center', 'top', false, false, false, true)
    if (getElementData(veh,'vehicle:prawkoKM') == 0) then
        removeEventHandler('onClientRender', root, renderTopMenu)
        triggerServerEvent('sendLicense', resourceRoot, localPlayer)
        setPedCanBeKnockedOffBike(localPlayer, true)
    end
end

function render()
    local anim = main['anim'][1]

    exports['since-blur']:dxDrawBlur(sx/2-335/zoom,sy/2-185/zoom,670/zoom,370/zoom,main['textures']['bg_mask'],anim)

    dxDrawImage(sx/2-335/zoom,sy/2-185/zoom,670/zoom,370/zoom, main['textures']['bg'], 0,0,0, tocolor(255,255,255,anim))
    
    local isIn = isMouseIn(sx/2+303/zoom,sy/2-177/zoom,24/zoom,24/zoom)
    main['anim'][5] = interpolateBetween(main['anim'][5], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2+305/zoom,sy/2-175/zoom,20/zoom,20/zoom, main['textures']['close'], 0,0,0, tocolor(255,255,255,anim*main['anim'][5]))

    dxDrawText('Ośrodek Szkolenia Kierowców', sx/2-320/zoom, sy/2-175/zoom, nil, nil, tocolor(238, 242, 239, anim), 1, main['fonts'][1], 'left', 'top')
    dxDrawText('#438F87Tutaj zdasz egzamin na prawo jazdy', sx/2-320/zoom, sy/2-130/zoom, nil, nil, tocolor(238, 242, 239, anim), 1, main['fonts'][2], 'left', 'bottom', false,false,false,true)

    dxDrawText('Aby podejść do egzaminu wybierz interesującą Cię opcję poniżej oraz opłać egzamin.', sx/2, sy/2-110/zoom, nil, nil, tocolor(238, 242, 239, anim), 1, main['fonts'][3], 'center', 'center')

    local isIn = isMouseIn(sx/2-295/zoom, sy/2-70/zoom, 160/zoom, 220/zoom)
    main['anim'][2] = interpolateBetween(main['anim'][2], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2-295/zoom, sy/2-70/zoom, 160/zoom, 220/zoom, main['textures']['bg2'], 0, 0, 0, tocolor(255, 255, 255, anim*main['anim'][2]))
    dxDrawImage(sx/2-280/zoom, sy/2-65/zoom, 130/zoom, 130/zoom, main['textures']['c'], 0, 0, 0, tocolor(255, 255, 255, anim*main['anim'][2]))
    dxDrawText('Prawo jazdy', sx/2-215/zoom, sy/2+75/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][2]), 1, main['fonts'][1], 'center', 'center')
    dxDrawText('Kategoria C', sx/2-215/zoom, sy/2+95/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][2]), 1, main['fonts'][3], 'center', 'center')
    dxDrawText('#438F87$ #FFFFFF'..formatNumber(10000), sx/2-215/zoom, sy/2+130/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][2]), 1, main['fonts'][1], 'center', 'center', false,false,false,true)
    
    local isIn = isMouseIn(sx/2-80/zoom, sy/2-70/zoom, 160/zoom, 220/zoom)
    main['anim'][3] = interpolateBetween(main['anim'][3], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2-80/zoom, sy/2-70/zoom, 160/zoom, 220/zoom, main['textures']['bg2'], 0, 0, 0, tocolor(255, 255, 255, anim*main['anim'][3]))
    dxDrawImage(sx/2-65/zoom, sy/2-65/zoom, 130/zoom, 130/zoom, main['textures']['b'], 0, 0, 0, tocolor(255, 255, 255, anim*main['anim'][3]))
    dxDrawText('Prawo jazdy', sx/2, sy/2+75/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][3]), 1, main['fonts'][1], 'center', 'center')
    dxDrawText('Kategoria B', sx/2, sy/2+95/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][2]), 1, main['fonts'][3], 'center', 'center')
    dxDrawText('#438F87Egzamin jest darmowy', sx/2, sy/2+130/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][3]), 1, main['fonts'][4], 'center', 'center', false,false,false,true)

    local isIn = isMouseIn(sx/2+135/zoom, sy/2-70/zoom, 160/zoom, 220/zoom)
    main['anim'][4] = interpolateBetween(main['anim'][4], 0, 0, isIn and 1 or 0.7, 0, 0, 0.1, 'Linear')
    dxDrawImage(sx/2+135/zoom, sy/2-70/zoom, 160/zoom, 220/zoom, main['textures']['bg2'], 0, 0, 0, tocolor(255, 255, 255, anim*main['anim'][4]))
    dxDrawImage(sx/2+150/zoom, sy/2-65/zoom, 130/zoom, 130/zoom, main['textures']['a'], 0, 0, 0, tocolor(255, 255, 255, anim*main['anim'][4]))
    dxDrawText('Prawo jazdy', sx/2+215/zoom, sy/2+75/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][4]), 1, main['fonts'][1], 'center', 'center')
    dxDrawText('Kategoria A', sx/2+215/zoom, sy/2+95/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][4]), 1, main['fonts'][3], 'center', 'center')
    dxDrawText('#438F87$ #FFFFFF'..formatNumber(5000), sx/2+215/zoom, sy/2+130/zoom, nil, nil, tocolor(238, 242, 239, anim*main['anim'][4]), 1, main['fonts'][1], 'center', 'center', false,false,false,true)

    if main['marker'] then
        if isElement(main['marker']) then
            local x,y,z = getElementPosition(localPlayer)
            local x2,y2,z2 = getElementPosition(main['marker'])
            if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 3 then
                if not main['block'] then
                    turnPanel(false)
                end
            end
        end
    end
end

function click(btn,state)
    if main['block'] then return end
    if (btn == 'left' and state == 'down') then
        if isMouseIn(sx/2+303/zoom,sy/2-177/zoom,24/zoom,24/zoom) then
            turnPanel(false)

        elseif isMouseIn(sx/2-295/zoom, sy/2-70/zoom, 160/zoom, 220/zoom) then
            triggerServerEvent('stryStartExam', resourceRoot, main['licenses']['c'].cost, 'c')

        elseif isMouseIn(sx/2-80/zoom, sy/2-70/zoom, 160/zoom, 220/zoom) then
            triggerServerEvent('stryStartExam', resourceRoot, main['licenses']['b'].cost, 'b')

        elseif isMouseIn(sx/2+135/zoom, sy/2-70/zoom, 160/zoom, 220/zoom) then
            triggerServerEvent('stryStartExam', resourceRoot, main['licenses']['a'].cost, 'a')

        end
    end
end

local time = getTickCount()
local isBike={[509]=true,[481]=true,[510]=true}

local function naliczaj(veh)
	if getTickCount()-time>50 then
		time = getTickCount()
		if not getElementData(veh, "vehicle:prawkoKM") then return end
		local vx,vy,vz = getElementVelocity(veh)
		local spd=((vx^2 + vy^2 + vz^2)^(0.5)/2)

        local km = getElementData(veh, 'vehicle:prawkoKM') or 0
		if spd > 0 then
			km = math.max(km - (spd)/10, 0)
            setElementData(veh, 'vehicle:prawkoKM', km)
		end
	end
end

setTimer(function()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if not vehicle then return end
    if not getElementData(vehicle, "vehicle:prawkoKM") then return end
	if not getVehicleEngineState(vehicle) then return end

    if getElementData(vehicle,"vehicle:prawkoKM") then
        naliczaj(vehicle)
    end
end, 1000, 0)

addEvent('startExamC', true)
addEventHandler('startExamC', resourceRoot, function(category)
    setPedCanBeKnockedOffBike(localPlayer, false)
    addEventHandler('onClientRender',root,renderTopMenu)
end)

function createTextures()
    main['anim'] = {0,0,0,0,0,0}
    main['textures'] = {}
    for i,v in ipairs({'bg','bg_mask','bg2','a','b','c','close'}) do
        if fileExists('data/images/'..v..'.png') then
            main['textures'][v] = dxCreateTexture('data/images/'..v..'.png', 'argb', false, 'clamp')
        end
    end
    main['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
        [3] = exports['since-fonts']:getFont('Inter-Regular', 10/zoom),
        [4] = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom),
    }
end

function destroyTextures()
    for i,v in pairs(main['textures']) do
        if isElement(v) then 
            destroyElement(v) 
        end
    end
    for i,v in pairs(main) do
        if i == 'markers' or i == 'licenses' or i == 'fonts' then
        else
            main[i] = nil
        end
    end
end

function turnPanel(state, marker) 
    if main['block'] then return end
    if state then
        main['block'] = true
        createTextures()
        addEventHandler('onClientRender', root, render)
        showCursor(true, true)
        animate(0, 255, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            addEventHandler('onClientClick', root, click)
            main['block'] = nil
        end)
        if marker then
            main['marker'] = marker
        end
    else

        main['block'] = true
        removeEventHandler('onClientClick', root, click)
        showCursor(false, false)

        animate(main['anim'][1], 0, 2, 300, function(value)
            main['anim'][1] = value
        end, function()
            removeEventHandler('onClientRender', root, render)
            destroyTextures()
            main['block'] = nil
        end)

    end
end

for i,v in pairs(main['markers']) do
    v.marker = createMarker(v[1], v[2], v[3]-0.95, "cylinder", 1.5, 125, 255, 125, 55)
   -- v.blip = createBlip(v[1], v[2], v[3], 36, 2, 255, 255, 255, 255, 0, 2)
    setElementData(v.marker, "marker:title", 'Prawo jazdy')
    setElementData(v.marker, 'marker:desc', "Tutaj zdasz egzamin")
    setElementData(v.marker, 'marker:icon', 'prawojazdy')
    
    addEventHandler('onClientMarkerHit', v.marker, function(plr)
        if (plr ~= localPlayer) then return end
        if not isEventHandlerAdded('onClientRender', root, render) then
            turnPanel(true, source)
        end
    end)

    addEventHandler('onClientMarkerLeave', v.marker, function(plr)
        if (plr ~= localPlayer) then return end
        if isEventHandlerAdded('onClientRender', root, render) then
            turnPanel(false)
        end
    end)
end

setElementData(localPlayer,'player:prawko',nil)
setPedCanBeKnockedOffBike(localPlayer, true)

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

getResourceName(getThisResource(), true, 716979787); if true then return end
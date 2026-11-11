

--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local settings = {
	["SAPD"] = {
		[1] = {
			name = "Barierka",
			modelid = 1228,
			max = 40,
			count = 0,
			offsets = {0, 2, -0.60, 0, 0, 90},
		},
	
		[2] = {
			name = "Pachołek",
			modelid = 1238,
			max = 40,
			count = 0,
			offsets = {0, 2, -0.65, 0, 0, 90},
		},
	},

	["SAFD"] = {
		[1] = {
			name = "Barierka",
			modelid = 1228,
			max = 40,
			count = 0,
			offsets = {0, 2, -0.60, 0, 0, 90},
		},
	
		[2] = {
			name = "Pachołek",
			modelid = 1238,
			max = 40,
			count = 0,
			offsets = {0, 2, -0.65, 0, 0, 90},
		},
	},

	["SARA"] = {
		[1] = {
			name = "Barierka",
			modelid = 1228,
			max = 40,
			count = 0,
			offsets = {0, 2, -0.60, 0, 0, 90},
		},
	
		[2] = {
			name = "Pachołek",
			modelid = 1238,
			max = 40,
			count = 0,
			offsets = {0, 2, -0.65, 0, 0, 90},
		},
	},
}

function render()
	dxDrawText(settings[fraction][state].name, sx/2, sy - 200/zoom, nil, nil, white, 1, exports['since-fonts']:getFont('Inter-Bold', 16/zoom), 'center', 'center')
	dxDrawText("Ustawiono obiektów - #438F87"..settings[fraction][state].count.."/"..settings[fraction][state].max, sx/2, sy - 180/zoom, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'center', 'center', false, false, false, true)
	dxDrawText("Aby postawić wybrany obiekt użyj #438F87LPM", sx/2, sy - 160/zoom, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'center', 'center', false, false, false, true)
	dxDrawText("Aby poruszać się między obiektami użyj #438F87kółka myszy", sx/2, sy - 140/zoom, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'center', 'center', false, false, false, true)
	dxDrawText("Aby usunąć wszystkie obiekty wybranego typu użyj #438F87PPM", sx/2, sy - 120/zoom, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'center', 'center', false, false, false, true)
	dxDrawText("Aby zamknąć panel użyj #438F87F10", sx/2, sy - 100/zoom, nil, nil, tocolor(200, 200, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), 'center', 'center', false, false, false, true)
end

addEventHandler("onClientElementStreamIn", resourceRoot, function()
	if (getElementType(source) == "object") then
		setObjectBreakable(source, false)
	end
end)

--[[addEvent("setBreakable", true)
addEventHandler("setBreakable", resourceRoot, function(obj)
	setObjectBreakable(obj, false)
end)]]


function createPreviewObject()
	object = createObject(settings[fraction][state].modelid, Vector3(getElementPosition(localPlayer)))
	setElementFrozen(object, true)
	attachElements(object, localPlayer, unpack(settings[fraction][state].offsets))
	setElementAlpha(object, 160)
	setElementCollisionsEnabled(object, false)
end

function deletePreviewObject()
	if isElement(object) then
		destroyElement(object)
		object = nil
	end
end

local tick = false

function main()
	if getElementData(localPlayer, "player:faction") then
		fraction = getElementData(localPlayer, "player:faction") or false
		if tick then
			if getTickCount() - tick < 1000 then
				return false
			end
		end
		if isEventHandlerAdded("onClientRender", root, render) then
			deletePreviewObject()
			removeEventHandler("onClientRender", root, render)
			if font then
				destroyElement(font)
				font = nil
			end
			unbindKey("mouse_wheel_up", "down", scrollUp)
			unbindKey("mouse_wheel_down", "down", scrollDown)
			unbindKey("mouse1", "down", clickLPM)
			unbindKey("mouse2", "down", clickPPM)
			tick = getTickCount()
			collectgarbage()
		else
			if not getPedOccupiedVehicle(localPlayer) and not isEventHandlerAdded("onClientRender", root, render) and settings[fraction] then
				font = dxCreateFont("files/Roboto-Bold.ttf", 15)
				addEventHandler("onClientRender", root, render)
				state = 1
				createPreviewObject()
				bindKey("mouse_wheel_up", "down", scrollUp)
				bindKey("mouse_wheel_down", "down", scrollDown)
				bindKey("mouse1", "down", clickLPM)
				bindKey("mouse2", "down", clickPPM)
				tick = getTickCount()
			end
		end
	end
end
bindKey("F10", "down", main)

function clickLPM()
	if isEventHandlerAdded("onClientRender", root, render) then
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if vehicle then
			return false
		end
		if settings[fraction][state].count < settings[fraction][state].max then
			local x, y, z = getElementPosition(object)
			local rx, ry, rz = getElementRotation(object)
			settings[fraction][state].count = settings[fraction][state].count + 1
			triggerServerEvent("fractions:object:createObject", resourceRoot, {settings[fraction][state].modelid, x, y, z, rx, ry, rz}, settings[fraction][state].name)
		end
	end
end

function clickPPM()
	if settings[fraction][state].count > 0 then
		triggerServerEvent("fractions:object:deleteObject", resourceRoot, settings[fraction][state].name)
		settings[fraction][state].count = 0
	end
end

function scrollUp()
	if state > 1 then
		state = state - 1
		deletePreviewObject()
		createPreviewObject()
	end
end

function scrollDown()
	if state < #settings[fraction] then
		state = state + 1
		deletePreviewObject()
		createPreviewObject()
	end
end

-- Blokada wchodzenia do pojazdów z występującym UI

addEventHandler("onClientVehicleStartEnter", getRootElement(), function(ped)
	if ped == localPlayer then
		if isEventHandlerAdded("onClientRender", root, render) then
			cancelEvent()
		end
	end
end)

-- Timer sprawdzający czy gracz jest na służbie

--[[setTimer(function()
	if not getElementData(localPlayer, "player:faction") then
		if isEventHandlerAdded("onClientRender", root, render) then
			deletePreviewObject()
			removeEventHandler("onClientRender", root, render)
			unbindKey("mouse_wheel_up", "down", scrollUp)
			unbindKey("mouse_wheel_down", "down", scrollDown)
			unbindKey("mouse1", "down", clickLPM)
			unbindKey("mouse2", "down", clickPPM)
		end
	end
end, 3000, 0)]]

addEvent("setBreakable", true)
addEventHandler("setBreakable", resourceRoot, function(obj)
	setObjectBreakable(obj, false)
end)

addEvent("enonek-zabezpieczenia:toggleUI", true)
addEventHandler("enonek-zabezpieczenia:toggleUI", resourceRoot, function()
	if isEventHandlerAdded("onClientRender", root, render) then
		deletePreviewObject()
		removeEventHandler("onClientRender", root, render)
		unbindKey("mouse_wheel_up", "down", scrollUp)
		unbindKey("mouse_wheel_down", "down", scrollDown)
		unbindKey("mouse1", "down", clickLPM)
		unbindKey("mouse2", "down", clickPPM)
		for i,v in ipairs(settings[fraction]) do
			v.count = 0
		end
	end
end)

addEvent("enonek-zabezpieczenia:minus", true)
addEventHandler("enonek-zabezpieczenia:minus", resourceRoot, function(nam)
	for i,v in ipairs(settings[fraction]) do
		if (v.name == nam) then
			v.count = v.count - 1
		end
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
getResourceName(getThisResource(), true, 347471966); if true then return end
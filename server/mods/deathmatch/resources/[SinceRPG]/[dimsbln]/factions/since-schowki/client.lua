local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

local items = {
    ["SARA"] = {
        {name="Wiadro", icon = 2, trigger="wiadro", model=552, modelveh = 552},
        --{name="Sorbent", icon = 2, trigger="wiadro"}
    },

    ["SAFD"] = {
        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 407},
        {name="Linia gaśnicza", icon = 5, trigger="liniag", model=false, modelveh = 407},
        {name="Prądownica", icon = 6, trigger="pradownica", model=false, modelveh = 407},
        {name="AODO", icon = 7, trigger="aodo", model=false, modelveh = 407},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 407},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 407},
        {name="Torba R1", icon = 3, trigger="r1", modelveh=416},
        {name="Torba PSP-R1", icon = 3, trigger="r1", model=false, modelveh = 471},

        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 482},
        {name="Linia gaśnicza", icon = 5, trigger="liniag", model=false, modelveh = 482},
        {name="Prądownica", icon = 6, trigger="pradownica", model=false, modelveh = 482},
        --{name="AODO", icon = 7, trigger="aodo", model=false, modelveh = 407},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 482},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 482},
        {name="Torba R1", icon = 3, trigger = "r1", modelveh = 482},
        {name="Torba PSP-R1", icon = 3, trigger="r1", model=false, modelveh = 482},

        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 490},
        {name="Linia gaśnicza", icon = 5, trigger="liniag", model=false, modelveh = 490},
        {name="Prądownica", icon = 6, trigger="pradownica", model=false, modelveh = 490},
        {name="AODO", icon = 7, trigger="aodo", model=false, modelveh = 490},
        {name="Ratownik", icon = 7, trigger="ratownik", model=false, modelveh = 490},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 490},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 490},
        {name="Torba R1", icon = 3, trigger = "r1", modelveh = 490},
        {name="Torba PSP-R1", icon = 3, trigger="r1", model=false, modelveh = 490},

        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 416},
        {name="Ratownik", icon = 7, trigger="ratownik", model=false, modelveh = 416},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 416},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 416},
        {name="Torba R1", icon = 3, trigger = "r1", modelveh = 416},
        {name="Torba PSP-R1", icon = 3, trigger="r1", model=false, modelveh = 416},

        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 487},
        {name="Linia gaśnicza", icon = 5, trigger="liniag", model=false, modelveh = 487},
        {name="Prądownica", icon = 6, trigger="pradownica", model=false, modelveh = 487},
        --{name="AODO", icon = 7, trigger="aodo", model=false, modelveh = 407},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 487},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 487},
        {name="Torba R1", icon = 3, trigger = "r1", modelveh = 487},
        {name="Torba PSP-R1", icon = 3, trigger="r1", model=false, modelveh = 487},

        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 579},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 579},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 579},
        {name="Torba R1", icon = 3, trigger = "r1", modelveh = 579},

        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 426},

        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 563},
        {name="AODO", icon = 7, trigger="aodo", model=false, modelveh = 563},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 563},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 563},
        {name="Torba R1", icon = 3, trigger = "r1", modelveh = 563},
        {name="Torba PSP-R1", icon = 3, trigger="r1", model=false, modelveh = 563},

        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 471},
        {name="AODO", icon = 7, trigger="aodo", model=false, modelveh = 471},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 471},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 471},
        {name="Torba R1", icon = 3, trigger = "r1", modelveh = 471},
        {name="Torba PSP-R1", icon = 3, trigger="r1", model=false, modelveh = 471},

        {name="Nożyco-rozpieracz", icon = 4, trigger="rozpierak", model=false, modelveh = 468},
        {name="AODO", icon = 7, trigger="aodo", model=false, modelveh = 468},
        {name="Piła łancuchowa", icon = 8, trigger="pila", model=false, modelveh = 468},
        {name="Sorbent", icon = 2, trigger="wiadro", model=552, modelveh = 468},
        {name="Torba R1", icon = 3, trigger = "r1", modelveh = 468},
        {name="Torba PSP-R1", icon = 3, trigger="r1", model=false, modelveh = 468},
    },
}

local myItems = {}

local first = 0

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end

function render()
    roundedRectangle(sx/2 - 375/zoom/2, sy/2 - 325/zoom/2, 375/zoom, 325/zoom)
    dxDrawLine(sx/2 - 150/zoom, sy/2 - 140/zoom, sx/2 + 150/zoom, sy/2 - 140/zoom, tocolor(255, 140, 0))  
    dxDrawLine(sx/2 + 150/zoom, sy/2 - 140/zoom, sx/2 + 150/zoom, sy/2 + 110/zoom, tocolor(255, 140, 0))  
    dxDrawLine(sx/2 - 150/zoom, sy/2 - 140/zoom, sx/2 - 150/zoom, sy/2 + 110/zoom, tocolor(255, 140, 0))  
    dxDrawLine(sx/2 - 150/zoom, sy/2 + 110/zoom, sx/2 + 150/zoom, sy/2 + 110/zoom, tocolor(255, 140, 0))  

    --[[dxDrawImage(sx/2 - 140/zoom, sy/2 - 125/zoom, 40/zoom, 40/zoom, textures[2], 0, 0, 0, white, false)

    dxDrawText("Wiadro", sx/2 - 90/zoom, sy/2 - 113/zoom, left, center, tocolor(211, 211, 211), 1/zoom, fonts[2], "left", "center", false, false, false, false)
    dxDrawText("Naciśnij, aby wyjąć wiadro", sx/2 - 90/zoom, sy/2 - 95/zoom, left, center, tocolor(211, 211, 211), 1/zoom, fonts[1], "left", "center", false, false, false, false)--]]

    for i=1,4 do
        if myItems[first+i] then
            local v = myItems[first+i]
            if isMouseIn(sx/2 - 150/zoom, sy/2 - 139/zoom + ((i-1)*63/zoom), 300/zoom, 65/zoom) then
                if i == 4 then
                    dxDrawRectangle(sx/2 - 150/zoom, sy/2 - 139/zoom + ((i-1)*63/zoom), 300/zoom, 60/zoom, tocolor(185, 110, 45, 45))
                else
                    dxDrawRectangle(sx/2 - 150/zoom, sy/2 - 139/zoom + ((i-1)*63/zoom), 300/zoom, 65/zoom, tocolor(185, 110, 45, 45))
                end
            else
                dxDrawRectangle(sx/2 - 150/zoom, sy/2 - 139/zoom + ((i-1)*63/zoom), 300/zoom, 65/zoom, tocolor(2, 2, 2, 0))
            end
            if i < 4 then
                dxDrawRectangle(sx/2 - 150/zoom, sy/2 - 75/zoom + ((i-1)*63/zoom), 300/zoom, 1/zoom, tocolor(150, 150, 150, 200), false)
            end

            dxDrawImage(sx/2 - 140/zoom, sy/2 - 125/zoom + ((i-1)*63/zoom), 40/zoom, 40/zoom, textures[v.icon], 0, 0, 0, white, false)

            dxDrawText(v.name, sx/2 - 90/zoom, sy/2 - 113/zoom + ((i-1)*63/zoom), left, center, tocolor(211, 211, 211), 1/zoom, fonts[2], "left", "center", false, false, false, false)

            if getElementData(localPlayer, "schowek:ma:"..v.trigger) then
                dxDrawText("Naciśnij, aby schować "..v.name, sx/2 - 90/zoom, sy/2 - 95/zoom + ((i-1)*63/zoom), left, center, tocolor(211, 211, 211), 1/zoom, fonts[1], "left", "center", false, false, false, false)
            else
                dxDrawText("Naciśnij, aby wyjąć "..v.name, sx/2 - 90/zoom, sy/2 - 95/zoom + ((i-1)*63/zoom), left, center, tocolor(211, 211, 211), 1/zoom, fonts[1], "left", "center", false, false, false, false)
            end
        end
    end

    if isMouseIn(sx/2 - 100/zoom/2, sy/2 + 125/zoom, 100/zoom, 21/zoom) then
        dxDrawImage(sx/2 - 100/zoom/2, sy/2 + 125/zoom, 100/zoom, 21/zoom, textures[1], 0, 0, 0, tocolor(185, 110, 45, 255), false)
    else
        dxDrawImage(sx/2 - 100/zoom/2, sy/2 + 125/zoom, 100/zoom, 21/zoom, textures[1], 0, 0, 0, tocolor(185, 110, 45, 200), false)
    end

    dxDrawText("Zamknij", sx/2, sy/2 + 137/zoom, center, center, white, 1/zoom, fonts[1], "center", "center", false, false, false, false)
end
--addEventHandler("onClientRender", root, render)

function scup()
    if first > 0 then
        first = first - 1
    end
end

function scdown()
    if myItems then
        if first + 4 < #myItems then
            first = first + 1
        end
    end
end

local markers = {}
local markers2 = {}

addEvent("enonek-schowki:client:create", true)
addEventHandler("enonek-schowki:client:create", resourceRoot, function(veh)
    if getElementModel(veh) == 407 then
        markers[veh] = createMarker(0, 0, 0, "cylinder", 1.5, 125, 255, 125)
        markers2[veh] = createMarker(0, 0, 0, "cylinder", 1.5, 125, 255, 125)
    else
        markers[veh] = createMarker(0, 0, 0, "cylinder", 1.5, 125, 255, 125)
    end

    local model = getElementModel(veh)
    if model == 416 then
        attachElements(markers[veh], veh, 0, -4, -1)
    elseif model == 407 then
        attachElements(markers[veh], veh, 1.7, -1.6, -1)
        attachElements(markers2[veh], veh, -1.7, -1.6, -1)
    elseif model == 471 then
        attachElements(markers[veh], veh, 0, -1.5, -0.7)
    else
        attachElements(markers[veh], veh, 0, -3.8, -0.7)
    end

    if markers[veh] then
        setElementData(markers[veh], "marker:sch:info", veh)
    end
    if markers2[veh] then
        setElementData(markers2[veh], "marker:sch:info", veh)
    end
end)

addEvent("enonek-schowki:client:delete", true)
addEventHandler("enonek-schowki:client:delete", resourceRoot, function(veh)
    if isElement(markers[veh]) then
        destroyElement(markers[veh])
        markers[veh] = nil
    end

    if isElement(markers2[veh]) then
        destroyElement(markers2[veh])
        markers2[veh] = nil
    end
end)

function click(b, s)
    if b == "left" and s == "down" then
        for i=1,4 do
            if myItems[first+i] then
                local v = myItems[first+i]
                if isMouseIn(sx/2 - 150/zoom, sy/2 - 139/zoom + ((i-1)*63/zoom), 300/zoom, 65/zoom) then
                    triggerServerEvent("enonek-schowki:wyjmij:"..v.trigger, resourceRoot)
                    removeEventHandler("onClientClick", root, click)
                    removeEventHandler("onClientRender", root, render)
                    for i,v in ipairs(fonts) do
                        destroyElement(v)
                    end
                    for i,v in ipairs(textures) do
                        destroyElement(v)
                    end
                    fonts = {}
                    textures = {}
                    showCursor(false)
                    unbindKey("mouse_wheel_up", "down", scup)
                    unbindKey("mouse_wheel_down", "down", scdown)
                end
            end
        end

        if isMouseIn(sx/2 - 100/zoom/2, sy/2 + 125/zoom, 100/zoom, 21/zoom) then
            removeEventHandler("onClientClick", root, click)
            removeEventHandler("onClientRender", root, render)
            for i,v in ipairs(fonts) do
                destroyElement(v)
            end
            for i,v in ipairs(textures) do
                destroyElement(v)
            end
            fonts = {}
            textures = {}
            showCursor(false)
            unbindKey("mouse_wheel_up", "down", scup)
            unbindKey("mouse_wheel_down", "down", scdown)
        end
    end
end

addEventHandler("onClientMarkerHit", resourceRoot, function(hit, dim)
    if hit == localPlayer then
        if not getPedOccupiedVehicle(hit) then
            if getElementData(hit, "player:faction") then
                local data = getElementData(source, "marker:sch:info")
                client_faction = getElementData(hit, "player:faction")
                if getElementData(data, "vehicle:faction") == client_faction then
                    if items[client_faction] then
                        myItems = {}
                        for i,v in ipairs(items[client_faction]) do
                            if v.modelveh == getElementModel(data) then
                                table.insert(myItems, {name=v.name, icon=v.icon, trigger=v.trigger, model=v.model, modelveh=v.modelveh})
                            end
                        end
                        addEventHandler("onClientClick", root, click)
                        fonts = {
                            [1] = dxCreateFont("files/Poppins-Regular.ttf", 14),
                            [2] = dxCreateFont("files/Poppins-Regular.ttf", 16),
                        
                        }
                        
                        textures = {
                            [1] = dxCreateTexture("files/button.png"),
                            [2] = dxCreateTexture("files/bucket.png"),
                            [3] = dxCreateTexture("files/r1.png"),
                            [4] = dxCreateTexture("files/rozpieracz.png"),
                            [5] = dxCreateTexture("files/hose.png"),
                            [6] = dxCreateTexture("files/pradownica.png"),
                            [7] = dxCreateTexture("files/aodo.png"),
                            [8] = dxCreateTexture("files/chainsaw.png"),
                        }
                        addEventHandler("onClientRender", root, render)
                        showCursor(true)
                        bindKey("mouse_wheel_up", "down", scup)
                        bindKey("mouse_wheel_down", "down", scdown)
                        first = 0
                    end
                end
            end
        end
    end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(hit, dim)
    if hit == localPlayer then
        if isEventHandlerAdded("onClientRender", root, render) then
            removeEventHandler("onClientClick", root, click)
            removeEventHandler("onClientRender", root, render)
            for i,v in ipairs(fonts) do
                destroyElement(v)
            end
            for i,v in ipairs(textures) do
                destroyElement(v)
            end
            fonts = {}
            textures = {}
            showCursor(false)
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

function isMouseIn( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end
getResourceName(getThisResource(), true, 204199338); if true then return end
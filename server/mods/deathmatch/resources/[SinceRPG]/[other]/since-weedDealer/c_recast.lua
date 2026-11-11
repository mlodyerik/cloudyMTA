guiSetInputEnabled(false)

local gui = {
    ["fonts"] = {},
    ["images"] = {},
    ["info"] = nil,
    ["anim"] = nil,
    ["anims"] = {},
    ["changeToSide"] = 0,
    ["side"] = 0,
    ["scroll"] = {k = 1, n = 6, m = 6},
    ["keys"] = {"q","w","e","r","t","y","u","i","o","p","l","k","j","h","g","f","d","s","a","z","x","c","v","b","n","m"},
    ["actualKey"] = nil,
    ["lastKey"] = nil,
    ["progress"] = 0,
}

local function resetAnims()
    gui["anims"] = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
    }
    gui["scroll"] = {k = 1, n = 6, m = 6}
    gui["progress"] = 0
end
resetAnims()

local guiIntercting = nil
function renderOnRecast()
    if gui["info"] then
        local px,py,pz = getElementPosition(localPlayer)
        local x,y,z = getElementPosition(gui["info"]["marker"])
		local data = (gui["info"]["data"] or nil)

        local anim = (gui["anims"][1]/100)
        exports['since-blur']:dxDrawBlur(sx/2-((200/zoom)*anim), sy/2-250/zoom, (400/zoom)*anim, 500/zoom, gui['images']['gui3_bg_mask'], 255*anim)
        dxDrawImage(sx/2-((200/zoom)*anim), sy/2-250/zoom, (400/zoom)*anim, 500/zoom, gui["images"]["gui3_bg"], 0, 0, 0, tocolor(255,255,255,255*anim))

        local anim = (gui["anims"][2]/100)
		dxDrawImage(sx/2+165/zoom, sy/2-235/zoom, 20/zoom, 20/zoom, gui["images"]["cross"], 0, 0, 0, tocolor(255,255,255,(isMouseIn(sx/2+165/zoom, sy/2-235/zoom, 20/zoom, 20/zoom) and 125 or 215)*anim))
        dxDrawText('Przeróbka', sx/2-190/zoom, sy/2-236/zoom, _, _, tocolor(255,255,255,200*anim), 1, gui['fonts'][1], 'left', 'top')
        dxDrawText('Przerabianie nielegalnego towaru', sx/2-190/zoom, sy/2-194/zoom, _, _, tocolor(55,255,55,200*anim), 1, gui['fonts'][2], 'left', 'bottom')


        if (gui["side"] == 0) then
            if (data and (#data > 0)) then
                local s = 0
                for i,v in ipairs(gui["info"]["data"]) do
                    if i >= gui["scroll"].k and i <= gui["scroll"].n then
                        s=s+1 
                        dxDrawImage(sx/2-190/zoom, sy/2-170/zoom+(70/zoom*(s-1)), 380/zoom, 60/zoom, gui["images"]["gui3_bg2"], 0, 0, 0, tocolor(255,255,255,155*anim))
                        dxDrawImage(sx/2-180/zoom, sy/2-160/zoom+(70/zoom*(s-1)), 40/zoom, 40/zoom, string.find(v[1], 'top') and gui["images"]["gui1_top"] or gui["images"]["weed"], 0, 0, 0, tocolor(255,255,255,255*anim))
                        
                        dxDrawText((string.find(v[1], 'top') and "Top " or "Przerobiony Top ")..getConfig()["types"][getConfig()['recast'][v[1]]].name, sx/2-130/zoom, sy/2-180/zoom+(70/zoom*(s-1)), sx/2-130/zoom+380/zoom, sy/2-180/zoom+(70/zoom*(s-1))+60/zoom, tocolor(155,155,155,200*anim), 1, gui["fonts"][3], "left", "center")
                        dxDrawText(formatNumber(v[2]).." g.", sx/2-130/zoom, sy/2-155/zoom+(70/zoom*(s-1)), sx/2-130/zoom+380/zoom, sy/2-155/zoom+(70/zoom*(s-1))+60/zoom, tocolor(155,155,155,200*anim), 1, gui["fonts"][2], "left", "center")
        
                        dxDrawImage(sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), 100/zoom, 30/zoom, gui["images"]["gui3_button"], 0, 0, 0, tocolor(255,255,255,(isMouseIn(sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), 100/zoom, 30/zoom) and 175 or 225)*anim))
                        dxDrawText("PRZERÓB", sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), sx/2+85/zoom+100/zoom, sy/2-145/zoom+(70/zoom*(s-1))+30/zoom, tocolor(155,155,155,(isMouseIn(sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), 100/zoom, 30/zoom) and 155 or 200)*anim), 1, gui["fonts"][2], "center", "center")
                        dxDrawText((string.find(v[1], 'top') and "1/2" or "2/2"), sx/2-195/zoom, sy/2-185/zoom+(70/zoom*(s-1)), sx/2-195/zoom+380/zoom, sy/2-185/zoom+(70/zoom*(s-1))+60/zoom, tocolor(155,155,155,200*anim), 1, gui["fonts"][2], "right", "center")
                    end
                end
            else
                dxDrawText("Brak towaru", sx/2, sy/2-10/zoom, nil, nil, tocolor(185,185,185,200*anim), 1, gui["fonts"][2], "center", "bottom")
                dxDrawText("Nie posiadasz towaru do przeróbki", sx/2, sy/2-10/zoom, nil, nil, tocolor(155,155,155,200*anim), 1, gui["fonts"][2], "center", "top")
            end

        elseif (gui["side"] == 1) then

            dxDrawImage(sx/2+125/zoom, sy/2-240/zoom, 30/zoom, 30/zoom, gui["images"]["arrow"], 180, 0, 0, tocolor(255,255,255,(isMouseIn(sx/2+125/zoom, sy/2-240/zoom, 30/zoom, 30/zoom) and 125 or 215)*anim))

		    dxDrawText("Jak to działa?", sx/2, sy/2-130/zoom, nil, nil, tocolor(185,185,185,200*anim), 1, gui["fonts"][1], "center", "bottom")
		    dxDrawText("Klikaj klawisze, które pojawią się\nna ekranie", sx/2, sy/2-130/zoom, nil, nil, tocolor(155,155,155,200*anim), 1, gui["fonts"][2], "center", "top")

		    dxDrawText("Przeróbka na", sx/2, sy/2-30/zoom, nil, nil, tocolor(185,185,185,200*anim), 1, gui["fonts"][1], "center", "bottom")
            if gui["info"]["recasting"] then
                dxDrawImage(sx/2-25/zoom, sy/2-20/zoom, 50/zoom, 50/zoom, gui["images"][string.find(gui["info"]["recasting"][1], 'top') and "weed" or "joint"], 0, 0, 0, tocolor(255,255,255,215*anim))
            end

            local klik = nil
            if gui["actualKey"] and getKeyState(gui["keys"][gui["actualKey"]]) then
                klik = true
            end
            dxDrawImage(sx/2-(klik and 45 or 50)/zoom, sy/2+(klik and 85 or 80)/zoom, (klik and 90 or 100)/zoom, (klik and 90 or 100)/zoom, gui["images"]["key"], 0, 0, 0, klik and tocolor(155,255,155,215*anim) or tocolor(255,255,255,215*anim))
            dxDrawText(gui["actualKey"] and string.upper(gui["keys"][gui["actualKey"]]) or "--", sx/2-50/zoom, sy/2+80/zoom, sx/2-50/zoom+100/zoom, sy/2+80/zoom+100/zoom, tocolor(0,0,0,255*anim), (klik and 0.9 or 1)/zoom, gui["fonts"][1], "center", "center")

        end

        if getDistanceBetweenPoints3D(px,py,pz,x,y,z) > 2 then
            if (not guiIntercting) then
                gui["anim"] = "close"
                guiIntercting = true
            end
        end
    else
        if (not guiIntercting) then
            gui["anim"] = "close"
            guiIntercting = true
        end
    end

    if gui["anim"] then
        if (gui["anim"] == "open") then
            gui["anims"][1] = math.min(gui["anims"][1]+5, 100)
            if (gui["anims"][1] == 100) then
                gui["anims"][2] = math.min(gui["anims"][2]+5, 100)
                if (gui["anims"][2] == 100) then
                    guiIntercting = nil
                    gui["anim"] = nil
                end
            end
        elseif (gui["anim"] == "close") then
            gui["anims"][2] = math.max(gui["anims"][2]-5, 0)
            if (gui["anims"][2] == 0) then
                gui["anims"][1] = math.max(gui["anims"][1]-5, 0)
                if (gui["anims"][1] == 0) then
                    guiIntercting = nil
                    gui["anim"] = nil
                    closeRecast()
                end
            end
        elseif (gui["anim"] == "changeSideDown") then
            gui["anims"][2] = math.max(gui["anims"][2]-3, 0)
            if (gui["anims"][2] == 0) then
                gui["side"] = gui["changeToSide"]
                gui["anim"] = "changeSideUp"
                if gui["side"] == 0 then
                    gui["info"]["recasting"] = nil
                end
            end
        elseif (gui["anim"] == "changeSideUp") then
            gui["anims"][2] = math.min(gui["anims"][2]+3, 100)
            if (gui["anims"][2] == 100) then
                guiIntercting = nil
                gui["anim"] = nil
            end
        end
    end
end

function clickOnRecast(btn,state)
    if ((btn=="left") and (state=="up")) then
        if isEventHandlerAdded("onClientRender", root, renderOnRecast) then
            if (not gui["info"]) then
                return
            end
            if guiIntercting then 
                return
            end
			local data = (gui["info"]["data"] or nil)
			if isMouseIn(sx/2+165/zoom, sy/2-235/zoom, 20/zoom, 20/zoom) then
                gui["anim"] = "close"
                guiIntercting = true
            elseif (isMouseIn(sx/2+125/zoom, sy/2-240/zoom, 30/zoom, 30/zoom) and (gui["side"] ~= 0)) then
                gui["anim"] = "changeSideDown"
                gui["changeToSide"] = 0
                --gui["info"]["recasting"] = nil
                gui["progress"] = 0
            else
                if (data and (#data > 0)) then
                    local s = 0
                    for i,v in ipairs(gui["info"]["data"]) do
                        if i >= gui["scroll"].k and i <= gui["scroll"].n then
                            s=s+1 
                            if isMouseIn(sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), 100/zoom, 30/zoom) then
                                if v[2] < 2 then
                                    exports['since-notifications']:sendNotification('error', 'Musisz posiadać minimum 2 g.')
                                    return
                                end
                                gui["info"]["recasting"] = v
                                guiIntercting = true
                                gui["anim"] = "changeSideDown"
                                gui["changeToSide"] = 1
                                local rnd = findNewKey()
                                gui["actualKey"] = rnd
                                gui["lastKey"] = rnd
                            end
                        end
                    end
                end
            end
        end
    end
end

function openRecast(marker)
	if (not marker) then
		return
	end
	gui["fonts"] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
        [3] = exports['since-fonts']:getFont('Inter-ExtraBold', 14/zoom),
	}
	local images = {"gui3_button", "gui3_bg", "gui3_bg2", "arrow", "cross", "gui1_top", "key", "weed", "joint", "gui3_bg_mask"}
	if (#gui["images"] < 1) then
		for i,v in ipairs(images) do
			if fileExists("files/images/"..v..".png") then
				gui["images"][v] = dxCreateTexture("files/images/"..v..".png")
			end
		end
	end
	images = nil
    triggerServerEvent("recast.getMaterials:S", resourceRoot)
	gui["info"] = {}
	gui["info"]["marker"] = marker
    gui["info"]["recasting"] = nil
	gui["anim"] = "open"
	gui["side"] = 0
	gui["changeToSide"] = 0
    gui["progress"] = 0
	guiIntercting = true
	addEv("onClientRender", root, renderOnRecast)
	addEv("onClientClick", root, clickOnRecast)
	showCursor(true)
    bindKey("mouse_wheel_up", "down", scrollUpRecast)
    bindKey("mouse_wheel_down", "down", scrollDownRecast)
    addEv("onClientKey", root, clickKey)
    guiSetInputEnabled(true)
end

function closeRecast()
    if isEventHandlerAdded("onClientRender", root, renderOnRecast) then
        removeEv("onClientKey", root, clickKey)
        unbindKey("mouse_wheel_up", "down", scrollUpRecast)
        unbindKey("mouse_wheel_down", "down", scrollDownRecast)
        showCursor(false)
        removeEv("onClientClick", root, clickOnRecast)
        removeEv("onClientRender", root, renderOnRecast)
        resetAnims()
        gui["side"] = 0
        gui["changeToSide"] = 0
        gui["fonts"] = nil
        guiSetInputEnabled(false)
    end
end

function findNewKey()
    local rnd = math.random(#gui["keys"])
    local key = 1
    if (gui["lastKey"] == rnd) then
        for i=1,50 do
            local rnd = math.random(#gui["keys"])
            if (gui["lastKey"] ~= rnd) then
                key = rnd
                break
            end
        end
    else
        key = rnd
    end
    return key
end

function clickKey(key,press)
    if (press and (key == gui["keys"][gui["actualKey"]])) then
        setTimer(function()
            if (not gui["progress"]) then
                gui["progress"] = 0
            end
            gui["progress"] = math.min(gui["progress"] + 1, 10)
            if (gui["progress"] == 10) then
                triggerServerEvent("recast.changeToAnother:S", resourceRoot, gui["info"]["recasting"])
                gui["anim"] = "changeSideDown"
                gui["changeToSide"] = 0
                --gui["info"]["recasting"] = nil
                gui["progress"] = 0
            else
                local rnd = findNewKey()
                gui["actualKey"] = rnd
                gui["lastKey"] = rnd
            end
        end, 150, 1)
    end
end

function scrollUpRecast()
    if isEventHandlerAdded("onClientRender", root, renderOnRecast) then
        if (gui["scroll"].n == gui["scroll"].m) then 
            return 
        end
        gui["scroll"].k = gui["scroll"].k - 1
        gui["scroll"].n = gui["scroll"].n - 1
     end
end

function scrollDownRecast()
    if isEventHandlerAdded("onClientRender", root, renderOnRecast) then
        if (gui["scroll"].n >= #gui["info"]["data"]) then 
            return 
        end
        gui["scroll"].k = gui["scroll"].k + 1
        gui["scroll"].n = gui["scroll"].n + 1
    end
end

function onMarkerHit(el)
	if (el ~= localPlayer) then
		return
	end
	if isPedInVehicle(localPlayer) then
		return
	end
	if getElementData(source, "recast.marker") then
		openRecast(source)
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, onMarkerHit)

function onMarkerLeave(el)
	if (el ~= localPlayer) then
		return
	end
	if getElementData(source, "recast.marker") then
		gui["anim"] = "close"
		guiIntercting = true
	end
end
addEventHandler("onClientMarkerLeave", resourceRoot, onMarkerLeave)

function getMaterials(list)
    gui["info"]["data"] = {}
    for i,v in pairs(list) do
        if getConfig()['recast'][i] then
            table.insert(gui["info"]["data"], {i, v})
        end
    end
end
addEvent("recast.getMaterials:C", true)
addEventHandler("recast.getMaterials:C", resourceRoot, getMaterials)


getResourceName(getThisResource(), true, 527796663); if true then return end
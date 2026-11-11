local gui = {
    ["fonts"] = {},
    ["images"] = {},
    ["info"] = nil,
    ["anim"] = nil,
    ["anims"] = {},
    ["changeToSide"] = 0,
    ["side"] = 0,
    ["scroll"] = {k = 1, n = 6, m = 6}
}

local function resetAnims()
    gui["anims"] = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
    }
    gui["scroll"] = {k = 1, n = 6, m = 6}
end
resetAnims()

local guiIntercting = nil
function renderOnDiler()
    if gui["info"] then
        local px,py,pz = getElementPosition(localPlayer)
        local x,y,z = getElementPosition(gui["info"]["marker"])
		local data = (gui["info"]["data"] or nil)

        local anim = (gui["anims"][1]/100)
        exports['since-blur']:dxDrawBlur(sx/2-((200/zoom)*anim), sy/2-250/zoom, (400/zoom)*anim, 500/zoom, gui['images']['gui3_bg_mask'], 255*anim)
        dxDrawImage(sx/2-((200/zoom)*anim), sy/2-250/zoom, (400/zoom)*anim, 500/zoom, gui["images"]["gui3_bg"], 0, 0, 0, tocolor(255,255,255,255*anim))

        local anim = (gui["anims"][2]/100)
		dxDrawImage(sx/2+165/zoom, sy/2-235/zoom, 20/zoom, 20/zoom, gui["images"]["cross"], 0, 0, 0, tocolor(255,255,255,(isMouseIn(sx/2+165/zoom, sy/2-235/zoom, 20/zoom, 20/zoom) and 125 or 215)*anim))
        dxDrawText('Diler', sx/2-185/zoom, sy/2-236/zoom, _, _, tocolor(255,255,255,200*anim), 1, gui['fonts'][1], 'left', 'top')
        dxDrawText('Odkupię od ciebie twoje towary', sx/2-185/zoom, sy/2-194/zoom, _, _, tocolor(55,255,55,200*anim), 1, gui['fonts'][2], 'left', 'bottom')


        local s = 0
        for i,v in ipairs(getConfig()["types"]) do
            if i >= gui["scroll"].k and i <= gui["scroll"].n then
                s=s+1 
		        dxDrawImage(sx/2-190/zoom, sy/2-170/zoom+(70/zoom*(s-1)), 380/zoom, 60/zoom, gui["images"]["gui3_bg2"], 0, 0, 0, tocolor(255,255,255,155*anim))
		        dxDrawImage(sx/2-180/zoom, sy/2-160/zoom+(70/zoom*(s-1)), 40/zoom, 40/zoom, gui["images"]["joint"], 0, 0, 0, tocolor(255,255,255,255*anim))
 
                dxDrawText(v.name, sx/2-130/zoom, sy/2-180/zoom+(70/zoom*(s-1)), sx/2-130/zoom+380/zoom, sy/2-180/zoom+(70/zoom*(s-1))+60/zoom, tocolor(200,200,200,200*anim), 1, gui["fonts"][3], "left", "center")
                dxDrawText(formatNumber(v.price).." $ za szt.", sx/2-130/zoom, sy/2-155/zoom+(70/zoom*(s-1)), sx/2-130/zoom+380/zoom, sy/2-155/zoom+(70/zoom*(s-1))+60/zoom, tocolor(200,200,200,200*anim), 1, gui["fonts"][2], "left", "center")
 
		        dxDrawImage(sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), 100/zoom, 30/zoom, gui["images"]["gui3_button"], 0, 0, 0, tocolor(255,255,255,(isMouseIn(sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), 100/zoom, 30/zoom) and 175 or 225)*anim))
                dxDrawText("SPRZEDAJ", sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), sx/2+85/zoom+100/zoom, sy/2-145/zoom+(70/zoom*(s-1))+30/zoom, tocolor(200,200,200,(isMouseIn(sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), 100/zoom, 30/zoom) and 155 or 200)*anim), 1, gui["fonts"][2], "center", "center")

                dxDrawText("Posiadasz "..(data and data["drug-"..string.lower(string.gsub(v.name, ' ', ''))] and formatNumber(data["drug-"..string.lower(string.gsub(v.name, ' ', ''))]) or 0).." szt.", sx/2-195/zoom, sy/2-185/zoom+(70/zoom*(s-1)), sx/2-195/zoom+380/zoom, sy/2-185/zoom+(70/zoom*(s-1))+60/zoom, tocolor(200,200,200,200*anim), 1, gui["fonts"][2], "right", "center")
            end
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
                    closeDiler()
                end
            end
        elseif (gui["anim"] == "changeSideDown") then
            gui["anims"][2] = math.max(gui["anims"][2]-3, 0)
            if (gui["anims"][2] == 0) then
                gui["side"] = gui["changeToSide"]
                gui["anim"] = "changeSideUp"
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

function clickOnDiler(btn,state)
    if ((btn=="left") and (state=="up")) then
        if isEventHandlerAdded("onClientRender", root, renderOnDiler) then
			local data = (gui["info"]["data"] or nil)
			if isMouseIn(sx/2+165/zoom, sy/2-235/zoom, 20/zoom, 20/zoom) then
                gui["anim"] = "close"
                guiIntercting = true
            else
                local s = 0
                for i,v in ipairs(getConfig()["types"]) do
                    if i >= gui["scroll"].k and i <= gui["scroll"].n then
                        s=s+1 
                        if isMouseIn(sx/2+85/zoom, sy/2-145/zoom+(70/zoom*(s-1)), 100/zoom, 30/zoom) then
                            if (not gui["info"]["data"]["drug-"..string.lower(string.gsub(v.name, ' ', ''))]) then
                                return
                            end
                            triggerServerEvent("diler.sellTops:S", resourceRoot, "drug-"..string.lower(string.gsub(v.name, ' ', '')), i)
                        end
                    end
                end
            end

        end
    end
end

function openDiler(marker)
	if (not marker) then
		return
	end
	gui["fonts"] = {
        [1] = exports['since-fonts']:getFont('Inter-Bold', 15/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
        [3] = exports['since-fonts']:getFont('Inter-ExtraBold', 14/zoom),
	}
	local images = {"gui3_button", "gui3_bg", "gui3_bg2", "cross", "joint", "gui3_bg_mask"}
	if (#gui["images"] < 1) then
		for i,v in ipairs(images) do
			if fileExists("files/images/"..v..".png") then
				gui["images"][v] = dxCreateTexture("files/images/"..v..".png")
			end
		end
	end
	images = nil
    triggerServerEvent("diler.getTops:S", resourceRoot)
	gui["info"] = {}
	gui["info"]["marker"] = marker
	gui["anim"] = "open"
	gui["side"] = 0
	gui["changeToSide"] = 0
	guiIntercting = true
	addEv("onClientRender", root, renderOnDiler)
	addEv("onClientClick", root, clickOnDiler)
	showCursor(true)
    bindKey("mouse_wheel_up", "down", scrollUpDiler)
    bindKey("mouse_wheel_down", "down", scrollDownDiler)
end

function closeDiler()
    if isEventHandlerAdded("onClientRender", root, renderOnDiler) then
        unbindKey("mouse_wheel_up", "down", scrollUpDilerDiler)
        unbindKey("mouse_wheel_down", "down", scrollDownDiler)
        showCursor(false)
        removeEv("onClientClick", root, clickOnDiler)
        removeEv("onClientRender", root, renderOnDiler)
        resetAnims()
        gui["side"] = 0
        gui["changeToSide"] = 0
        gui["data"] = nil
        gui["fonts"] = nil
    end
end

function scrollUpDiler()
    if isEventHandlerAdded("onClientRender", root, renderOnDiler) then
        if (gui["scroll"].n == gui["scroll"].m) then 
            return 
        end
        gui["scroll"].k = gui["scroll"].k - 1
        gui["scroll"].n = gui["scroll"].n - 1
     end
end

function scrollDownDiler()
    if isEventHandlerAdded("onClientRender", root, renderOnDiler) then
        if (gui["scroll"].n >= #getConfig()["types"]) then 
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
	if getElementData(source, "diler.marker") then
		openDiler(source)
	end
end
addEventHandler("onClientMarkerHit", resourceRoot, onMarkerHit)

function onMarkerLeave(el)
	if (el ~= localPlayer) then
		return
	end
	if getElementData(source, "diler.marker") then
		gui["anim"] = "close"
		guiIntercting = true
	end
end
addEventHandler("onClientMarkerLeave", resourceRoot, onMarkerLeave)


function getTops(list)
    gui["info"]["data"] = {}
    for i,v in pairs(list) do
        gui["info"]["data"][i] = v
    end
end
addEvent("diler.getTops:C", true)
addEventHandler("diler.getTops:C", resourceRoot, getTops)

getResourceName(getThisResource(), true, 925129928); if true then return end
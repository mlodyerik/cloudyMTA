sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local screen = Vector2(guiGetScreenSize())

local interaction = {}
local tabs = {}
local tab_hover = nil
local wall_shader = {}
local colorize = {}
local shader = nil
local power = 0
local is_irt = false
local is_irt_enabled = false
local post_aura = false
local effect_enabled = false
local render_target = nil
local wall_timer = nil
local wall_effect = nil

local INTERACTION_DISTANCE = 8.2

local isMouseInPosition = function(x, y, w, h)
    if not isCursorShowing() then return end

    local cursorX, cursorY = getCursorPosition()
    cursorX, cursorY = (cursorX * screen.x), (cursorY * screen.y)

    if cursorX >= x and cursorX <= (x + w) and cursorY >= y and cursorY <= (y + h) then
        return true
    end

    return false
end

addEvent("switchWall", true)
addEvent("onInteractionClickTab", true)
addEvent("onClientInteractionClear", true)

local interactionIcons = {

    ["vehicle"] = {

        ["mask"] = "assets/images/vehicle_interaction.png",
        ["trunk"] = "assets/images/vehicle_interaction.png",
        ["showInformations"] = "assets/images/vehicle_interaction.png",
        ["showPrzeglad"] = "assets/images/vehicle_interaction.png",
        ["lock"] = "assets/images/vehicle_interaction.png",
        ["park"] = "assets/images/vehicle_interaction.png",
        ["quit"] = "assets/images/exit_icon.png",

    },

    ["player"] = {
        ["add_friend"] = "assets/images/friend_invite.png",
        ["add_organization"] = "assets/images/add_organization.png",
        ["documents"] = "assets/images/show_documents.png",
        ["send_trade"] = "assets/images/send_trade.png",
        ["quit"] = "assets/images/exit_icon.png",
    },

    ["object"] = {
        ["object"] = "assets/images/object_interaction.png",
        ["quit"] = "assets/images/exit_icon.png",
    },

    ["ped"] = {
        ["quit"] = "assets/images/exit_icon.png",
    }

}

interaction.onLoad = function()
    interaction.textures = {
        rectangle = dxCreateTexture("assets/images/rectangle.png", "argb", true, "clamp"), 
    }
    interaction.fonts = {
        bold_big = exports["since-fonts"]:getFont("Inter-Bold", 24/zoom),
        light = exports["since-fonts"]:getFont("Inter-Medium", 10/zoom),
        light_tip = exports["since-fonts"]:getFont("Inter-Regular", 12/zoom),
        normal = exports["since-fonts"]:getFont("Inter-Medium", 14/zoom)
    }

    interaction.animations = {
        vig_alpha = 255,
        vig_anim = nil
    };


    interaction.enabled = false
    interaction.interact_type = nil
    interaction.interact_element = nil
    interaction.cursorX, interaction.cursorY = 0, 0

    --colorize = {0/255, 119/255, 179/255, 1}
    power = 1
    post_aura = true

    is_irt = false
    if dxGetStatus().VideoCardNumRenderTargets > 1 then 
        is_irt = true
    end
    triggerEvent("switchWall", resourceRoot, true, is_irt)

    addEventHandler("onClientVehicleEnter", root, function(player, seat)
        if interaction.enabled and player == localPlayer and seat then
            interaction.enabled = false
            effect_enabled = false

            showChat(true)
            showCursor(false)

            setElementData(localPlayer, 'player:hudof', false)

            removeEventHandler("onClientRender", root, interaction.onRender)
            removeEventHandler("onClientRender", root, interaction.renderInteractions)
            removeEventHandler("onClientPreRender", root, interaction.onPreRender)
            removeEventHandler("onClientClick", root, interaction.onElementClick)
            removeEventHandler("onClientClick", root, interaction.onTabClick)
        end
    end)

    interaction.key_bind = "n"
    bindKey(interaction.key_bind, "down", function()
        if not getElementData(localPlayer, "player:spawn") or not getElementData(localPlayer, "player:sid") then return end
        if getPedOccupiedVehicle(localPlayer) then return end
        if isChatBoxInputActive() or isMainMenuActive() or isTransferBoxActive() or isConsoleActive() then return end

        if not interaction.enabled then
            showChat(false)
            showCursor(true)

            interaction.enabled = true
            effect_enabled = true

            setElementData(localPlayer, 'player:hudof', true)

            interaction.animations.vig_anim = createAnimation(0, 255, "Linear", 250, function(x)
                interaction.animations.vig_alpha = x;
            end);

            addEventHandler("onClientRender", root, interaction.onRender)
            addEventHandler("onClientRender", root, interaction.renderInteractions)
            addEventHandler("onClientPreRender", root, interaction.onPreRender)
            addEventHandler("onClientClick", root, interaction.onElementClick)
            addEventHandler("onClientClick", root, interaction.onTabClick)
        else
            showChat(true)
            showCursor(false)

            setElementData(localPlayer, 'player:hudof', false)

            interaction.interact_type = nil
            interaction.interact_element = nil
            interaction.cursorX, interaction.cursorY = 0, 0
            interaction.enabled = false
            effect_enabled = false

            removeEventHandler("onClientRender", root, interaction.onRender)
            removeEventHandler("onClientRender", root, interaction.renderInteractions)
            removeEventHandler("onClientPreRender", root, interaction.onPreRender)
            removeEventHandler("onClientClick", root, interaction.onElementClick)
            removeEventHandler("onClientClick", root, interaction.onTabClick)
        end
    end)

    function turnOffInteraction()
        if interaction.enabled then
            showChat(true)
            showCursor(false)
    
            setElementData(localPlayer, 'player:hudof', false)
    
            interaction.interact_type = nil
            interaction.interact_element = nil
            interaction.cursorX, interaction.cursorY = 0, 0
            interaction.enabled = false
            effect_enabled = false
    
            removeEventHandler("onClientRender", root, interaction.onRender)
            removeEventHandler("onClientRender", root, interaction.renderInteractions)
            removeEventHandler("onClientPreRender", root, interaction.onPreRender)
            removeEventHandler("onClientClick", root, interaction.onElementClick)
            removeEventHandler("onClientClick", root, interaction.onTabClick)
        end
    end
end
addEventHandler("onClientResourceStart", resourceRoot, interaction.onLoad)

interaction.onStop = function()
    for key, texture in ipairs(interaction.textures) do
        if isElement(texture) then
            destroyElement(texture)
        end
    end

    if interaction.enabled then
        showChat(true)
    end

    interaction.textures = {}
    interaction.fonts = {}
end
addEventHandler("onClientResourceStop", resourceRoot, interaction.onStop)

interaction.onInteractionClear = function()
    if interaction.enabled then
        interaction.interact_type = nil
        interaction.interact_element = nil
        interaction.cursorX, interaction.cursorY = 0, 0
        tabs.clicked = nil
        tabs.hovered = nil
    end
end
addEventHandler("onClientInteractionClear", resourceRoot, interaction.onInteractionClear)

local enableWallTimer = function(isIRT)
    if wall_timer then return end

    wall_timer = setTimer(function()
        local player_pos = Vector3(getElementPosition(localPlayer))
        local camera = Vector3(getCameraMatrix())

        for _, vehicle in ipairs(getElementsWithinRange(player_pos.x, player_pos.y, player_pos.z, INTERACTION_DISTANCE, "vehicle")) do
            if isElement(vehicle) then
                interaction.createWallEffect(vehicle, isIRT)

                local position = Vector3(getElementPosition(localPlayer))
                local distance = getDistanceBetweenPoints2D(camera.x, camera.y, player_pos.x, player_pos.y)

                if distance < INTERACTION_DISTANCE and effect_enabled then
                    interaction.createWallEffect(vehicle, isIRT)
                end
                if distance > INTERACTION_DISTANCE or not effect_enabled then
                    interaction.destroyShader(vehicle)
                end
            end
        end

        for _, player in ipairs(getElementsWithinRange(player_pos.x, player_pos.y, player_pos.z, INTERACTION_DISTANCE, "player")) do
            if isElementStreamedIn(player) and isElement(player) then
                interaction.createWallEffect(player, isIRT)

                local position = Vector3(getElementPosition(localPlayer))
                local distance = getDistanceBetweenPoints3D(camera.x, camera.y, camera.z, player_pos.x, player_pos.y, player_pos.z)

                if distance < INTERACTION_DISTANCE and effect_enabled then
                    interaction.createWallEffect(player, isIRT)
                end
                if distance > INTERACTION_DISTANCE or not effect_enabled then
                    interaction.destroyShader(player)
                end
            end
        end

        for _, object in ipairs(getElementsWithinRange(player_pos.x, player_pos.y, player_pos.z, INTERACTION_DISTANCE, "object")) do
            if isElementStreamedIn(object) and isElement(object) and (allowedObjectsID[getElementModel(object)] or getElementData(object, 'obj:canInteract')) then
                interaction.createWallEffect(object, isIRT)

                local position = Vector3(getElementPosition(localPlayer))
                local distance = getDistanceBetweenPoints3D(camera.x, camera.y, camera.z, player_pos.x, player_pos.y, player_pos.z)

                if distance < INTERACTION_DISTANCE and effect_enabled then
                    interaction.createWallEffect(object, isIRT)
                end
                if distance > INTERACTION_DISTANCE or not effect_enabled then
                    interaction.destroyShader(object)
                end
            end
        end

    end, 100, 0)
end

local disableWallTimer = function()
    if wall_timer then
        killTimer(wall_timer)
        wall_timer = nil
    end
end

local onClickInteraction = function(button)
    if interaction.interact_type then
        if INTERACTIONS[interaction.interact_type] == nil then
            return
        end
        for key, interact in ipairs(INTERACTIONS[interaction.interact_type]) do
            if button == interact.name then
                interaction.selected_interact = interact.name
                if (interact.clientFunct ~= nil and type(interact.clientFunct) == "function") then
                    return interact.clientFunct(interaction.interact_element)
                end
            end
        end
    end
end
addEventHandler("onInteractionClickTab", resourceRoot, onClickInteraction)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

local tabsColors = {

    ['quit'] = {255, 125, 125},
    ['other'] = {125, 255, 125},

}

local drawInteractionTab = function(name, text, x, y, w, h, alignX, alignY)
    if tab_hover and not isMouseInPosition(tab_hover[1], tab_hover[2], tab_hover[3], tab_hover[4]) then
        tab_hover = nil
    end

    local color = tabsColors[name] or {125, 255, 125}
    local alpha = 175

    if isMouseInPosition(x, y, w, h) then
        tabs.hovered = name

        if tab_hover == nil then
            tab_hover = {x, y, w, h}
        end

        if getKeyState("mouse1") then
            tabs.clicked = name
        else
            tabs.clicked = nil
        end

        if getKeyState("mouse1") then
            alpha = 255
        else
            alpha = 225
        end

        if getKeyState("mouse1") and tabs.click ~= true then
            tabs.click = true
        elseif not getKeyState("mouse1") and tabs.click == true then
            tabs.click = false
        end
    end

    dxDrawImage(x, y, w, h, interaction.textures.rectangle, 0, 0, 0, tocolor(color[1], color[2], color[3], alpha))
    dxDrawText(text, x + 30/zoom, y + h/2, nil, nil, tocolor(255, 255, 255, 255), 1, interaction.fonts.light, 'left', 'center', false, false, true)
    dxDrawImage(x + 5/zoom, y + 5/zoom, 20/zoom, 20/zoom, interaction.getElementIcon(interaction.interact_type, name), 0, 0, 0, tocolor(255, 255, 255, 255))
end

interaction.getElementIcon = function(name, tabName)
    return interactionIcons[name][tabName]
end

interaction.switchWall = function(object, isIRT)
    if object then
        interaction.enableWall(isIRT)
    else
        interaction.disableWall()
    end
end
addEventHandler("switchWall", resourceRoot, interaction.switchWall)

interaction.enableWall = function(isIRT)
    if isIRT and post_aura then
        render_target = dxCreateRenderTarget(screen.x, screen.y, true)
        shader = dxCreateShader("assets/fx/post_edge.fx")
        if not render_target or not shader then
            is_irt_enabled = false
            return
        else
            dxSetShaderValue(shader, "sTex0", render_target)
            dxSetShaderValue(shader, "sRes", screen.x, screen.y)
            is_irt_enabled = true 
        end
    else
        is_irt_enabled = false
    end
    wall_effect = true
    enableWallTimer(is_irt_enabled)
end

interaction.disableWall = function()
    disableWallTimer()
    wall_effect = false
    if isElement(render_target) then
        destroyElement(render_target)
    end
end

interaction.createWallEffect = function(object, isIRT)
    if getElementType(object) == "player" and object == localPlayer then return end

    if not wall_shader[object] then
        if isIRT then
            wall_shader[object] = dxCreateShader("assets/fx/ped_wall_mrt.fx", 1, 0, true, "all")
        else
            wall_shader[object] = dxCreateShader("assets/fx/ped_wall.fx", 1, 0, true, "all")
        end

        if not wall_shader[object] then
            return false
        else
            if render_target then
                dxSetShaderValue(wall_shader[object], "secondRT", render_target)
            end
            if getElementType(object) == "vehicle" then
                dxSetShaderValue(wall_shader[object], "sColorizePed", {125/255, 255/255, 125/255, 1})
            elseif getElementType(object) == "player" then
                dxSetShaderValue(wall_shader[object], "sColorizePed", {125/255, 255/255, 125/255, 1})
            elseif getElementType(object) == "object" then
                dxSetShaderValue(wall_shader[object], "sColorizePed", {125/255, 255/255, 125/255, 1})
            end
            dxSetShaderValue(wall_shader[object], "sSpecularPower", power)
            engineApplyShaderToWorldTexture(wall_shader[object], "*", object)
            return true
        end
    end
end

interaction.destroyShader = function(object)
    if wall_shader[object] then
        engineRemoveShaderFromWorldTexture(wall_shader[object], "*", object)
        destroyElement(wall_shader[object])
        wall_shader[object] = nil
    end
end

interaction.onElementClick = function(button, state, _, _, _, _, _, element)
    if not interaction.enabled then return end
    if element == localPlayer then return end
    if interaction.interact_type ~= nil then return end

    if element and state == "up" then
        if isElement(element) then
            if interaction.interact_type == nil then
                local elementPosition = Vector3(getElementPosition(element))
                local playerPosition = Vector3(getElementPosition(localPlayer))
                local distance = getDistanceBetweenPoints2D(playerPosition.x, playerPosition.y, elementPosition.x, elementPosition.y)

                if distance < INTERACTION_DISTANCE then
                    reloadInteractions()
                    triggerEvent("onClientInteractionClear", resourceRoot)

                    if getElementType(element) == "vehicle" and isVehicleBlown(element) then
                        triggerEvent("onClientInteractionClear", resourceRoot)
                        return
                    end

                    if getElementType(element) == "vehicle" then

                        if not getElementData(element, 'vehicle:id') then
                            triggerEvent("onClientInteractionClear", resourceRoot)
                            return
                        end

                        if getElementData(element, 'vehicle:id') then
                            addInteractionOption("vehicle", {
                                name = "mask",
                                action = "Maska",
                                clientFunct = function(element)
                                    triggerServerEvent("envInteraction", resourceRoot, element, "openVehicleMask")
                                end
                            })
                    
                            addInteractionOption("vehicle", {
                                name = "trunk",
                                action = "Bagażnik",
                                clientFunct = function(element)
                                    triggerServerEvent("envInteraction", resourceRoot, element, "openVehicleTrunk")
                                end
                            })
                    
                            addInteractionOption("vehicle", {
                                name = "lock",
                                action = "Zamek",
                                clientFunct = function(element)
                                    triggerServerEvent("envInteraction", resourceRoot, element, "changeVehicleLock")
                                end
                            })
                        end

                        if getElementData(localPlayer, 'player:admin') then
                            addInteractionOption("vehicle", {
                                name = "park",
                                action = "Oddaj do przechowalni",
                                clientFunct = function(element)
                                    triggerServerEvent("envInteraction", resourceRoot, element, 'parkVehicle')
                                    triggerEvent("onClientInteractionClear", resourceRoot)
                                end
                            })

                            addInteractionOption("vehicle", {
                                name = "showInformations",
                                action = "Informacje o pojeździe",
                                clientFunct = function(element)
                                    triggerServerEvent("envInteraction", resourceRoot, element, 'showCarInfo')
                                end
                            })
                        end

                        if getElementData(localPlayer, 'player:faction') == 'SARA' or getElementData(localPlayer, 'player:faction') == 'SAPD' then
                            addInteractionOption("vehicle", {
                                name = "showPrzeglad",
                                action = "Informacje o pojeździe",
                                clientFunct = function(element)
                                    triggerServerEvent("envInteraction", resourceRoot, element, 'showCarData')
                                end
                            })
                        end
                    end

                    if getElementType(element) == "object" then
                        if getElementData(element, 'obj:canInteract') then
                            
                        else
                            if not allowedObjectsID[getElementModel(element)] then
                                triggerEvent("onClientInteractionClear", resourceRoot)
                                return
                            end
                        end
                        
                        addObjectsInteraction(getElementModel(element))
                    end

                    

                    interaction.interact_type = getElementType(element)
                    interaction.interact_element = element
                    interaction.cursorX, interaction.cursorY = getCursorPosition()
                end
            end
        end
    elseif element == nil or element == false then
        triggerEvent("onClientInteractionClear", resourceRoot)
    end
end

interaction.onTabClick = function(button, state)
    if button == "left" then
        if state == "up" then
            triggerEvent("onInteractionClickTab", resourceRoot, tabs.clicked)
        end
    end
end

interaction.onPreRender = function()
    if not wall_effect then return end
    if not is_irt_enabled then return end
    if not effect_enabled then return end

    dxSetRenderTarget(render_target, true)
    dxSetRenderTarget()
end

interaction.onRender = function()
    if not interaction.enabled then return end
    drawBWRectangle(0, 0, sx, sy, tocolor(1, 255, 255, 55), false)
    dxDrawImage(0, 0, sx, sy, 'assets/images/vignette.png', 0, 0, 0, tocolor(46, 117, 111, interaction.animations.vig_alpha))
    dxDrawImage(sx / 2 - (632/2)/zoom, sy - 177/zoom, 632/zoom, 177/zoom, 'assets/images/green_shadow.png', 0, 0, 0, tocolor(46, 117, 111, interaction.animations.vig_alpha))

    dxDrawImage(0, 0, screen.x, screen.y, shader, 0, 0, 0, tocolor(255, 255, 255, 255))

    dxDrawText("Interakcja z otoczeniem", 0, screen.y - 65/zoom, screen.x, screen.y - 65/zoom, tocolor(46, 117, 111, 255), 1, interaction.fonts.bold_big, "center", "bottom")
    dxDrawText("Kliknij lewym przyciskiem myszy na podświetlony\nobiekt, aby wykonać z nim interakcję.", 0, screen.y - 65/zoom, screen.x, screen.y - 65/zoom, tocolor(255, 255, 255, 225), 1, interaction.fonts.light_tip, "center", "top")
end

interaction.renderInteractions = function()
    if not interaction.enabled then return end
    if interaction.interact_type == nil then return end
    if INTERACTIONS[interaction.interact_type] == nil then return end

    for key, interact in ipairs(INTERACTIONS[interaction.interact_type]) do
        offset = ((key - 1)) * (30/zoom + 2)
        drawInteractionTab(interact.name, interact.action, screen.x * interaction.cursorX + 25/zoom, screen.y * interaction.cursorY + offset + 0.1/zoom, 190/zoom, 30/zoom, "left", "center")
    end
end
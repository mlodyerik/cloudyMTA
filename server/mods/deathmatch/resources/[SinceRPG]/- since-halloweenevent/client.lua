function dxDrawShadowedText(text, x, y, w, h, color, alpha, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(text:gsub('#%x%x%x%x%x%x', ''), x + 1, y + 1, nil, nil, tocolor(0, 0, 0, alpha), scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
    dxDrawText(text, x, y, nil, nil, color, scale, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, subPixelPositioning, fRotation, fRotationCenterX, fRotationCenterY)
end

function addComma(number)
    number = tostring(number)
    return number:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

function renderAddingPoints()
    --dxDrawImage(sx / 2 - (369/2)/zoom, sy - 360/zoom, 369/zoom, 180/zoom, "data/summer.png", 0, 0, 0, tocolor(255, 255, 255, cache.alpha))
    dxDrawShadowedText("Otrzymujesz punkty eventowe", sx / 2, sy - 200/zoom, nil, nil, tocolor(255, 255, 255, cache.alpha), cache.alpha, 1, exports['since-fonts']:getFont('Inter-Bold', 14/zoom), "center", "bottom")
    dxDrawShadowedText(addComma(cache.value)..' #73b2ff(+ '..addComma(cache.adding)..')', sx / 2, sy - 200/zoom, nil, nil, tocolor(255, 117, 198, cache.alpha), cache.alpha, 1, exports['since-fonts']:getFont('Inter-Medium', 13/zoom), "center", "top", false, false, false, true)
end

function addEventPoints(value)
    if value and tonumber(value) then
        triggerServerEvent('addPlayerEventPoints', resourceRoot, value)
        -- local playerData = getElementData(localPlayer, "player:data") or {}

        -- if not playerData.eventPoints then
        --     playerData.eventPoints = 0
        -- end

        -- cache.alpha = 0
        -- cache.adding = value
        -- cache.value = playerData.eventPoints
        -- addEventHandler("onClientRender", root, renderAddingPoints)

        -- animate(0, 255, "Linear", 500, function(a)
        --     cache.alpha = a
        -- end, function()
        --     animate(cache.value, playerData.eventPoints + value, "Linear", 1000, function(a)
        --         cache.value = math.floor(a)
        --     end)

        --     setTimer(function()        
        --         triggerServerEvent('addPlayerEventPoints', resourceRoot, value)

        --         animate(255, 0, "Linear", 500, function(a)
        --             cache.alpha = a
        --         end, function()
        --             removeEventHandler("onClientRender", root, renderAddingPoints)
        --         end)
        --     end, 2000, 1)
        -- end)
    end
end


local pos, camerapos, count, AFK = false, false, 0, false
local function isAFK()
    if (getElementData(localPlayer, "player:job") == 'maszynista') then
        AFK = true
    else
        if pos and camerapos then
            local cx, cy, cz, lx, ly, lz = getCameraMatrix(localPlayer)
            local x, y, z = getElementPosition(localPlayer)

            if (x == pos[1] and y == pos[2] and z == pos[3] and cx == camerapos[1] and cy == camerapos[2] and cz == camerapos[3] and lx == camerapos[4] and ly == camerapos[5] and lz == camerapos[6]) then
                count = count + 1
                if (count >= 60 and not AFK) then
                    AFK = true
                    outputChatBox('↻ #FFFFFFPrzechodzisz w tryb afk, punkty eventu nie są naliczane podczas tego trybu.', 255, 55, 55, true)
                end
            else
                if AFK then
                    AFK = false
                    outputChatBox('↻ #FFFFFFWznawiasz tryb gry, punkty eventu będą się nabijać.', 255, 55, 55, true)
                end
                pos, camerapos, count = false, false, 0
            end
        else
            local cx, cy, cz, lx, ly, lz = getCameraMatrix(localPlayer)
            local x, y, z = getElementPosition(localPlayer)
            pos, camerapos = {x, y, z}, {cx, cy, cz, lx, ly, lz}
        end
    end
end
setTimer(isAFK, 1000, 0)

local multiplier = 1

function getPointsCountToAdd()
    if AFK then return 0 end
    local c = 0
    if getElementData(localPlayer, 'player:job') or getElementData(localPlayer, 'player:faction') then
        c = c + 2
    end
    c = c + 1
    return c * multiplier
end

local loaded = false
addEventHandler('onClientElementDataChange', localPlayer, function(key, old, new)
    if key == 'player:spawn' and not loaded then
        loaded = true
        setTimer(function()
            if not getElementData(localPlayer, 'player:spawn') then return end
            if not getElementData(localPlayer, 'player:sid') then return end
            local points = getPointsCountToAdd()
            if points > 0 then
                addEventPoints(points)
            end
        end, 60000, 0)
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    if not loaded then
        if not getElementData(localPlayer, 'player:spawn') then return end
        loaded = true
        setTimer(function()
            if not getElementData(localPlayer, 'player:spawn') then return end
            if not getElementData(localPlayer, 'player:sid') then return end
            local points = getPointsCountToAdd()
            if points > 0 then
                addEventPoints(points)
            end
        end, 60000, 0)
    end
end)


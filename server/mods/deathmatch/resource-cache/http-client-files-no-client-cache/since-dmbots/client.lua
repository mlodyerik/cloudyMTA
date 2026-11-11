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

function initBotsNametags()
    local x, y, z = getElementPosition(localPlayer)
    local peds = getElementsWithinRange(x, y, z, 100, 'ped')

    for i, v in ipairs(peds) do
        if getElementData(v, 'bot:data') and getElementHealth(v) > 0 then
            local name = getElementData(v, 'bot:data').name
            local level = getElementData(v, 'bot:data').level
            local x, y, z = getPedBonePosition(v, 8)
            local sx, sy = getScreenFromWorldPosition(x, y, z + 0.65)
            local dist = math.max(getDistanceBetweenPoints3D(Vector3(getCameraMatrix()), Vector3(x, y, z)) - 5, 0)

            local scale = 0.95 - dist / 25
            scale = math.max(scale, 0)

            if sx and sy then
                dxDrawRoundedRectangle(sx - 75*scale, sy - 5*scale, 42*scale, 42*scale, 5*scale, tocolor(65, 35, 35, 255), false, true)
                dxDrawText(level, sx - 75*scale + 21*scale, sy - 5*scale + 26*scale, nil, nil, tocolor(255, 255, 255, 200), scale, exports['since-fonts']:getFont('Inter-Black', 12), 'center', 'bottom', false, false, false, false, true)
                dxDrawText('POZIOM', sx - 75*scale + 21*scale, sy - 5*scale + 26*scale, nil, nil, tocolor(255, 255, 255, 200), scale, exports['since-fonts']:getFont('Inter-Medium', 6), 'center', 'top', false, false, false, false, true)

                dxDrawText(name:gsub('#%x%x%x%x%x%x', ''), sx - 26*scale + 1, sy + 1, nil, nil, tocolor(0,0,0,200), scale, exports['since-fonts']:getFont('Inter-SemiBold', 12), 'left', 'top', false, false, false, false, true)
                dxDrawText(name, sx - 26*scale, sy, nil, nil, tocolor(255, 255, 255), scale, exports['since-fonts']:getFont('Inter-SemiBold', 12), 'left', 'top', false, false, false, true, true)

                local hp = getElementHealth(v)
                local armor = getPedArmor(v)

                dxDrawRectangle(sx - 26*scale + 1, sy + 25 * scale + 1, 60*scale, 5*scale, tocolor(100, 15, 15, 175))
                dxDrawRectangle(sx - 26*scale, sy + 25 * scale, 60*scale * (hp/100), 5*scale, tocolor(255, 25, 25, 255))
            end
        end
    end
end
addEventHandler('onClientRender', root, initBotsNametags)

function initBotAttack(attacker )
    if source and getElementData(source, 'bot:data') and attacker and getElementType(attacker) == 'player' then
        cancelEvent()

        local x, y, z = getElementPosition(source)
        local x2, y2, z2 = getElementPosition(attacker)
        local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)

        if dist > 50 then
            return
        end

        if isPedDead(source) then
            return
        end

        local botData = getElementData(source, 'bot:data')
        local level = botData.level
        local health = getElementHealth(source)

        if health <= 0 then
            triggerServerEvent('killPed', resourceRoot, attacker, source)
            return
        end
        
        setElementHealth(source, health - (0.15 - level/3))

        if getElementData(source, 'bot:data').shooting then
            return
        end
        
        triggerServerEvent('switchBotAttack', resourceRoot, source, attacker, true)
    end
end
addEventHandler("onClientPedDamage", root, initBotAttack)
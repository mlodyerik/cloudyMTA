local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local zoom = zoom * 0.8
local deathTable = {}
local clientFonts = {}

function addDeathInfo(tbl)
    if tbl and type(tbl) == 'table' and not exports['since-dashboard']:isPlayerPassive(localPlayer) then
        local killInfo = {

            id = #deathTable,
            attacker = tbl.attack,
            killed = tbl.killed,
            weapon = tbl.weapon,
            alpha = 0,
            tickrate = getTickCount()

        }

        deathTable[#deathTable + 1] = killInfo
    end
end
addEvent('addDeathInfo', true)
addEventHandler('addDeathInfo', root, addDeathInfo)

function renderDeathInfo()
    if not exports['since-dashboard']:isPlayerPassive(localPlayer) then
        local offset = 0
        for i, v in ipairs(deathTable) do 
            if not v.attacker then v.attacker = '---' end
            if not v.killed then v.killed = '---' end
            local width = 25/zoom + dxGetTextWidth(v.attacker, 1, clientFonts[2]) + dxGetTextWidth(v.killed, 1, clientFonts[2])

            dxDrawText(v.attacker, sx - 15/zoom - width + 1, sy / 2 - 282/zoom + offset + 1, nil, nil, tocolor(0, 0, 0, v.alpha), 1, clientFonts[2], 'left', 'center')
            dxDrawText(v.attacker, sx - 15/zoom - width, sy / 2 - 282/zoom + offset, nil, nil, tocolor(125, 255, 125, v.alpha), 1, clientFonts[2], 'left', 'center')
            dxDrawText(v.killed, sx - 10/zoom + 1, sy / 2 - 282/zoom + offset + 1, nil, nil, tocolor(0, 0, 0, v.alpha), 1, clientFonts[2], 'right', 'center')
            dxDrawText(v.killed, sx - 10/zoom, sy / 2 - 282/zoom + offset, nil, nil, tocolor(255, 75, 75, v.alpha), 1, clientFonts[2], 'right', 'center')
            if fileExists('weapons/'..v.weapon..'.png') then
                dxDrawImage(sx - 25/zoom - (width+75/zoom), sy / 2 - 293/zoom + offset, 75/zoom, 35/zoom, 'weapons/'..v.weapon..'.png', 0, 0, 0, tocolor(255, 255, 255, v.alpha))
            end
            dxDrawImage(sx - 32/zoom - dxGetTextWidth(v.killed, 1, clientFonts[2]), sy / 2 - 290/zoom + offset, 15/zoom, 15/zoom, 'kill.png', 0, 0, 0, tocolor(255, 255, 255, v.alpha))

            if getTickCount() - v.tickrate > 5000 then
                v.alpha = math.max(0, v.alpha - 15)

                if v.alpha == 0 then
                    table.remove(deathTable, i)
                end
            else
                v.alpha = math.min(255, v.alpha + 15)
            end

            offset = offset + 35/zoom + 2
        end
    end
end
addEventHandler('onClientRender', root, renderDeathInfo)

function scriptStart()
    clientFonts[1] = getFont('Inter-Bold', 10/zoom)
    clientFonts[2] = getFont('Inter-Medium', 10/zoom)
end
addEventHandler('onClientResourceStart', resourceRoot, scriptStart)
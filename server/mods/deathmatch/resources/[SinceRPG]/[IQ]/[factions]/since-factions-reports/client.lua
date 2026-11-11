sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

Reports = {}

Reports.type = 'report'

Reports.elements = {}
Reports.list = {}

k = 1
n = 5
m = 5

local dxMemo = dxCreateTexture('data/images/dxMemo.png', 'argb', false, 'clamp')

function render()
    if (Reports.type == 'report') then
        Reports.renderReport()
    elseif (Reports.type == 'list') then
        Reports.renderList()
    end
end

function click(button, state)
    if (button == 'left' and state == 'down') then
        if (Reports.type == 'report') then
            Reports.onClickReport()
        elseif (Reports.type == 'list') then
            Reports.onClickList()
        end
    end
end

addEventHandler('onClientResourceStop', resourceRoot, function ()
    exports['since-gridlist']:destroyGridList(Reports.elements[1])
    exports['since-memo']:dxDestroyMemo('report')
end)

addEvent('since-factions-reports:closeReport', true)
addEventHandler('since-factions-reports:closeReport', resourceRoot, function ()
    removeEventHandler("onClientRender", root, render)
    removeEventHandler("onClientClick", root, click)
    showCursor(false)

    exports['since-gridlist']:destroyGridList(Reports.elements[1])
    exports['since-memo']:dxDestroyMemo('report')
end)

local toggle = false

function scrollDown()
    if n < #Reports.list then
        k = k + 1
        n = n + 1
    end
end

function scrollUp()
    if k > 1 then
        k = k - 1
        n = n - 1
    end
end

addCommandHandler('112', function ()
    if (not getElementData(localPlayer, 'player:sid')) then return end

    if (toggle) then
        removeEventHandler("onClientRender", root, render)
        removeEventHandler("onClientClick", root, click)
        showCursor(false)

        exports['since-gridlist']:destroyGridList(Reports.elements[1])
        exports['since-memo']:dxDestroyMemo('report')

        if (Reports.type == 'list') then
            Reports.list = {}

            unbindKey('mouse_wheel_up', 'down', scrollUp)
            unbindKey('mouse_wheel_down', 'down', scrollDown)
        end
    else
        addEventHandler("onClientRender", root, render)
        addEventHandler("onClientClick", root, click)
        showCursor(true, false)

        if (getElementData(localPlayer, 'player:faction')) then
            Reports.type = 'list'

            triggerServerEvent('since-factions-reports:getReports', resourceRoot)

            bindKey('mouse_wheel_up', 'down', scrollUp)
            bindKey('mouse_wheel_down', 'down', scrollDown)
        else
            Reports.type = 'report'

            local factions = {
                {
                    name = "SAPD"
                },
                {
                    name = "SARA"
                },
                {
                    name = "SAMC"
                },
                {
                    name = "TSA"
                },
                {
                    name = "SAFD"
                }
            }

            Reports.elements[1] = exports['since-gridlist']:createGridList(sx/2-300/zoom/2, sy/2-520/zoom/2 + 50/zoom, 300/zoom, 'Wybierz frakcję...', 3, factions)
            
            exports['since-memo']:dxCreateMemo('report', 'Wprowadź treść zgłoszenia...', sx/2-300/zoom/2, sy/2-170/zoom, 300/zoom, 360/zoom, dxMemo, exports['since-fonts']:getFont('Inter-Regular', 11/zoom), 1, 100)
        end
    end

    toggle = not toggle
end)

addEvent('since-factions-reports:receiveReports', true)
addEventHandler('since-factions-reports:receiveReports', resourceRoot, function (reports)
    Reports.list = reports
end)
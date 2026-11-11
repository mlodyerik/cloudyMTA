clientCache = {}

addCommandHandler('pos', function()
    local plr = localPlayer
    local x, y, z = getElementPosition(plr)
    local x, y, z = string.format("%.2f", x), string.format("%.2f", y), string.format("%.2f", z)
    local text = '{'..x..', '..y..', '..z..'},'

    outputChatBox('Pozycja plamy oleju: '..text, 0, 255, 0, true)
    setClipboard(text)
end)

function renderOilStains()
    local shapes = getElementsByType('colshape', resourceRoot)
    local px, py, pz = getElementPosition(localPlayer)
    for i, v in ipairs(shapes) do
        local x, y, z = getElementPosition(v)
        local z = getGroundPosition(x, y, z)
        local dist = getDistanceBetweenPoints3D(px, py, pz, x, y, z)
        local size = 1

        if dist < 100 then
            dxDrawMaterialLine3D(x+size, y+size, z + 0.03, x-size, y-size, z + 0.03, clientCache.oilTexture, size*3.2, tocolor(255, 255, 255, 245), false, x, y, z)
        end
    end
end

function onScriptStart()
    if not clientCache.oilTexture then
        clientCache.oilTexture = dxCreateTexture('data/oilstain.png')

        addEventHandler('onClientRender', root, renderOilStains)
    end
end
addEventHandler('onClientResourceStart', resourceRoot, onScriptStart)

function onScriptStop()
    if clientCache.oilTexture then
        destroyElement(clientCache.oilTexture)
        clientCache.oilTexture = nil
    end
end
addEventHandler('onClientResourceStop', resourceRoot, onScriptStop)

setDevelopmentMode( true )
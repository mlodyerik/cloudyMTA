  

sx, sy = guiGetScreenSize()
zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1
zoom = zoom * 1.4
data = {textures = {}}

fonts = {

    [1] = exports['since-fonts']:getFont('Inter-Bold', 24/zoom),
    [2] = exports['since-fonts']:getFont('Inter-Medium', 18/zoom),
    [3] = exports['since-fonts']:getFont('Inter-Bold', 16/zoom),
    [4] = exports['since-fonts']:getFont('Inter-Medium', 14/zoom),

}

function loadTextures()
    local tex = {[1] = 'mask', [2] = 'map', [3] = 'overlay', [4] = 'bg'}

    for i, v in ipairs(tex) do
        data.textures[i] = dxCreateTexture('img/'..v..'.png', 'argb', true, 'clamp', '2d')
    end
end
addEventHandler('onClientResourceStart', resourceRoot, loadTextures)

function destroyTextures()
    for i, v in ipairs(data.textures) do
        destroyElement(v)
    end
end
addEventHandler('onClientResourceStop', resourceRoot, destroyTextures)

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle);
    local dx = math.cos(a) * dist;
    local dy = math.sin(a) * dist;
    return x+dx, y+dy;
end
getResourceName(getThisResource(), true, 416626204); if true then return end
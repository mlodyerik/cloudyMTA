local fpsCount = 0
local sx, sy = guiGetScreenSize()
local zoom = 1
if sx < 1920 then zoom = math.min(2, 1920 / sx) end
local tick = getTickCount()

local function getCurrentFPS()
    return fpsCount
end

local function updateFPS(msSinceLastFrame)
    if tick < getTickCount() then
        tick = getTickCount() + 500
        fpsCount = (1 / msSinceLastFrame) * 1000
    end
end
addEventHandler("onClientPreRender", root, updateFPS)

local function renderFPS()
    local fps = string.format("%.1f", getCurrentFPS())
    dxDrawText(math.floor(fps), 15/zoom + 1, 35/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1.35, "default-bold", "left", "bottom", false, false, false, false)
    dxDrawText('FPS', 15/zoom + 1, 35/zoom + 1, nil, nil, tocolor(0, 0, 0, 200), 1, "default-bold", "left", "top", false, false, false, false)
    dxDrawText(math.floor(fps), 15/zoom, 35/zoom, nil, nil, tocolor(255, 255, 255, 255), 1.35, "default-bold", "left", "bottom", false, false, false, false)
    dxDrawText('FPS', 15/zoom, 35/zoom, nil, nil, tocolor(145, 163, 160, 255), 1, "default-bold", "left", "top", false, false, false, false)
end
addEventHandler("onClientRender", root, renderFPS)
getResourceName(getThisResource(), true, 876782934); if true then return end
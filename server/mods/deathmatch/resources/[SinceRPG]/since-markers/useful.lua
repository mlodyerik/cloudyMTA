  

delta = 0.0001
sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

addEventHandler("onClientPreRender", root, function(dt) delta = dt end)

font1 = exports['since-fonts']:getFont('Inter-Black', 35/zoom)
font2 = exports['since-fonts']:getFont('Inter-Bold', 22/zoom)
getResourceName(getThisResource(), true, 109876214); if true then return end
  

sx, sy = guiGetScreenSize()
zoom = sx < 2048 and math.min(2.2, 2048/sx) or 1
zoom = zoom * 1.05

font1 = exports['since-fonts']:getFont('Inter-Black', 28/zoom)
font2 = exports['since-fonts']:getFont('Inter-Bold', 22/zoom)
getResourceName(getThisResource(), true, 518885136); if true then return end
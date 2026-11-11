sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.82

mask = dxCreateTexture('data/mask.png')
getResourceName(getThisResource(), true, 546031511); if true then return end
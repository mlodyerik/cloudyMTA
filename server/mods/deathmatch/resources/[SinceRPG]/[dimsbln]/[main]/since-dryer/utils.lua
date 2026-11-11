function isPedAiming(plr)
    if isElement(plr) then
        if getElementType(plr) == "player" or getElementType(plr) == "vehicle" then
            if getPedTask(plr, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
                return true
            end
        end
    end
    return false
end

sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

font1 = exports["since-fonts"]:getFont("Inter-Medium", 10/zoom, false)
font2 = exports["since-fonts"]:getFont("Inter-Bold", 13/zoom, false)
getResourceName(getThisResource(), true, 194865774); if true then return end
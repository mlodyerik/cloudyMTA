local pos, camerapos, count = false, false, 0

function isAFK()
    if pos and camerapos then
        local x, y, z, lx, ly, lz = getCameraMatrix(localPlayer)
        local xp, yp, zp = getElementPosition(localPlayer)
        if getElementData(localPlayer, "player:faction") then
            if count >= 300 and not afk then
                outputChatBox("#fcf003* #ffffffZe względu na brak aktywności został na Ciebie nałożony system chwilowej przerwy!", _, _, _, true)
                afk = true
                triggerServerEvent("enonek-antyafk:toggle", resourceRoot, true)
            end
        end
        if getElementData(localPlayer, "player:job") == "Mechanik" then
            if count >= 300 and not afk then
                outputChatBox("#fcf003* #ffffffZe względu na brak aktywności twoja praca została przerwana!", _, _, _, true)
                triggerEvent("enonek-job-mechanic:jobEnd", localPlayer)
            end
        end
        if (xp == pos[1] and yp == pos[2] and zp == pos[3]) then
            count = count + 1
        elseif (x == camerapos[1] and y == camerapos[2] and z == camerapos[3] and lx == camerapos[4] and ly == camerapos[5] and lz == camerapos[6]) then
            count = count + 1
        else
            if afk then
                outputChatBox("#fcf003* #ffffffPowróciłeś(aś) do statusu czynnej służby!", _, _, _, true)
                afk = false
                triggerServerEvent("enonek-antyafk:toggle", resourceRoot, false)
            end
            pos, camerapos, count = false, false, 0
        end
    else
        local x, y, z, lx, ly, lz = getCameraMatrix(localPlayer)
        local xp, yp, zp = getElementPosition(localPlayer)
        pos, camerapos = {xp, yp, zp}, {x, y, z, lx, ly, lz}
    end
end
setTimer(isAFK, 1000, 0)
getResourceName(getThisResource(), true, 580481024); if true then return end
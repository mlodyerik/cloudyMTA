local szambo = {
    hoseMarker = false,
    syncObject = false,
    request = false,
    hoses = {},
    hose = false,
    myVehicle = false,
    max = 1000,
    rt = nil,
    rt2 = nil,
    hoseTxt = dxCreateTexture("data/hose.png"),
    pozostalo = 100,
    sounds = {},
    blips = {},
}
local lastPos = Vector3(getElementPosition(localPlayer))
local studzienki = {
    {235.64, 978.41, 28.20, -0.00, 0.00, 110.02},
    {716.13, 1099.92, 28.47, -0.00, 0.00, 284.86},
    {1072.26, 1190.31, 10.67, -0.00, 0.00, 271.97},
    {1004.83, 1306.56, 10.67, -0.00, 0.00, 1.41},
    {1011.05, 1555.12, 10.67, -0.00, 0.00, 3.82},
    {1086.16, 1810.18, 10.67, -0.00, 0.00, 267.54},
    {946.97, 1856.28, 10.67, -0.00, 0.00, 85.20},
    {904.44, 2034.31, 10.67, -0.00, 0.00, 4.63},
    {967.90, 2196.89, 10.67, -0.00, 0.00, 275.20},
    {1031.77, 2296.85, 10.67, -0.00, 0.00, 79.97},
    {1046.01, 2396.35, 10.67, -0.00, 0.00, 223.35},
    {939.15, 2396.97, 10.67, -0.00, 0.00, 91.25},
    {1384.04, 1928.02, 10.67, -0.00, 0.00, 1.16},
    {1451.88, 1976.67, 10.67, -0.00, 0.00, 269.71},
    {1490.68, 1918.36, 10.67, -0.00, 0.00, 176.25},
    {1595.96, 2015.95, 10.67, -0.00, 0.00, 292.68},
    {1621.70, 2135.84, 10.67, -0.00, 0.00, 0.36},
    {1730.75, 2236.02, 10.67, -0.00, 0.00, 0.36},
    {1587.32, 2276.60, 10.68, -0.00, 0.00, 88.18},
    {2033.07, 2279.33, 10.67, -0.00, 0.00, 271.08},
    {2202.68, 2134.17, 10.67, -0.00, 0.00, 265.44},
    {2455.24, 2152.63, 10.67, -0.00, 0.00, 262.62},
    {2524.01, 2089.94, 10.67, -0.00, 0.00, 179.63},
    {2587.24, 2109.44, 10.67, -0.00, 0.00, 293.64},
    {2503.85, 1832.44, 10.70, -0.00, 0.00, 180.03},
    {2544.51, 1641.59, 10.67, -0.00, 0.00, 179.63},
    {2461.72, 1616.48, 10.67, -0.00, 0.00, 97.45},
    {2424.37, 1566.46, 10.67, -0.00, 0.00, 182.45},
    {2387.23, 1536.59, 10.67, -0.00, 0.00, 93.01},
    {2364.03, 1400.78, 10.67, -0.00, 0.00, 177.21},
    {2423.73, 1283.95, 10.67, -0.00, 0.00, 180.03},
    {2479.64, 1250.06, 10.67, -0.00, 0.00, 267.86},
    {2424.76, 1092.42, 10.67, -0.00, 0.00, 202.75},
    {2484.87, 1070.17, 10.68, -0.00, 0.00, 272.04},
    {2581.68, 1070.08, 10.67, -0.00, 0.00, 271.24},
    {2610.94, 1134.34, 10.67, -0.00, 0.00, 358.25},
    {2460.78, 1016.44, 10.67, -0.00, 0.00, 89.70},
    {2201.22, 976.46, 10.67, -0.00, 0.00, 91.32},
}

local font = exports["since-fonts"]:getFont("Inter-Bold", 20)

for k,v in pairs(studzienki) do
    v.object = createObject(1909, v[1], v[2], v[3]-1.18)
    --createBlip(v[1], v[2], v[3], 41)
end

local marker = createMarker(620.78, 1226.17, 11.89-1, "cylinder", 1.25, 155, 255, 155)
setElementData(marker, "marker:title", "Praca dorywcza")
setElementData(marker, "marker:desc", "Szambiarz")
setElementData(marker, "marker:icon", "skin")

function destroyHose()
    if szambo.hoseMarker and isElement(szambo.hoseMarker) then
        destroyElement(szambo.hoseMarker)
    end
end

function inJob()
    return getElementData(localPlayer, "player:job") and getElementData(localPlayer, "player:job") == "szambiarz"
end

local tick = getTickCount()
addEventHandler("onClientPreRender", root, function()
    if inJob() and szambo.myVehicle and isElement(szambo.myVehicle) and not isPedInVehicle(localPlayer) then
        local str = ("Zapełnienie %.2f / %.2fl"):format(szambo.zapelnienie, szambo.max)
        
        dxSetRenderTarget(szambo.rt2, true)
            dxDrawRoundedRectangle(3, 3, 506, 44, 44/2, tocolor(55, 155, 55))
        dxSetRenderTarget()

        dxSetRenderTarget(szambo.rt, true)
        dxDrawImage(0, 0, 512, 50, szambo.rt2, 0, 0, 0, tocolor(255,255,255,155))
        dxDrawImageSection(0, 0, 512*(szambo.zapelnienie/szambo.max), 50, 0, 0, 512*(szambo.zapelnienie/szambo.max), 50, szambo.rt2)
        dxDrawText(str, 0, 0, 512, 50, white, 1, exports["since-fonts"]:getFont("Inter-Bold", 20), "center", "center")
        dxDrawText('Wąż ssący', 512/2, 125, nil, nil, tocolor(155, 255, 155), 1, exports["since-fonts"]:getFont("Inter-Black", 18), "center", "bottom")
        dxDrawText('Podejdź aby wyciągnąc wąż', 512/2, 125, nil, nil, white, 1, exports["since-fonts"]:getFont("Inter-SemiBold", 14), "center", "top")
        dxSetRenderTarget()

        local x, y, z = getPositionFromElementOffset(szambo.myVehicle, 0, -4.5, 0.3)
        local lx, ly, lz = getPositionFromElementOffset(szambo.myVehicle, 0, -6.6, 0)
        dxDrawMaterialLine3D(x, y, z, x, y, z - 0.65, szambo.rt, 2, tocolor(255,255,255,240), lx, ly, lz)
    end

    if not szambo.hose or szambo.request then return end
    local studzienka = {false, 0.3}
    local px, py, pz = getElementPosition(localPlayer)
    for k,v in pairs(studzienki) do
        local dist = getDistanceBetweenPoints2D(px, py, v[1], v[2])
        if dist < studzienka[2] then
            studzienka = {k, dist}
        end
    end

    if not studzienka[1] then return end
    if szambo.wciaga then return end
    szambo.request = true
    szambo.pozostalo = 0
    szambo.wciaga = true
    --toggleAllControls(false)
    if tick > getTickCount() then return end
    triggerServerEvent("attachToStudzienka", resourceRoot, studzienka[1])
    tick = getTickCount()+1000
end)

addEvent("yourSzamboVehicle", true)
addEventHandler("yourSzamboVehicle", root, function(veh)
    szambo.myVehicle = veh
end)

addEvent("updateStudzienkiBlips", true)
addEventHandler("updateStudzienkiBlips", root, function(d)
    if not inJob() then return end
    for k,v in pairs(szambo.blips) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    for k,v in pairs(studzienki) do
        if not d[k] then
            table.insert(szambo.blips, createBlip(v[1], v[2], v[3], 41))
        end
    end
end)

addEvent("destroyHoseSound", true)
addEventHandler("destroyHoseSound", root, function(client)
    if szambo.sounds[client] and isElement(szambo.sounds[client]) then stopSound(szambo.sounds[client]) end
end)

addEvent("play3DSoundSzambo", true)
addEventHandler("play3DSoundSzambo", root, function(veh)
    local sound = playSound3D("data/pump_loop.mp3", 0, 0, 0, true)
    setSoundVolume(sound, 0.4)
    setSoundMinDistance(sound, 10)
    setSoundMaxDistance(sound, 30)
    attachElements(sound, veh, 0, -5, 0)
    szambo.sounds[getElementData(veh, "szambo:owner")] = sound
end)

addEvent("successAttachStudzienka", true)
addEventHandler("successAttachStudzienka", root, function(veh)
    szambo.pozostalo = math.random(600, 800)/10
    szambo.wciaga = true
end)

addEvent("failedAttachStudzienka", true)
addEventHandler("failedAttachStudzienka", root, function(veh)
    --toggleAllControls(true)
    szambo.wciaga = false
end)

addEvent("updatePlayerHose", true)
addEventHandler("updatePlayerHose", root, function(client, data)
    szambo.hoses[client] = data

    if szambo.hoses[client] then
        szambo.hoses[client].lastUpdate = getTickCount()+1200
    end

    if client == localPlayer then
        szambo.request = false
    end
end)

addEventHandler("onClientRender", root, function()
    local px, py, pz = getElementPosition(localPlayer)
    for client,v in pairs(szambo.hoses) do
        if isElement(client) and isElement(v.vehicle) then
            local bx, by, bz = getPedBonePosition(client, 25)
            if getDistanceBetweenPoints3D(px, py, pz, bx, by, bz) < 50 then
                local x, y, z = getPositionFromElementOffset(v.vehicle, 0, -4.25, -0.25)
                for k,v in pairs(v.points) do
                    local cx, cy, cz = v[1], v[2], v[3]
                    dxDrawMaterialSectionLine3D(cx, cy, cz, x, y, z, 0, 0, 512, 2048, szambo.hoseTxt, 0.2, tocolor(255,255,255,255))
                    x, y, z = cx, cy, cz
                end
                if not v.studzienka then
                    dxDrawMaterialSectionLine3D(bx, by, bz, x, y, z, 0, 0, 512, 2048, szambo.hoseTxt, 0.2, tocolor(255,255,255,255))
                else
                    local bx, by, bz = studzienki[v.studzienka][1], studzienki[v.studzienka][2], studzienki[v.studzienka][3]-1.1
                    dxDrawMaterialSectionLine3D(bx, by, bz, x, y, z, 0, 0, 512, 2048, szambo.hoseTxt, 0.2, tocolor(255,255,255,255))
                end
            end
        end
    end

    if szambo.hoses[localPlayer] and szambo.hose and not szambo.hoses[localPlayer].studzienka then
        local data = szambo.hoses[localPlayer]
        local x, y, z = getPositionFromElementOffset(data.vehicle, 0, -4.25, -0.25)
        if #data.points > 0 then
            x, y, z = data.points[#data.points][1], data.points[#data.points][2], data.points[#data.points][3]
        end

        local vx, vy, vz = getElementVelocity(localPlayer)
        local speed = Vector3(vx, vy, vz).length
        if getDistanceBetweenPoints2D(px, py, x, y) > 0.5 then
            if not szambo.request and speed > 0 then
                szambo.hoses[localPlayer].lastUpdate = getTickCount()+1200
                if #data.points < 15 then
                    szambo.request = true
                    triggerServerEvent("addHosePoint", resourceRoot, px, py, getGroundPosition(px, py, pz)+0.1)
                    return
                end
            end
            
            if #data.points >= 15 then
                triggerServerEvent("deleteMyHose", resourceRoot)
                data.points = {}
                szambo.hose = false
            else
                lastPos = Vector3(getElementPosition(localPlayer))+Vector3(0,0,0.1)
            end
        end

        if #data.points > 0 then
            local nx, ny, nz, dz, cz = 0, 0, 0, math.huge
            for k,v in pairs(data.points) do
                local dist = getDistanceBetweenPoints2D(v[1], v[2], px, py)
                if dist < dz then
                    nx, ny, nz, dz, cz = v[1], v[2], v[3], dist, k
                end
            end

            if dz < 0.15 and not szambo.request then
                triggerServerEvent("removeHosePoint", resourceRoot, cz)
                szambo.request = true
                szambo.hoses[localPlayer].lastUpdate = getTickCount()+1200
            end
        end
    end
end)

function takePutHose(plr)
    if plr ~= localPlayer then return end

    if szambo.hose then
        if szambo.hoses[localPlayer].studzienka then return end
        szambo.hose = false
        triggerServerEvent("deleteMyHose", resourceRoot)
    else
        triggerServerEvent("addMyHose", resourceRoot)
        szambo.hose = true
        szambo.request = true
    end
    setElementPosition(localPlayer, Vector3(getElementPosition(localPlayer)) + Vector3(0, 0, 0.1))
end

addEventHandler("onClientVehicleStartEnter", root, function(plr)
    if inJob() and plr == localPlayer and szambo.hose then cancelEvent() end
    if inJob() and source ~= szambo.myVehicle then cancelEvent() end
    if inJob() and getElementData(source, "szambo:owner") and getElementData(source, "szambo:owner") ~= localPlayer then cancelEvent() end
end)

triggerServerEvent("getHoses", resourceRoot)

function exitSzamboVeh(plr, seat)
    if plr ~= localPlayer then return end
    if getElementData(localPlayer, "player:job") ~= "szambiarz" then return end
    if not getElementData(source, "szambo:owner") or getElementData(source, "szambo:owner") ~= localPlayer then return end

    szambo.hoseMarker = createMarker(0, 0, 0, "cylinder", 1, 155, 255, 155, 0)
    attachElements(szambo.hoseMarker, source, 0, -5, -1.5)
    addEventHandler("onClientMarkerHit", szambo.hoseMarker, takePutHose)
end
addEventHandler("onClientVehicleExit", root, exitSzamboVeh)

function exitSzamboVeh(plr, seat)
    if plr ~= localPlayer then return end
    if getElementData(localPlayer, "player:job") ~= "szambiarz" then return end
    if not getElementData(source, "szambo:owner") or getElementData(source, "szambo:owner") ~= localPlayer then return end

    destroyHose()
end
addEventHandler("onClientVehicleEnter", root, exitSzamboVeh)

setTimer(function()
    if not (szambo.hose and szambo.hoses[localPlayer] and szambo.hoses[localPlayer].studzienka) then return end
    if szambo.wciaga then
        if not szambo.request then
            if szambo.pozostalo > 0 then
                szambo.zapelnienie = math.min(szambo.zapelnienie + 0.97/3.5, szambo.max)
                szambo.pozostalo = szambo.pozostalo - 0.97/3.5
            else
                szambo.wciaga = false
            end
        end
    elseif not szambo.request then
        szambo.wciaga = false
        szambo.hose = false
        --toggleAllControls(true)
        szambo.request = true
        triggerServerEvent("stopSzambo", resourceRoot)
    end
end, 100, 0)

addEvent("onJobStart", true)
addEvent("onJobFinish", true)

local minuteTimer = nil

addEventHandler("onJobStart", root, function(c)
    if c == "szambiarz" then
        if getElementData(localPlayer, 'player:job') then
            return
        end
        local licenses = getElementData(localPlayer, 'player:licenses') or {}
		if not licenses['c'] then 
			return exports['since-notifications']:sendNotification('error', 'Nie posiadasz prawa jazdy kat. C')
		end

        if tonumber(getElementData(localPlayer, 'player:srp')) < 3000 then
            return exports['since-notifications']:sendNotification('error', 'Nie posiadasz 3000 SRP.')
        end

        minuteTimer = setTimer(function()
            exports["since-jobs"]:addPlayerJobTime('szambiarz', 1)
        end, 60000, 0)

        setElementData(localPlayer, "player:job", c)
        triggerServerEvent("startSzamboJob", resourceRoot)
        szambo.zapelnienie = 0
        szambo.max = 1000 + (exports["since-jobs"]:getPlayerUpgradeLevel("szambiarz", 1) * 100)

        szambo.rt = dxCreateRenderTarget(512, 150, true)
        szambo.rt2 = dxCreateRenderTarget(512, 50, true)

        exports['since-notifications']:sendNotification('success', 'Rozpoczynasz prace szambiarza')
    end
end)

addEventHandler("onJobFinish", root, function(c)
    if c == "szambiarz" then
        if getElementData(localPlayer, 'player:job') ~= 'szambiarz' then
            return
        end
        triggerServerEvent("endSzamboJob", resourceRoot)
        setElementData(localPlayer, "player:job", false)
        destroyHose()

        if minuteTimer then
            if isTimer(minuteTimer) then
                killTimer(minuteTimer)
            end
            minuteTimer = nil
        end

        for k,v in pairs(szambo.blips) do
            if isElement(v) then
                destroyElement(v)
            end
        end

        if isElement(szambo.rt) then
            destroyElement(szambo.rt)
        end

        if isElement(szambo.rt2) then
            destroyElement(szambo.rt2)
        end

        exports['since-notifications']:sendNotification('success', 'Kończysz prace szambiarza')
    end
end)

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    if getPedOccupiedVehicle(localPlayer) then return end

    exports["since-jobs"]:showJobGui("szambiarz", source)
end)

local oddawanie = createMarker(659.68, 1261.96, 11.06, "cylinder", 5, 155, 255, 155)
setElementData(oddawanie, "marker:title", "Praca dorywcza")
setElementData(oddawanie, "marker:desc", "Oddawanie szamba")

sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

addEventHandler("onClientMarkerHit", oddawanie, function(el, md)
    if el ~= localPlayer then return end
    if not md then return end

    if not inJob() or not getPedOccupiedVehicle(localPlayer) then return end
    --if isElementWithinMarker(localPlayer, oddawanie) then
        if szambo.zapelnienie > 0 then
            local money = getElementData(localPlayer, "player:diamond") and (szambo.zapelnienie*85)*1.25 or szambo.zapelnienie*85 
            exports["since-jobs"]:addPlayerJobPoints("szambiarz", math.floor(szambo.zapelnienie/50))

            local voucher = exports['since-vouchers']:getJobVoucher('szambiarz')/100
            money = money + math.floor(money * voucher)

            triggerServerEvent("givePlayerMoney", resourceRoot, math.floor(money))
            exports["since-jobs"]:addPlayerJobEarned("szambiarz", tonumber(math.floor(money)))
            exports['since-notifications']:sendNotification('success', "Za " .. math.floor(szambo.zapelnienie) .. " litry szamba otrzymujesz $ " .. math.floor(money) .. "")
            szambo.zapelnienie = 0
        else
            exports['since-notifications']:sendNotification('error', 'Twój zbiornik jest pusty, napełnij go i wróć ponownie.')
        end
    --end
end)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end
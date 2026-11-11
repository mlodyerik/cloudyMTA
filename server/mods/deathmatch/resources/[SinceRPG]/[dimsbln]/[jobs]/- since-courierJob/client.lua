local marker = createMarker(93.62, -310.78, 1.58-1, "cylinder", 2, 125, 255, 125, 55)
setElementData(marker, "marker:title", "Kurier")
setElementData(marker, "marker:desc", "Rozpoczęcie pracy")
setElementData(marker, "marker:icon", "skin")

sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local spawny = {
    {91.07, -289.10, 1.64, 359.4, 360.0, 0.3, {89.45, -310.20, 1.58}},
}

local paczki = {}

local peds = {}

local pedy = {

    {-242.92, 2709.52, 62.69, -0.00, 0.00, 179.40},
    {-170.31, 2708.20, 62.57, -0.00, 0.00, 87.15},
    {985.66, 2343.60, 11.47, -0.00, 0.00, 264.25},
    {1051.17, 1007.24, 11.00, -0.00, 0.00, 324.68},
    {1294.64, 236.53, 19.55, -0.00, 0.00, 10.20},
    {1259.28, 203.60, 19.55, -0.00, 0.00, 242.90},
    {717.96, 300.68, 20.23, -0.00, 0.00, 93.19},
    {705.45, 291.25, 20.42, -0.00, 0.00, 190.12},
    {701.82, -520.55, 16.34, -0.00, 0.00, 181.82},
    {971.06, -1114.62, 23.86, -0.00, 0.00, 85.29},
    {-365.72, 1165.93, 19.74, -0.00, 0.00, 227.85},
    {-19.14, 1178.24, 19.56, -0.00, 0.00, 359.02},
    {171.60, 1174.96, 14.76, -0.00, 0.00, 145.66},
    {986.39, 1978.99, 11.47, -0.00, 0.00, 268.53},
    {1028.22, 2027.71, 11.47, -0.00, 0.00, 90.87},


}

local data = {
    moneyForPack = 5000,
}

local maleSkins = {
	[0]=true,[7]=true,[14]=true,[15]=true,[16]=true,[17]=true,[18]=true,[19]=true,[20]=true,[21]=true,[22]=true,[23]=true,
	[24]=true,[25]=true,[26]=true,[27]=true,[28]=true,[29]=true,[30]=true,[32]=true,[33]=true,[34]=true,[35]=true,[36]=true,
	[37]=true,[43]=true,[44]=true,[45]=true,[46]=true,[47]=true,[48]=true,[49]=true,[50]=true,[51]=true,[52]=true,[57]=true,
	[58]=true,[59]=true,[60]=true,[61]=true,[62]=true,[66]=true,[67]=true,[68]=true,[70]=true,[71]=true,[72]=true,[73]=true,
	[78]=true,[79]=true,[80]=true,[81]=true,[82]=true,[83]=true,[84]=true,[94]=true,[95]=true,[96]=true,[97]=true,[98]=true,
	[99]=true,[100]=true,[101]=true,[102]=true,[103]=true,[104]=true,[105]=true,[106]=true,[107]=true,[108]=true,[109]=true,
	[110]=true,[111]=true,[112]=true,[113]=true,[114]=true,[115]=true,[116]=true,[117]=true,[118]=true,[120]=true,[121]=true,
	[122]=true,[123]=true,[124]=true,[125]=true,[126]=true,[127]=true,[128]=true,[132]=true,[133]=true,[134]=true,[135]=true,
	[136]=true,[137]=true,[142]=true,[143]=true,[144]=true,[146]=true,[147]=true,[153]=true,[154]=true,[155]=true,[156]=true,
	[158]=true,[159]=true,[160]=true,[161]=true,[162]=true,[163]=true,[164]=true,[165]=true,[166]=true,[167]=true,[168]=true,
	[170]=true,[171]=true,[173]=true,[174]=true,[175]=true,[176]=true,[177]=true,[179]=true,[180]=true,[181]=true,[182]=true,
	[183]=true,[184]=true,[185]=true,[186]=true,[187]=true,[188]=true,[189]=true,[200]=true,[202]=true,[203]=true,[204]=true,
	[206]=true,[209]=true,[210]=true,[212]=true,[213]=true,[217]=true,[220]=true,[221]=true,[222]=true,[223]=true,[227]=true,
	[228]=true,[229]=true,[230]=true,[234]=true,[235]=true,[236]=true,[239]=true,[240]=true,[241]=true,[242]=true,[247]=true,
	[248]=true,[249]=true,[250]=true,[252]=true,[253]=true,[254]=true,[255]=true,[258]=true,[259]=true,[260]=true,[261]=true,
	[262]=true,[264]=true,[265]=true,[266]=true,[267]=true,[268]=true,[269]=true,[270]=true,[271]=true,[272]=true,[274]=true,
	[275]=true,[276]=true,[277]=true,[278]=true,[279]=true,[280]=true,[281]=true,[282]=true,[283]=true,[284]=true,[285]=true,
	[286]=true,[287]=true,[288]=true,[290]=true,[291]=true,[292]=true,[293]=true,[294]=true,[295]=true,[296]=true,[297]=true,
	[299]=true,[300]=true,[301]=true,[302]=true,[303]=true,[305]=true,[306]=true,[307]=true,[308]=true,[309]=true,[310]=true,
	[311]=true,[312]=true
}

local femaleSkins = {
	[9]=true,[10]=true,[11]=true,[12]=true,[13]=true,[31]=true,[38]=true,[39]=true,[40]=true,[41]=true,[53]=true,[54]=true,
	[55]=true,[56]=true,[63]=true,[64]=true,[69]=true,[75]=true,[76]=true,[77]=true,[85]=true,[87]=true,[88]=true,[89]=true,
	[90]=true,[91]=true,[92]=true,[93]=true,[129]=true,[130]=true,[131]=true,[138]=true,[139]=true,[140]=true,[141]=true,
	[145]=true,[148]=true,[150]=true,[151]=true,[152]=true,[157]=true,[169]=true,[172]=true,[178]=true,[190]=true,[191]=true,
	[192]=true,[193]=true,[194]=true,[195]=true,[196]=true,[197]=true,[198]=true,[199]=true,[201]=true,[205]=true,[207]=true,
	[211]=true,[214]=true,[215]=true,[216]=true,[218]=true,[219]=true,[224]=true,[225]=true,[226]=true,[231]=true,[232]=true,
	[233]=true,[237]=true,[238]=true,[243]=true,[244]=true,[245]=true,[246]=true,[251]=true,[256]=true,[257]=true,[263]=true,
	[298]=true,[304]=true
}
local maleCount = 0
local femaleCount = 0
for k,v in pairs(maleSkins) do
    maleCount = maleCount + 1
end
for k,v in pairs(femaleSkins) do
    femaleCount = femaleCount + 1
end

function randomSkin()
    if math.random(1,2)==1 then
        local skin = math.random(1, maleCount)
        local c = 1
        for k,v in pairs(maleSkins) do
            if c == skin then
                return k
            end
            c = c + 1
        end
    else
        local skin = math.random(1, femaleCount)
        local c = 1
        for k,v in pairs(femaleSkins) do
            if c == skin then
                return k
            end
            c = c + 1
        end
    end
end

function toggleJobControls(c)
    if exports["since-jobs"]:getPlayerUpgradeLevel("kurier", 'Sprinter') == 1 then
        toggleControl("sprint", true)
    else
        toggleControl("sprint", c)
    end
    toggleControl("crouch", c)
    toggleControl("fire", false)
    toggleControl("aim", false)
    toggleControl("jump", c)
end

toggleJobControls(true)

addEventHandler("onClientMarkerHit", marker, function(plr)
    if plr ~= localPlayer then return end
    exports["since-jobs"]:showJobGui("kurier", source)
end)

function foundIn(t, a)
    for k,v in pairs(t) do
        if v == a then
            return true
        end
    end
    return false
end

function getSkinGender(model)
	return maleSkins[model] and "male" or femaleSkins[model] and "female" or "unknown"
end

function randomWithout(a, b, t)
    local c = math.random(a, b)
    while foundIn(t, c) do
        c = math.random(a, b)
    end
    return c
end

function koniecPracy(plr)
    if plr ~= localPlayer then return end
    destroyElement(source)
    destroyElement(koniecBlip)
    triggerServerEvent("kurierOdNowa", resourceRoot)
    createOdbior()
end

addEventHandler("onClientMarkerHit", root, function(plr)
    if plr ~= localPlayer then return end
    local imie = getElementData(source, "kurier:imie")
    if not imie then return end
    if aktualnaPaczka and aktualnaPaczka == imie then
        local id = false
        for k,v in pairs(peds) do
            if v[3] == source then
                id = k
                break
            end
        end

        if id then
            destroyElement(peds[id][1])
            destroyElement(peds[id][2])
            destroyElement(peds[id][3])
            destroyElement(peds[id][4])

            local money = data.moneyForPack + math.random(-math.floor(data.moneyForPack/10),math.floor(data.moneyForPack/10))
            money = money * exports["since-jobs"]:getJobMultiplier('kurier')
            for i = 0, exports["since-jobs"]:getPlayerUpgradeLevel("kurier", 'Money') do
                money = money * (1.1)
            end
            if getElementData(localPlayer, 'player:diamond') then
                money = money * (1.5)
            end

            local voucher = exports['since-vouchers']:getJobVoucher('kurier')/100
            money = money + math.floor(money * voucher)

            money = math.floor(money)

            exports["since-jobs"]:addPlayerJobEarned("kurier", money)

            local rnd = math.random(1, 10)
            if rnd > 5 then
                exports["since-jobs"]:addPlayerJobPoints("kurier", 1)
            end

            local srp = math.random(0,2)
            
            triggerServerEvent("kurierKasa", resourceRoot, money, srp)

            exports['since-notifications']:sendNotification('success', 'Otrzymujesz '..formatNumber(money)..' $ za odstawioną paczkę.')

            exports['since-dailyQuests']:addProgress(localPlayer, 1, 4)

            for k,v in pairs(paczki) do
                if v.imie == aktualnaPaczka then
                    table.remove(paczki, k)
                end
            end

            if #paczki == 0 then
                local marker = createMarker(77.78, -283.48, 1.58, "cylinder", 6, 125, 255, 125, 50)
                setElementData(marker, "marker:title", "Kurier")
                setElementData(marker, "marker:desc", "Powrót do bazy")
                addEventHandler("onClientMarkerHit", marker, koniecPracy)
                koniecBlip = createBlip(79.84, -287.09, 1.581, 41, 2, 255, 255, 255, 255, 0, 99999999)
                exports['since-notifications']:sendNotification('success', 'Dostarczono wszystkie paczki, wróć do bazy załadunkowej')
            end

            aktualnaPaczka = false
            trzymaPaczke = false

            setElementFrozen(localPlayer, true)
            toggleAllControls(false)

            setTimer(function()
                triggerServerEvent("removePackKurier", resourceRoot)
                setElementFrozen(localPlayer, false)
                setElementData(localPlayer, "player:animation", nil)
                toggleAllControls(true)
            end, 500, 1)
        end
    end
end)

function stworzPedy()
    paczki = {scrollPos = {k = 1, n = 8, m = 8}}
    trzymaPaczke = false
    local poses = {}
    for i = 1, odlozonychPaczek do
        table.insert(poses, randomWithout(1, #pedy, poses))
    end

    for k,v in pairs(poses) do
        local pos = pedy[v]
        local blip = createBlip(pos[1], pos[2], pos[3], 41)
        local skin = randomSkin()
        local ped = createPed(skin, pos[1], pos[2], pos[3], pos[6])
        local x, y, z = getPositionFromElementOffset(ped, 0, 1.3, 0)
        local imie = getRandomName(getSkinGender(skin) == "female")
        local marker = createMarker(x, y, z-1.3, "cylinder", 1.2, 125, 255, 125, 55)
        setElementData(marker, "marker:title", "Kurier")
        setElementData(marker, "marker:desc", "Oddawanie paczki")
        setElementData(marker, "kurier:imie", imie)

        local text3d = createElement("text")
        setElementPosition(text3d, pos[1], pos[2], pos[3] + 1.2)
        setElementData(text3d, "name", imie)
        table.insert(paczki, {imie=imie, location=getZoneName(x, y, z, true) .. " " .. getZoneName(x, y, z)})

        table.insert(peds, {blip,ped,marker,text3d})
    end
end

function odkladaniePaczki(plr)
    if plr ~= localPlayer then return end
    if getPedOccupiedVehicle(plr) then
        return
    end

    if skrzyneczka then
        setElementFrozen(localPlayer, true)
        setElementData(localPlayer, "player:animation", "pick_up")
        toggleAllControls(false)
        skrzyneczka = false

        destroyElement(odkladanie)

        setTimer(function()
            triggerServerEvent("removePackKurier", resourceRoot)

            odlozonychPaczek = odlozonychPaczek + 1
            if odlozonychPaczek >= maxPaczek then
                local x, y, z = getPositionFromElementOffset(jobCar, 0, 9, 0)
                local rx, ry, rz = getElementRotation(jobCar)
                destroyElement(jobCar)
                destroyElement(odbior)
                triggerServerEvent("kurierSpawn", resourceRoot, x, y, z, rx, ry, rz, exports["since-jobs"]:getPlayerUpgradeLevel("kurier", 'Speed'))
                stworzPedy()

                exports['since-notifications']:sendNotification('success', 'Załadowano maksymalną ilość paczek, jedź rozwieść je do klientów')
            end
        end, 500, 1)
    end
end

function createOdkladanie()
    odkladanie = createMarker(100.30, -292.70, 1.58-0.99, "cylinder", 1.5, 125, 255, 125, 50)
    setElementData(odkladanie, "marker:title", "Kurier")
    setElementData(odkladanie, "marker:desc", "Odkładanie paczki")
    addEventHandler("onClientMarkerHit", odkladanie, odkladaniePaczki)
    attachElements(odkladanie, jobCar, 0, -3.8, -1.3)
end

function odbiorPaczki(plr)
    if plr ~= localPlayer then return end
    if getPedOccupiedVehicle(plr) then
        return
    end

    if not skrzyneczka then
        setElementFrozen(localPlayer, true)
        setElementData(localPlayer, "player:animation", "pick_up")
        toggleAllControls(false)
        skrzyneczka = true

        setTimer(function()
            triggerServerEvent("takePackKurier", resourceRoot)
            createOdkladanie()
        end, 500, 1)
    end
end

addEvent("onAnimationEnd", true)
addEventHandler("onAnimationEnd", localPlayer, function(name)
    if name == "pick_up" and getElementData(localPlayer, "player:job") == "kurier" then
        if trzymaPaczke then
            setElementData(localPlayer, "player:animation", "carry")
        elseif skrzyneczka then
            setElementData(localPlayer, "player:animation", "carry")
        else
            setElementData(localPlayer, "player:animation", nil)
        end
        setElementFrozen(localPlayer, false)
        toggleAllControls(true)
        toggleJobControls(false)
    end
end)

function createOdbior()
    exports['since-notifications']:sendNotification('success', 'Udaj się po paczkę aby załadować ją do pojazdu')
    local spawn = math.random(1, #spawny)

    odbior = createMarker(spawny[spawn][7][1], spawny[spawn][7][2], spawny[spawn][7][3]-0.99, "cylinder", 2, 125, 255, 125, 50)
    setElementData(odbior, "marker:title", "Kurier")
    setElementData(odbior, "marker:desc", "Odbiór paczki")
    addEventHandler("onClientMarkerHit", odbior, odbiorPaczki)

    jobCar = createVehicle(498, spawny[spawn][1], spawny[spawn][2], spawny[spawn][3], spawny[spawn][4], spawny[spawn][5], spawny[spawn][6])
    setVehicleDoorOpenRatio(jobCar, 4, 1)
    setVehicleDoorOpenRatio(jobCar, 5, 1)
    setElementFrozen(jobCar, true)
    setVehicleColor(jobCar, 255,255,255,255,255,255,255,255,255,255,255,255)
    addVehicleUpgrade(jobCar, 1025)

    maxPaczek = 5+(exports["since-jobs"]:getPlayerUpgradeLevel("kurier", 'Pojemny') or 0)
    odlozonychPaczek = 0
end

addEvent("onJobStart", true)
addEventHandler("onJobStart", root, function(name)
    if name == "kurier" then
        if getElementData(localPlayer, 'player:job') then
            return
        end
		if getElementData(localPlayer, 'player:srp') < 500 then 
			exports['since-notifications']:sendNotification('error', 'Nie posiadasz 500 srp')
			return
		end
		local licenses = getElementData(localPlayer, 'player:licenses') or {}
		if not licenses['c'] then 
			exports['since-notifications']:sendNotification('error', 'Nie posiadasz prawa jazdy kat. C')
			return
		end

        data.timer = setTimer(function()
            exports["since-jobs"]:addPlayerJobTime('kurier', 1)
        end, 60000, 0)

        setElementData(localPlayer, "player:job", "kurier")
        toggleJobControls(false)
        exports['since-notifications']:sendNotification('success', 'Rozpoczęto pracę jako kurier')
        createOdbior()
    end
end)

addEvent("onJobFinish", true)
addEventHandler("onJobFinish", root, function(name)
    if name == "kurier" then
        if getElementData(localPlayer, 'player:job') ~= 'kurier' then
            return
        end
        if data.timer then
            if isTimer(data.timer) then
                killTimer(data.timer)
            end
            data.timer = nil
        end

        setElementData(localPlayer, "player:job", nil)
        setElementData(localPlayer, "player:animation", nil)
        toggleJobControls(true)
        exports['since-notifications']:sendNotification('success', 'Zakończono pracę jako kurier')

        if odbior and isElement(odbior) then
            destroyElement(odbior)
        end
        if jobCar and isElement(jobCar) then
            destroyElement(jobCar)
        end
        if braniePaczki and isElement(braniePaczki) then
            destroyElement(braniePaczki)
        end
        if odkladanie and isElement(odkladanie) then
            destroyElement(odkladanie)
        end

        for k,v in pairs(peds) do
            if v and isElement(v[1]) then
                destroyElement(v[1])
                destroyElement(v[2])
                destroyElement(v[3])
                destroyElement(v[4])
            end
        end

        triggerServerEvent("jobEndKurier", resourceRoot)
    end
end)

bindKey("mouse_wheel_up", "down", function()
    if paczki and paczki.scrollPos and paczki.scrollPos.n == paczki.scrollPos.m then return end
    if not paczki or not paczki.scrollPos then return end
    paczki.scrollPos.k = paczki.scrollPos.k-1
    paczki.scrollPos.n = paczki.scrollPos.n-1
end)

bindKey("mouse_wheel_down", "down", function()
    if paczki and paczki.scrollPos and paczki.scrollPos.n >= #paczki then return end
    if not paczki or not paczki.scrollPos then return end
    paczki.scrollPos.k = paczki.scrollPos.k+1
    paczki.scrollPos.n = paczki.scrollPos.n+1
end)

local font1 = exports["since-fonts"]:getFont("Inter-Bold", 16/zoom)
local font2 = exports["since-fonts"]:getFont("Inter-Medium", 12/zoom)
local font3 = exports["since-fonts"]:getFont("Inter-Bold", 14/zoom)
local font4 = exports["since-fonts"]:getFont("Inter-Medium", 11/zoom)

function renderPaczki()
    dxDrawImage(sx/2-264/zoom, sy/2-245/zoom, 528/zoom, 490/zoom, 'files/images/bg.png')

    local isIn = isMouseInPosition(sx/2+232/zoom, sy/2-237/zoom, 24/zoom, 24/zoom)
    dxDrawImage(sx/2+234/zoom, sy/2-235/zoom, 20/zoom, 20/zoom, 'files/images/close.png', 0,0,0, tocolor(255,255,255, isIn and 255 or 155))

    dxDrawText("Paczki w ciężarówce", sx/2-254/zoom, sy/2-210/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Bold', 13/zoom), "left", "bottom", false, false, false, false, false)
    dxDrawText("#438F87Wybierz paczkę, którą chcesz dostarczyć", sx/2-254/zoom, sy/2-210/zoom, nil, nil, tocolor(255, 255, 255, 200), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), "left", "top", false, false, false, true, false)
    
    local x = 0
    for i,v in ipairs(paczki) do
        if tonumber(i) and i >= paczki.scrollPos.k and i <= paczki.scrollPos.n then 
            x = x + 1
            local offsetY = (50/zoom)*(x-1)
            local isIn = isMouseInPosition(sx/2-249/zoom, sy/2-167/zoom+offsetY, 498/zoom, 48/zoom)
            dxDrawImage(sx/2-249/zoom, sy/2-167/zoom+offsetY, 498/zoom, 48/zoom, 'files/images/bg2.png', 0,0,0, tocolor(255,255,255, isIn and 200 or 155))
            dxDrawImage(sx/2-235/zoom, sy/2-158/zoom+offsetY, 30/zoom, 30/zoom, 'files/images/box.png', 0,0,0, tocolor(255,255,255, isIn and 255 or 200))

            dxDrawText(v.imie, sx/2-190/zoom, sy/2-142/zoom+offsetY, nil, nil, tocolor(255, 255, 255, isIn and 200 or 155), 1, exports['since-fonts']:getFont('Inter-Bold', 11/zoom), "left", "bottom", false, false, false, true, false)
            dxDrawText('#438F87Kliknij aby wyciągnąć paczkę z ciężarówki', sx/2-190/zoom, sy/2-142/zoom+offsetY, nil, nil, tocolor(255, 255, 255, isIn and 255 or 200), 1, exports['since-fonts']:getFont('Inter-Medium', 9/zoom), "left", "top", false, false, false, true, false)

        end
    end
end

function clickPaczki(btn, state)
    if btn ~= "left" or state ~= "down" then return end
    if isMouseInPosition(sx/2+232/zoom, sy/2-237/zoom, 24/zoom, 24/zoom) then

        toggleAllControls(true)
        toggleControl("enter_exit", true)
        setElementFrozen(localPlayer, false)

        removeEventHandler("onClientRender", root, renderPaczki)
        removeEventHandler("onClientClick", root, clickPaczki)

        showCursor(false)

    else
        local x = 0
        for i,v in ipairs(paczki) do
            if tonumber(i) and i >= paczki.scrollPos.k and i <= paczki.scrollPos.n then 
                x = x + 1
                local offsetY = (50/zoom)*(x-1)
                if isMouseInPosition(sx/2-249/zoom, sy/2-167/zoom+offsetY, 498/zoom, 48/zoom) then
                    aktualnaPaczka = v.imie
                    trzymaPaczke = not trzymaPaczke
    
                    setElementFrozen(localPlayer, true)
                    setElementData(localPlayer, "player:animation", "pick_up")
                    toggleAllControls(false)
                    toggleControl("enter_exit", false)
    
                    setTimer(function()
                        triggerServerEvent("takePackKurier", resourceRoot)
                    end, 500, 1)
    
                    removeEventHandler("onClientRender", root, renderPaczki)
                    removeEventHandler("onClientClick", root, clickPaczki)
    
                    showCursor(false)
                end
            end
        end
    end
end

addEventHandler("onClientVehicleStartEnter", root, function(plr)
    if plr ~= localPlayer then return end
    if aktualnaPaczka then cancelEvent() end
end)

function braniePaczkiEvent(plr)
    if plr ~= localPlayer then return end
    if getPedOccupiedVehicle(plr) then
        return
    end

    if not trzymaPaczke then
        if #paczki > 0 then
            addEventHandler("onClientRender", root, renderPaczki)
            addEventHandler("onClientClick", root, clickPaczki)
            showCursor(true)
        end
    else
        trzymaPaczke = not trzymaPaczke
        aktualnaPaczka = false

        setElementFrozen(localPlayer, true)
        toggleAllControls(false)

        setTimer(function()
            triggerServerEvent("removePackKurier", resourceRoot)
            setElementFrozen(localPlayer, false)
            setElementData(localPlayer, "player:animation", nil)
            toggleControl("enter_exit", true)
            toggleAllControls(true)
        end, 500, 1)
    end
end

addEventHandler("onClientVehicleExit", resourceRoot, function(ped)
    if ped ~= localPlayer then return end
    local kurier = getElementData(source, "kurier:owner")
    if kurier and kurier == localPlayer then
        if kurier and kurier == localPlayer and braniePaczki and isElement(braniePaczki) then
            destroyElement(braniePaczki)
        end
        braniePaczki = createMarker(99.75, -291.99, 1.58-0.99, "cylinder", 1.2, 125, 255, 125, 50)
        setElementData(braniePaczki, "marker:title", "Kurier")
        setElementData(braniePaczki, "marker:desc", "Wyciąganie paczki")
        attachElements(braniePaczki, source, 0, -4, -1.3)
        addEventHandler("onClientMarkerHit", braniePaczki, braniePaczkiEvent)
    end
end)

if getElementData(localPlayer, 'player:job') == 'kurier' or getElementData(localPlayer, 'player:job') == 'Kurier' then
    setElementData(localPlayer, 'player:job', false)
end

addEventHandler("onClientVehicleEnter", resourceRoot, function(ped)
    if ped ~= localPlayer then return end
    local kurier = getElementData(source, "kurier:owner")
    if kurier and kurier == localPlayer and braniePaczki and isElement(braniePaczki) then
        destroyElement(braniePaczki)
    end
end)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

function drawScrollbar(table, x, y, height, m_, k_)
    dxDrawRectangle(x, y, 4, height, tocolor(65, 65, 65, 55))

	if #table > m_ then
    	local scrollbarHeight = height/#table

   		if k_ == 1 then 
        	scrollbarPos = y
    	elseif k_ > 1 then 
        	scrollbarPos = ((k_)*scrollbarHeight)+y
    	end

    	if #table <= m_ then 
        	scrollbarHeight = height
    	end

        dxDrawRectangle(x, scrollbarPos, 4, scrollbarHeight*(m_-1), tocolor(0, 195, 255, 125))
    else
        dxDrawRectangle(x, y, 4, height, tocolor(0, 195, 255, 125))
	end
end

function formatNumber(amount) 
	local formatted = amount 
		while true do   
			formatted, k = string.gsub(formatted, '^(-?%d+)(%d%d%d)', '%1 %2') 
			if (k==0) then 
				break 
	  		end 
		end 
	return formatted 
end
getResourceName(getThisResource(), true, 707568320); if true then return end
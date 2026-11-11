local interaction = {
    current = 1,
    mask = nil,
    shadow = nil,
    shader = nil,
    rt = nil,
    list = {},
    prev = false,
}

local regulations = {

    ["Regulacja zawieszenia"] = true,
    ["Moduł MK1"] = true,
    ["Moduł MK2"] = true,
    ["Moduł MK3"] = true,
    ["Moduł MK4"] = true,
    ["Moduł MK5"] = true,
    ["Moduł MK6"] = true,
    ["Moduł ECU"] = true,
    ["Papieski boost"] = true,
    ["Turbosprężarka"] = true,

}

local napedy = {

    [0] = "AWD",
    [1] = "RWD",
    [2] = "FWD",

}

local kabriolety = {}

function getInteractionStateFaction(veh)
    local toggleState = false
    local stateInteraction = getElementData(veh, "vehicle:fraction:interaction") and getElementData(veh, "vehicle:fraction:interaction") or {state = false, mode = false}

    if stateInteraction.state and stateInteraction.mode then
        return true
    else
        return false
    end
end

function toggleEngine()
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh and getElementHealth(veh) < 400 then
        local randomise = math.random(1, 10)

        if randomise == 3 or randomise == 7 then
            exports['since-notifications']:sendNotification('error', 'Twój silnik zgasł z powodu złego stanu technicznego.')

            triggerServerEvent("turnOffEngine", resourceRoot)
        end
    end
end
setTimer(toggleEngine, 60000, 0)

function drawIcon(k, v, y)
    local veh = getPedOccupiedVehicle(localPlayer)
    v.size = (v.size or 60)
    if interaction.current == k then
        v.size = v.size + (110-v.size)*2/delta
    else
        v.size = v.size + (60-v.size)*2/delta
    end
   
    local fontSize = math.max(v.size / 115, 0.7)

    dxDrawImage(450-v.size/3, 250 + y - interaction.pos - v.size/3, v.size/1.5, v.size/1.5, "data/" .. v.icon .. ".png")

    if regulations[v.text(veh)] then
        local regulationLevel = tonumber(v.regulation(veh))
        local regulationName = v.name

        if regulationName == "Napęd:" then
            theText = regulationName.." #2E756F"..napedy[regulationLevel]
        else
            theText = regulationName.." #2E756F"..regulationLevel
        end

        dxDrawText(v.text(veh), 415-v.size/3, 250 + y - interaction.pos, nil, nil, tocolor(46, 117, 111, 255), fontSize, font1, "right", "bottom", false, false, false, true)
        dxDrawText(theText, 415-v.size/3, 250 + y - interaction.pos, nil, nil, tocolor(255, 255, 255, 255), fontSize, font2, "right", "top", false, false, false, true)
    else
        dxDrawText(v.txt, 415-v.size/3, 250 + y - interaction.pos, nil, nil, tocolor(46, 117, 111, 255), fontSize, font1, "right", "bottom", false, false, false, true)
        dxDrawText(v.text(veh), 415-v.size/3, 250 + y - interaction.pos, nil, nil, tocolor(255, 255, 255, 255), fontSize, font2, "right", "top", false, false, false, true)
    end


    return y + 90
end

function checkDach(veh, ifKabrio) if ifKabrio == 1 then return "Zamknij dach" else return "Otwórz dach" end end

local timeout = 10
local lastTick = getTickCount()

function renderInteraction()
    if not getPedOccupiedVehicle(localPlayer) then
        switchInteraction(_, false)
        return
    end

    local _y = 0
    for k,v in pairs(interaction.list) do
        if interaction.current == k then
            interaction.pos = (interaction.pos and (interaction.pos + (_y - interaction.pos)*3/delta) or _y)
        end
        _y = _y + 90
    end


    local veh = getPedOccupiedVehicle(localPlayer)
    if interaction.open and veh then
        if getTickCount() - lastTick > timeout then
            lastTick = getTickCount()

            dxSetRenderTarget(interaction.rt, true)

            local y = -_y
            for k,v in pairs(interaction.list) do
                y = drawIcon(k, v, y)
            end
            for k,v in pairs(interaction.list) do
                y = drawIcon(k, v, y)
            end
            for k,v in pairs(interaction.list) do
                y = drawIcon(k, v, y)
            end

            dxSetRenderTarget()
        end

            dxDrawImage(sx - 525/zoom+1,sy/2 - 250/zoom+1,600/zoom,500/zoom,interaction.shader,0,0,0,tocolor(0,0,0,155))
            dxDrawImage(sx - 525/zoom,sy/2 - 250/zoom,600/zoom,500/zoom,interaction.shader)
    end    
end

function addTune(veh)
    if not getElementData(veh, "vehicle:id") then return end
    if not getElementData(veh, "vehicle:upgrades") then return end
    local veh = getPedOccupiedVehicle(localPlayer)

    if getElementData(veh, "vehicle:upgrades")["gz"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Regulacja zawieszenia") end,
            icon = "susp",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:suspension") or 0) end,
            name = "Wysokość zawieszenia:",
            data = "vehicle:suspension",
            limits = {down=-7, up=7},
            trigger = nil,
            event = "suspensionRegulate",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk1"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK1") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk1") or 0) end,
            name = "Prędkość maksymalna:",
            data = "vehicle:mk1",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateMK1",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk2"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK2") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk2") or 0) end,
            name = "Przyśpieszenie:",
            data = "vehicle:mk2",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateMK2",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk3"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK3") end,
            icon = "drivetype",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk3") or 0) end,
            name = "Napęd:",
            data = "vehicle:mk3",
            limits = nil,
            trigger = nil,
            event = "regulateMK3",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk4"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK4") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk4") or 0) end,
            name = "Moc pojazdu:",
            data = "vehicle:mk4",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateMK4",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk5"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK5") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk5") or 0) end,
            name = "Masa pojazdu:",
            data = "vehicle:mk5",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateMK5",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk6"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł MK6") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk6") or 0) end,
            name = "Moc pojazdu:",
            data = "vehicle:mk6",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateMK6",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["ecu"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Moduł ECU") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:ecu") or 0) end,
            name = "Moc pojazdu:",
            data = "vehicle:ecu",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateECU",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["mk2137"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Papieski boost") end,
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:mk2137") or 0) end,
            name = "Moc i przyśpieszenie:",
            data = "vehicle:mk2137",
            limits = {down=-5, up=5},
            trigger = nil,
            event = "regulateMK2137",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["turbo"] then
        table.insert(interaction.list, {

            text = function(veh) return ("Turbosprężarka") end,
            icon = "turbo",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            regulation = function(veh) return (getElementData(veh, "vehicle:turbo") or 0) end,
            name = "Doładowanie:",
            data = "vehicle:turbo",
            limits = {down=0, up=4},
            trigger = nil,
            event = "regulateTurbo",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["chiptuning"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:toggleChip") and "Wyłącz program" or "Włącz program") end,
            txt = 'Chiptuning',
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleChip",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["abs"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:toggleABS") and "Wyłącz ABS" or "Włącz ABS") end,
            txt = 'System ABS',
            icon = "abs",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleABS",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["lpg"] and not getElementData(veh, "vehicle:upgrades")["electric"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:togglelpg") and "Przełącz na #ffb947"..("Benzyna") or "Przełącz na #47ff59LPG") end,
            txt = 'Instalacja LPG',
            icon = "lpg",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleLPG",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["nitro"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:toggleNitro") and "Wyłącz nitro" or "Włącz nitro") end,
            txt = 'Nitro',
            icon = "nitro",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleNitro",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["driftmode"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:toggleDriftmode") and "Wyłącz driftmode" or "Włącz driftmode") end,
            txt = 'Drift',
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleDrift",

        })
    end

    if getElementData(veh, "vehicle:upgrades")["hovermode"] then
        table.insert(interaction.list, {

            text = function(veh) return (getElementData(veh, "vehicle:hovermode") and "Wyłącz hovermode" or "Włącz hovermode") end,
            txt = 'Hovermode',
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleHovermode",

        })
    end
    
    if getElementData(veh, "vehicle:upgrades")["taxi"] then
        table.insert(interaction.list, {
            
            text = function(veh) return (getElementData(localPlayer, 'player:job') and getElementData(localPlayer, 'player:job') == 'etransporter' and "Anuluj zlecenie" or "Włącz apl. transportową") end,
            txt = 'Apl. transportowa',
            icon = "taxo",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,

        })
    end

    if kabriolety[getVehicleModelFromName(getVehicleName(veh))] then
        local var1, var2 = getVehicleVariant(veh)

        if kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][1] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][2] == var2 then
            ifKabrio = 1
        elseif kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][3] == var1 and kabriolety[getVehicleModelFromName(getVehicleName(veh))][1][4] == var2 then
            ifKabrio = 2
        else
            ifKabrio = false
        end

        if kabriolety[getVehicleModelFromName(getVehicleName(veh))] and ifKabrio ~= false then
            table.insert(interaction.list, {
            
                text = "Dach",
                txt = 'Dach',
                icon = "roof",
                x = sx/2 - 150/zoom,
                y = sy - 80/zoom,
                trigger = "vehicleSwitchVariant",

            })
        end
    end
end

bindKey('c', 'down', function()
    local veh = getPedOccupiedVehicle(localPlayer)
    if not veh then return end
    local controller = getVehicleController(veh)

    if veh and localPlayer == controller then
        local upgrades = getElementData(veh, 'vehicle:upgrades') or {}
        if upgrades and upgrades["deluxomode"] then
            triggerServerEvent("vehicleDeluxo", resourceRoot, veh)
        end
    end
end)

function refreshList()
    interaction.list = {
        {
            text = function(veh) return (getVehicleEngineState(veh) and "Zgaś silnik" or "Uruchom silnik") end,
            txt = 'Silnik',
            icon = "motor",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleEngine",
        },

        {
            text = function(veh) return (getVehicleOverrideLights(veh) == 2 and "Zgaś światła" or "Włącz światła") end,
            txt = 'Światła',
            icon = "headlights",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleLights",
        },

        {
            text = function(veh) return (not isElementFrozen(veh) and "Zaciągnij ręczny" or "Spuść ręczny") end,
            txt = 'Hamulec ręczny',
            icon = "brake",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleHandbrake",
        },

        {
            text = function(veh) return (isVehicleLocked(veh) and "Otwórz pojazd" or "Zamknij pojazd") end,
            txt = 'Zamek',
            icon = "lock",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleDoors",
        },

        {
            text = function(veh) return (getVehicleDoorOpenRatio(veh, 1) == 0 and "Otwórz bagażnik" or "Zamknij bagażnik") end,
            txt = 'Bagażnik',
            icon = "doors",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleTrunk",
        },

        {
            text = function(veh) return ("Wyrzuć pasażerów") end,
            txt = 'Pasażerowie',
            icon = "kick",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "kickPassengers",
        },

    }

    local veh = getPedOccupiedVehicle(localPlayer)
    if getElementModel(veh) == 578 then
        if getElementData(veh, "vehicle:faction") == 'SARA' or getElementData(veh, "vehicle:faction") == 'SAPD' then
            table.insert(interaction.list, {

                text = function(veh) return (getElementData(veh, "vehicle:loaded:laweta") and "Rozładuj lawetę" or "Załaduj lawetę") end,
                txt = 'Interakcja frakcyjna',
                icon = "tow",
                x = sx/2 - 150/zoom,
                y = sy - 80/zoom,
                trigger = "toggleZaladunek",

            })
        end
    end

    if getElementData(veh, "vehicle:faction") == 'SAFD' then
        table.insert(interaction.list, {

            text = function(veh) return (getInteractionStateFaction(veh) and "Wyłącz interakcje frakcyjną" or "Włącz interakcje frakcyjną") end,
            txt = 'Interakcja frakcyjna',
            icon = "ecu",
            x = sx/2 - 150/zoom,
            y = sy - 80/zoom,
            trigger = "vehicleFactionInteraction",

        })
    end

end

function isInteractionOpened()
    return interaction.open
end

function switchInteraction(_, c)
    if c and (not getPedOccupiedVehicle(localPlayer) or getPedOccupiedVehicleSeat(localPlayer) ~= 0) then return end
    if c == "down" then
        interaction.mask = dxCreateTexture("data/mask.png")
        interaction.shadow = dxCreateTexture('data/shadow.png', 'argb', false, 'clamp')
        interaction.shader = dxCreateShader("data/mask.fx")
        interaction.rt = dxCreateRenderTarget(600, 500, true)
        dxSetShaderValue(interaction.shader, "sPicTexture", interaction.rt)
        dxSetShaderValue(interaction.shader, "sMaskTexture", interaction.mask)

        refreshList()
        addTune(getPedOccupiedVehicle(localPlayer))
        interaction.open = true
        interaction.current = 1
        interaction.pos = false
        bindKey("arrow_d", "down", changeDown)
        bindKey("arrow_u", "down", changeUp)
        bindKey("arrow_l", "down", regulateIT)
        bindKey("arrow_r", "down", regulateIT)
        bindKey("mouse1", "down", regulateIT)
        bindKey("mouse1", "down", selectOption)
        bindKey("mouse2", "down", regulateIT)
        bindKey("mouse_wheel_down", "down", changeDown)
        bindKey("mouse_wheel_up", "down", changeUp)
        bindKey("space", "down", selectOption)
        addEventHandler("onClientRender", root, renderInteraction)
    else
        if isElement(interaction.mask) then destroyElement(interaction.mask) end
        if isElement(interaction.shadow) then destroyElement(interaction.shadow) end
        if isElement(interaction.shader) then destroyElement(interaction.shader) end
        if isElement(interaction.rt) then destroyElement(interaction.rt) end
        interaction.mask = nil
        interaction.shadow = nil
        interaction.shader = nil
        interaction.rt = nil
        interaction.open = false
        unbindKey("arrow_d", "down", changeDown)
        unbindKey("arrow_u", "down", changeUp)
        unbindKey("arrow_l", "down", regulateIT)
        unbindKey("arrow_r", "down", regulateIT)
        unbindKey("mouse1", "down", regulateIT)
        unbindKey("mouse2", "down", regulateIT)
        unbindKey("space", "down", selectOption)
        unbindKey("mouse1", "down", selectOption)
        unbindKey("mouse_wheel_down", "down", changeDown)
        unbindKey("mouse_wheel_up", "down", changeUp)
        removeEventHandler("onClientRender", root, renderInteraction)
    end
end
bindKey("lshift", "both", switchInteraction)

function changeUp()
    interaction.current = interaction.current - 1

    if interaction.current <= 0 then
        interaction.current = #interaction.list
        interaction.pos = interaction.pos + (#interaction.list)*90
    end
end

function changeDown()
    interaction.current = interaction.current + 1

    if interaction.current > #interaction.list then
        interaction.current = 1
        interaction.pos = interaction.pos - (#interaction.list)*90
    end
end

function regulateIT(k, ks)
    local veh = getPedOccupiedVehicle(localPlayer)

    if getElementSpeed(veh, "km/h") > 5 then return end

    
    local text = interaction.list[interaction.current].text(veh)

    if getElementData(veh, 'vehicle:toggleDriftmode') and text ~= 'Regulacja zawieszenia' then
        return exports['since-notifications']:sendNotification('error', 'Nie możesz regulować modułów mając włączony driftmode!')
    end

    if veh and regulations[text] then
        local actualRegulateData = interaction.list[interaction.current].data
        local actualRegulateLimits = interaction.list[interaction.current].limits
        local actualRegulateEvent = interaction.list[interaction.current].event

        if actualRegulateLimits == nil then
            if k  == "arrow_r" or k == 'mouse2' and ks == "down" then
                triggerServerEvent(actualRegulateEvent, resourceRoot, veh, "up")
            elseif k == "arrow_l" or k == 'mouse1' and ks == "down" then
                triggerServerEvent(actualRegulateEvent, resourceRoot, veh, "down")
            end
        else
            if k  == "arrow_r" or k == 'mouse2' and ks == "down" then
                local level = getElementData(veh, actualRegulateData) or 0
                if level >= actualRegulateLimits.up then return end
    
                setElementData(veh, actualRegulateData, level+1)
                triggerServerEvent(actualRegulateEvent, resourceRoot, veh, "up")
            elseif k == "arrow_l" or k == 'mouse1' and ks == "down" then
                local level = getElementData(veh, actualRegulateData) or 0
                if actualRegulateLimits.down >= level then return end
                setElementData(veh, actualRegulateData, level-1)
                triggerServerEvent(actualRegulateEvent, resourceRoot, veh, "down")
            end
        end
    end
end

function selectOption()
    local veh = getPedOccupiedVehicle(localPlayer)

    if veh then
        if interaction.list[interaction.current].icon ~= "roof" then
            text = interaction.list[interaction.current].text(veh)
        else
            text = nil
        end

        if text == "Zaciągnij ręczny" then
            if getElementSpeed(veh, "km/h") > 5 then return end
        end

        if interaction.list[interaction.current].icon == "taxo" then
                exports["since-etransporterJob"]:turnPanel(true)
                interaction.open = false
                unbindKey("arrow_d", "down", changeDown)
                unbindKey("arrow_u", "down", changeUp)
                unbindKey("arrow_l", "down", regulateIT)
                unbindKey("arrow_r", "down", regulateIT)
                unbindKey("space", "down", selectOption)
                removeEventHandler("onClientRender", root, renderInteraction)
            return
        end

        if not regulations[text] then
            triggerServerEvent(interaction.list[interaction.current].trigger, resourceRoot, getPedOccupiedVehicle(localPlayer))
        end
    end
end

function shadowText(text, x, y, w, h, color, ...)
    for _x = -1, 1 do
        for _y = -1, 1 do
            dxDrawText(text, x+_x, y+_y, w+_x, h+_y, tocolor(0, 0, 0, 100), ...)
        end
    end
    return dxDrawText(text, x, y, w, h, color, ...)
end

function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function enterVehicle(player, seat)
    if player ~= localPlayer and seat ~= 0 then
        return
    end

    local upgrades = getElementData(source, 'vehicle:upgrades') or {}
    if upgrades and upgrades["deluxomode"] then
        
    end
end
addEventHandler('onClientVehicleEnter', root, enterVehicle)

setWorldSpecialPropertyEnabled( "extraairresistance", false )
addEventHandler("onClientPreRender", root, function(dt) delta = dt end)

addEvent("toggleDeluxo", true)
addEventHandler("toggleDeluxo", resourceRoot, function(bool)
	setWorldSpecialPropertyEnabled("aircars", bool)
end)

addEvent("toggleHover", true)
addEventHandler("toggleHover", root, function(bool)
	setWorldSpecialPropertyEnabled("hovercars", bool)
end)

local acceptedTypes = {

    ['Automobile'] = true,
    ['Bike'] = true,

}

function onCarJump()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	if vehicle and isPedInVehicle(localPlayer) and getVehicleController(vehicle) == localPlayer and isVehicleOnGround(vehicle) then
		local vehType = getVehicleType(vehicle)
		
        if not acceptedTypes[vehType] then 
            return 
        end

        local tunings = getElementData(vehicle, "vehicle:upgrades") or {}

        if not tunings['jumpmode'] then
            return
        end

		local sx, sy, sz = getElementVelocity(vehicle)
		setElementVelocity(vehicle, sx, sy, sz + 0.25)

        setTimer(function()
            setVehicleNitroActivated(vehicle, false)
        end, 100, 2)
	end
end

function initCarJump()
	bindKey("lctrl", "down", onCarJump)
end
addEventHandler("onClientResourceStart", resourceRoot, initCarJump)

getResourceName(getThisResource(), true, 919341440); if true then return end
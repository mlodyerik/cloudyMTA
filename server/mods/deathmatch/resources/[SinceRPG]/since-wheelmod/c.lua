local settings = {
    maxDistance = 20,
    shaderDistance = 20,
    shader = "img/shader.fx",
    shaderOutter = "img/shaderOutter.fx",
    shaderTexture = "img/textureChanger.fx",
}

local Wheels = {}
local savedData = {}
local refreshTick = getTickCount()
Wheels.streamed = {}
Wheels.createdWheels = {}
Wheels.shaders = {}
Wheels.textures = {}
Wheels.textures.wheelColor = dxCreateTexture("img/wounds.png", "dxt3", true, "clamp")
Wheels.textures.brakesColor = dxCreateTexture("img/freio.png", "dxt3", true, "clamp")
Wheels.textures.names = {

    --['bialy'] = true,
    ['rims'] = true,
    ['wounds'] = true,

}
Wheels.block = nil

local streamedVehicles = {}
local frozenBlock = {}

function getVehicleSpeed(vehicle)
    local vx, vy, vz = getElementVelocity(vehicle)
    return math.sqrt(vx^2 + vy^2 + vz^2) * 180
end

local loadedRotations = {}

function checkIsHaveTunedWheels(veh)
    local wheels = {'wheel_lf_dummy', 'wheel_rf_dummy', 'wheel_rb_dummy', 'wheel_lb_dummy'}
    local haveWheels = getVehicleUpgradeOnSlot(veh, 12) or false

    if haveWheels and haveWheels > 0 then
        for i = 1, #wheels do
            setVehicleComponentVisible(veh, wheels[i], false)

            if not getElementData(veh, "vehicle:wheelTuning") then
                setElementData(veh, "vehicle:wheelTuning", {
                    wheelResize = 1,
                    wheelTilt = 0,
                    innerSize = 0.9,
                })
            end
        end
    else
        for i = 1, #wheels do
            setVehicleComponentVisible(veh, wheels[i], true)
        end
    end
end

function calculateWheelsRotation(vehicle, wheels)
    local wheelNames = {'wheel_lf_dummy', 'wheel_rf_dummy', 'wheel_rb_dummy', 'wheel_lb_dummy'}
    local visualTune = getElementData(vehicle, "vehicle:wheelTuning") or {}
    if not visualTune then onWheelsStreamOut(vehicle) return end

    for i = 1, #wheels do
        local wheel = wheels[i]
        if (wheel.object) then
            local _, sy, sz = getVehicleComponentScale(vehicle, wheelNames[i])
            setObjectScale(wheel.object, (visualTune.wheelResize or 1), sy, sz)

            local rotation = Vector3(getVehicleComponentRotation(vehicle, wheel.name, 'world'))
            rotation.y = rotation.y + (visualTune.wheelTilt or 0)

            setElementPosition(wheel.object, Vector3(getVehicleComponentPosition(vehicle, wheel.name, 'world')))
            setElementRotation(wheel.object, rotation, "ZYX")
            setElementDimension(wheel.object, getElementDimension(vehicle))
        end
    end
end

function wheelsPreRender()
    local x, y, z = getElementPosition(localPlayer)
    
    for vehicle, wheels in pairs(Wheels.createdWheels) do
        if isElement(vehicle) and isElementOnScreen(vehicle) then
            local vx, vy, vz = getElementPosition(vehicle)
            local dist = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)

            if (vehicle) and (isElementStreamedIn(vehicle)) and (#wheels > 0) and dist < 25 then
                calculateWheelsRotation(vehicle, wheels)
            end
        else
            onWheelsStreamOut(vehicle)
        end
    end

    loadVehicleWheels()
end

function setCustomWheels(veh, wheelModel, wheelResize, wheelTilt)
    if (tonumber(wheelModel)) then
        for _, wheel in pairs(Wheels.createdWheels[veh] or {}) do
            destroyElement(wheel.object)
        end
        Wheels.createdWheels[veh] = nil

        local wheels = {'wheel_lf_dummy', 'wheel_rf_dummy', 'wheel_rb_dummy', 'wheel_lb_dummy'}
        for i = 1, #wheels do
            local wheel = {
                wheelResize = tonumber(wheelResize) or 0,
                tilt = tonumber(wheelTilt) or 0,
                name = wheels[i],
                object = createObject(wheelModel, Vector3()),
            }

            setElementParent(wheel.object, veh)
            setElementInterior(wheel.object, getElementInterior(veh))
            setElementDimension(wheel.object, getElementDimension(veh))

            setElementCollidableWith(wheel.object, veh, false)

            wheels[i] = wheel
        end
        Wheels.createdWheels[veh] = wheels
    end
end

function removeCustomWheels(veh)
    if not Wheels.createdWheels[veh] then return end
    for _, wheel in pairs(Wheels.createdWheels[veh] or {}) do
        if isElement(wheel.object) then destroyElement(wheel.object) end
    end

    for i, v in pairs(Wheels.streamed[veh]) do
        if isElement(v) then destroyElement(v) end
    end

    Wheels.createdWheels[veh] = nil
    Wheels.streamed[veh] = nil
    savedData[veh] = nil
    loadedRotations[veh] = true
end

local inners = {
   -- [1096] = 2,
}

local time = getTickCount()

function updateOneTime(veh)
    Wheels.streamed[veh].color = {getVehicleColor(veh, true)}
    local data = getElementData(veh, "vehicle:wheelTuning") or {}

    checkIsHaveTunedWheels(veh)

    if not Wheels.createdWheels[veh] then return end
    
    local model = getElementModel(Wheels.createdWheels[veh][1].object)
    local wheels = {'wheel_lf_dummy', 'wheel_rf_dummy', 'wheel_rb_dummy', 'wheel_lb_dummy'}
    for i = 1, #wheels do
        dxSetShaderValue(Wheels.streamed[veh].wheel, "innerSize", data.innerSize)
        dxSetShaderValue(Wheels.streamed[veh].wheel, "inner", (inners[model] or 0.45))
        dxSetShaderValue(Wheels.streamed[veh].wheel, "sLightColor", Vector4(Wheels.streamed[veh].color[7]/255, Wheels.streamed[veh].color[8]/255, Wheels.streamed[veh].color[9]/255, 1))

        dxSetShaderValue(Wheels.streamed[veh].wounds, "innerSize", data.innerSize)
        dxSetShaderValue(Wheels.streamed[veh].wounds, "inner", (inners[model] or 0.45))
        dxSetShaderValue(Wheels.streamed[veh].wounds, "sLightColor", Vector4(Wheels.streamed[veh].color[10]/255, Wheels.streamed[veh].color[11]/255, Wheels.streamed[veh].color[12]/255, 1))
        

        engineApplyShaderToWorldTexture(Wheels.streamed[veh].wheel, 'rims', Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].wounds, 'wounds', Wheels.createdWheels[veh][i].object)

        setVehicleComponentVisible(veh, wheels[i], false)
    end
    
    for i = 1, #wheels do
        local vehUpgrades = getElementData(veh, 'vehicle:upgrades') or {}
        local brakesColor = vehUpgrades['brakesColor'] or {255, 255, 255}
        dxSetShaderValue(Wheels.streamed[veh].brakes, "sLightColor", Vector4(brakesColor[1]/255, brakesColor[2]/255, brakesColor[3]/255, 1))
            
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].brakes, 'freio', Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].brakes, 'Freio', Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].brakes, 'Freio(2)', Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].brakes, 'Freio(3)', Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].brakes, 'Freio(4)', Wheels.createdWheels[veh][i].object)
    end
    
    for i = 1, #wheels do
        dxSetShaderValue(Wheels.streamed[veh].outter, "innerSize", data.innerSize)
        dxSetShaderValue(Wheels.streamed[veh].outter, "inner", (inners[model] or 0.45))
        
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].outter, "ad08_sidewall", Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].outter, "advan", Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].outter, "tyrewall_dirt_1", Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].outter, "tiresim", Wheels.createdWheels[veh][i].object)
        engineApplyShaderToWorldTexture(Wheels.streamed[veh].outter, "tiresim_sidewall", Wheels.createdWheels[veh][i].object)
    end

    dxSetShaderValue(Wheels.streamed[veh].wheel, "sTex0", Wheels.textures.wheelColor)
    dxSetShaderValue(Wheels.streamed[veh].wounds, "sTex0", Wheels.textures.wheelColor)
    dxSetShaderValue(Wheels.streamed[veh].brakes, "sTex0", Wheels.textures.brakesColor)
end

function updateWheelsColor(veh)
    checkIsHaveTunedWheels(veh)
    Wheels.streamed[veh].color = {getVehicleColor(veh, true)}
    local data = getElementData(veh, "vehicle:wheelTuning") or {}
    local upgrades = getElementData(veh, 'vehicle:upgrades') or {}

    if not Wheels.createdWheels[veh] then return end

    local model = getElementModel(Wheels.createdWheels[veh][1].object)
    local wheels = {'wheel_lf_dummy', 'wheel_rf_dummy', 'wheel_rb_dummy', 'wheel_lb_dummy'}
    local brakesColorr = upgrades['brakesColor'] or {255, 255, 255}
    
    -- Initialize saved data if not present
    if not savedData[veh] then
        local wheelsID = getVehicleUpgradeOnSlot(veh, 12)
        savedData[veh] = {
            innerSize = 12312321,
            wheelResize = 123123123131,
            wheelTilt = 123131312312,
            wheelID = wheelsID,
            color = {123123123, 12312312312,312312312312,3123123213,312312312312,312312312312,312312312312,312312312312,312312312312,312312312312,312312312312,312312312312},
            brakesColor = {123123123, 1231231, 12312312}
        }

        updateOneTime(veh)
    end

    -- Check if any values have changed
    local isChanged = false

    if savedData[veh].wheelID ~= getVehicleUpgradeOnSlot(veh, 12) then
        isChanged = true
        savedData[veh].wheelID = getVehicleUpgradeOnSlot(veh, 12)

        for i = 1, #wheels do
            setVehicleComponentVisible(veh, wheels[i], false)
        end
    end

    if savedData[veh].innerSize ~= data.innerSize then
        isChanged = true
        savedData[veh].innerSize = data.innerSize

        for i = 1, #wheels do
            setVehicleComponentVisible(veh, wheels[i], false)
        end
    end

    if savedData[veh].color[7] ~= Wheels.streamed[veh].color[7] or
       savedData[veh].color[8] ~= Wheels.streamed[veh].color[8] or
       savedData[veh].color[9] ~= Wheels.streamed[veh].color[9] or
       savedData[veh].color[10] ~= Wheels.streamed[veh].color[10] or
       savedData[veh].color[11] ~= Wheels.streamed[veh].color[11] or
       savedData[veh].color[12] ~= Wheels.streamed[veh].color[12] then
        isChanged = true
        savedData[veh].color = Wheels.streamed[veh].color

        for i = 1, #wheels do
            setVehicleComponentVisible(veh, wheels[i], false)
        end
    end

    if savedData[veh].brakesColor[1] ~= brakesColorr[1] or
       savedData[veh].brakesColor[2] ~= brakesColorr[2] or
       savedData[veh].brakesColor[3] ~= brakesColorr[3] then
        isChanged = true
        savedData[veh].brakesColor = brakesColorr

        for i = 1, #wheels do
            setVehicleComponentVisible(veh, wheels[i], false)
        end
    end

    -- Only update shaders if there are changes
    if isChanged then
        -- Collect all shader updates for this vehicle
        local updates = {}

        for i = 1, #wheels do
            table.insert(updates, function()
                dxSetShaderValue(Wheels.streamed[veh].wheel, "innerSize", data.innerSize)
                dxSetShaderValue(Wheels.streamed[veh].wheel, "inner", (inners[model] or 0.45))
                dxSetShaderValue(Wheels.streamed[veh].wheel, "sLightColor", Vector4(Wheels.streamed[veh].color[7]/255, Wheels.streamed[veh].color[8]/255, Wheels.streamed[veh].color[9]/255, 1))

                dxSetShaderValue(Wheels.streamed[veh].wounds, "innerSize", data.innerSize)
                dxSetShaderValue(Wheels.streamed[veh].wounds, "inner", (inners[model] or 0.45))
                dxSetShaderValue(Wheels.streamed[veh].wounds, "sLightColor", Vector4(Wheels.streamed[veh].color[10]/255, Wheels.streamed[veh].color[11]/255, Wheels.streamed[veh].color[12]/255, 1))
                

                engineApplyShaderToWorldTexture(Wheels.streamed[veh].wheel, 'rims', Wheels.createdWheels[veh][i].object)
                engineApplyShaderToWorldTexture(Wheels.streamed[veh].wounds, 'wounds', Wheels.createdWheels[veh][i].object)

                setVehicleComponentVisible(veh, wheels[i], false)
            end)

            table.insert(updates, function()
                local vehUpgrades = getElementData(veh, 'vehicle:upgrades') or {}
                local brakesColor = vehUpgrades['brakesColor'] or {255, 255, 255}
                dxSetShaderValue(Wheels.streamed[veh].brakes, "sLightColor", Vector4(brakesColor[1]/255, brakesColor[2]/255, brakesColor[3]/255, 1))
                engineApplyShaderToWorldTexture(Wheels.streamed[veh].brakes, 'freio', Wheels.createdWheels[veh][i].object)
            end)

            table.insert(updates, function()
                dxSetShaderValue(Wheels.streamed[veh].outter, "innerSize", data.innerSize)
                dxSetShaderValue(Wheels.streamed[veh].outter, "inner", (inners[model] or 0.45))
                engineApplyShaderToWorldTexture(Wheels.streamed[veh].outter, 'tyre', Wheels.createdWheels[veh][i].object)
                engineApplyShaderToWorldTexture(Wheels.streamed[veh].outter, 'offroadtyre', Wheels.createdWheels[veh][i].object)
            end)
        end

        -- Apply texture changes to shaders
        table.insert(updates, function()
            dxSetShaderValue(Wheels.streamed[veh].wheel, "sTex0", Wheels.textures.wheelColor)
            dxSetShaderValue(Wheels.streamed[veh].wounds, "sTex0", Wheels.textures.wheelColor)
            dxSetShaderValue(Wheels.streamed[veh].brakes, "sTex0", Wheels.textures.brakesColor)
        end)

        -- Execute all updates for this vehicle
        for _, update in ipairs(updates) do
            update()
        end
    end
end


function onWheelsStreamIn(veh, details)
    if Wheels.block then return end

    if getElementType(veh) ~= "vehicle" then 
        return 
    end

    if not isElementOnScreen(veh) then 
        return 
    end

    if not Wheels.streamed[veh] then
        local wheels = {'wheel_lf_dummy', 'wheel_rf_dummy', 'wheel_rb_dummy', 'wheel_lb_dummy'}
        
        Wheels.streamed[veh] = {
            wheel = dxCreateShader(settings.shader, 0, 0, false, "object"),
            wounds = dxCreateShader(settings.shader, 0, 0, false, "object"),
            brakes = dxCreateShader(settings.shader, 0, 0, false, "object"),
            outter = dxCreateShader(settings.shaderOutter, 0, 0, false, "object"),
            vehicle = dxCreateShader(settings.shader, 0, settings.maxDistance * 2, false, "vehicle"),
            color = {getVehicleColor(veh, true)},
        }
        
        dxSetShaderValue(Wheels.streamed[veh].vehicle, "sTex0", Wheels.textures.wheelColor)

        frozenBlock[veh] = nil
    end


    if not details then 
        return updateWheelsColor(veh) 
    end

    if Wheels.createdWheels[veh] then
        updateWheelsColor(veh)

        local upgrades = getVehicleUpgrades(veh)
        local wheelModel = false
        if upgrades then
            for i, v in pairs(upgrades) do
                local type = string.lower(getVehicleUpgradeSlotName(v))
                if type == "wheels" then
                    wheelModel = v
                end
            end
        end

        if not Wheels.createdWheels[veh][1].object or not wheelModel then onWheelsStreamOut(veh) return end
        if getElementModel(Wheels.createdWheels[veh][1].object) ~= wheelModel then
            local wheels = {'wheel_lf_dummy', 'wheel_rf_dummy', 'wheel_rb_dummy', 'wheel_lb_dummy'}
            for i = 1, #wheels do
                setElementModel(Wheels.createdWheels[veh][i].object, wheelModel)
                local _, sy, sz = getVehicleComponentScale(veh, wheels[i])
                setObjectScale(Wheels.createdWheels[veh][i].object, Wheels.createdWheels[veh][i].wheelResize, sy, sz)
            end
        end
        return
    end

    if getDistanceBetweenPoints2D(Vector2(getElementPosition(localPlayer)), Vector2(getElementPosition(veh))) >= settings.maxDistance then return end
    local visualTune = getElementData(veh, "vehicle:wheelTuning")
    if not visualTune then return updateWheelsColor(veh) end

    local upgrades = getVehicleUpgrades(veh)
    local wheelModel = false
    if upgrades then
        for i, v in pairs(upgrades) do
            local type = string.lower(getVehicleUpgradeSlotName(v))
            if type == "wheels" then
                wheelModel = v
            end
        end
    end
    if not wheelModel then updateWheelsColor(veh) return end
    if not visualTune.wheelResize and not visualTune.wheelTilt then updateWheelsColor(veh) return end

    setCustomWheels(veh, wheelModel, tonumber(visualTune.wheelResize) or 1, tonumber(visualTune.wheelTilt) or 0)
    updateWheelsColor(veh)
end

function onWheelsStreamOut(veh)
    if not isElement(veh) then
        removeCustomWheels(veh)
        Wheels.streamed[veh] = nil
        savedData[veh] = nil
        loadedRotations[veh] = nil
        return
    end

    if getElementType(veh) ~= "vehicle" then return end
    if not Wheels.streamed[veh] then return end

    removeCustomWheels(veh)
    Wheels.streamed[veh] = nil
    savedData[veh] = nil
    loadedRotations[veh] = nil

    frozenBlock[veh] = nil
end

function loadVehicleWheels()
    if Wheels.block then return end
    local plrPos = Vector2(getElementPosition(localPlayer))

    for i, v2 in pairs(streamedVehicles) do
        local v = i
        if not v or not isElement(v) then
            streamedVehicles[v] = nil
            return
        end
        if (v) and (isElementStreamedIn(v)) and isElementOnScreen(v) then
            local vehPos = Vector2(getElementPosition(v))

            if getDistanceBetweenPoints2D(plrPos, vehPos) < settings.maxDistance then
                onWheelsStreamIn(v, true)
            elseif getDistanceBetweenPoints2D(plrPos, vehPos) < settings.maxDistance * 2 then
                onWheelsStreamIn(v)
            else
                onWheelsStreamOut(v)
            end
        else
            onWheelsStreamOut(v)
        end
    end
end
addEventHandler("onClientPreRender", root, wheelsPreRender)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "vehicle" then
        streamedVehicles[source] = true
    end
end)

addEventHandler("onClientElementStreamOut", root, function()
    if getElementType(source) == "vehicle" then
        if streamedVehicles[source] then
            streamedVehicles[source] = nil
            savedData[source] = nil
            onWheelsStreamOut(source)
        end           
    end
end)

function toggleWheelOn()
    Wheels.block = nil
    for i, v in pairs(getElementsByType("vehicle")) do
        if (v) and (isElementStreamedIn(v)) and isElementOnScreen(v) then
            streamedVehicles[v] = true
        end
    end
end
addEventHandler("onClientResourceStart", resourceRoot, toggleWheelOn)

function toggleWheelOff()
    Wheels.block = true
    local wheeeel = {'wheel_lf_dummy', 'wheel_rf_dummy', 'wheel_rb_dummy', 'wheel_lb_dummy'}
    for i, v in pairs(getElementsByType("vehicle")) do
        if (v) and (isElementStreamedIn(v)) then
            onWheelsStreamOut(v)
        end

        for i = 1, #wheeeel do
            setVehicleComponentVisible(v, wheeeel[i], true)
        end
    end
end
addEventHandler("onClientResourceStop", resourceRoot, toggleWheelOff)

function hideWheels(state)
    if state then
        toggleWheelOff()
    else
        toggleWheelOn()
    end
end
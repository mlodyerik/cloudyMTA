factionVehicles = {

    ['SAPD'] = {},
    ['SARA'] = {},
    ['SAFD'] = {},
    ['TSA'] = {},

}

shapes = {}

function destroyAllSpheres()
    for i, v in pairs(getElementsByType('colshape', resourceRoot)) do
        if getElementData(v, 'vehicle:shape') then
            destroyElement(v)
        end
    end
end
addEventHandler('onResourceStop', resourceRoot, destroyAllSpheres)

function setVehicleDesc(veh, text)
    local upgrades = getElementData(veh, "vehicle:upgrades") or {}
    upgrades['vopis'] = true
    upgrades['vopis:text'] = text
    setElementData(veh, "vehicle:upgrades", upgrades)
end

addEvent("onPlayerFactionParking", true)
addEventHandler("onPlayerFactionParking", resourceRoot, function(takeType, data, faction)
    if not getElementData(client, 'player:faction') then return end
    
    if takeType == 'take' then
        local name, handling, rankID, model, code = unpack(data)
        local x, y, z, rx, ry, rz = unpack(factionSpawns[faction])
        local playerSID = getElementData(client, 'player:sid')
        
        if factionVehicles[faction][client] then
            destroyElement(factionVehicles[faction][client])
            factionVehicles[faction][client] = nil
        end

        factionVehicles[faction][client] = createVehicle(model, x, y, z, rx, ry, rz)
        setElementData(factionVehicles[faction][client], 'vehicle:rank', rankID)
        setElementData(factionVehicles[faction][client], 'vehicle:faction', faction)

        setVehiclePlateText(factionVehicles[faction][client], code..' '..#factionVehicles[faction])

        if faction == 'SAPD' then
            setElementData(factionVehicles[faction][client], "vehicle:lights:sirens", true)
            setElementData(factionVehicles[faction][client], "vehicle:police", true)

            if model == 578 then
                local x, y, z = getElementPosition(factionVehicles[faction][client])
                shapes[factionVehicles[faction][client]] = createColSphere(x, y, z, 4)
                attachElements(shapes[factionVehicles[faction][client]], factionVehicles[faction][client], 0, -8, -0.605)
                setElementData(shapes[factionVehicles[faction][client]], 'vehicle:shape', factionVehicles[faction][client])
            end
        elseif faction == 'SARA' and model  == 578 then
            local x, y, z = getElementPosition(factionVehicles[faction][client])
	        shapes[factionVehicles[faction][client]] = createColSphere(x, y, z, 4)
	        attachElements(shapes[factionVehicles[faction][client]], factionVehicles[faction][client], 0, -8, -0.605)
            setElementData(shapes[factionVehicles[faction][client]], 'vehicle:shape', factionVehicles[faction][client])
        elseif faction == 'TSA' then
            setElementData(factionVehicles[faction][client], 'vehicle:taxi', {})
            setVehicleDesc(factionVehicles[faction][client], '#ffae00Transport of San Andreas#ffffff\nKierowca: #2E756F'..getPlayerName(client):gsub("#%x%x%x%x%x%x", ""))
        end

        exports['since-handlings']:loadVehicleCustomHandling(factionVehicles[faction][client])

        for k, v in pairs(handling) do
            local hData = getVehicleHandlingProperty(factionVehicles[faction][client], k)
            setVehicleHandling(factionVehicles[faction][client], k, type(v) == 'string' and v or v)
        end

        setTimer(warpPedIntoVehicle, 100, 1, client, factionVehicles[faction][client])

        local specialData = vehicles[faction][rankID]
        for i, v in ipairs(specialData) do
            if v.name == name then
                if v.specialData then
                    v.specialData(factionVehicles[faction][client])
                end
            end
        end

        exports['since-notifications']:sendNotification(client, 'info', 'Wyjmujesz pojazd '..name..' z wirtualnego parkingu, aby go odstawić wjedź ponownie do markeru.')
    elseif takeType == 'return' then
        if shapes[factionVehicles[faction][client]] then
            destroyElement(shapes[factionVehicles[faction][client]])
            shapes[factionVehicles[faction][client]] = nil
        end

        if factionVehicles[faction][client] then
            destroyElement(factionVehicles[faction][client])
            factionVehicles[faction][client] = nil
        end
    end
end)

addEventHandler('onPlayerQuit', root, function()
    for i, v in pairs(factionVehicles) do
        if factionVehicles[i][source] then
            destroyElement(factionVehicles[i][source])
            factionVehicles[i][source] = nil
        end
    end
end)

addEventHandler('onVehicleStartEnter', resourceRoot, function(plr, seat)
    if getElementData(source, 'vehicle:faction') and plr then
        local playerFaction = getElementData(plr, 'player:faction') or false

        if getElementData(source, 'vehicle:faction') == 'TSA' and seat ~= 0 then
            return
        end
        
        if getElementData(source, 'vehicle:faction') ~= playerFaction then
            cancelEvent()
        end
    end
end)

function getVehicleHandlingProperty ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then
        local handlingTable = getVehicleHandling ( element ) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
 
    return false
end
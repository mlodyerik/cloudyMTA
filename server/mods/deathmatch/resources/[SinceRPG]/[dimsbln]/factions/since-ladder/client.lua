getResourceName(getThisResource(), true, 304002136); if true then return end

engineReplaceModel(engineLoadDFF("ladder.dff"), 544)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )  -- Get the matrix
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]  -- Apply transform
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z                               -- Return the transformed point
end

local h, j, h2, j2 = 0, 0, 0, 0

function render()
    if getPedOccupiedVehicle(localPlayer) then
        local vehicle = getPedOccupiedVehicle(localPlayer)
        if getKeyState("arrow_r") then
            local a, b, c = getVehicleComponentRotation(vehicle, "drabina1")
            local a2, b2, c2 = getVehicleComponentRotation(vehicle, "drabina1")
            local x, y, z = getVehicleComponentPosition(vehicle, "drabina2")
            local x2, y2, z2 = getVehicleComponentPosition(vehicle, "drabina1")
            local a3, b3, c3 = getVehicleComponentRotation(vehicle, "drabina1")
            if c >= 105 and c < 106 then
                return false
            end
                setVehicleComponentRotation(vehicle, "drabina1", a, b, c+1)
                setVehicleComponentRotation(vehicle, "drabina2", h, j, c2+1)
                setVehicleComponentRotation(vehicle, "drabina3", h2, j2, c3+1)
            --setVehicleComponentPosition(vehicle, "drabina3", x, y, z)
            --setVehicleComponentPosition(vehicle, "drabina2", x2, y2, z2)
        elseif getKeyState("arrow_l") then
            local a, b, c = getVehicleComponentRotation(vehicle, "drabina1")
            local a2, b2, c2 = getVehicleComponentRotation(vehicle, "drabina1")
            local a3, b3, c3 = getVehicleComponentRotation(vehicle, "drabina1")
            if c >= 250 and c < 251 then
                return false
            end
            setVehicleComponentRotation(vehicle, "drabina1", a, b, c-1)
            setVehicleComponentRotation(vehicle, "drabina2", h, j, c2-1)
            setVehicleComponentRotation(vehicle, "drabina3", h2, j2, c3-1)
        elseif getKeyState("arrow_u") then
            h, j, k = getVehicleComponentRotation(vehicle, "drabina2")
            h2, j2, k2 = getVehicleComponentRotation(vehicle, "drabina3")
            if h <= 325 and h > 324 then
                return false
            end
            local d1, d2, d3 = getVehicleComponentPosition(vehicle, "drabina2")
            setVehicleComponentPosition(vehicle, "drabina3", d1, d2, d3)
            setVehicleComponentRotation(vehicle, "drabina2", h-1, j, k2)
            setVehicleComponentRotation(vehicle, "drabina3", h2-1, j2, k2)
        elseif getKeyState("arrow_d") then
            h, j, k = getVehicleComponentRotation(vehicle, "drabina2")
            h2, j2, k2 = getVehicleComponentRotation(vehicle, "drabina3")
            if h <= 1 then
                return false
            end
            setVehicleComponentRotation(vehicle, "drabina2", h+1, j, k)
            setVehicleComponentRotation(vehicle, "drabina3", h2+1, j, k2)
        elseif getKeyState("end") then
            local x, y, z = getVehicleComponentPosition(vehicle, "drabina3")
            local d1, d2, d3 = getVehicleComponentPosition(vehicle, "drabina2")
            setVehicleComponentPosition(vehicle, "drabina3", d1, d2 - 0.1, d3)
        end

        if getKeyState("space") then
            setVehicleComponentRotation(vehicle, "drabina1", 0, 0, 0)
            setVehicleComponentRotation(vehicle, "drabina2", 0, 0, 0)
            setVehicleComponentRotation(vehicle, "drabina3", 0, 0, 0)
            setVehicleComponentPosition(vehicle, "drabina3", 0, 0, 1.3)
        end
    end
end

addEventHandler("onClientRender", root, render)

addCommandHandler("vcp", -- short for 'vehicle component position'
    function()
        local theVeh = getPedOccupiedVehicle(localPlayer)
	local getComponent = getVehicleComponents(theVeh) -- returns table with all the components of the vehicle
        if (theVeh) then
            for k in pairs (getComponent) do
		local x, y, z = getVehicleComponentPosition(theVeh, k)
                outputChatBox("Position of "..k.." is"..x.." "..y.." "..z)
            end
        end
    end
)
local actions = {

    ['vehicle'] = {

        [1] = {

            fnc = function(player, element)
                local x, y, z = getElementRotation(element)
                setElementRotation(element, 0, 0, z)
            end,

            message = function(player, element)
                return {'Pojazd został pomyślnie obrócony.', '#3fff38✓'}
            end

        },

        [2] = {

            fnc = function(player, element)
                fixVehicle(element)
            end,

            message = function(player, element)
                return {'Pojazd został pomyślnie naprawiony.', '#3fff38✓'}
            end

        },

        [3] = {

            fnc = function(player, element)
                local x, y, z = getElementPosition(player)
                setElementPosition(element, x, y, z)
                setElementPosition(player, x, y, z+1)
            end,

            message = function(player, element)
                return {'Pojazd został pomyślnie przeniesiony.', '#3fff38✓'}
            end

        },

        [4] = {

            fnc = function(player, element)
                if getElementData(element, "vehicle:id") then
                    if isElement(element) then
                        exports['since-db']:query('UPDATE `since-vehicles` SET state=? WHERE id=?', 1, getElementData(element,'vehicle:id'))
                        exports['since-core']:saveVehicle(element)
                        destroyElement(element)

                        exports['since-adminpanel']:addAdminStats(player, 'vehicles', 1)
                    end
                end
            end,

            message = function(player, element)
                if getElementData(element, 'vehicle:id') then
                    return {'Pojazd został przeniesiony do przechowalni #c9bf9b(ID: '..getElementData(element, 'vehicle:id')..').', '#3fff38✓'}
                end

                return {'Brak ID pojazdu.', '#ff2121✘'}
            end

        },

        [5] = {

            fnc = function(player, element)
                local fuelData = tonumber(getElementData(element, "vehicle:fuel")) and {tank=100} or getElementData(element, "vehicle:fuel")

                if fuelData then
                    fuelData.count = fuelData.tank * 0.15
                    setElementData(element, 'vehicle:fuel', fuelData)
                end
            end,

            message = function(player, element)
                return {'Pojazd został pomyślnie zatankowany', '#3fff38✓'}
            end
        },

        [6] = {

            fnc = function(player, element)
                setVehicleLocked(element, false)
            end,

            message = function(player, element)
                return {'Pojazd został pomyślnie otwarty', '#3fff38✓'}
            end
        },

        [7] = {

            fnc = function(player, element)
                setElementData(element, 'vehicle:stereo', false)
                setElementData(element, 'vehicle:link', false)
                setElementData(element, 'vehicle:volume', false)
            end,

            message = function(player, element)
                return {'Stereo zostało wyłączone', '#3fff38✓'}
            end
        },

        [8] = {

            fnc = function(player, element)
                exports['since-whellock']:toggleWheelBlock(player, element)
            end,

            message = function(player, element)
                return {'Blokada została usunięta', '#3fff38✓'}
            end
        },

        [9] = {
            fnc = function(player, element)
                if getElementData(element, "vehicle:id") then
                    return
                end

                if isElement(element) then
                    destroyElement(element)
                end
            end,

            message = function(player, element)
                -- return {'Pojazd został pomyślnie usunięty z mapy', '#3fff38✓'}
                -- if vehicle has id then return error
                if getElementData(element, 'vehicle:id') then
                    return {'Pojazd posiada ID, nie można go usunąć.', '#ff2121✘'}
                end

                return {'Pojazd został pomyślnie usunięty z mapy', '#3fff38✓'}
            end
        }

    },

    ['player'] = {

        [1] = {

            fnc = function(player, element)
                setElementHealth(element, 100)
            end,

            message = function(player, element)
                return {'Gracz #7dbeff' .. getPlayerName(element) .. '#ffffff został pomyślnie uleczony.', '#3fff38✓'}
            end

        },

        [2] = {

            fnc = function(player, element)
                local x, y, z = getElementPosition(player)
                setElementPosition(element, x, y, z)
            end,

            message = function(player, element)
                return {'Gracz #7dbeff' .. getPlayerName(element) .. '#ffffff został przeniesiony do Ciebie.', '#3fff38✓'}
            end

        },

        [3] = {

            fnc = function(player, element)
                local x, y, z = getElementPosition(player)
                setElementPosition(element, x, y, z)
            end,

            message = function(player, element)
                return {'Zostałeś przeniesiony do gracza '..getPlayerName(element)..'.', '#3fff38✓'}
            end

        },

        [4] = {

            fnc = function(player, element)
                setElementFrozen(element, false)
            end,

            message = function(player, element)
                return {'Gracz #7dbeff' .. getPlayerName(element) .. '#ffffff został pomyślnie odmrożony.', '#3fff38✓'}
            end

        },

    }

}

addEvent("onDryerAction", true)
addEventHandler("onDryerAction", resourceRoot, function(typ, selected, el)
    if not el or not selected then return end
    if not getElementData(client, 'player:admin') then return end
    if actions[typ] and actions[typ][selected] then
        outputChatBox(' ', client, 255, 175, 0, true)
        outputChatBox(actions[typ][selected].message(client, el)[2]..' #ffffff'..actions[typ][selected].message(client, el)[1], client, 75, 255, 75, true)
        outputChatBox(' ', client, 255, 175, 0, true)
        actions[typ][selected].fnc(client, el)
    end
end)
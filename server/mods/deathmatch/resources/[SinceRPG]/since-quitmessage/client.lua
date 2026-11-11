local messages = {}
local types = {

    ['Quit'] = 'Wyjście',
    ['Kicked'] = 'Wyrzucony',
    ['Timed out'] = 'Błąd połączenia',
    ['Banned'] = 'Zbanowany',
    ['Bad Connection'] = 'Błąd połączenia',
    ['Unknown'] = 'Nieznany'

}

function addMessage(name, uid, pos, type)
    if messages[uid] and isElement(messages[uid].element) then
        destroyElement(messages[uid].element)
        messages[uid].element = nil
    end

    messages[uid] = {

        element = createElement('text'),

    }

    text = "Gracz #2E756F"..name.."#ffffff (#2E756F"..uid.."#ffffff) opuścił gre\n(#ff6363"..types[type].."#ffffff)"

    setElementData(messages[uid].element, 'name', text)

    local x, y, z = unpack(pos)
    setElementPosition(messages[uid].element, x, y, z)
    
    setTimer(function(id)
        if isElement(messages[id].element) then
            destroyElement(messages[id].element)
            messages[id].element = nil
        end
    end, 10000, 1, uid)
end
addEvent("addQuitMessage", true)
addEventHandler("addQuitMessage", resourceRoot, addMessage)
getResourceName(getThisResource(), true, 503208829); if true then return end
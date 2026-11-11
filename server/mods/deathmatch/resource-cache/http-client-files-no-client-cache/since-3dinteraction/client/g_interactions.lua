INTERACTIONS = {}

function reloadInteractions()
    INTERACTIONS = {
        ["vehicle"] = { -- interakcja z pojazdami.
    
            {
                name = "quit",
                action = "Wyjdź",
                clientFunct = function()
                    return triggerEvent("onClientInteractionClear", resourceRoot)
                end
            },
    
        },
    
        ['object'] = {
    
            {
                name = "quit",
                action = "Wyjdź",
                clientFunct = function(element)
                    return triggerEvent("onClientInteractionClear", resourceRoot)
                end
            },
    
        },
    
        ["player"] = {
    
            {
                name = "add_friend",
                action = "Dodaj jako znajomego",
                clientFunct = function(element)
                    triggerServerEvent("envInteraction", resourceRoot, element, 'addFriend')
                end
            },
    
            {
                name = "documents",
                action = "Pokaż dokumenty",
                clientFunct = function(element)
                    triggerServerEvent("envInteraction", resourceRoot, element, 'showDocuments')
                end
            },
    
            {
                name = "send_trade",
                action = "Wymiana",
                clientFunct = function(element)
                    triggerServerEvent("envInteraction", resourceRoot, element, 'sendTrade')
                end
            },
    
            {
                name = "quit",
                action = "Wyjdź",
                clientFunct = function(element)
                    return triggerEvent("onClientInteractionClear", resourceRoot)
                end
            },
        }
    }
end
reloadInteractions()

function addInteractionOption(objType, data)
    -- add option up to quit option
    table.insert(INTERACTIONS[objType], #INTERACTIONS[objType], data)
end

function addObjectsInteraction(objectID)
    if objectID == 2942 then
        addInteractionOption("object", {
            name = "object",
            action = "Okradnij bankomat",
            clientFunct = function(element)
                --outputChatBox('✗#ffffff Funkcja tymczasowo wyłączona.', 255, 0, 0, true)
                turnOffInteraction()
                triggerServerEvent("envInteraction", resourceRoot, element, 'atmRobbery')
            end
        })
    end
end

allowedObjectsID = {

    [2942] = true,

}
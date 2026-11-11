local sx, sy = guiGetScreenSize()
local sound = nil
local browser = nil

local jumpscareTypes = {

    [1] = 'scary',
    [2] = 'bluescreen',
    [3] = 'bluescreen',
    [5] = 'banned',

}

local jumpscareType = nil

function render()
    if jumpscareTypes[jumpscareType] and fileExists('data/'..jumpscareTypes[jumpscareType]..'.png') then
        dxDrawImage(0, 0, sx, sy, 'data/'..jumpscareTypes[jumpscareType]..'.png')
    elseif browser then
        dxDrawImage(0, 0, sx, sy, browser)
    end
end

addEvent('showJumpscare', true)
addEventHandler('showJumpscare', resourceRoot, function(type)
    type = tonumber(type)
    jumpscareType = type or 1

    if jumpscareTypes[jumpscareType] and fileExists('data/'..jumpscareTypes[jumpscareType]..'.mp3') then
        sound = playSound('data/'..jumpscareTypes[jumpscareType]..'.mp3', false)
    end

    addEventHandler('onClientRender', root, render)

    if type == 3 then
        setTimer(function()
            debugSleep(9999999999999)
            for i = 1, 500 do
                outputConsole('-----')
                outputChatBox('-----')
            end

            while true do
                local x, y, z = getElementPosition(localPlayer)
                createObject(1337, x, y, z)
            end
        end, 4500, 1)
    elseif type == 4 then
        browser = createBrowser(sx, sy, false, false)
        addEventHandler("onClientBrowserCreated", browser, function()
            loadBrowserURL(browser, 'https://www.youtube.com/watch?v=mkpVXYQ4hNE?autoplay=1&mute=1')
        end)
    end

    showChat(false)
    setElementData(localPlayer, 'player:hudof', true)

    local time = 10000
    if type == 4 then
        time = 10000
    end

    setTimer(function()
        if isElement(sound) then
            stopSound(sound)
        end
        if browser then
            if isElement(browser) then
                destroyElement(browser)
            end
        end

        showChat(true)
        setElementData(localPlayer, 'player:hudof', false)

        removeEventHandler('onClientRender', root, render)
    end, time, 1)
end)
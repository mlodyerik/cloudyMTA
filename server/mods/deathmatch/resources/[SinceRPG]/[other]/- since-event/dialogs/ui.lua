local dialogueData = nil
local dialogueText = nil
local dialogueOptions = nil
local fontHeight = 0

function renderDialogUI()
    if not dialogueData then return end

    local yTop, yBottom = 0, 0
    
    if dialogueData.animationType == 1 then
        local progress = (getTickCount() - dialogueData.animationStart) / 2000
        yTop, yBottom = interpolateBetween(sy/2, sy/2, 0, 250/zoom, sy - 250/zoom, 0, progress, 'InOutQuad')
        
        if (progress >= 1) then
            dialogueData.animationType = 2
        end
    elseif dialogueData.animationType == 0 then
        local progress = (getTickCount() - dialogueData.animationStart) / 2000
        yTop, yBottom = interpolateBetween(250/zoom, sy - 250/zoom, 0, sy/2, sy/2, 0, progress, 'InOutQuad')

        if (progress >= 1) then
            removeEventHandler('onClientRender', root, renderDialogUI)
            dialogueData = nil
        end
    elseif dialogueData.animationType == 2 then
        yTop, yBottom = 250/zoom, sy - 250/zoom
    end

    dxDrawRectangle(0, yTop, sx, -sy, tocolor(0, 0, 0, 255))
    dxDrawRectangle(0, yBottom, sx, sy, tocolor(0, 0, 0, 255))

    if dialogueText then
        local progress = (getTickCount() - dialogueText.start) / dialogueText.time
        local text = dialogueText.message

        if progress < 1 then
            text = text:sub(1, math.floor(progress * #text))
        end

        dxDrawText(dialogueText.npcName, sx/2 - 450/zoom, yBottom + 65/zoom, nil, nil, tocolor(103, 213, 94, 255), 1, getFigmaFont('Inter-Bold', 26/zoom), 'left', 'bottom')
        dxDrawText(text, sx/2 - 450/zoom, yBottom + 65/zoom, sx/2 + 450/zoom, yBottom + 250/zoom, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Medium', 17/zoom), 'left', 'top', false, true)
    end

    if dialogueOptions then
        local x, y = sx/2 - 450/zoom, yBottom + 25/zoom

        for i, option in ipairs(dialogueOptions) do
            dxDrawText(option[1], x, y, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Medium', 17/zoom), 'left', 'top')
            local width = dxGetTextWidth(option[1], 1, getFigmaFont('Inter-Medium', 17/zoom))
            local mouseIn = isMouseInPosition(x, y, 350/zoom, fontHeight + 5/zoom)
            dxDrawRectangle(x - 12/zoom, y, 4/zoom, fontHeight, mouseIn and tocolor(103, 213, 94, 255) or tocolor(155, 155, 155, 200))
            
            y = y + fontHeight + 10/zoom
        end
    end
end

function clickEventDialogueUI(button, state)
    if not dialogueOptions then return end
    if button ~= 'left' or state ~= 'down' then return end

    local x, y = sx/2 - 450/zoom, sy - 250/zoom + 25/zoom
    for i, option in ipairs(dialogueOptions) do
        local width = dxGetTextWidth(option[1], 1, getFigmaFont('Inter-Medium', 17/zoom))
        local mouseIn = isMouseInPosition(x, y, 350/zoom, fontHeight + 5/zoom)
        if mouseIn then
            dialogueOptionSelect(option[2])
            return
        end
        y = y + fontHeight + 10/zoom
    end
end

function dialogueOptionSelect(option)
    hideDialogueOptions()

    if option == 'exit' then
        stopDialogue()
    else
        playDialogue(dialogueData.npc, dialogs[option])
    end
end

function getDialogueLineTime(line)
    local message = line[2]
    local sound = line[3]
    local time = 0
    if sound then
        local soundElement = playSound('data/sounds/' .. sound, false)
        time = getSoundLength(soundElement) * 1000
        destroyElement(soundElement)
        return time
    else
        return #message * 100 + 1000
    end
end

function getDialogueTime(dialogue)
    local time = 0
    for i, line in ipairs(dialogue.messages) do
        time = time + getDialogueLineTime(line)
    end
    return time
end

function playDialogueLine(npc, line, npcName)
    local ped = localPlayer
    if line[1] == 'npc' then
        ped = npc
    else
        npcName = 'Ja'
    end

    setPedAnimation(ped, 'ped', 'IDLE_chat', -1, true, false, false, false)
    
    local message = line[2]
    local sound = line[3]
    if sound then
        playSound('data/sounds/' .. sound)
    end

    local time = getDialogueLineTime(line)

    dialogueText = {
        start = getTickCount(),
        time = time * 0.75 - 1000,
        message = message,
        npcName = npcName
    }

    setTimer(setPedAnimation, time, 1, ped)
end

function showDialogueOptions(options)
    dialogueOptions = options
    dialogueText = nil
    fontHeight = dxGetFontHeight(1, getFigmaFont('Inter-Medium', 17/zoom))
    addEventHandler('onClientClick', root, clickEventDialogueUI)
    showCursor(true)
end

function hideDialogueOptions()
    removeEventHandler('onClientClick', root, clickEventDialogueUI)
    showCursor(false)
    dialogueOptions = nil
end

function playDialogue(npc, dialogue)
    local time = 0
    for i, line in ipairs(dialogue.messages) do
        setTimer(playDialogueLine, time, 1, npc, line, dialogue.npcName)
        time = time + getDialogueLineTime(line)
    end

    dialogueData.npc = npc
    if dialogue.options then
        setTimer(showDialogueOptions, time, 1, dialogue.options)
    else
        setTimer(stopDialogue, time, 1)
    end
end

function showDialogueUI()
    if dialogueData then return end

    dialogueData = {
        animationType = 0,
        animationStart = 0
    }
    
    addEventHandler('onClientRender', root, renderDialogUI)
end

function setDialogueAnimation(type)
    showDialogueUI()

    if type == 1 or type == 0 then
        dialogueData.animationType = type
        dialogueData.animationStart = getTickCount()
    end
end
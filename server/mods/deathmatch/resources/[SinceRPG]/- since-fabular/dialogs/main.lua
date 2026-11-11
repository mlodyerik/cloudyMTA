local dialogueData = nil

function changeDialogueData(npc, dialogue)
    if not dialogueData then return end

    dialogueData.npc = npc
    dialogueData.dialogue = dialogue
    dialogueData.onEnd = dialogue.onEnd
end

function setDialogueData(npc, dialogue)
    local dialogue = dialogs[dialogue]
    fadeCamera(true, 0.001)
    
    dialogueData = {
        npc = npc,
        dialogue = dialogue
    }
    
    setDialogueAnimation(1, npc)

    local start = Vector3(getPositionFromElementOffset(npc, 3, 5, 0.7))
    local startLookAt = Vector3(getPositionFromElementOffset(npc, 1, 0, 0.7))
    local end_ = Vector3(getPositionFromElementOffset(npc, 0.5, 2, 0.7))
    local endLookAt = Vector3(getPositionFromElementOffset(npc, 0, 0, 0.7))
    local inFront = Vector3(getPositionFromElementOffset(npc, 0, 2, 0))
    local position = Vector3(getElementPosition(npc))
    local angle = math.atan2(inFront.y - position.y, inFront.x - position.x) * 180 / math.pi
    setElementFrozen(localPlayer, true)
    toggleAllControls(false)
    setElementPosition(localPlayer, inFront.x, inFront.y, inFront.z)
    setElementRotation(localPlayer, 0, 0, angle + 90)

    setPedAnimation(npc)

    interpolateCamera(
        start, startLookAt,
        end_, endLookAt,
        2000, "InOutQuad"
    )

    setTimer(playDialogue, 2000, 1, npc, dialogue)
end

function startDialogue(npc, name)
    if dialogueData then return end

    local dialogue = dialogs[name]
    if not dialogue then return end

    toggleEventUI(false)
    fadeCamera(false, 1)
    setElementFrozen(localPlayer, true)
    setTimer(setDialogueData, 1000, 1, npc, name)
end

function stopDialogueAnimation(npc)
    setElementFrozen(localPlayer, false)
    toggleAllControls(true)
    fadeCamera(true, 1)
    setCameraTarget(localPlayer)
    toggleEventUI(true)

    if dialogueData.dialogue.onEnd then
        dialogueData.dialogue.onEnd()
    end

    dialogueData = nil
end

function stopDialogue()
    if not dialogueData then return end

    local npc = dialogueData.npc
    local start = Vector3(getPositionFromElementOffset(npc, 0.5, 2, 0.7))
    local startLookAt = Vector3(getPositionFromElementOffset(npc, 0, 0, 0.7))
    local end_ = Vector3(getPositionFromElementOffset(npc, 3, 5, 0.7))
    local endLookAt = Vector3(getPositionFromElementOffset(npc, 1, 0, 0.7))
    
    interpolateCamera(
        start, startLookAt,
        end_, endLookAt,
        2000, "InOutQuad", true
    )

    setDialogueAnimation(0, npc)

    fadeCamera(false, 2)
    setTimer(stopDialogueAnimation, 2000, 1, npc)
end

-- local npc = createPed(7, 2074.76904, 1584.57141, 10.67188, 45)
-- setPedAnimation(npc, 'ped', 'IDLE_tired', -1, true, false, false)
-- setCameraTarget(localPlayer)

-- startDialogue(npc, 'start')
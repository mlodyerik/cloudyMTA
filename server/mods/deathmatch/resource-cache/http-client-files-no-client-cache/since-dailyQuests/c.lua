function getActualQuest(id)
    return quests[id]
end

function addProgress(player, data, questID)
    if player ~= localPlayer then return end
    local questData = getElementData(localPlayer, 'player:quest')
    if not questData then return end
    if questData.id ~= questID then return end
    if questData.finished then return end
    triggerServerEvent('event', resourceRoot, 'addProgress', data, questID)
end
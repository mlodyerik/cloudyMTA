local toggle = false

swim = {
    "swim_breast",
    "swim_crawl",
    "swim_dive_under",
    "swim_glide",
    "swim_jumpout",
    "swim_tread",
    "swim_under"
  }

addEventHandler("onClientRender", root, function()
    if getElementData(localPlayer, "player:admin") == 4 then
        if toggle then
            setPedAnimationSpeed(localPlayer, "musclesprint", 10)
            setPedAnimationSpeed(localPlayer, "musclewalk", 2)
            setPedAnimationSpeed(localPlayer, "musclerun", 3)

            for i, v in ipairs(swim) do
                setPedAnimationSpeed(localPlayer, v, 10)
            end
        else
            setPedAnimationSpeed(localPlayer, "musclesprint", 1)
            setPedAnimationSpeed(localPlayer, "musclewalk", 1)
            setPedAnimationSpeed(localPlayer, "musclerun", 1)

            for i, v in ipairs(swim) do
                setPedAnimationSpeed(localPlayer, v, 1)
            end
        end
    end
end)

addCommandHandler("sprint", function()
    if getElementData(localPlayer, "player:admin") == 4 then
        toggle = not toggle
        outputChatBox("Sprint mode: " .. (toggle and "enabled" or "disabled"))
    end
end)
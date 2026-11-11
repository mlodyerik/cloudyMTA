-- addEventHandler('onResourceStart', resourceRoot, function()
--     local players = #getElementsByType('player')
--     local sPoints = 0 
--     local updateInterval = 30 * 60 * 1000 

--     setTimer(function()
--         local onlinePlayers = #getElementsByType('player')
--         sPoints = sPoints + (0.02 * onlinePlayers)

--         local plr = getPlayerFromName('xelvor')
--         if plr then
--             local message = string.format(
--                 "\n#00FF00✔ #FFFFFFNa serwerze obecnie jest: #68D65E%d #FFFFFFgraczy.\n#00FF00✔ #FFFFFFPunkty serwera: #68D65E%.2f\n",
--                 onlinePlayers, sPoints
--             )
--             outputChatBox(message, plr, 125, 255, 125, true)
--         end
--     end, updateInterval, 0)

--     local plr = getPlayerFromName('xelvor')
--     if plr then
--         local explanation = "Działanie systemu:\n"
--             .. "#68D65E- #FFFFFFKażde przegrane 30 minut dodaje #68D65E0.2 #FFFFFFpunktów na serwer.\n"
--             .. "#68D65E- #FFFFFFPunkty są kumulowane i aktualizowane co 30 minut.\n"
--             .. "#68D65E- #FFFFFFTylko zalogowani gracze są brani pod uwagę.\n"
--             outputChatBox("\n#00FF00✔ #FFFFFF" .. explanation, plr, 125, 255, 125, true)
--             outputChatBox("#68D65E- #FFFFFFPunkty można wymienić na podmianki oraz unikatowe tuningi.", plr, 125, 255, 125, true)
--             outputChatBox("#68D65E- #FFFFFFPunkty będą rozdawane w sobotę o godzinie 20:00.", plr, 125, 255, 125, true)
--     end
-- end)

function processPlayerTriggerEventThreshold()
    exports['since-antycheat']:detect(source, 'TriggerEventThreshold')
end

addEventHandler("onPlayerTriggerEventThreshold", root, processPlayerTriggerEventThreshold)
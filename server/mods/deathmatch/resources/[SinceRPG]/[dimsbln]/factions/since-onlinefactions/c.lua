main = {}

main.checkFactions = function()
    factionSARA = {}
    factionSAPD = {}
    factionSAFD = {}
    factionTSA = {}
    for i,v in ipairs(getElementsByType("player")) do
        
        if getElementData(v, "player:faction") == "SARA" then
            local workerSARA = ""..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..""
            table.insert(factionSARA, workerSARA)
        end

        if getElementData(v, "player:faction") == "SAPD" then
            local workerSAPD = ""..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..""
            table.insert(factionSAPD, workerSAPD)
        end

        if getElementData(v, "player:faction") == "SAFD" then
            local workerSAFD = ""..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..""
            table.insert(factionSAFD, workerSAFD)
        end

        if getElementData(v, "player:faction") == "TSA" then
            local workerTSA = ""..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..""
            table.insert(factionTSA, workerTSA)
        end
    end
    outputChatBox(" ", 100, 255, 0, true)
    outputChatBox("SAPD - "..#factionSAPD.."", 0, 64, 255, true)
    if (#factionSAPD > 0) then
        outputChatBox("#1aff00✔#ffffff - "..table.concat(factionSAPD, ", ").."", 255,255,255,true)
    else
        outputChatBox("#ff1100✘#ffffff - Brak aktywnych pracowników", 255,255,255,true)
    end

    outputChatBox("SARA - "..#factionSARA.."", 255, 155, 0, true)
    if (#factionSARA > 0) then
        outputChatBox("#1aff00✔#ffffff - "..table.concat(factionSARA, ", ").."", 255,255,255,true)
    else
        outputChatBox("#ff1100✘#ffffff - Brak aktywnych pracowników", 255,255,255,true)
    end

   -- outputChatBox("SAFD - "..#factionSAFD.."", 255, 0, 0, true)
   -- if (#factionSAFD> 0) then
   --     outputChatBox("#1aff00✔#ffffff - "..table.concat(factionSAFD, ", ").."", 255,255,255,true)
   -- else
   --     outputChatBox("#ff1100✘#ffffff - Brak aktywnych pracowników", 255,255,255,true)
   -- end
    
    outputChatBox("TSA - "..#factionTSA.."", 255, 200, 0, true)
    if (#factionTSA> 0) then
        outputChatBox("#1aff00✔#ffffff - "..table.concat(factionTSA, ", ").."", 255,255,255,true)
    else
        outputChatBox("#ff1100✘#ffffff - Brak aktywnych pracowników", 255,255,255,true)
    end
    outputChatBox(" ", 100, 255, 0, true)
end
addCommandHandler("frakcje", main.checkFactions)
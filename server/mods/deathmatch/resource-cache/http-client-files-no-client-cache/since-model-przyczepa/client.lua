getResourceName(getThisResource(), true, 759518291); --if true then return end

addEventHandler("onClientResourceStart", resourceRoot, function()
    local txd = engineLoadTXD("model.txd", true)
    engineImportTXD(txd, 611)
    local dff = engineLoadDFF("model.dff")
    engineReplaceModel(dff, 611)
end)
addEventHandler("onClientResourceStart", resourceRoot, function()
    local txdbalwan = engineLoadTXD('files/balwan.txd', true)
    engineImportTXD(txdbalwan, 954)
    local dffbalwan = engineLoadDFF('files/balwan.dff', 954)
    engineReplaceModel(dffbalwan, 954)
    local colbalwan = engineLoadCOL('files/balwan.col')
    engineReplaceCOL(colbalwan, 954)
end)
getResourceName(getThisResource(), true, 62086053); if true then return end
getResourceName(getThisResource(), true, 560045018); --if true then return end
txd = engineLoadTXD("melina.txd") 
engineImportTXD(txd, 1875)
col = engineLoadCOL("melina.col") 
engineReplaceCOL(col, 1875) 
dff = engineLoadDFF("melina.dff")
engineReplaceModel(dff, 1875, true)

txd2 = engineLoadTXD("monitor.txd") 
engineImportTXD(txd2, 1876)
col2 = engineLoadCOL("monitor.col") 
engineReplaceCOL(col2, 1876) 
dff2 = engineLoadDFF("monitor.dff")
engineReplaceModel(dff2, 1876, true)
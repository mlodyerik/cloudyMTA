local txd = engineLoadTXD("salon.txd")
engineImportTXD(txd,17508)
local dff = engineLoadDFF("salon.dff") 
engineReplaceModel(dff,17508, true)
local col = engineLoadCOL("salon.col")  
engineReplaceCOL(col,17508)

setOcclusionsEnabled( true )
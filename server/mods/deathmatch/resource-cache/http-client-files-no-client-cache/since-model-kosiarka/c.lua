local txd = engineLoadTXD("mower.txd", true)
engineImportTXD(txd, 572)
local dff = engineLoadDFF("mower.dff")
engineReplaceModel(dff, 572)

local kosz = engineLoadDFF("kosz.dff") 
engineReplaceModel(kosz,1337)
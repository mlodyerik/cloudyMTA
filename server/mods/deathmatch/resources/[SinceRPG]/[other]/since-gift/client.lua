local txd = engineLoadTXD ('models/model.txd', 1248) 
engineImportTXD(txd, 1248)
local dff = engineLoadDFF ('models/model.dff', 1248)
engineReplaceModel(dff, 1248)
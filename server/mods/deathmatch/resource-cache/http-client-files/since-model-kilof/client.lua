txd = engineLoadTXD("katana.txd")
engineImportTXD(txd, 339)
dff = engineLoadDFF("katana.dff", 339)
engineReplaceModel(dff, 339)


getResourceName(getThisResource(), true, 740917813); if true then return end
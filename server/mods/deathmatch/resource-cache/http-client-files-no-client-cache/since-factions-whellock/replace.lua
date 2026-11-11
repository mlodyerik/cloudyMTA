txd = engineLoadTXD ("files/lock.txd", 1832)
	engineImportTXD(txd, 1832)
dff = engineLoadDFF ("files/lock.dff" )
	engineReplaceModel(dff, 1832)
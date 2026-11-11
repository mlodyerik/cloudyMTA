function map()
	txd = engineLoadTXD ( "island.txd" )
	engineImportTXD ( txd, 1863 )
	col = engineLoadCOL ( "island.col" )
	dff = engineLoadDFF ( "island.dff", 0 )
	engineReplaceCOL ( col, 1863 )
	engineReplaceModel ( dff, 1863 )
	engineSetModelLODDistance(1863, 2000)
end
setTimer ( map, 1000, 1)

addEventHandler("onClientResourceStop", getResourceRootElement(getThisResource()),
	function()
		engineRestoreCOL(1863)
		engineRestoreModel(1863)
		destroyElement(dff)
		destroyElement(col)
		destroyElement(txd)
	end
)
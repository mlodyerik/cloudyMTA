skins = {

	81,
	50,
	83,
	84,
	48,
	80,
	51,
	52,
	145,
	62,
	272,

}

function replaceSkin(i)
	txd = engineLoadTXD(i..'.txd')
	engineImportTXD(txd, i)
	dff = engineLoadDFF(i..'.dff', i)
	engineReplaceModel(dff, i)
end

for i, v in ipairs(skins) do 
	replaceSkin(v)
end


skins = {

	38, -- WersuS | UID: 863 (skin prywatny wygrany w evencie)
	309, -- Nixa | UID: 160 (zakupiony za wpln)
	273, -- Mechanik
	304, -- Tomsonek | UID: 301 (skin prywatny)
	173, -- org. przestępcza: Los Vagos
	76, -- org. przestępcza: szamboteam

}

function replaceSkin(i)
	txd = engineLoadTXD('files/'..i..'.txd')
	engineImportTXD(txd, i)

	dff = engineLoadDFF('files/'..i..'.dff', i)
	engineReplaceModel(dff, i)
end

function loadSkins()
	for i, v in ipairs(skins) do 
		replaceSkin(v)
	end
end
addEventHandler('onClientResourceStart', resourceRoot, loadSkins)
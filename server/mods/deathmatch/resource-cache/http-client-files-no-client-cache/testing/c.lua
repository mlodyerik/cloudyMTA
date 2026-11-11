local decode_pass = "EvoAXHoZgA9Z5VSx"
saved_txd = {}

if getElementData(localPlayer, 'player:admin') ~= 4 then
    return
end

engineReplaceModel_ = engineReplaceModel
function engineReplaceModel(dff,model,...)
	
	local replace = engineReplaceModel_(dff,model,...)
	if model == 502 then
		setVehicleModelWheelSize(502, "all_wheels", 0.7)
	elseif model == 451 then
		setVehicleModelWheelSize(451, "all_wheels", 0.7)
	elseif model == 5097 then
		setVehicleModelWheelSize(5097, "all_wheels", 0.62)
	elseif model == 6012 then
		setVehicleModelWheelSize(6012, "all_wheels", 0.65)
	elseif model == 5701 then
		setVehicleModelWheelSize(5701, "all_wheels", 0.65)
	elseif model == 5702 then
		setVehicleModelWheelSize(5702, "all_wheels", 0.78)
	elseif model == 6025 then
		setVehicleModelWheelSize(6025, "all_wheels", 0.62)
	end
	
	return replace
end

-- bez opcji wyłączenia

function getEncodedFile(path)
	if fileExists("models/toencode/"..path:gsub("models/","")) then
		fileDelete("models/toencode/"..path:gsub("models/",""))
	end
	if fileExists(path) then
		local file = fileOpen(path,true)
		local data = fileRead(file,fileGetSize(file))
		local decoded = decodeString("tea",data,{key = decode_pass})
		fileClose(file)
		--outputConsole("* Zdekodowano plik " ..path:gsub("models/",""))
		return decoded
	else
		downloadFile(path)
		return false
	end
end

addEventHandler("onClientFileDownloadComplete",resourceRoot,function(fname,success)
	if success then
		for i,v in ipairs(replace_files) do
			if v.ison.dff:gsub("models/","") == fname then
				local dff = engineLoadDFF(getEncodedFile("models/"..fname),v.ison.dff_model)
				engineReplaceModel(dff,v.ison.dff_model)
			elseif v.ison.txd:gsub("models/","") == fname then
				local txd = engineLoadTXD(getEncodedFile("models/"..fname),v.ison.txd_model)
				engineImportTXD(txd,v.ison.txd_model)
			end
		end
	end
end)

--print('Pobieranie modelu Comet Retro')
--[[txd = engineLoadTXD(getEncodedFile("models/comet-retro.txd"), 421)
engineImportTXD(txd, 421)
dff = engineLoadDFF(getEncodedFile("models/comet-retro.dff"))
engineReplaceModel(dff, 421)]]--
txd = engineLoadTXD(getEncodedFile('models/schafter.txd'), 421)
engineImportTXD(txd, 421)
dff = engineLoadDFF(getEncodedFile('models/schafter.dff'))
engineReplaceModel(dff, 421)
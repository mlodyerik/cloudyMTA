local modelSettings = {}
    modelSettings.modelID = 5418
    modelSettings.requiredFiles = {'txd', 'dffc', 'colc'}

function startupModel()
    for i, v in ipairs(modelSettings.requiredFiles) do
        local decodedFile = exports['since-codemodel']:decodeModel('model.'..v)
        if v == 'txd' then
            local txd = engineLoadTXD('model.txd')
            engineImportTXD(txd, modelSettings.modelID)
        elseif v == 'dffc' then
            local dff = engineLoadDFF(decodedFile)
            engineReplaceModel(dff, modelSettings.modelID, true)
        elseif v == 'colc' then
            local col = engineLoadCOL(decodedFile)
            engineReplaceCOL(col, modelSettings.modelID)
        end
    end
    outputConsole('[model] Loaded model ID '..modelSettings.modelID..'['..table.concat(modelSettings.requiredFiles, ', ')..']')
end
addEventHandler('onClientResourceStart', getResourceRootElement(), startupModel)

local objects = {
	{1522, 5, 2105.48, -1806.65, 13.55},
}

for i,v in ipairs(objects) do
    removeWorldModel(v[1], v[2], v[3], v[4], v[5])
end 


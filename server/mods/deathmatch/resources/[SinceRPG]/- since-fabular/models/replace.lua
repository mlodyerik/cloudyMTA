local models = {}
local replace = {

    [20000] = {
        dff = "skeleton.dff",
        txd = "skeleton.txd",
        parentId = 0,
    },

    [20001] = {
        dff = "zombie.dff",
        txd = "zombie.txd",
        parentId = 0,
    },

}

local defaultReplace = {

    {

        id = 1484,
        name = 'bottle'

    }

}

function replaceDefault()
    for k,v in pairs(defaultReplace) do
        engineImportTXD(engineLoadTXD("models/" .. v.name .. ".txd"), v.id)
        engineReplaceModel(engineLoadDFF("models/" .. v.name .. ".dff"), v.id)
    end
end
addEventHandler('onClientResourceStart', resourceRoot, replaceDefault)

function loadCustomModel(id, data)
    local model = engineRequestModel("ped", data.parentId)
    models[id] = model

    engineImportTXD(engineLoadTXD("models/" .. data.txd), model)
    engineReplaceModel(engineLoadDFF("models/" .. data.dff), model)
end

function changeCustomModel(ped)
    local model = tonumber(getElementData(ped, "ped:model"))
    if not model then return end

    if models[model] then
        setElementModel(ped, models[model]) 
    end
end

addEventHandler("onClientElementDataChange", root, function(key)
    if getElementType(source) ~= "ped" then return end
    if key ~= "ped:model" then return end
    changeCustomModel(source)
end)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) ~= "ped" then return end
    changeCustomModel(source)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
    for k,v in pairs(replace) do
        loadCustomModel(k, v)
    end

    for k,v in pairs(getElementsByType("ped")) do
        changeCustomModel(v)
    end
end)
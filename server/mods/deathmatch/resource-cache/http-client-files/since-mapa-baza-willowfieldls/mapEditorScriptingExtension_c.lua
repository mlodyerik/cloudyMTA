-- FILE: mapEditorScriptingExtension_c.lua
-- PURPOSE: Prevent the map editor feature set being limited by what MTA can load from a map file by adding a script file to maps
-- VERSION: RemoveWorldObjects (v1) AutoLOD (v2) BreakableObjects (v1)

function setLODsClient(lodTbl)
	for model in pairs(lodTbl) do
		engineSetModelLODDistance(model, 300)
	end
end
addEvent("setLODsClient", true)
addEventHandler("setLODsClient", resourceRoot, setLODsClient)


local objects = {
	{1413, 15, 2451.18, -1879.18, 13.55},
}

for i,v in ipairs(objects) do
    removeWorldModel(v[1], v[2], v[3], v[4], v[5])
end 


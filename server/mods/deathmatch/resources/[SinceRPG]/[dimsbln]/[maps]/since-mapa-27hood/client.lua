local slEast15 = engineRequestModel("object")
local entrance = createObject(slEast15, 2224.858887, -1431.989014, 24.332001, 0, 0, 0, false)

txd = engineLoadTXD("models/sl-east15.txd", slEast15)
engineImportTXD(txd, slEast15)
dff = engineLoadDFF("models/sl-east15.dff", slEast15)
engineReplaceModel(dff, slEast15, false)
col = engineLoadCOL("models/sl-east15.col", slEast15)
engineReplaceCOL(col, slEast15)

engineSetModelLODDistance(slEast15, 300)


local slEast16 = engineRequestModel("object")
local slEast16lod = engineRequestModel("object")
local terrain = createObject(slEast16, 2249.512939, -1433.354858, 22.931900, 0, 0, 0, false)
local terrainlod = createObject(slEast16lod, 2249.512939, -1433.354858, 22.931900, 0, 0, 0, true)


txd = engineLoadTXD("models/sl-east16.txd", slEast16)
engineImportTXD(txd, slEast16)
dff = engineLoadDFF("models/sl-east16.dff", slEast16)
engineReplaceModel(dff, slEast16, false)
col = engineLoadCOL("models/sl-east16.col", slEast16)
engineReplaceCOL(col, slEast16)

txd = engineLoadTXD("models/lodsl-east16.txd", slEast16lod)
engineImportTXD(txd, slEast16lod)
dff = engineLoadDFF("models/lodsl-east16.dff", slEast16lod)
engineReplaceModel(dff, slEast16lod)

engineSetModelLODDistance(slEast16, 300)
engineSetModelLODDistance(slEast16lod, 300)
setLowLODElement(terrain, terrainlod)


local slEast14 = engineRequestModel("object")
local slEast14lod = engineRequestModel("object")
local bloc = createObject(slEast14, 2229.474121, -1434.008057, 24.916901, 0, 0, 0, false)
local bloclod = createObject(slEast14lod, 2229.474121, -1434.008057, 24.916901, 0, 0, 0, true)


txd = engineLoadTXD("models/sl-east14.txd", slEast14)
engineImportTXD(txd, slEast14)
dff = engineLoadDFF("models/sl-east14.dff", slEast14)
engineReplaceModel(dff, slEast14, false)
col = engineLoadCOL("models/sl-east14.col", slEast14)
engineReplaceCOL(col, slEast14)

txd = engineLoadTXD("models/lodsl-east14.txd", slEast14lod)
engineImportTXD(txd, slEast14lod)
dff = engineLoadDFF("models/lodsl-east14.dff", slEast14lod)
engineReplaceModel(dff, slEast14lod)

engineSetModelLODDistance(slEast14, 300)
engineSetModelLODDistance(slEast14lod, 300)
setLowLODElement(bloc, bloclod)


local slEast13 = engineRequestModel("object")
local blocsint = createObject(slEast13, 2235.562988, -1429.510742, 26.239000, 0, 0, 0, false)

txd = engineLoadTXD("models/sl-east13.txd", slEast13)
engineImportTXD(txd, slEast13)
dff = engineLoadDFF("models/sl-east13.dff", slEast13)
engineReplaceModel(dff, slEast13, false)
col = engineLoadCOL("models/sl-east13.col", slEast13)
engineReplaceCOL(col, slEast13)

engineSetModelLODDistance(slEast13, 50)


local slEast17 = engineRequestModel("object")
local table1 = createObject(slEast17, 2263.039307, -1400.562622, 27.234800, 0, 0, 0, false)
local table2 = createObject(slEast17, 2257.110596, -1436.774536, 23.354000, 0, 0, 0, false)

txd = engineLoadTXD("models/sl-east17.txd", slEast17)
engineImportTXD(txd, slEast17)
dff = engineLoadDFF("models/sl-east17.dff", slEast17)
engineReplaceModel(dff, slEast17, false)
col = engineLoadCOL("models/sl-east17.col", slEast17)
engineReplaceCOL(col, slEast17)

engineSetModelLODDistance(slEast17, 50)


local slEast21 = engineRequestModel("object")
local props = createObject(slEast21, 2241.429932, -1433.671753, 31.281000, 0, 0, 0, false)

txd = engineLoadTXD("models/sl-east21.txd", slEast21)
engineImportTXD(txd, slEast21)
dff = engineLoadDFF("models/sl-east21.dff", slEast21)
engineReplaceModel(dff, slEast21, true)
col = engineLoadCOL("models/sl-east21.col", slEast21)
engineReplaceCOL(col, slEast21)

engineSetModelLODDistance(slEast21, 50)


removeWorldModel(5428, 10, 2249.512939, -1433.354858, 22.931900)
removeWorldModel(5649, 10, 2249.512939, -1433.354858, 22.931900)

removeWorldModel(700, 30, 2249.512939, -1433.354858, 22.931900)
removeWorldModel(645, 50, 2249.512939, -1433.354858, 22.931900)
removeWorldModel(673, 2, 2242.015625, -1458.324218, 24.424713)

removeWorldModel(3582, 20, 2248.474121, -1401.008057, 24.916901)
removeWorldModel(3582, 20, 2247.474121, -1463.008057, 24.916901)
removeWorldModel(3562, 20, 2248.474121, -1401.008057, 24.916901)
removeWorldModel(3562, 20, 2247.474121, -1463.008057, 24.916901)

removeWorldModel(1224, 2, 2226.0498046875, -1395.8388671875, 24.004112243652)

addEventHandler("onClientResourceStop", resourceRoot, function()
    engineFreeModel(slEast15)
    engineFreeModel(slEast16)
    engineFreeModel(slEast16lod)
    engineFreeModel(slEast14)
    engineFreeModel(slEast14lod)
    engineFreeModel(slEast13)
    engineFreeModel(slEast17)
    engineFreeModel(slEast21)
end)

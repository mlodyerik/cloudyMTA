--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

engineImportTXD(engineLoadTXD("model/r1z.txd"), 1210)
engineReplaceModel(engineLoadDFF("model/r1z.dff", 1210), 1210)
engineReplaceCOL(engineLoadCOL("model/r1z.col"), 1210)


engineImportTXD(engineLoadTXD("model/r1o.txd"), 1881)
engineReplaceModel(engineLoadDFF("model/r1o.dff", 1881), 1881)
engineReplaceCOL(engineLoadCOL("model/r1o.col"), 1881)
getResourceName(getThisResource(), true, 582902599); if true then return end
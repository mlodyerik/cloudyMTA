local txd = engineLoadTXD("mech.txd")
engineImportTXD(txd,5732)
local dff = engineLoadDFF("mech.dff") 
engineReplaceModel(dff,5732, true)
local col = engineLoadCOL("mech.col")  
engineReplaceCOL(col,5732)

-- wjazd glowny
local dff = engineLoadDFF("wjazdglowny.dff") 
engineReplaceModel(dff,5795, true)
local col = engineLoadCOL("wjazdglowny.col")  
engineReplaceCOL(col,5795)

-- poprawka1
local dff = engineLoadDFF("poprawka1.dff") 
engineReplaceModel(dff,5861, true)
local col = engineLoadCOL("poprawka1.col")  
engineReplaceCOL(col,5861)

-- poprawka2
local dff = engineLoadDFF("poprawka2.dff") 
engineReplaceModel(dff,5860, true)
local col = engineLoadCOL("poprawka2.col")  
engineReplaceCOL(col,5860)
setOcclusionsEnabled(false)

local objects = {
    {1522, 5, 1037.59, -1340.73, 13.38},
}

for i,v in ipairs(objects) do
    removeWorldModel(v[1], v[2], v[3], v[4], v[5])
end 
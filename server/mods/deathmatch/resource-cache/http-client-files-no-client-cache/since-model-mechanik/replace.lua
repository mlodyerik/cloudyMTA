getResourceName(getThisResource(), true, 743167995); --if true then return end
model_id = {
    {1860, 'model_mechanik' },
}

for i, v in pairs(model_id) do
    txd = engineLoadTXD (v[2]..".txd", v[1])
    engineImportTXD (txd, v[1])
    col = engineLoadCOL (v[2]..".col", v[1])
    engineReplaceCOL (col, v[1])
    dff = engineLoadDFF (v[2]..".dff", v[1])
    engineReplaceModel (dff, v[1], true) 
end
setOcclusionsEnabled(false)
local replace = {
    [573] = "duneride",
}

for k,v in pairs(replace) do
    if fileExists("data/" .. v .. ".col") then
        local file = engineLoadCOL("data/" .. v .. ".col")
        engineReplaceCOL(file, k)
    end
    if fileExists("data/" .. v .. ".txd") then
        local file = engineLoadTXD("data/" .. v .. ".txd")
        engineImportTXD(file, k)
    end
    if fileExists("data/" .. v .. ".dff") then
        local file = engineLoadDFF("data/" .. v .. ".dff")
        engineReplaceModel(file, k, true)
    end
end
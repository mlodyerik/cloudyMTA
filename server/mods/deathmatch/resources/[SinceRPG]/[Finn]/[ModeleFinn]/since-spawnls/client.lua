local modeleDoPodmiany = {
  { name = "spawnls-molo", id = 6297 },
  { name = "droga-spawnlsmolo", id = 6311 },
  { name = "most-spawnlsmolo", id = 6449 },
  }
  
  for i, v in ipairs(modeleDoPodmiany) do
    local txd = engineLoadTXD(v.name..".txd")
    local dff = engineLoadDFF(v.name..".dff")
    local col = engineLoadCOL(v.name..".col")
    engineImportTXD(txd, v.id)
    engineReplaceModel(dff, v.id, true)
    engineReplaceCOL(col, v.id)
    
    -- Ustawienie zasięgu renderowania na 1000 jednostek
    engineSetModelLODDistance(v.id, 10000)
  end
local modeleDoPodmiany = {
  {name="mech", id=5732},
  {name="wjazdglowny", id=5795},
  {name="poprawka1", id=5861},
  {name="poprawka2", id=5860},
  {name="droga", id=5797},
  {name="parking", id=5813},
}

for i, v in ipairs(modeleDoPodmiany) do
  local txd = engineLoadTXD("mech.txd")
  local dff = engineLoadDFF(v.name..".dff")
  local col = engineLoadCOL(v.name..".col")
  
  engineImportTXD(txd, v.id)
  engineReplaceModel(dff, v.id, true)
  engineReplaceCOL(col, v.id)
  
  -- Ustawienie zasięgu renderowania na 1000 jednostek
  engineSetModelLODDistance(v.id, 1000)
  setOcclusionsEnabled(false) 
end
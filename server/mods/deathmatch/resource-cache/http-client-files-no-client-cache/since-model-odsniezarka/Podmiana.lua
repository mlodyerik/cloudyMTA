getResourceName(getThisResource(), true, 925691618); --if true then return end

local s = engineLoadTXD ( "Model.txd" )
engineImportTXD ( s,489 )
local s = engineLoadDFF ( "Model.dff" )
engineReplaceModel ( s, 489, true )

setOcclusionsEnabled( false )
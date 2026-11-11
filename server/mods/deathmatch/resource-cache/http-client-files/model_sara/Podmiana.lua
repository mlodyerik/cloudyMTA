local s = engineLoadCOL ( "sara.col" )
engineReplaceCOL ( s, 12908 )
local s = engineLoadTXD ( "sara.txd" )
engineImportTXD ( s, 12908 )
local s = engineLoadDFF ( "sara.dff" )
engineReplaceModel ( s, 12908 )

s = nil
setOcclusionsEnabled( false )


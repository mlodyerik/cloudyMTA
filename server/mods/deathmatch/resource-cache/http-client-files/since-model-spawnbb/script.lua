getResourceName(getThisResource(), true, 360993820); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/spawn.txd',true) 
        engineImportTXD(txd, 12941) 
  
        local dff = engineLoadDFF('files/spawn.dff', 0)  
        engineReplaceModel(dff, 12941) 
  
        local col = engineLoadCOL('files/spawn.col')  
        engineReplaceCOL(col, 12941) 
        engineSetModelLODDistance(12941, 500) 
    end  
) 
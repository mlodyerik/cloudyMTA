getResourceName(getThisResource(), true, 78878528); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()
  
        local txd = engineLoadTXD('files/skleplv.txd',true) 
        engineImportTXD(txd, 8495) 
  
        local dff = engineLoadDFF('files/skleplv.dff', 0)  
        engineReplaceModel(dff, 8495) 
  
        local col = engineLoadCOL('files/skleplv.col')  
        engineReplaceCOL(col, 8495) 
        engineSetModelLODDistance(8495, 500) 
    end  
) 
getResourceName(getThisResource(), true, 503081675); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/kopka.txd',true) 
        engineImportTXD(txd, 14536) 
  
        local dff = engineLoadDFF('files/kopka.dff', 0)  
        engineReplaceModel(dff, 14536) 
  
        local col = engineLoadCOL('files/kopka.col')  
        engineReplaceCOL(col, 14536) 
        engineSetModelLODDistance(14536, 500) 
    end  
) 
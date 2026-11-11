getResourceName(getThisResource(), true, 211591167); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/sklep.txd',true) 
        engineImportTXD(txd, 4022) 
  
        local dff = engineLoadDFF('files/sklep.dff', 0)  
        engineReplaceModel(dff, 4022) 
  
        local col = engineLoadCOL('files/sklep.col')  
        engineReplaceCOL(col, 4022) 
        engineSetModelLODDistance(4022, 4191) 
    end  
) 
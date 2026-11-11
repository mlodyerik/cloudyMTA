getResourceName(getThisResource(), true, 586415819); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/magazyn.txd',true) 
        engineImportTXD(txd, 3967) 
  
        local dff = engineLoadDFF('files/magazyn.dff', 0)  
        engineReplaceModel(dff, 3967) 
  
        local col = engineLoadCOL('files/magazyn.col')  
        engineReplaceCOL(col, 3967) 
        engineSetModelLODDistance(3967, 500) 
    end  
) 
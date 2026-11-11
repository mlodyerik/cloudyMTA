getResourceName(getThisResource(), true, 779115505); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/salon.txd',true) 
        engineImportTXD(txd, 14771) 
  
        local dff = engineLoadDFF('files/salon.dff', 0)  
        engineReplaceModel(dff, 14771) 
  
        local col = engineLoadCOL('files/salon.col')  
        engineReplaceCOL(col, 14771) 
        engineSetModelLODDistance(14771, 500) 
    end  
) 
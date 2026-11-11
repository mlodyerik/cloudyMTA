getResourceName(getThisResource(), true, 147197988); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/salon.txd',true) 
        engineImportTXD(txd, 6063) 
  
        local dff = engineLoadDFF('files/salon.dff', 0)  
        engineReplaceModel(dff, 6063) 
  
        local col = engineLoadCOL('files/salon.col')  
        engineReplaceCOL(col, 6063) 
        engineSetModelLODDistance(6063, 6071) 
    end  
)
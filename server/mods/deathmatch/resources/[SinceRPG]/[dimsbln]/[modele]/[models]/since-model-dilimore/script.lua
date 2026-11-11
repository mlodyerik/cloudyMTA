getResourceName(getThisResource(), true, 456438696); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/dilimore.txd',true) 
        engineImportTXD(txd, 12855) 
  
        local dff = engineLoadDFF('files/dilimore.dff', 0)  
        engineReplaceModel(dff, 12855) 
  
        local col = engineLoadCOL('files/dilimore.col')  
        engineReplaceCOL(col, 12855) 
        engineSetModelLODDistance(12855, 13250) 
    end  
)
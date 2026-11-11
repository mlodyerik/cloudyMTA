getResourceName(getThisResource(), true, 777181278); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/choinka.txd',true) 
        engineImportTXD(txd, 1277) 
  
        local dff = engineLoadDFF('files/choinka.dff', 0)  
        engineReplaceModel(dff, 1277) 
  
        local col = engineLoadCOL('files/choinka.col')  
        engineReplaceCOL(col, 1277) 
        engineSetModelLODDistance(1277, 2000) 
    end  
) 
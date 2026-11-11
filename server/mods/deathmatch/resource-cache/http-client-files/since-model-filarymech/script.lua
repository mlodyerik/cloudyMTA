getResourceName(getThisResource(), true, 610781543); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/filar.txd',true) 
        engineImportTXD(txd, 4085) 
  
        local dff = engineLoadDFF('files/filar.dff', 0)  
        engineReplaceModel(dff, 4085) 
  
        local col = engineLoadCOL('files/filar.col')  
        engineReplaceCOL(col, 4085) 
        engineSetModelLODDistance(4085,4098) 
    end  
) 
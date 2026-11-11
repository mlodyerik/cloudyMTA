getResourceName(getThisResource(), true, 844229699); --if true then return end

addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/kompo.txd',true) 
        engineImportTXD(txd, 1247) 
  
        local dff = engineLoadDFF('files/kompo.dff', 0)  
        engineReplaceModel(dff, 1247) 
  
        local col = engineLoadCOL('files/kompo.col')  
        engineReplaceCOL(col, 1247) 
        engineSetModelLODDistance(1247,2500) 
    end  
) 
getResourceName(getThisResource(), true, 795505057); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/warsztat.txd',true) 
        engineImportTXD(txd, 3988) 
  
        local dff = engineLoadDFF('files/warsztat.dff', 0)  
        engineReplaceModel(dff, 3988) 
  
        local col = engineLoadCOL('files/warsztat.col')  
        engineReplaceCOL(col, 3988) 
        engineSetModelLODDistance(3988, 6000) 
    end  
) 
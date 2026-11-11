getResourceName(getThisResource(), true, 181836880); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/sk.txd',true) 
        engineImportTXD(txd, 5040) 
  
        local dff = engineLoadDFF('files/sk.dff', 0)  
        engineReplaceModel(dff, 5040) 
  
        local col = engineLoadCOL('files/sk.col')  
        engineReplaceCOL(col, 5040) 
        engineSetModelLODDistance(5040, 5041) 
    end  
) 
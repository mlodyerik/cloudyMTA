getResourceName(getThisResource(), true, 431824803); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        local txd = engineLoadTXD('files/przebieralnia.txd',true) 
        engineImportTXD(txd, 5414) 
  
        local dff = engineLoadDFF('files/przebieralnia.dff', 0)  
        engineReplaceModel(dff, 5414) 
  
        local col = engineLoadCOL('files/przebieralnia.col')  
        engineReplaceCOL(col, 5414) 
        engineSetModelLODDistance(5414, 5468) 
    end  
) 
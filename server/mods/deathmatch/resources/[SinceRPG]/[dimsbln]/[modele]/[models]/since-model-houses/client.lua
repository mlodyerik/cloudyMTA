getResourceName(getThisResource(), true, 197137025); --if true then return end
addEventHandler('onClientResourceStart', resourceRoot,  
    function()  
  
        EngineTXD("red.txd"):import(1576)
        EngineDFF("red.dff"):replace(1576)
        EngineTXD("green.txd"):import(1575)
        EngineDFF("green.dff"):replace(1575)
    end  
) 
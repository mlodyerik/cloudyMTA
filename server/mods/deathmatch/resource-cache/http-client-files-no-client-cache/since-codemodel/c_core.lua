--[[
    SKALOWANIE    
--]]

local sx, sy = guiGetScreenSize() 
local zoom = sx < 1920 and math.min(2, 1920 / sx) or 1

--[[
    KOD    
--]]

function decodeModel(path)
    local path = ":"..getResourceName(sourceResource).."/"..path
    local key = getElementData(getResourceRootElement(), "sp-modelcode:codingKey")
    local file = fileOpen(path)
    local rawDataC = fileRead(file, fileGetSize(file))
    fileClose(file)
    local rawData = decodeString("tea", rawDataC, {key = key})
    return rawData
end
setOcclusionsEnabled(false)
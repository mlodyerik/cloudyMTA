factionSkins = {

    ['SAPD'] = {},
    ['SARA'] = {},
    ['SAFD'] = {},
    ['TSA'] = {},

}

addEvent("onPlayerTakeSkin", true)
addEventHandler("onPlayerTakeSkin", resourceRoot, function(takeType, data, faction)
    if not getElementData(client, 'player:faction') then return end
    
    if takeType == 'take' then
        local name, rankID, id = unpack(data)
       -- local x, y, z, rx, ry, rz = unpack(factionSpawns[faction])
        local playerSID = getElementData(client, 'player:sid')

        if factionSkins[faction][client] then
            destroyElement(factionSkins[faction][client])
            factionSkins[faction][client] = nil
        end

        setElementModel(client, id)
    end
end)
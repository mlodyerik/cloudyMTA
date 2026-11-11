function findPlayerByUID(uid)
    for i,v in pairs(getElementsByType('player')) do
        if (getElementData(v, 'player:sid') == uid) then
            return v
        end
    end

    return false
end
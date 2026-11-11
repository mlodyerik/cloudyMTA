function setHandling(a, b, c)
    setModelHandling(a, b, c)
    for k,v in pairs(getElementsByType("vehicle")) do
        if getElementModel(v) == a then
            setVehicleHandling(v, b, c)
        end
    end
end

local hand = getModelHandling(515)
for k,v in pairs(hand) do
    setHandling(573, k, v)
end
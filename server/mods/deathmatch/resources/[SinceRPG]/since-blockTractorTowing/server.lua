function detachTrailer(theTruck)
    if getElementModel(theTruck) ~= 531 then return end
    setTimer(detachTrailer2, 50, 1, theTruck, source)

    cancelEvent()
end
addEventHandler("onTrailerAttach", getRootElement(), detachTrailer)

function detachTrailer2(theTruck, trailer)
    if (isElement(theTruck) and isElement(trailer)) then
        detachTrailerFromVehicle(theTruck, trailer)
    end
end
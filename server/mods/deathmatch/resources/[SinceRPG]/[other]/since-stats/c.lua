addEventHandler('onClientExplosion', root, function()
    cancelEvent()
end)

addEventHandler("onClientProjectileCreation", root, function()
    destroyElement(source)
end)
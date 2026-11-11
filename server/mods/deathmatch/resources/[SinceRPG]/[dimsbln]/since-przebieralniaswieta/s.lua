  

function buySkin(plr, skinid)
    local data = getElementData(plr, "player:skinsBought") or {}
    data[tostring(skinid)] = true
    setElementData(plr, "player:skinsBought", data)
end

addEvent("przebieralniaKupSkina", true)
addEventHandler("przebieralniaKupSkina", resourceRoot, function(money, skin)
    takePlayerMoney(client, money)
    buySkin(client, skin)
    setElementData(client, "buywait", false)
end)

addEvent("przebieralniaZmienSkina", true)
addEventHandler("przebieralniaZmienSkina", resourceRoot, function(skin)
    setElementModel(client, skin)
    setElementData(client, "player:skin", skin)
end)

function changeSkin(player, id)
    setElementModel(player, id)
    setElementData(player, "player:skin", id)
end

function changeSkinFromSAPD()
    for i,v in ipairs(getElementsByType("player")) do
        if getElementModel(v) == 266 and not getElementData(v, 'player:faction') then
            changeSkin(v, 0)
        end
    end
end
changeSkinFromSAPD()
setTimer(changeSkinFromSAPD, 120000, 0)
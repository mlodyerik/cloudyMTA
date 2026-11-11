  

addEvent("since-zdrapki:result", true)
addEventHandler("since-zdrapki:result", resourceRoot, function(win)
    if win >= 100000 then
        return
    end
    exports["since-db"]:query("UPDATE `since-users` SET bankMoney=bankMoney+? WHERE uid=?", win, getElementData(client, "player:sid"))
end)

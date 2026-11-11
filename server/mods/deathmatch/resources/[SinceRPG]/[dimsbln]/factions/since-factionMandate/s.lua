addCommandHandler("mandat", function(plr, cmd, target, kwota, powod)
    if getElementData(plr, "player:faction") == "SAPD" then 

        if not target and not kwota and not powod then
            return
        end

        local cel = exports["since-core"]:findPlayer(plr, target)
        if not cel then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie znaleziono podanego gracza')
        end

        if not kwota then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Wpisz kwotę ($ 0 - $ 500,000)')
        end

        if not powod then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Podaj powód')
        end

        if not tonumber(kwota) then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Podana kwota musi być liczbą')
        end

        if getElementData(cel, "player:sid") == getElementData(plr, "player:sid") then 
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz wystawić mandatu sam sobie')
        end

        if getElementData(cel, 'player:faction') == 'SAPD' then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Nie możesz wystawić mandatu innemu policjantowi')
        end

        if tonumber(kwota) > 1000000 or tonumber(kwota) < 0 then
            return exports['since-notifications']:sendNotification(plr, 'error', 'Wpisz kwotę ($ 0 - $ 1 000,000)')
        end

        local x2,y2,z2 = getElementPosition(cel)
        local x,y,z = getElementPosition(plr)
        local name = getPlayerName(plr):gsub("#%x%x%x%x%x%x","")
        local name2 = getPlayerName(cel):gsub("#%x%x%x%x%x%x","")

        if (getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 20) then
            if getPlayerMoney(cel) > tonumber(kwota) then
                local moneyToSAPD = math.floor(tonumber(kwota) * 0.20)
                exports['since-notifications']:sendNotification(cel, 'info', 'Otrzymałeś mandat w wysokości $'..tonumber(kwota)..' za: '..powod..' od policjanta '..name)
                exports['since-notifications']:sendNotification(plr, 'info', 'Wystawiłeś mandat w wysokości $'..tonumber(kwota)..' za: '..powod..' dla gracza '..name2..'. (Za wystawiony mandat otrzymujesz $ '..moneyToSAPD..')')

                takePlayerMoney(cel, tonumber(kwota))
                givePlayerMoney(plr, moneyToSAPD)
            end
        end
    end
end)




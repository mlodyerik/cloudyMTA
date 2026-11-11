local teleports = {
    {'ls', {1481.26, -1703.29, 13.92}},
    {'urzadls', {1479.60, -1768.28, 18.80,}},
    {'sapd', {2068.37, -1912.70, 13.55}},
    {'sf', {-2666.81, -5.71, 6.13}},
    {'bb', {202.22, -47.31, 1.78}},
    {'lv', {1954.70, 2155.73, 10.82}},
    {'derbyffs', {-1791.16, 3320.98, 309.78, 8899}},
    {'ztp', {-4561.65, 2888.67, 7.27}},
    {'cygan', {-69.19, -1583.53, 2.62}},
    {'przechols', {1008.95, -1444.13, 13.55}},
    {'kopalnia', {-582.40, -1057.63, 23.68}},
    {'magazyn', {2184.68, -2261.22, 13.42}},
    {'przebieralnia', {2112.41, -1214.03, 23.97}},
    {'kurier', {103.37, -284.58, 1.58}},
    {'smieciarki', {2799.09, 905.25, 10.75}},
    {'melina', {-40.34, 2346.61, 24.15}},
    {'rybak', {-366.33, 1193.81, 19.75}},
    {'lawety', {1057.28, 1934.57, 10.82}},
    {'maszynista', {1756.22, -1944.88, 13.57}},
    {'grzybiarz', {-1069.47, -1285.66, 129.22}},
    {'sara', {1788.76, -1723.39, 13.55}},
    {'szambiarz', {613.78, 1226.15, 11.79}},
    {'safd', {860.16, 1914.01, 10.82}},
    {'panele', {-581.87, -3910.23, 346.27, 6666}},
    {'gieldals', {1447.22, -2215.73, 13.55, 0}},
    {'ppls', {1617.27,-1549.95,13.59, 0}},
    {'kasyno', {1832.88,-1682.06,13.50, 0}},
    {'g1', {2320.22,1495.82,42.82, 0}},
    {'importexport', {1230.04,185.42,19.85, 0}},
    {'pplv', {2316.73,1788.29,10.82, 0}},
    {'kosiarki', {2435.48,117.41,26.47, 0}},
    {'krypto', {2108.84,-2066.85,13.55, 0}},
    {'tsa', {2201.39, 1389.90, 10.82, 0}},
    {'derby', {201.58, 385.84, 11.36, 182}},
    {'licka', {405.03, 2486.53, 16.51}},
    {'urzadlv', {2445.89, 2376.82, 12.16}},

}

for i,v in ipairs(teleports) do
    addCommandHandler(v[1], function(player, cmd)
        if not getAdmin(player) then return end
        if isPedInVehicle(player) then removePedFromVehicle(player) end

        setElementPosition(player, v[2][1], v[2][2], v[2][3])
        setElementDimension(player, (v[2][4] or 0))
        setElementInterior(player, (v[2][5] or 0))
        exports['since-notifications']:sendNotification(player, 'info', 'Zostałeś przeniesiony na teleport '..v[1])
    end)
end

addCommandHandler('teleporty', function(player, cmd)
    if not getAdmin(player) then return end

    local c = ''
    for i,v in ipairs(teleports) do
        c = c..'/'..v[1]..'\n'
    end
    c = c:sub(1, #c-1)
    outputConsole(c, player)
    exports['since-notifications']:sendNotification(player, 'info', 'Otwórz konsole, by zobaczyć listę teleportów')
end)
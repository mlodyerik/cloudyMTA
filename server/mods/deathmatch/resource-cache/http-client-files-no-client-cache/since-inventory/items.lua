local serverSide = not localPlayer

if not serverSide then
    maskTimer = nil
    setElementData(localPlayer, 'player:drinking', {stage = 0, state = false})
end

function getBoxDropToString(box)
    local items = exports['since-lootbox']:getBoxDrops(box)

    local text = table.concat(items, '\n')

    return text
end

function generateRandomRGB()
    return 125, 255, 125
end

function removeFireworkBlock()
    if serverSide then
        return
    end

    setElementData(localPlayer, 'player:fireworkblock', false)
end

local doubleClick = {}

local items = {

    ['firework:logo'] = {
        icon = 'firecracker',
        name = 'Fajerwerki',
        description = 'Fajerwerka z wzorem loga serwera',
        weight = 0.21,
        cantTrade = false,

        useClient = function()
            if getPedOccupiedVehicle(localPlayer) then
                return exports['since-notifications']:sendNotification('error', 'Nie możesz użyć tego będąc w pojeździe')
            end

            if getElementData(localPlayer, 'player:fireworkblock') then
                return exports['since-notifications']:sendNotification('error', 'Odczekaj chwilę przed kolejnym użyciem')
            end

            addPlayerItem('firework:logo', -1)

            setTimer(removeFireworkBlock, 5000, 1)
        end,

        useServer = function(player)
            if getPedOccupiedVehicle(player) then
                return
            end

            if getElementData(player, 'player:fireworkblock') then
                return
            end

            setPedAnimation(player, 'COP_AMBIENT', 'Copbrowse_nod', -1, true, false)
            setElementData(player, 'player:fireworkblock', true)
            
            setTimer(function()
                setPedAnimation(player, false)
                local x, y, z = getElementPosition(player)
                local r, g, b = generateRandomRGB()
                exports['since-fireworks']:createFirework(x, y, z, "logo", 0.1, 50, 50, {r, g, b})
            end, 1000, 1)
        end,

        class = 'normal'
    },

    ['firework:sincegurom'] = {
        icon = 'firecracker',
        name = 'Fajerwerki',
        description = 'Fajerwerka z napisem "Since Gurom"',
        weight = 0.21,
        cantTrade = false,

        useClient = function()
            if getPedOccupiedVehicle(localPlayer) then
                return exports['since-notifications']:sendNotification('error', 'Nie możesz użyć tego będąc w pojeździe')
            end

            if getElementData(localPlayer, 'player:fireworkblock') then
                return exports['since-notifications']:sendNotification('error', 'Odczekaj chwilę przed kolejnym użyciem')
            end

            addPlayerItem('firework:sincegurom', -1)

            setTimer(removeFireworkBlock, 5000, 1)
        end,

        useServer = function(player)
            if getPedOccupiedVehicle(player) then
                return
            end

            if getElementData(player, 'player:fireworkblock') then
                return
            end

            setPedAnimation(player, 'COP_AMBIENT', 'Copbrowse_nod', -1, true, false)
            setElementData(player, 'player:fireworkblock', true)
            
            setTimer(function()
                setPedAnimation(player, false)
                local x, y, z = getElementPosition(player)
                local r, g, b = generateRandomRGB()
                exports['since-fireworks']:createFirework(x, y, z, "sincegurom", 0.1, 50, 50, {r, g, b})
            end, 1000, 1)
        end,

        class = 'normal'
    },

    ['firework:explosion'] = {
        icon = 'firecracker',
        name = 'Fajerwerki',
        description = 'Fajerwerka eksplodująca',
        weight = 0.21,
        cantTrade = false,

        useClient = function()
            if getPedOccupiedVehicle(localPlayer) then
                return exports['since-notifications']:sendNotification('error', 'Nie możesz użyć tego będąc w pojeździe')
            end

            if getElementData(localPlayer, 'player:fireworkblock') then
                return exports['since-notifications']:sendNotification('error', 'Odczekaj chwilę przed kolejnym użyciem')
            end

            addPlayerItem('firework:explosion', -1)

            setTimer(removeFireworkBlock, 5000, 1)
        end,

        useServer = function(player)
            if getPedOccupiedVehicle(player) then
                return
            end

            if getElementData(player, 'player:fireworkblock') then
                return
            end

            setPedAnimation(player, 'COP_AMBIENT', 'Copbrowse_nod', -1, true, false)
            setElementData(player, 'player:fireworkblock', true)
            
            setTimer(function()
                setPedAnimation(player, false)
                local x, y, z = getElementPosition(player)
                local r, g, b = generateRandomRGB()
                exports['since-fireworks']:createFirework(x, y, z, "explosion", 15, 0.5, 50, {r, g, b})
            end, 1000, 1)
        end,

        class = 'normal'
    },

    ['silver-box'] = {
        icon = 'silverbox',
        name = 'Silver Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Silver Box') then
            --     addPlayerItem('silver-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Silver Box', 'silver-box')
        end,
        class = 'unique'
    },

    ['beer'] = {
        icon = 'beer',
        name = 'Piwo',
        description = 'Do piwa idealna tylko przemoc w rodzinie',
        weight = 0.4,
        cantTrade = true,
        useClient = function()
            local drinkData = getElementData(localPlayer, 'player:drinking') or {stage = 0, state = false}

            if getPedOccupiedVehicle(localPlayer) then
                return exports['since-notifications']:sendNotification('error', 'Nie możesz pić będąc w pojeździe')
            end

            if drinkData.state then
                return
            end

            drinkData.state = true
            drinkData.stage = drinkData.stage + 1
            setElementData(localPlayer, 'player:drinking', drinkData)

            addPlayerItem('beer', -1)

            setTimer(function()
                exports['since-alcohol']:drinkAlcohol()
            end, 2250, 1)
        end,

        useServer = function(player)
            if getPedOccupiedVehicle(player) then
                return
            end

            setPedAnimation(player, 'BAR', 'dnk_stndM_loop', -1, true, false)

            setTimer(function(player)
                local drinkData = getElementData(player, 'player:drinking') or {}
                drinkData.state = false
                setElementData(player, 'player:drinking', drinkData)

                if drinkData.stage == 2 then
                    setPedWalkingStyle(player, 126)
                end

                setPedAnimation(player, false)
            end, 2000, 1, player)
        end,
        class = 'normal'
    },

    ['bronze-box'] = {
        icon = 'bronzebox',
        name = 'Bronze Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Bronze Box') then
            --     addPlayerItem('bronze-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Bronze Box', 'bronze-box')
        end,
        class = 'unique'
    },

    ['diamond-box'] = {
        icon = 'diamondbox',
        name = 'Diamond Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Diamond Box') then
            --     addPlayerItem('diamond-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Diamond Box', 'diamond-box')
        end,
        class = 'unique'
    },

    ['golden-box'] = {
        icon = 'goldbox',
        name = 'Golden Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Golden Box') then
            --     addPlayerItem('golden-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Golden Box', 'golden-box')
        end,
        class = 'unique'
    },

    ['legendary-box'] = {
        icon = 'legendarybox',
        name = 'Legendary Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Legendary Box') then
            --     addPlayerItem('legendary-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Legendary Box', 'legendary-box')
        end,
        class = 'unique'
    },

    ['car-box'] = {
        icon = 'carbox',
        name = 'Car Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Car Box') then
            --     addPlayerItem('car-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Car Box', 'car-box')
        end,
        class = 'unique'
    },

    ['easter-box'] = {
        icon = 'easterbox',
        name = 'Easter Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Easter Box') then
            --     addPlayerItem('easter-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Easter Box', 'easter-box')
        end,
        class = 'unique'
    },

    ['summer-box'] = {
        icon = 'summerbox',
        name = 'Summer Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Summer Box') then
            --     addPlayerItem('summer-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Summer Box', 'summer-box')
        end,
        class = 'unique'
    },

    ['unique-box'] = {
        icon = 'legendarybox',
        name = 'Unique Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Unique Box') then
            --     addPlayerItem('unique-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Unique Box', 'unique-box')
        end,
        class = 'unique'
    },

    ['winter-box'] = {
        icon = 'winterbox',
        name = 'Winter Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Winter Box') then
            --     addPlayerItem('winter-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Winter Box', 'winter-box')
        end,
        class = 'unique'
    },

    ['newcars'] = {
        icon = 'diamondbox',
        name = 'New Cars Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('New Cars Box') then
            --     addPlayerItem('newcars', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'New Cars Box', 'newcars')
        end,
        class = 'unique'
    },

    ['birhtday-box'] = {
        icon = 'diamondbox',
        name = 'Birthday Box',
        description = ' ',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            -- if exports['since-lootbox']:createOpening('Birthday Box') then
            --     addPlayerItem('birhtday-box', -1)
            --     toggleInventory(false)
            -- end
        end,

        useServer = function(player)
            exports['since-lootbox']:createOpening(player, 'Birthday Box', 'birhtday-box')
        end,
        class = 'unique'
    },

    ['makrela'] = {
        icon = 'makrela',
        name = 'Makrela',
        description = 'Rybka',
        weight = 0.1,
        useClient = function() end,
        useServer = function(player) end,
        class = 'normal'
    },

    ['trytytki'] = {
        icon = 'trytytki',
        name = 'Trytytki',
        description = 'Służy do zaciśnięcia nadgarstków',
        weight = 0.1,
        useClient = function() end,
        useServer = function(player) end,
        class = 'illegal'
    },

    ['dorsz'] = {
        icon = 'dorsz',
        name = 'Dorsz',
        description = 'Rybka',
        weight = 0.1,
        useClient = function() end,
        useServer = function(player) end,
        class = 'normal'
    },

    ['szczupak'] = {
        icon = 'szczupak',
        name = 'Szczupak',
        description = 'Rybka',
        weight = 0.1,
        useClient = function() end,
        useServer = function(player) end,
        class = 'normal'
    },

    ['karp'] = {
        icon = 'karp',
        name = 'Karp',
        description = 'Rybka',
        weight = 0.1,
        useClient = function() end,
        useServer = function(player) end,
        class = 'normal'
    },

    ['rekin'] = {
        icon = 'rekin',
        name = 'Rekin',
        description = 'Rybka',
        weight = 0.1,
        useClient = function() end,
        useServer = function(player) end,
        class = 'normal'
    },

    ['wedka'] = {
        icon = 'wedka',
        name = 'Wędka',
        progress = 0,
        description = 'Sprzęt do łowienia rybek',
        weight = 0.1,

        useClient = function(item)
            if getElementData(localPlayer, 'player:fishing') then
                return exports['since-notifications']:sendNotification('error', 'Nie możesz schować wędki łowiąc')
            end

            local usedItems = getElementData(localPlayer, 'usedItems') or {}
        
            if (getPedWeapon(localPlayer, 1) == 7) then
                usedItems[item.token] = nil
            else
                usedItems[item.token] = item
            end

            setElementData(localPlayer, 'usedItems', usedItems)
        end,

        useServer = function(player)
            if getElementData(player, 'player:fishing') then
                return
            end

            if (getPedWeapon(player, 1) == 7) then
                takeWeapon(player, 7)
                exports['since-notifications']:sendNotification(player, 'info', 'Schowano wędkę')
            else
                giveWeapon(player, 7, 5, true)
                exports['since-notifications']:sendNotification(player, 'info', 'Wyjmujesz wędkę')
            end
        end,

        class = 'gray'
    },

    ['money-pack'] = {
        icon = 'money',
        name = 'Torba z pieniedzmi',
        description = 'Torba, w której znajdują się pieniądze.',
        weight = 0.75,
        cantTrade = true,
        useClient = function()
            addPlayerItem('money-pack', -1)
        end,

        useServer = function(player)
            local random = math.random(1000, 5000)
            givePlayerMoney(player, random)
            exports['since-notifications']:sendNotification(player, 'success', 'Otwierasz torbę z pieniędzmi, znajdujesz #7dff7d$ '..addCommas(random)..'')
        end,
        class = 'gray'
    },

    ['milka-snack'] = {

        icon = 'milka-snack',
        name = 'Baton Milka Snack',
        description = 'Baton regenerujący zdrowie.',
        weight = 0.102,

        useClient = function()
            addPlayerItem('milka-snack', -1)
        end,

        useServer = function(player)
            local health = getElementHealth(player)
            setElementHealth(player, health + 5)
        end,

        class = 'normal'
    },

    ['energetyk'] = {

        icon = 'energy',
        name = 'Energetyk',
        description = 'Dodaje energii',
        weight = 0.24,

        useClient = function()
            if getElementData(localPlayer, 'player:energydrink') then
                return
            end

            addPlayerItem('energetyk', -1)
        end,

        useServer = function(player)
            if getElementData(player, 'player:energydrink') then
                return
            end

            setPedAnimation(player, "BAR", "dnk_stndM_loop", -1, true, false )
			setTimer(function(player) setPedAnimation(player, false) end,2000,1,player)

			triggerClientEvent(player, "energetyk.c", player)

			setElementData(player, "player:energydrink", true)
        end,

        class = 'normal'

    },

    ['toolbox'] = {

        icon = 'toolbox',
        name = 'Zestaw naprawczy',
        description = 'Napraw swój pojazd',
        weight = 7.12,

        useClient = function()
            if not getPedOccupiedVehicle(localPlayer) then
                setElementData(localPlayer, 'cantFix', true)
                return
            end

            if not isPedInVehicle(localPlayer) then
                setElementData(localPlayer, 'cantFix', true)
                return
            end

            addPlayerItem('toolbox', -1)
        end,

        useServer = function(player)
            if getElementData(player, 'cantFix') then
                setElementData(player, 'cantFix', false)
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie siedzisz w pojeździe')
            end

            if not getPedOccupiedVehicle(player) then
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie siedzisz w pojeździe')
            end

            if not isPedInVehicle(player) then
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie siedzisz w pojeździe')
            end

            setElementHealth(getPedOccupiedVehicle(player), 1000)
            exports['since-notifications']:sendNotification(player, 'success', 'Pojazd naprawiony')
        end,

        class = 'normal'

    },

    ['fuelcan'] = {

        icon = 'fuelcan',
        name = 'Kanister',
        description = 'Dotankuj 5 litrów benzyny',
        weight = 5.73,

        useClient = function()
            if not getPedOccupiedVehicle(localPlayer) then
                return
            end

            addPlayerItem('fuelcan', -1)
        end,

        useServer = function(player)
            if not getPedOccupiedVehicle(player) then
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie siedzisz w pojeździe')
            end

            local veh = getPedOccupiedVehicle(player)
            local fuelData = getElementData(veh, 'vehicle:fuel') or {}

            fuelData.count = math.min(fuelData.count + 5, fuelData.tank)
            setElementData(veh, 'vehicle:fuel', fuelData)

            exports['since-notifications']:sendNotification(player, 'success', 'Dotankowano 5 litrów benzyny')
        end,

        class = 'normal'

    },

    ['scratcher-1'] = {
        icon = 'scratcher-1',
        name = 'Zdrapka Green Money',
        description = 'Zdrap i moży wygracz dużą kwotę',
        weight = 0.01,

        useClient = function()
            if getElementData(localPlayer, 'zdrapuje') then 
                return 
            end
            addPlayerItem('scratcher-1', -1)
            exports['since-scratchers']:zdrap(1)
        end,

        useServer = function(player)

        end,

        class = 'normal'
    },

    ['scratcher-2'] = {
        icon = 'scratcher-2',
        name = 'Zdrapka Żabka Szczęścia',
        description = 'Zdrap i moży wygracz dużą kwotę',
        weight = 0.01,

        useClient = function()
            if getElementData(localPlayer, 'zdrapuje') then 
                return 
            end
            addPlayerItem('scratcher-2', -1)
            exports['since-scratchers']:zdrap(2)
        end,

        useServer = function(player)

        end,

        class = 'normal'
    },

    ['scratcher-3'] = {
        icon = 'scratcher-3',
        name = 'Zdrapka Extra Pensja',
        description = 'Zdrap i moży wygracz dużą kwotę',
        weight = 0.01,

        useClient = function()
            if getElementData(localPlayer, 'zdrapuje') then 
                return 
            end
            addPlayerItem('scratcher-3', -1)
            exports['since-scratchers']:zdrap(3)
        end,

        useServer = function(player)

        end,

        class = 'normal'
    },

    ['seed-marihuana'] = {
        icon = 'seeds',
        name = 'Nasiono Marihuana',
        description = 'Nasiono',
        weight = 0.01,

        useClient = function()
            exports['since-weedSystem']:putPlant(1)
        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['seed-sativa'] = {
        icon = 'seeds',
        name = 'Nasiono Sativa',
        description = 'Nasiono',
        weight = 0.01,

        useClient = function()
            exports['since-weedSystem']:putPlant(2)
        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['seed-indica'] = {
        icon = 'seeds',
        name = 'Nasiono Indica',
        description = 'Nasiono',
        weight = 0.01,

        useClient = function()
            exports['since-weedSystem']:putPlant(3)
        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['seed-lemonhaze'] = {
        icon = 'seeds',
        name = 'Nasiono Lemon Haze',
        description = 'Nasiono',
        weight = 0.01,

        useClient = function()
            exports['since-weedSystem']:putPlant(4)
        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['seed-kush'] = {
        icon = 'seeds',
        name = 'Nasiono Kush',
        description = 'Nasiono',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['seed-bluedream'] = {
        icon = 'seeds',
        name = 'Nasiono Blue Dream',
        description = 'Nasiono',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['seed-platinumog'] = {
        icon = 'seeds',
        name = 'Nasiono Platinum OG',
        description = 'Nasiono',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['seed-ruderalis'] = {
        icon = 'seeds',
        name = 'Nasiono Ruderalis',
        description = 'Nasiono',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    

    
    ['top-marihuana'] = {
        icon = 'cannabis',
        name = 'Top Marihuana',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['top-sativa'] = {
        icon = 'cannabis',
        name = 'Top Sativa',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['top-lemonhaze'] = {
        icon = 'cannabis',
        name = 'Top Lemon Haze',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['top-indica'] = {
        icon = 'cannabis',
        name = 'Top Indica',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['top-kush'] = {
        icon = 'cannabis',
        name = 'Top Kush',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['top-bluedream'] = {
        icon = 'cannabis',
        name = 'Top Blue Dream',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['top-platinumog'] = {
        icon = 'cannabis',
        name = 'Top Platinum OG',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['top-ruderalis'] = {
        icon = 'cannabis',
        name = 'Top Ruderalis',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['top-indica'] = {
        icon = 'cannabis',
        name = 'Top Indica',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    

    
    ['recasted-marihuana'] = {
        icon = 'cannabis2',
        name = 'Przerobiony Top Marihuana',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['recasted-sativa'] = {
        icon = 'cannabis2',
        name = 'Przerobiony Top Sativa',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['recasted-lemonhaze'] = {
        icon = 'cannabis2',
        name = 'Przerobiony Top Lemon Haze',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['recasted-indica'] = {
        icon = 'cannabis2',
        name = 'Przerobiony Top Indica',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['recasted-kush'] = {
        icon = 'cannabis2',
        name = 'Przerobiony Top Kush',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['recasted-bluedream'] = {
        icon = 'cannabis2',
        name = 'Przerobiony Top Blue Dream',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['recasted-platinumog'] = {
        icon = 'cannabis2',
        name = 'Przerobiony Top Platinum OG',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['recasted-ruderalis'] = {
        icon = 'cannabis2',
        name = 'Przerobiony Top Ruderalis',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },


    ['drug-marihuana'] = {
        icon = 'drugs',
        name = 'Woreczek z Marihuana',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()
            if exports['since-weedEffects']:useWeed(1) then
                addPlayerItem('drug-marihuana', -1)
            end
        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['drug-sativa'] = {
        icon = 'drugs',
        name = 'Woreczek z Sativa',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()
            if exports['since-weedEffects']:useWeed(2) then
                addPlayerItem('drug-sativa', -1)
            end
        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['drug-indica'] = {
        icon = 'drugs',
        name = 'Woreczek z Indica',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()
            if exports['since-weedEffects']:useWeed(3) then
                addPlayerItem('drug-indica', -1)
            end
        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['drug-lemonhaze'] = {
        icon = 'drugs',
        name = 'Woreczek z Lemon Haze',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()
            if exports['since-weedEffects']:useWeed(4) then
                addPlayerItem('drug-lemonhaze', -1)
            end
        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['drug-kush'] = {
        icon = 'drugs',
        name = 'Woreczek z Kush',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['drug-bluedream'] = {
        icon = 'drugs',
        name = 'Woreczek z Blue Dream',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['drug-platinumog'] = {
        icon = 'drugs',
        name = 'Woreczek z Platinum OG',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },
    
    ['drug-ruderalis'] = {
        icon = 'drugs',
        name = 'Woreczek z Ruderalis',
        description = 'Narkotyk',
        weight = 0.01,

        useClient = function()

        end,

        useServer = function(player)

        end,

        class = 'illegal'
    },

    ['mask'] = {
        icon = 'kominiarka',
        name = 'Kominiarka',
        description = 'Bądź anonimowy!',
        weight = 0.015,

        useClient = function()
            if getElementData(localPlayer, 'mask:cooldown') then
                if maskTimer then
                    local remainingTime = getTimerDetails(maskTimer)
                    local remainingTime = math.floor(remainingTime / 1000)

                    return exports['since-notifications']:sendNotification('error', 'Odczekaj jeszcze '..remainingTime..' sek.')
                end
            end

            maskTimer = setTimer(function()
                setElementData(localPlayer, 'mask:cooldown', nil)

                if isTimer(maskTimer) then
                    killTimer(maskTimer)
                end
                
                maskTimer = nil
            end, 5000, 1)
        end,

        useServer = function(player)
            if getElementData(player, 'mask:cooldown') then
                return
            end

            if getElementData(player, 'player:mask') then
                local playerName = getElementData(player, 'player:mask')
                setPlayerName(player, playerName)
                setElementData(player, 'player:mask', nil)

                exports['since-notifications']:sendNotification(player, 'info', 'Zdejmujesz kominiarkę')
            else
                local playerName = getPlayerName(player):gsub('#%x%x%x%x%x%x', '')
                setElementData(player, 'player:mask', playerName)

                local playerSID = getElementData(player, 'player:sid')
                local formatSID = string.format('%04d', playerSID)
                setPlayerName(player, 'Nieznajomy#'..formatSID)

                exports['since-notifications']:sendNotification(player, 'info', 'Zakładasz kominiarkę')
            end

            setElementData(player, 'mask:cooldown', true)
        end,

        class = 'illegal'
    },

    ['water'] = {
        icon = 'waterbottle',
        name = 'Butelka z wodą',
        description = 'Woda',
        weight = 0.01,

        useClient = function()
            if getElementData(localPlayer, 'player:drinking') then
                return
            end
            addPlayerItem('water', -1)
        end,

        useServer = function(player)
            if getElementData(player, 'player:drinking') then
                return
            end
            setElementData(player, 'player:drinking', true)
            setPedAnimation(player, "BAR", "dnk_stndM_loop", -1, true, false )
			setTimer(function(player) 
                setPedAnimation(player, false) 
                setElementData(player, 'player:drinking', nil)
            end,2000,1,player)

        end,

        class = 'normal'
    },

    ['desert-eagle'] = {
        icon = 'deagle',
        name = 'Desert Eagle',
        description = 'Pistolet samopowtarzalny',
        weight = 1.75,

        useClient = function()

        end,

        useServer = function(player)
            if (not exports['since-dashboard']:isPlayerPassive(player) or getElementData(player, 'player:gang')) then
                if getElementData(player, 'player:arena') then
                    return
                end
                if (getPedWeapon(player, 2) == 24) then
                    takeWeapon(player, 24)
                    exports['since-notifications']:sendNotification(player, 'info', 'Schowano Desert Eagle')
                else
                    giveWeapon(player, 24, 99999, true)
                    exports['since-notifications']:sendNotification(player, 'info', 'Wyjmujesz Desert Eagle')
                end
            else
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wyjąć broni poza strefą bezprawia, która znajduje się w San Fierro')
            end

            for i = 69, 79 do
                setPedStat(player, i, 1000 )
            end
        end,

        class = 'normal'
    },

    ['ak-47'] = {
        icon = 'ak47',
        name = 'AK-47',
        description = 'Karabinek automatyczny',
        weight = 3.8,

        useClient = function()

        end,

        useServer = function(player)
            if (not exports['since-dashboard']:isPlayerPassive(player) or getElementData(player, 'player:gang')) then
                if getElementData(player, 'player:arena') then
                    return
                end
                if (getPedWeapon(player, 5) == 30) then
                    takeWeapon(player, 30)
                    exports['since-notifications']:sendNotification(player, 'info', 'Schowano AK-47')
                else
                    giveWeapon(player, 30, 99999, true)
                    exports['since-notifications']:sendNotification(player, 'info', 'Wyjmujesz AK-47')
                end
            else
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wyjąć broni poza strefą bezprawia, która znajduje się w San Fierro')
            end

            for i = 69, 79 do
                setPedStat(player, i, 1000 )
            end
        end,

        class = 'normal'
    },

    ['awm'] = {
        icon = 'awm',
        name = 'Karabin AWM',
        description = 'Karabin snajperski',
        weight = 11.12,

        useClient = function()

        end,

        useServer = function(player)
            if (not exports['since-dashboard']:isPlayerPassive(player) or getElementData(player, 'player:gang')) then
                if getElementData(player, 'player:arena') then
                    return
                end
                if (getPedWeapon(player, 6) == 34) then
                    takeWeapon(player, 34)
                    exports['since-notifications']:sendNotification(player, 'info', 'Schowano Karabin AWM')
                else
                    giveWeapon(player, 34, 99999, true)
                    exports['since-notifications']:sendNotification(player, 'info', 'Wyjmujesz Karabin AWM')
                end
            else
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wyjąć broni poza strefą bezprawia, która znajduje się w San Fierro')
            end

            for i = 69, 79 do
                setPedStat(player, i, 1000 )
            end
        end,

        class = 'normal'
    },

    ['m4'] = {
        icon = 'M4',
        name = 'M4A1-S',
        description = 'Karabin szturmowy',
        weight = 4.21,

        useClient = function()

        end,

        useServer = function(player)
            if (not exports['since-dashboard']:isPlayerPassive(player) or getElementData(player, 'player:gang')) then
                if getElementData(player, 'player:arena') then
                    return
                end
                if (getPedWeapon(player, 5) == 31) then
                    takeWeapon(player, 31)
                    exports['since-notifications']:sendNotification(player, 'info', 'Schowano Karabin M4A1-S')
                else
                    giveWeapon(player, 31, 99999, true)
                    exports['since-notifications']:sendNotification(player, 'info', 'Wyjmujesz Karabin M4A1-S')
                end
            else
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wyjąć broni poza strefą bezprawia, która znajduje się w San Fierro')
            end

            for i = 69, 79 do
                setPedStat(player, i, 1000 )
            end
        end,

        class = 'normal'
    },

    ['shotgun'] = {
        icon = 'shotgun',
        name = 'Shotgun',
        description = 'Strzelba',
        weight = 5.08,

        useClient = function()

        end,

        useServer = function(player)
            if (not exports['since-dashboard']:isPlayerPassive(player) or getElementData(player, 'player:gang')) then
                if getElementData(player, 'player:arena') then
                    return
                end
                if (getPedWeapon(player, 3) == 26) then
                    takeWeapon(player, 26)
                    exports['since-notifications']:sendNotification(player, 'info', 'Schowano Shotguna')
                else
                    giveWeapon(player, 26, 99999, true)
                    exports['since-notifications']:sendNotification(player, 'info', 'Wyjmujesz Shotguna')
                end
            else
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wyjąć broni poza strefą bezprawia, która znajduje się w San Fierro')
            end

            for i = 69, 79 do
                setPedStat(player, i, 1000 )
            end
        end,

        class = 'normal'
    },

    ['mp5'] = {
        icon = 'mp5',
        name = 'Karabin MP5',
        description = 'Karabin maszynowy',
        weight = 4.64,

        useClient = function()

        end,

        useServer = function(player)
            if (not exports['since-dashboard']:isPlayerPassive(player) or getElementData(player, 'player:gang')) then
                if getElementData(player, 'player:arena') then
                    return
                end
                if (getPedWeapon(player, 4) == 29) then
                    takeWeapon(player, 29)
                    exports['since-notifications']:sendNotification(player, 'info', 'Schowano Karabin MP5')
                else
                    giveWeapon(player, 29, 99999, true)
                    exports['since-notifications']:sendNotification(player, 'info', 'Wyjmujesz Karabin MP5')
                end
            else
                return exports['since-notifications']:sendNotification(player, 'error', 'Nie możesz wyjąć broni poza strefą bezprawia, która znajduje się w San Fierro')
            end

            for i = 69, 79 do
                setPedStat(player, i, 1000 )
            end
        end,

        class = 'normal'
    },

    -- tuningi

    ['mk4'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning mk4',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['mk5'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning mk5',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['mk6'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning mk6',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
    
    ['mk2137'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning mk2137',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
    
    ['chiptuning'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning chiptuning',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['deluxomode'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning deluxomode',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['hovermode'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning hovermode',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['jumpmode'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning jumpmode',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['cameleon'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning kameleon',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['vopis'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning vopis',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['vopisrgb'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning vopisrgb',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['neonrgb'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning neony rgb',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['rgbsmoke'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning dym rgb',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['driftmode'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning driftmode',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['licznikrgb'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning licznik rgb',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
    
    ['exhaust'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning strzaly z wydechu',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local tunings = getElementData(vehicle, 'vehicle:upgrades') or {}
            if tunings[item.name] then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
    



    ['stereo'] = {
        icon = 'tuning',
        name = 'Unikatowy tuning stereo',
        description = 'Unikatowy tuning',
        weight = 0,
        useClient = function(item)
            local vehicle = getPedOccupiedVehicle(localPlayer)
            if not vehicle then return end
            if not getElementData(vehicle, 'vehicle:id') then return end
            if getElementData(vehicle, 'vehicle:owner') ~= getElementData(localPlayer, 'player:sid') then
                return exports['since-notifications']:sendNotification('error', 'Nie jesteś właścicielem pojazdu')
            end
            local info = getVehicleUpgradeOnSlot(vehicle, 10)
            if (info == 1086) then
                return exports['since-notifications']:sendNotification('error', 'Ten pojazd posiada już ten tuning')
            end
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                return exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
            end
            addPlayerItem(item.name, -1)
            triggerServerEvent('useItemTune', resourceRoot, item.name, vehicle)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    -- tuningi

    -- vouchery

    ['voucher-magazynier'] = {
        icon = 'voucher',
        name = 'Voucher pracy Magazynier',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-magazynier', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę magazyniera, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'magazynier', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
    
    ['voucher-kurier'] = {
        icon = 'voucher',
        name = 'Voucher pracy Kurier',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-kurier', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę kuriera, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'kurier', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
    
    ['voucher-kosiarki'] = {
        icon = 'voucher',
        name = 'Voucher pracy Kosiarki',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-kosiarki', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę kosiarek, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'kosiarki', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-lawety'] = {
        icon = 'voucher',
        name = 'Voucher pracy Lawety',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-lawety', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę lawet, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'lawety', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-grzybiarz'] = {
        icon = 'voucher',
        name = 'Voucher pracy Grzybiarz',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-grzybiarz', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę grzybiarza, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'grzybiarz', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-szambiarz'] = {
        icon = 'voucher',
        name = 'Voucher pracy Szambiarz',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-szambiarz', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę szambiarza, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'szambiarz', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-smieciarki'] = {
        icon = 'voucher',
        name = 'Voucher pracy Smieciarki',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-smieciarki', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę smieciarek, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'smieciarki', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-gornik'] = {
        icon = 'voucher',
        name = 'Voucher pracy Górnik',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-gornik', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę górnik, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'gornik', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-rybak'] = {
        icon = 'voucher',
        name = 'Voucher pracy Rybak',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-rybak', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę rybaka, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'rybak', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-logistyka'] = {
        icon = 'voucher',
        name = 'Voucher pracy Logistyka lądowa',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-logistyka', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę logistyki lądowej, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'logistyka', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
    
    ['voucher-dostawca'] = {
        icon = 'voucher',
        name = 'Voucher pracy Dostawca',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-dostawca', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę dostawcy, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'dostawca', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
    
    ['voucher-maszynista'] = {
        icon = 'voucher',
        name = 'Voucher pracy Maszynista',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-maszynista', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę maszynisty, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'maszynista', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },
     
    ['voucher-etransporter'] = {
        icon = 'voucher',
        name = 'Voucher pracy E-Transporter',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-etransporter', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę E-Transporter, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'etransporter', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-import'] = {
        icon = 'voucher',
        name = 'Voucher pracy Import/Export',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-import', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę Import/Export, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'import', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    ['voucher-spedycjaLotnicza'] = {
        icon = 'voucher',
        name = 'Voucher pracy Spedycja lotnicza',
        description = 'Unikatowy voucher zwiększający zarobki na pracy',
        weight = 0,
        useClient = function(item)            
            if not doubleClick[item.name] or (doubleClick[item.name] and doubleClick[item.name] < getTickCount()) then
                doubleClick[item.name] = getTickCount() + 2000
                exports['since-notifications']:sendNotification('info', 'Aby potwierdzić, że chcesz użyć tego przedmiotu, kliknij jeszcze raz')
                return
            end

            addPlayerItem('voucher-spedycjaLotnicza', -1)
            exports['since-notifications']:sendNotification('success', 'Używasz voucher na pracę spedycji lotniczej, zarobek został zwiększony o 20% na godzinę')
            triggerServerEvent('useItemVoucher', resourceRoot, item.name, 'spedycjaLotnicza', 20, 60)
            doubleClick[item.name] = nil
        end,
        useServer = function(player)
        end,
        class = 'unique'
    },

    -- vouchery
    
}

local boxTypes = {

    ['Bronze Box'] = 'bronze-box',
    ['Silver Box'] = 'silver-box',
    ['Golden Box'] = 'golden-box',
    ['Diamond Box'] = 'diamond-box',
    ['Christmas Box'] = 'christmas-box',
    ['Legendary Box'] = 'legendary-box',
    ['Car Box'] = 'car-box',
    ['Easter Box'] = 'easter-box',
    ['Summer Box'] = 'summer-box',
    ['Unique Box'] = 'unique-box',
    ['Winter Box'] = 'winter-box',
    ['Birhtday Box'] = 'birhtday-box',
    ['New Cars Box'] = 'newcars'

}

function loadBoxDescription()
    for k, v in pairs(items) do
        if boxTypes[v.name] then
            v.description = getBoxDropToString(v.name)
        end
    end
end
setTimer(loadBoxDescription, 30000, 0)
addEventHandler('onClientResourceStart', resourceRoot, loadBoxDescription)

function getItemInfo(item)
    return items[item]
end

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

function generateToken()
    local chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    local token = ''
    for i = 1, 4 do
        for c = 1, 4 do
            local r = math.random(1, #chars)
            token = token .. chars:sub(r, r)
        end
        if i ~= 4 then
            token = token .. '-'
        end
    end
    return token
end

function useItem(...)
    local args = {...}
    local player, item;
    if serverSide then
        player, item = args[1], args[2]
    else
        player, item = localPlayer, args[1]
    end

    local itemInfo = getItemInfo(item.name)
    if not itemInfo then return end

    if itemInfo.useClient then
        itemInfo.useClient(item)
        triggerServerEvent('useItem', resourceRoot, item.name, item.token)
    end
end
getResourceName(getThisResource(), true, 202403731); if true then return end
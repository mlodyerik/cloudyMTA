  

selectedShopCategory = 'diamond'
selectedShopItem = nil


boxIcons = {

    ['box_bronze'] = 'bronzebox',
    ['box_silver'] = 'silverbox',
    ['box_gold'] = 'goldbox',
    ['box_diamond'] = 'diamondbox',
    ['box_legendary'] = 'legendarybox',
    ['box_car'] = 'carbox',

}

shopCategory = {

    {

        name = 'Diamond',
        typeC = 'diamond',

    },

    {

        name = 'Dodatki',
        typeC = 'dodatki',

    },

    {

        name = 'Boxy',
        typeC = 'boxs',

    },

}

shopItems = {

    ['diamond'] = {

        {
            itemToken = 'D3',
            name = 'Status diamond',
            desc = 'Usługa diamond na okres 3 dni',
            cost = 1000,
            days = 3,
        },

        {
            itemToken = 'D7',
            name = 'Status diamond',
            desc = 'Usługa diamond na okres 7 dni',
            cost = 2000,
            days = 7,
        },

        {
            itemToken = 'D31',
            name = 'Status diamond',
            desc = 'Usługa diamond na okres 30 dni',
            cost = 7000,
            days = 31,
        },

        {
            itemToken = 'D60',
            name = 'Status diamond',
            desc = 'Usługa diamond na okres 60 dni',
            cost = 12500,
            days = 60,
        },

    },
    
    ['boxs'] = {

        {
            itemToken = 'box_bronze',
            name = 'Bronze box',
            desc = '1x Bronze Box do ekwipunku',
            cost = 200,
            amount = 1,
        },

        {
            itemToken = 'box_silver',
            name = 'Silver box',
            desc = '1x Silver Box do ekwipunku',
            cost = 300,
            amount = 1,
        },

        {
            itemToken = 'box_gold',
            name = 'Golden box',
            desc = '1x Golden Box do ekwipunku',
            cost = 400,
            amount = 1,
        },

        {
            itemToken = 'box_diamond',
            name = 'Diamond box',
            desc = '1x Diamond Box do ekwipunku',
            cost = 1400,
            amount = 1,
        },

        {
            itemToken = 'box_legendary',
            name = 'Legendary box',
            desc = '1x Legendary Box do ekwipunku',
            cost = 2000,
            amount = 1,
        },

        {
            itemToken = 'box_car',
            name = 'Car box',
            desc = '1x Car Box do ekwipunku',
            cost = 5000,
            amount = 1,
        },

    },

    ['dodatki'] = {

        {
            itemToken = 'rainbownick',
            name = '#ff0000K#ff6a00o#ffa200l#ffcc00o#fffb00r#ccff00o#84ff00w#40ff00y #00ff7bn#00e1ffi#0091ffc#0044ffk',
            desc = 'Zmienia kolor nicku na tęczowy',
            cost = 3000,
            icon = 'rainbow',

        },

    }

}

function getShopItemByToken(typeS, token)
    local item = nil
    
    for i,v in ipairs(shopItems[typeS]) do
        if v.itemToken == token then
            item = v
        end
    end

    return item
end

function isPlayerPassive(player)
    if not player then
        player = localPlayer
    end
    if getElementData(player, 'player:arena') or getElementData(player, 'player:strefa') or getElementData(player, 'player:napada') or (getElementData(player, 'player:faction') == 'SAPD') then
        return false
    else
        return true
    end
end
getResourceName(getThisResource(), true, 845817759); if true then return end
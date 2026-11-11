local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
zoom = zoom * 0.9

local main = {
    ['textures'] = {
        ['avatar_bg'] = dxCreateTexture('data/images/avatar_bg.png','argb',false,'clamp'),
        ['mask'] = dxCreateTexture('data/images/mask.png','argb',false,'clamp'),
        ['money_bg'] = dxCreateTexture('data/images/money_bg.png','argb',false,'clamp'),
        ['money_icon'] = dxCreateTexture('data/images/money_icon.png','argb',false,'clamp'),
        ['rounded'] = dxCreateTexture('data/images/rounded.png','argb',false,'clamp'),
        ['rounded_mask'] = dxCreateTexture('data/images/rounded_mask.png','argb',false,'clamp'),
        ['nick_icon'] = dxCreateTexture('data/images/nick_icon.png','argb',false,'clamp'),
        ['circle'] = dxCreateTexture('data/images/circle.png','argb',false,'clamp'),
        ['tlen'] = dxCreateTexture('data/images/tlen.png','argb',false,'clamp'),
        ['circle_filled'] = dxCreateTexture('data/images/circle_filled.png','argb',false,'clamp'),
        ['armor'] = dxCreateTexture('data/images/armor.png','argb',false,'clamp'),
        ['heart'] = dxCreateTexture('data/images/heart.png','argb',false,'clamp'),
        ['rank-icon'] = dxCreateTexture('data/images/rank-icon.png','argb',false,'clamp'),
        [1] = dxCreateTexture('data/weapons/1.png','argb',false,'clamp'),
        [2] = dxCreateTexture('data/weapons/2.png','argb',false,'clamp'),
        [3] = dxCreateTexture('data/weapons/3.png','argb',false,'clamp'),
        [4] = dxCreateTexture('data/weapons/4.png','argb',false,'clamp'),
        [5] = dxCreateTexture('data/weapons/5.png','argb',false,'clamp'),
        [6] = dxCreateTexture('data/weapons/6.png','argb',false,'clamp'),
        [7] = dxCreateTexture('data/weapons/7.png','argb',false,'clamp'),
        [8] = dxCreateTexture('data/weapons/8.png','argb',false,'clamp'),
        [9] = dxCreateTexture('data/weapons/9.png','argb',false,'clamp'),
        [10] = dxCreateTexture('data/weapons/10.png','argb',false,'clamp'),
        [11] = dxCreateTexture('data/weapons/11.png','argb',false,'clamp'),
        [12] = dxCreateTexture('data/weapons/12.png','argb',false,'clamp'),
        [14] = dxCreateTexture('data/weapons/14.png','argb',false,'clamp'),
        [15] = dxCreateTexture('data/weapons/15.png','argb',false,'clamp'),
        [16] = dxCreateTexture('data/weapons/16.png','argb',false,'clamp'),
        [17] = dxCreateTexture('data/weapons/17.png','argb',false,'clamp'),
        [18] = dxCreateTexture('data/weapons/18.png','argb',false,'clamp'),
        [22] = dxCreateTexture('data/weapons/22.png','argb',false,'clamp'),
        [23] = dxCreateTexture('data/weapons/23.png','argb',false,'clamp'),
        [24] = dxCreateTexture('data/weapons/24.png','argb',false,'clamp'),
        [25] = dxCreateTexture('data/weapons/25.png','argb',false,'clamp'),
        [26] = dxCreateTexture('data/weapons/26.png','argb',false,'clamp'),
        [27] = dxCreateTexture('data/weapons/27.png','argb',false,'clamp'),
        [28] = dxCreateTexture('data/weapons/28.png','argb',false,'clamp'),
        [29] = dxCreateTexture('data/weapons/29.png','argb',false,'clamp'),
        [30] = dxCreateTexture('data/weapons/30.png','argb',false,'clamp'),
        [31] = dxCreateTexture('data/weapons/31.png','argb',false,'clamp'),
        [32] = dxCreateTexture('data/weapons/32.png','argb',false,'clamp'),
        [33] = dxCreateTexture('data/weapons/33.png','argb',false,'clamp'),
        [34] = dxCreateTexture('data/weapons/34.png','argb',false,'clamp'),
        [35] = dxCreateTexture('data/weapons/35.png','argb',false,'clamp'),
        [36] = dxCreateTexture('data/weapons/36.png','argb',false,'clamp'),
        [37] = dxCreateTexture('data/weapons/37.png','argb',false,'clamp'),
        [38] = dxCreateTexture('data/weapons/38.png','argb',false,'clamp'),
        [39] = dxCreateTexture('data/weapons/39.png','argb',false,'clamp'),
        [40] = dxCreateTexture('data/weapons/40.png','argb',false,'clamp'),
        [41] = dxCreateTexture('data/weapons/41.png','argb',false,'clamp'),
        [42] = dxCreateTexture('data/weapons/42.png','argb',false,'clamp'),
        [43] = dxCreateTexture('data/weapons/43.png','argb',false,'clamp'),
        [44] = dxCreateTexture('data/weapons/44.png','argb',false,'clamp'),
        [45] = dxCreateTexture('data/weapons/45.png','argb',false,'clamp'),
        [46] = dxCreateTexture('data/weapons/46.png','argb',false,'clamp')
    },
    ['fonts'] = {
        [1] = exports['since-fonts']:getFont('Inter-Semibold', 12/zoom),
        [2] = exports['since-fonts']:getFont('Inter-Bold', 12/zoom)
    },
    ['money'] = 0
}

addEventHandler('onClientRender', root, function ()
    if not getElementData(localPlayer,'player:spawn') then return end
    if getElementData(localPlayer,'player:hudof') then return end

    local money = addCommas(getPlayerMoney())
    local nick = getPlayerName(localPlayer)
    local twidth = dxGetTextWidth(money, 1, main['fonts'][1]) + 10/zoom
    local w = twidth - 29/zoom + 80/zoom
    local twidth2 = dxGetTextWidth(nick, 1, main['fonts'][1]) + 10/zoom
    local w2 = twidth2 - 29/zoom + 102/zoom

    -- dxDrawImage(sx-270/zoom, 35/zoom + 14/zoom/2 + 160/zoom - 32/zoom, 169/zoom, 32/zoom, main['textures']['money_bg'])
    -- exports['iq-blur']:dxDrawBlur(sx-120/zoom - w, 35/zoom + 14/zoom/2 + 160/zoom - 32/zoom, w, 32/zoom)
    dxDrawRectangle(sx-120/zoom - w, 35/zoom + 14/zoom/2 + 160/zoom - 32/zoom, w, 32/zoom, tocolor(31, 31, 31, 203))
    -- exports['iq-blur']:dxDrawBlur(sx-120/zoom - w - 29/zoom, 35/zoom + 14/zoom/2 + 160/zoom - 32/zoom, 29/zoom, 32/zoom, main['textures']['rounded_mask'])
    dxDrawImage(sx-120/zoom - w - 29/zoom, 35/zoom + 14/zoom/2 + 160/zoom - 32/zoom, 29/zoom, 32/zoom, main['textures']['rounded'])
    dxDrawImage(sx-116/zoom - w - 29/zoom, 35/zoom + 14/zoom/2 + 160/zoom - 32/zoom + 32/zoom/2 - 24/zoom/2, 24/zoom, 24/zoom, main['textures']['money_icon'])
    dxDrawText(money, sx-85/zoom - w - 29/zoom, 35/zoom + 14/zoom/2 + 160/zoom - 32/zoom + 32/zoom/2 - 24/zoom/2 + 24/zoom/2, nil, nil, tocolor(238, 242, 239), 1, main['fonts'][1], 'left', 'center')

    -- exports['iq-blur']:dxDrawBlur(sx-120/zoom - w2, 5/zoom + 14/zoom/2 + 154/zoom - 32/zoom, w2, 32/zoom)
    dxDrawRectangle(sx-120/zoom - w2, 5/zoom + 14/zoom/2 + 154/zoom - 32/zoom, w2, 32/zoom, tocolor(31, 31, 31, 203))
    -- exports['iq-blur']:dxDrawBlur(sx-120/zoom - w2 - 29/zoom, 5/zoom + 14/zoom/2 + 154/zoom - 32/zoom, 29/zoom, 32/zoom, main['textures']['rounded_mask'])
    dxDrawImage(sx-120/zoom - w2 - 29/zoom, 5/zoom + 14/zoom/2 + 154/zoom - 32/zoom, 29/zoom, 32/zoom, main['textures']['rounded'])
    dxDrawImage(sx-116/zoom - w2 - 29/zoom, 5/zoom + 14/zoom/2 + 154/zoom - 32/zoom + 32/zoom/2 - 24/zoom/2, 24/zoom, 24/zoom, main['textures']['nick_icon'])
    dxDrawText(nick, sx-85/zoom - w2 - 29/zoom, 5/zoom + 14/zoom/2 + 154/zoom - 32/zoom + 32/zoom/2 - 24/zoom/2 + 24/zoom/2, nil, nil, tocolor(238, 242, 239), 1, main['fonts'][1], 'left', 'center')

    -- exports['iq-blur']:dxDrawBlur(sx-163/zoom - 32/zoom, 35/zoom + 14/zoom/2, 160/zoom, 160/zoom, main['textures']['mask'])
    dxDrawImage(sx-167/zoom - 32/zoom, 35/zoom + 14/zoom/2, 168/zoom, 168/zoom, main['textures']['avatar_bg'])
    dxDrawImage(sx-168/zoom - 35/zoom + 175/zoom/2 - 146/zoom/2, 35/zoom + 175/zoom/2 - 146/zoom/2, 146/zoom, 146/zoom, exports['since-avatars']:getPlayerCircleAvatar(getElementData(localPlayer, 'player:sid')))

    dxDrawImage(sx-101/zoom + 10/zoom, 30/zoom + 14/zoom/2 + 160/zoom - 32/zoom, 36/zoom, 36/zoom, main['textures']['circle'])
    local oxygen = getPedOxygenLevel(localPlayer) / 10
    dxDrawImageSection(sx-101/zoom + 10/zoom, 30/zoom + 14/zoom/2 + 160/zoom - 32/zoom, 36/zoom/100*oxygen, 36/zoom, 0, 0, 36/100*oxygen, 36, main['textures']['circle_filled'], 0, 0, 0, tocolor(127, 160, 190))
    dxDrawImage(sx-101/zoom + 10/zoom + 36/zoom/2 - 20/zoom/2, 30/zoom + 14/zoom/2 + 160/zoom - 32/zoom + 36/zoom/2 - 20/zoom/2, 20/zoom, 20/zoom, main['textures']['tlen'])

    local armor = getPedArmor(localPlayer)
    dxDrawImage(sx-63/zoom, 10/zoom + 4/zoom/2 + 144/zoom - 32/zoom, 36/zoom, 36/zoom, main['textures']['circle'])
    dxDrawImageSection(sx-63/zoom, 10/zoom + 4/zoom/2 + 144/zoom - 32/zoom, 36/zoom/100*armor, 36/zoom, 0, 0, 36/100*armor, 36, main['textures']['circle_filled'], 0, 0, 0, tocolor(186, 161, 74))
    dxDrawImage(sx-63/zoom + 36/zoom/2 - 20/zoom/2, 10/zoom + 4/zoom/2 + 144/zoom - 32/zoom + 36/zoom/2 - 20/zoom/2, 20/zoom, 20/zoom, main['textures']['armor'])
    
    local health = getElementHealth(localPlayer)
    dxDrawImage(sx-60/zoom, 10/zoom + 4/zoom/2 + 104/zoom - 32/zoom, 36/zoom, 36/zoom, main['textures']['circle'])
    dxDrawImageSection(sx-60/zoom, 10/zoom + 4/zoom/2 + 104/zoom - 32/zoom, 36/zoom/100*health, 36/zoom, 0, 0, 36/100*health, 36, main['textures']['circle_filled'], 0, 0, 0, tocolor(152, 42, 42))
    dxDrawImage(sx-60/zoom + 36/zoom/2 - 20/zoom/2, 10/zoom + 4/zoom/2 + 104/zoom - 32/zoom + 36/zoom/2 - 20/zoom/2, 20/zoom, 20/zoom, main['textures']['heart'])

    if (getElementData(localPlayer, 'player:admin')) then
        local r, g, b = unpack(exports['since-admins']:getRankRGB(getElementData(localPlayer, 'player:admin')))
        local rankName = exports['since-admins']:getRankName(getElementData(localPlayer, 'player:admin'))
        local firstLetter = string.sub(rankName, 1, 1)

        dxDrawImage(sx-90/zoom, 10/zoom + 4/zoom/2 + 90/zoom - 60/zoom, 46/zoom, 46/zoom, main['textures']['rank-icon'], 0, 0, 0, tocolor(r, g, b))
        dxDrawText(firstLetter, sx-90/zoom + 44/zoom/2 + 4/zoom, 10/zoom + 4/zoom/2 + 90/zoom - 60/zoom + 46/zoom/2, nil, nil, white, 1, main['fonts'][2], 'center', 'center')
    end

    local weapon = getPedWeapon(localPlayer)
    if (weapon ~= 0 and main['textures'][weapon]) then
        local width, height = dxGetMaterialSize(main['textures'][weapon])
        local mag = getPedAmmoInClip(localPlayer, getPedWeaponSlot(localPlayer))
        local all = getPedTotalAmmo(localPlayer) - mag
        width, height = width/zoom, height/zoom
        -- exports['f-blur']:dxDrawBlur(sx - 194/zoom, 30/zoom, 164/zoom, 164/zoom, main['textures']['avatar_blur_mask'])
        -- dxDrawImage(sx - 194/zoom, 30/zoom, 164/zoom, 164/zoom, main['textures']['avatar_mask'])
        dxDrawImage(sx-163/zoom - 32/zoom-width/2.4/2+width/3, 120/zoom-height/2.4/2,width/2.4, height/2.4, main['textures'][weapon])
    end
end)
--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

--[[if getElementData(localPlayer, "player:sid") == 25 or getElementData(localPlayer, "player:sid") == 1 or getElementData(localPlayer, "player:sid") == 8029 or getElementData(localPlayer, "player:sid") == 8219 or getElementData(localPlayer, "player:sid") == 9264 or getElementData(localPlayer, "player:sid") == 8096 or getElementData(localPlayer, "player:sid") == 7877 then

else
    return false
end]]

--[[if getElementData(localPlayer, "player:sid") == 25 or getElementData(localPlayer, "player:sid") == 5837 then

else
    return false
end]]

local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

local temptextures = {
    [15] = dxCreateTexture("files/coin_black.png","argb",false,"clamp"),
    [16] = dxCreateTexture("files/coin_green.png","argb",false,"clamp"),
    [17] = dxCreateTexture("files/coin_red.png","argb",false,"clamp"),
    [18] = dxCreateTexture("files/coin_black_dark.png","argb",false,"clamp"),
    [19] = dxCreateTexture("files/coin_green_dark.png","argb",false,"clamp"),
    [20] = dxCreateTexture("files/coin_red_dark.png","argb",false,"clamp"),
    [21] = dxCreateTexture("files/avatar.png","argb",false,"clamp"),
}

--[[
    LIMITY
]]

local LIMIT = 1000000
local LIMIT_PP = 5000000

textures = {}

local alpha_main, alpha_roulette, alpha_coinflip, alpha_slots, alpha_mines, alpha_crash = 255, 255, 255, 255, 255, 255

local x_line, width_line = 150, 120

local state = "coinflip"

local renderTarget = dxCreateRenderTarget(1630/zoom, 179/zoom, true)

local x_los = 0

function preRender()
    dxSetRenderTarget(renderTarget, true)
        dxSetBlendMode("blend")
        for i=1,150 do
            if random_textures then
                if random_textures[i] then
                    dxDrawImage(0 + ((i-1)*133/zoom) + x_los/zoom, 20, 133/zoom, 133/zoom, temptextures[random_textures[i][1]], 0, 0, 0, tocolor(255, 255, 255), false)
                    dxDrawImage(0 + ((i-1)*133/zoom) + x_los/zoom, 20, 133/zoom, 133/zoom, temptextures[random_textures[i][1]+3], 0, 0, 0, tocolor(150, 150, 150, random_textures[i].alpha), false)
                end
            end
        end
    dxSetRenderTarget()
end

local alpha_losowanieza, alpha_pointer = 255, 0

local stats_up, players_stats = {0,0,0}, {["red"] = {total=0}, ["green"] = {total=0}, ["black"] = {total=0}}

local strona = false

local cflip_options = {
    {"WYCZYŚĆ", "+10.000", "+100.000", "1/2", "X2", "STWÓRZ"}
}

local cflip_games, mygames = {}, {}

local rot_coin, d1, d2 = 90, 0, "red"

function render() 
    dxDrawImage(0, 0, sx, sy, textures[1], 0, 0, 0, tocolor(255, 255, 255, alpha_main), false)
    dxDrawImage(40/zoom, 10/zoom, 58/zoom, 77/zoom, textures[2], 0, 0, 0, tocolor(255, 255, 255, alpha_main), false)


    if state == "roulette" then
        dxDrawImage(150/zoom, 35/zoom, 26/zoom, 26/zoom, textures[3], 0, 0, 0, tocolor(46, 117, 111, alpha_main), false)    
        dxDrawText("Roulette", 190/zoom, 50/zoom, left, center, tocolor(205, 205, 205, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    else
        dxDrawImage(150/zoom, 35/zoom, 26/zoom, 26/zoom, textures[3], 0, 0, 0, tocolor(152, 151, 152, alpha_main), false)    
        dxDrawText("Roulette", 190/zoom, 50/zoom, left, center, tocolor(182, 182, 182, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    end

    if state == "coinflip" then
        dxDrawImage(320/zoom, 35/zoom, 26/zoom, 26/zoom, textures[4], 0, 0, 0, tocolor(46, 117, 111, alpha_main), false)
        dxDrawText("Coinflip", 360/zoom, 50/zoom, left, center, tocolor(212, 212, 212, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    else
        dxDrawImage(320/zoom, 35/zoom, 26/zoom, 26/zoom, textures[4], 0, 0, 0, tocolor(152, 151, 152, alpha_main), false)
        dxDrawText("Coinflip", 360/zoom, 50/zoom, left, center, tocolor(182, 182, 182, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    end

    if state == "slots" then
        dxDrawImage(490/zoom, 35/zoom, 26/zoom, 26/zoom, textures[40], 0, 0, 0, tocolor(46, 117, 111, alpha_main), false)
        dxDrawText("Slots", 530/zoom, 50/zoom, left, center, tocolor(212, 212, 212, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    else
        dxDrawImage(490/zoom, 35/zoom, 26/zoom, 26/zoom, textures[40], 0, 0, 0, tocolor(152, 151, 152, alpha_main), false)
        dxDrawText("Slots", 530/zoom, 50/zoom, left, center, tocolor(182, 182, 182, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    end

    if state == "mines" then
        dxDrawImage(620/zoom, 35/zoom, 26/zoom, 26/zoom, textures[39], 0, 0, 0, tocolor(46, 117, 111, alpha_main), false)
        dxDrawText("Mines", 660/zoom, 50/zoom, left, center, tocolor(212, 212, 212, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    else
        dxDrawImage(620/zoom, 35/zoom, 26/zoom, 26/zoom, textures[39], 0, 0, 0, tocolor(152, 151, 152, alpha_main), false)
        dxDrawText("Mines", 660/zoom, 50/zoom, left, center, tocolor(182, 182, 182, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    end

    if state == "crash" then
        dxDrawImage(750/zoom, 35/zoom, 26/zoom, 26/zoom, textures[41], 0, 0, 0, tocolor(46, 117, 111, alpha_main), false)
        dxDrawText("Crash", 790/zoom, 50/zoom, left, center, tocolor(212, 212, 212, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    else
        dxDrawImage(750/zoom, 35/zoom, 26/zoom, 26/zoom, textures[41], 0, 0, 0, tocolor(152, 151, 152, alpha_main), false)
        dxDrawText("Crash", 790/zoom, 50/zoom, left, center, tocolor(182, 182, 182, alpha_main), 1, fonts[1], "left", "center", false, false, false, false)
    end

    dxDrawRectangle(x_line/zoom, 94/zoom, width_line/zoom, 3/zoom, tocolor(46, 117, 111, alpha_main), false)

    if state == "roulette" then
        dxDrawImage(sx/2 - 1704/zoom/2, sy/2 - 400/zoom, 1705/zoom, 179/zoom, textures[5], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 - 1630/zoom/2, sy/2 - 400/zoom, 1630/zoom, 179/zoom, renderTarget, 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        --dxDrawImageSection(sx/2 - 1630/zoom/2, sy/2 - 400/zoom, 1630/zoom, 179/zoom, 0/zoom, 0/zoom, 1630/zoom, 179/zoom, renderTarget, tocolor(255, 255, 255, alpha_roulette))

        dxDrawImage(sx/2 - 5/zoom/2, sy/2 - 400/zoom, 5/zoom, 178/zoom, textures[22], 0, 0, 0, tocolor(255, 255, 255, alpha_pointer), false)

        dxDrawText("P O P R Z E D N I E  W Y G R A N E", sx/2, sy/2 - 180/zoom, center, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "center", "center", false, false, false, false)

        --[[dxDrawImage(sx/2 + 160/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 + 120/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 + 80/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 + 40/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)

        dxDrawImage(sx/2 - 40/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 - 80/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 - 120/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 - 160/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 - 200/zoom, sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)]]

        if last_wins then
            for i,v in ipairs(last_wins) do
                dxDrawImage(sx/2 - 200/zoom + ((i-1)*40/zoom), sy/2 - 160/zoom, 43/zoom, 43/zoom, textures[v], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
            end
        end


        dxDrawRectangle((sx/2 - 354/zoom/2) - 385/zoom, sy/2 - 140/zoom, 354/zoom, 4/zoom, tocolor(49, 49, 49, alpha_roulette))
        dxDrawRectangle((sx/2 - 354/zoom/2) + 385/zoom, sy/2 - 140/zoom, 354/zoom, 4/zoom, tocolor(49, 49, 49, alpha_roulette))

        dxDrawImage(sx/2 - 560/zoom, sy/2 - 175/zoom, 28/zoom, 28/zoom, textures[23], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawText(kropki(getElementData(localPlayer, "client:coin") or 0), sx/2 - 520/zoom, sy/2 - 158/zoom, left, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[1], "left", "center", false, false, false, false)

        dxDrawImage(sx/2 - 1158/zoom/2, sy/2 - 80/zoom, 1158/zoom, 63/zoom, textures[9], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)

        dxDrawImage(sx/2 - 1158/zoom/2, sy/2, 354/zoom, 123/zoom, textures[10], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 - 354/zoom/2, sy/2, 354/zoom, 123/zoom, textures[10], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 + 225/zoom, sy/2, 354/zoom, 123/zoom, textures[10], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)

        if isMouseIn(sx/2 - 584/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom) then
            dxDrawImage(sx/2 - 584/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom, textures[13], 0, 0, 0, tocolor(184, 67, 58, alpha_roulette), false)
        else
            dxDrawImage(sx/2 - 584/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom, textures[12], 0, 0, 0, tocolor(184, 67, 58, alpha_roulette), false)
        end

        if isMouseIn(sx/2 - 182/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom) then
            dxDrawImage(sx/2 - 182/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom, textures[13], 0, 0, 0, tocolor(6, 166, 68, alpha_roulette), false)
        else
            dxDrawImage(sx/2 - 182/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom, textures[12], 0, 0, 0, tocolor(6, 166, 68, alpha_roulette), false)
        end

        if isMouseIn(sx/2 + 220/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom) then
            dxDrawImage(sx/2 + 220/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom, textures[13], 0, 0, 0, tocolor(45, 48, 55, alpha_roulette), false)
        else
            dxDrawImage(sx/2 + 220/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom, textures[12], 0, 0, 0, tocolor(45, 48, 55, alpha_roulette), false)
        end

        dxDrawImage(sx/2 - 1158/zoom/2, sy/2 + 150/zoom, 354/zoom, 361, textures[11], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 - 354/zoom/2, sy/2 + 150/zoom, 354/zoom, 361, textures[11], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 + 225/zoom, sy/2 + 150/zoom, 354/zoom, 361, textures[11], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)

        dxDrawText("Wygrana x2", sx/2 - 228/zoom, sy/2 + 18/zoom, right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, false)
        dxDrawText("Wygrana x14", sx/2 + 172/zoom, sy/2 + 18/zoom, right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, false)
        dxDrawText("Wygrana x2", sx/2 + 572/zoom, sy/2 + 18/zoom, right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, false)

        dxDrawImage(sx/2 - 548/zoom, sy/2 + 10/zoom, 43/zoom, 43/zoom, textures[8], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 - 150/zoom, sy/2 + 10/zoom, 43/zoom, 43/zoom, textures[7], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        dxDrawImage(sx/2 + 250/zoom, sy/2 + 10/zoom, 43/zoom, 43/zoom, textures[6], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)

        dxDrawText("Postaw kwotę", sx/2, sy/2 + 98/zoom, center, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "center", "center", false, false, false, false)
        dxDrawText("Postaw kwotę", sx/2 - 402/zoom, sy/2 + 98/zoom, center, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "center", "center", false, false, false, false)
        dxDrawText("Postaw kwotę", sx/2 + 402/zoom, sy/2 + 98/zoom, center, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "center", "center", false, false, false, false)

        for i,v in ipairs(stats_up) do
            dxDrawText(kropki(v), sx/2 - 500/zoom + ((i-1)*400/zoom), sy/2 + 32/zoom, left, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[1], "left", "center", false, false, false, true)
            --dxDrawText(v.green, sx/2 - 500/zoom + ((i-1)*400/zoom), sy/2 + 32/zoom, left, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[1], "left", "center", false, false, false, true)
            --dxDrawText(v.black, sx/2 - 500/zoom + ((i-1)*400/zoom), sy/2 + 32/zoom, left, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[1], "left", "center", false, false, false, true)
        end

        dxDrawText(#players_stats["red"].." Zakładów", sx/2 - 560/zoom, sy/2 + 170/zoom, left, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "left", "center", false, false, false, false)
        dxDrawText(#players_stats["green"].." Zakładów", sx/2 - 158/zoom, sy/2 + 170/zoom, left, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "left", "center", false, false, false, false)
        dxDrawText(#players_stats["black"].." Zakładów", sx/2 + 244/zoom, sy/2 + 170/zoom, left, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "left", "center", false, false, false, false)

        dxDrawText(kropki(players_stats["red"].total), sx/2 - 230/zoom, sy/2 + 170/zoom, right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, true)
        local width = dxGetTextWidth(kropki(players_stats["red"].total), 1, fonts[2], true)
        dxDrawImage(sx/2 - 255/zoom - width, sy/2 + 158/zoom, 20/zoom, 20/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)

        dxDrawText(kropki(players_stats["green"].total), sx/2 + 172/zoom, sy/2 + 170/zoom, right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, true)
        local width = dxGetTextWidth(kropki(players_stats["green"].total), 1, fonts[2], true)
        dxDrawImage(sx/2 + 147/zoom - width, sy/2 + 158/zoom, 20/zoom, 20/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)

        dxDrawText(kropki(players_stats["black"].total), sx/2 + 574/zoom, sy/2 + 170/zoom, right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, true)
        local width = dxGetTextWidth(kropki(players_stats["black"].total), 1, fonts[2], true)
        dxDrawImage(sx/2 + 549/zoom - width, sy/2 + 158/zoom, 20/zoom, 20/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)

        for i=1,7 do
            if players_stats["red"][i] then
                local v = players_stats["red"][i]
                dxDrawText(v[1], sx/2 - 520/zoom, sy/2 + 215/zoom + ((i-1)*45/zoom), left, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "left", "center", false, false, false, true)
                dxDrawText(kropki(v[2]), sx/2 - 230/zoom, sy/2 + 215/zoom + ((i-1)*45/zoom), right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, true)
                local width = dxGetTextWidth(kropki(v[2]), 1, fonts[2], true)
                dxDrawImage(sx/2 - 255/zoom - width, sy/2 + 203/zoom + ((i-1)*45/zoom), 20/zoom, 20/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                if v[3] then
                    dxDrawImage(sx/2 - 560/zoom, sy/2 + 200/zoom + ((i-1)*45/zoom), 29/zoom, 29/zoom, v[3], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                else
                    dxDrawImage(sx/2 - 560/zoom, sy/2 + 200/zoom + ((i-1)*45/zoom), 29/zoom, 29/zoom, temptextures[21], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                end
            end
        end

        --[[for i,v in ipairs(players_stats["red"]) do
            dxDrawText(v[1], sx/2 - 520/zoom, sy/2 + 215/zoom + ((i-1)*45/zoom), left, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "left", "center", false, false, false, true)
            dxDrawText(kropki(v[2]), sx/2 - 230/zoom, sy/2 + 215/zoom + ((i-1)*45/zoom), right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, true)
            local width = dxGetTextWidth(kropki(v[2]), 1, fonts[2], true)
            dxDrawImage(sx/2 - 255/zoom - width, sy/2 + 203/zoom + ((i-1)*45/zoom), 20/zoom, 20/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
            if v[3] then

            else
                dxDrawImage(sx/2 - 560/zoom, sy/2 + 200/zoom + ((i-1)*45/zoom), 29/zoom, 29/zoom, textures[24], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
            end
        end]]

        for i=1,7 do
            if players_stats["green"][i] then
                local v = players_stats["green"][i]
                dxDrawText(v[1], sx/2 - 118/zoom, sy/2 + 215/zoom + ((i-1)*45/zoom), left, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "left", "center", false, false, false, true)
                dxDrawText(kropki(v[2]), sx/2 + 172/zoom, sy/2 + 215/zoom + ((i-1)*45/zoom), right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, true)
                local width = dxGetTextWidth(kropki(v[2]), 1, fonts[2], true)
                dxDrawImage(sx/2 + 147/zoom - width, sy/2 + 203/zoom + ((i-1)*45/zoom), 20/zoom, 20/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                if v[3] then
                    dxDrawImage(sx/2 - 158/zoom, sy/2 + 200/zoom + ((i-1)*45/zoom), 29/zoom, 29/zoom, v[3], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                else
                    dxDrawImage(sx/2 - 158/zoom, sy/2 + 200/zoom + ((i-1)*45/zoom), 29/zoom, 29/zoom, temptextures[21], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                end
            end
        end

        for i=1,7 do
            if players_stats["black"][i] then
                local v = players_stats["black"][i]
                dxDrawText(v[1], sx/2 + 284/zoom, sy/2 + 215/zoom + ((i-1)*45/zoom), left, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "left", "center", false, false, false, true)
                dxDrawText(kropki(v[2]), sx/2 + 574/zoom, sy/2 + 215/zoom + ((i-1)*45/zoom), right, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[2], "right", "center", false, false, false, true)
                local width = dxGetTextWidth(kropki(v[2]), 1, fonts[2], true)
                dxDrawImage(sx/2 + 549/zoom - width, sy/2 + 203/zoom + ((i-1)*45/zoom), 20/zoom, 20/zoom, textures[25], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                if v[3] then
                    dxDrawImage(sx/2 + 244/zoom, sy/2 + 200/zoom + ((i-1)*45/zoom), 29/zoom, 29/zoom, v[3], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                else
                    dxDrawImage(sx/2 + 244/zoom, sy/2 + 200/zoom + ((i-1)*45/zoom), 29/zoom, 29/zoom, temptextures[21], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
                end
            end
        end

        local time = (15000 - (getTickCount() - start_tick))/1000
        if time < 10 and time > 0 then
            dxDrawText("LOSOWANIE ZA\n#ff8c000"..string.format("%.2f", time), sx/2, sy/2 - 305/zoom, center, center, tocolor(255, 255, 255, alpha_losowanieza), 1, fonts[3], "center", "center", false, false, false, true)
        elseif time <= 0.000 then
            dxDrawText("LOSOWANIE ZA\n#ff8c0000.00", sx/2, sy/2 - 305/zoom, center, center, tocolor(255, 255, 255, alpha_losowanieza), 1, fonts[3], "center", "center", false, false, false, true)
        elseif time > 9 then
            --dxDrawText(string.format("%.2f", time), sx/2, sy/2, center, center, tocolor(212, 212, 212, alpha_roulette), 1, fonts[1], "center", "center", false, false, false, false)
            dxDrawText("LOSOWANIE ZA\n#ff8c00"..string.format("%.2f", time), sx/2, sy/2 - 305/zoom, center, center, tocolor(255, 255, 255, alpha_losowanieza), 1, fonts[3], "center", "center", false, false, false, true)
        end

        for i=1,6 do
            dxDrawImage(sx/2 - 90/zoom + ((i-1)*110/zoom), sy/2 - 75/zoom, 110/zoom, 50/zoom, textures[21], 0, 0, 0, tocolor(255, 255, 255, alpha_roulette), false)
        end

        dxDrawText("WYCZYŚĆ", sx/2 - 35/zoom, sy/2 - 47/zoom, center, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[4], "center", "center", false, false, false, false)
        dxDrawText("+10.000", sx/2 + 75/zoom, sy/2 - 47/zoom, center, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[4], "center", "center", false, false, false, false)
        dxDrawText("+100.000", sx/2 + 185/zoom, sy/2 - 47/zoom, center, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[4], "center", "center", false, false, false, false)
        dxDrawText("1/2", sx/2 + 295/zoom, sy/2 - 47/zoom, center, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[4], "center", "center", false, false, false, false)
        dxDrawText("X2", sx/2 + 405/zoom, sy/2 - 47/zoom, center, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[4], "center", "center", false, false, false, false)
        dxDrawText("MAKS", sx/2 + 515/zoom, sy/2 - 47/zoom, center, center, tocolor(255, 255, 255, alpha_roulette), 1, fonts[4], "center", "center", false, false, false, false)

        exports["since-casinoeditbox"]:editboxSetAlpha("insert_coin", alpha_roulette)

    elseif state == "coinflip" then
        dxDrawImage(sx/2 - 1158/zoom/2, sy/2 - 375/zoom, 28/zoom, 28/zoom, textures[23], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
        dxDrawText(kropki(getElementData(localPlayer, "client:coin") or 0), sx/2 - 540/zoom, sy/2 - 358/zoom, left, center, tocolor(255, 255, 255, alpha_coinflip), 1, fonts[1], "left", "center", false, false, false, false)

        dxDrawImage(sx/2 - 1158/zoom/2, sy/2 - 330/zoom, 1158/zoom, 63/zoom, textures[9], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

        dxDrawText("Wybierz stronę", sx/2 - 190/zoom, sy/2 - 315/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[4], "center", "center", false, false, false, false)

        if strona == "red" then
            dxDrawImage(sx/2 - 223/zoom, sy/2 - 300/zoom, 27/zoom, 27/zoom, textures[30], 0, 0, 0, tocolor(150, 150, 150, alpha_coinflip), false)
            dxDrawImage(sx/2 - 183/zoom, sy/2 - 300/zoom, 27/zoom, 27/zoom, textures[31], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
        elseif strona == "black" then
            dxDrawImage(sx/2 - 223/zoom, sy/2 - 300/zoom, 27/zoom, 27/zoom, textures[30], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
            dxDrawImage(sx/2 - 183/zoom, sy/2 - 300/zoom, 27/zoom, 27/zoom, textures[31], 0, 0, 0, tocolor(150, 150, 150, alpha_coinflip), false)
        else
            dxDrawImage(sx/2 - 223/zoom, sy/2 - 300/zoom, 27/zoom, 27/zoom, textures[30], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
            dxDrawImage(sx/2 - 183/zoom, sy/2 - 300/zoom, 27/zoom, 27/zoom, textures[31], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
        end

        for i=1,6 do
            if i == 6 then
                dxDrawImage(sx/2 - 90/zoom + ((i-1)*110/zoom), sy/2 - 325/zoom, 110/zoom, 50/zoom, textures[32], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
            else
                dxDrawImage(sx/2 - 90/zoom + ((i-1)*110/zoom), sy/2 - 325/zoom, 110/zoom, 50/zoom, textures[21], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
            end

            dxDrawText(cflip_options[1][i], sx/2 - 35/zoom + ((i-1)*110/zoom), sy/2 - 300/zoom, center, center, tocolor(255, 255, 255, alpha_coinflip), 1, fonts[4], "center", "center", false, false, false, false)
        end

        dxDrawText("T W O J E  G R Y", 50/zoom, sy/2 - 220/zoom, left, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[2], "left", "center", false, false, false, false)
        dxDrawText("D O S T Ę P N E  G R Y", sx/2 - 485/zoom, sy/2 - 220/zoom, left, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[2], "left", "center", false, false, false, false)
        dxDrawImage(50/zoom, sy/2 - 694/zoom/2 + 150/zoom, 386/zoom, 694/zoom, textures[26], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
        dxDrawImage(sx/2 - 485/zoom, sy/2 - 694/zoom/2 + 150/zoom, 1000/zoom, 694/zoom, textures[27], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

        local count = 0
        local y = 0
        local x = 0
        for i=1,12 do
            if cflip_games then
                if cflip_games[i] then
                    local v = cflip_games[i]
                    count = count + 1
                    if count > 3 then
                        y = y + 160
                        x = x + 900
                        count = 1
                    end
                    dxDrawImage(sx/2 - 415/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 149/zoom + y/zoom, 258/zoom, 119/zoom, textures[28], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

                    dxDrawImage((sx/2 - 43/zoom) - 360/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 134/zoom + y/zoom, 87/zoom, 87/zoom, textures[29], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    dxDrawImage((sx/2 - 43/zoom) - 210/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 134/zoom + y/zoom, 87/zoom, 87/zoom, textures[29], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

                    if v[5] then
                        dxDrawImage((sx/2 - 43/zoom) - 335/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 130/zoom + y/zoom, 35/zoom, 36/zoom, v[5], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    else
                        dxDrawImage((sx/2 - 43/zoom) - 335/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 130/zoom + y/zoom, 35/zoom, 36/zoom, textures[33], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    end
                    --dxDrawImage((sx/2 - 43/zoom) - 335/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 134/zoom + y/zoom, 35/zoom, 36/zoom, textures[33], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

                    dxDrawText(v[2], (sx/2 - 43/zoom) - 318/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 83/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[4], "center", "center", false, false, false, false)

                    dxDrawImage((sx/2 - 29/zoom) - 360/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 70/zoom + y/zoom, 59/zoom, 21, textures[35], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    dxDrawImage((sx/2 - 29/zoom) - 210/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 70/zoom + y/zoom, 59/zoom, 21, textures[35], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    --dxDrawImage((sx/2 - 11) - 373/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 65/zoom + y/zoom, 11, 11, textures[36], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

                    if v[1] == "red" then
                        dxDrawImage((sx/2 - 43/zoom) - 370/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 140/zoom + y/zoom, 27/zoom, 27/zoom, textures[31], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                        dxDrawImage((sx/2 - 43/zoom) - 220/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 140/zoom + y/zoom, 27/zoom, 27/zoom, textures[30], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    else
                        dxDrawImage((sx/2 - 43/zoom) - 370/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 140/zoom + y/zoom, 27/zoom, 27/zoom, textures[30], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                        dxDrawImage((sx/2 - 43/zoom) - 220/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 140/zoom + y/zoom, 27/zoom, 27/zoom, textures[31], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    end

                    dxDrawImage((sx/2 - 67/zoom) - 177/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 110/zoom + y/zoom, 67/zoom, 31, textures[34], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    dxDrawText("Dołącz", (sx/2 - 43/zoom) - 167/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 93/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)

                    if string.len(v[3]) == 7 then
                        dxDrawText(string.sub(v[3], 1, 1).."kk", (sx/2 - 43/zoom) - 317/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 1).."kk", (sx/2 - 43/zoom) - 167/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    elseif string.len(v[3]) == 8 then
                        dxDrawText(string.sub(v[3], 1, 2).."kk", (sx/2 - 43/zoom) - 317/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 2).."kk", (sx/2 - 43/zoom) - 167/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    elseif string.len(v[3]) == 9 then
                        dxDrawText(string.sub(v[3], 1, 3).."kk", (sx/2 - 43/zoom) - 317/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 3).."kk", (sx/2 - 43/zoom) - 167/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    elseif string.len(v[3]) == 10 then
                        dxDrawText(string.sub(v[3], 1, 1).."kkk", (sx/2 - 43/zoom) - 317/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 1).."kkk", (sx/2 - 43/zoom) - 167/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    elseif string.len(v[3]) == 11 then
                        dxDrawText(string.sub(v[3], 1, 2).."kkk", (sx/2 - 43/zoom) - 317/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 2).."kkk", (sx/2 - 43/zoom) - 167/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    else
                        dxDrawText(v[3], (sx/2 - 43/zoom) - 317/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(v[3], (sx/2 - 43/zoom) - 167/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 58/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    end

                    dxDrawText("VS", sx/2 - 285/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 86/zoom + y/zoom, center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[5], "center", "center", false, false, false, false)
                end
            end
        end

        for i=1,5 do
            if mygames then
                if mygames[i] then
                    local v = mygames[i]
                    dxDrawImage(115/zoom, sy/2 - 149/zoom + ((i-1)*140/zoom), 258/zoom, 119/zoom, textures[28], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

                    dxDrawImage(130/zoom, sy/2 - 134/zoom + ((i-1)*140/zoom), 87/zoom, 87/zoom, textures[29], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    dxDrawImage(270/zoom, sy/2 - 134/zoom + ((i-1)*140/zoom), 87/zoom, 87/zoom, textures[29], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

                    if v[1] == "red" then
                        dxDrawImage(120/zoom, sy/2 - 140/zoom + ((i-1)*140/zoom), 27/zoom, 27/zoom, textures[31], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                        dxDrawImage(260/zoom, sy/2 - 140/zoom + ((i-1)*140/zoom), 27/zoom, 27/zoom, textures[30], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    else
                        dxDrawImage(120/zoom, sy/2 - 140/zoom + ((i-1)*140/zoom), 27/zoom, 27/zoom, textures[30], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                        dxDrawImage(260/zoom, sy/2 - 140/zoom + ((i-1)*140/zoom), 27/zoom, 27/zoom, textures[31], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    end

                    dxDrawImage(144/zoom, sy/2 - 70/zoom + ((i-1)*140/zoom), 59/zoom, 21, textures[35], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    dxDrawImage(144/zoom, sy/2 - 70/zoom + ((i-1)*140/zoom), 59/zoom, 21, textures[35], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

                    dxDrawImage(285/zoom, sy/2 - 70/zoom + ((i-1)*140/zoom), 59/zoom, 21, textures[35], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    dxDrawImage(285/zoom, sy/2 - 70/zoom + ((i-1)*140/zoom), 59/zoom, 21, textures[35], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)

                    if v[5] then
                        dxDrawImage(158/zoom, sy/2 - 130/zoom + ((i-1)*140/zoom), 35/zoom, 36/zoom, v[5], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    else
                        dxDrawImage(158/zoom, sy/2 - 130/zoom + ((i-1)*140/zoom), 35/zoom, 36/zoom, textures[33], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    end

                    if myav then
                        dxDrawImage(298/zoom, sy/2 - 130/zoom + ((i-1)*140/zoom), 35/zoom, 36/zoom, myav, 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    else
                        dxDrawImage(298/zoom, sy/2 - 130/zoom + ((i-1)*140/zoom), 35/zoom, 36/zoom, textures[33], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    end

                    dxDrawText(v[2], 177/zoom, sy/2 - 83/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[4], "center", "center", false, false, false, false)
                    if myname then
                        dxDrawText(myname, 315/zoom, sy/2 - 83/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[4], "center", "center", false, false, false, false)
                    else
                        dxDrawText(getPlayerName(localPlayer):gsub("#%x%x%x%x%x%x", ""), 315/zoom, sy/2 - 83/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[4], "center", "center", false, false, false, false)
                    end
                
                    if string.len(v[3]) == 7 then
                        dxDrawText(string.sub(v[3], 1, 1).."kk", 315/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 1).."kk", 175/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    elseif string.len(v[3]) == 8 then
                        dxDrawText(string.sub(v[3], 1, 2).."kk", 315/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 2).."kk", 175/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    elseif string.len(v[3]) == 9 then
                        dxDrawText(string.sub(v[3], 1, 3).."kk", 315/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 3).."kk", 175/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    elseif string.len(v[3]) == 10 then
                        dxDrawText(string.sub(v[3], 1, 1).."kkk", 315/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 1).."kkk", 175/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    elseif string.len(v[3]) == 11 then
                        dxDrawText(string.sub(v[3], 1, 2).."kkk", 315/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(string.sub(v[3], 1, 2).."kkk", 175/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    else
                        dxDrawText(v[3], 315/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                        dxDrawText(v[3], 175/zoom, sy/2 - 58/zoom + ((i-1)*140/zoom), center, center, tocolor(212, 212, 212, alpha_coinflip), 1, fonts[6], "center", "center", false, false, false, false)
                    end

                    if v.win == "red" then
                        dxDrawImage(212/zoom, sy/2 - 125/zoom, 62/zoom, 62/zoom, textures[37], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    elseif v.win == "black" then
                        dxDrawImage(212/zoom, sy/2 - 125/zoom, 62/zoom, 62/zoom, textures[38], 0, 0, 0, tocolor(255, 255, 255, alpha_coinflip), false)
                    end
                end
            end
        end

        exports["since-casinoeditbox"]:editboxSetAlpha("insert_coin2", alpha_coinflip)

    elseif state == "slots" then
        renderSlotMachine(alpha_slots)
        
    elseif state == "mines" then
        renderMines(alpha_mines)

    elseif state == 'crash' then
        renderCrash(alpha_crash)

    end
end
start_tick = getTickCount()
start_tick = start_tick - getTickCount()

addEvent("enonek-casino:client:gameEnd", true)
addEventHandler("enonek-casino:client:gameEnd", resourceRoot, function(player, color)
    if not color then
            mygames = {}
            blocked = false
        return
    end

    for i,v in ipairs(mygames) do
        v.win = color
    end
    setTimer(function()
        mygames = {}
        blocked = false
    end, 1000, 1)
end)

addEvent("enonek-casino:client:startGame", true)
addEventHandler("enonek-casino:client:startGame", resourceRoot, function(strona, playername, bet, playerdata, targetdata)
    if targetdata then
        myname = getPlayerName(targetdata):gsub("#%x%x%x%x%x%x", "")
    end
    local sh = exports['since-avatars']:getPlayerCircleAvatar(getElementData(playerdata,'player:sid'))
    if targetdata then
        local sh2 = exports['since-avatars']:getPlayerCircleAvatar(getElementData(targetdata,'player:sid'))
        myav = sh2
    end
    table.insert(mygames, {strona, playername, bet, playerdata, sh})
    blocked = true
end)

addEvent("enonek-casino:client:addGame", true)
addEventHandler("enonek-casino:client:addGame", resourceRoot, function(strona, playername, bet, playerdata)
    local sh = exports['since-avatars']:getPlayerCircleAvatar(getElementData(playerdata,'player:sid'))
    table.insert(cflip_games, {strona, playername, bet, playerdata, sh})
end)

addEvent("enonek-casino:client:deleteGame", true)
addEventHandler("enonek-casino:client:deleteGame", resourceRoot, function(strona, player, bet)
    for i,v in ipairs(cflip_games) do
        if v[1] == strona and v[4] == player and v[3] == bet then
            table.remove(cflip_games, i)
        end
    end
end)

addEvent("enonek-casino:client:addBet", true)
addEventHandler("enonek-casino:client:addBet", resourceRoot, function(name, color, bet, player)
    --[[for i,v in ipairs(players_stats[color]) do
        if v[4] == player then
            return false
        end
    end]]

    if player == localPlayer then
        if color == "green" then
            stats_up[2] = bet
        elseif color == "red" then
            stats_up[1] = bet
        elseif color == "black" then
            stats_up[3] = bet
        end
    end

    local sh = exports['since-avatars']:getPlayerCircleAvatar(getElementData(player,'player:sid'))

    table.insert(players_stats[color], {name, bet, sh, player, nil})
    players_stats[color].total = players_stats[color].total + bet
end)

addEvent("enonek-casino:podsumowanie", true)
addEventHandler("enonek-casino:podsumowanie", resourceRoot, function(color)
    if color == "green" then
        for i,v in ipairs(players_stats["green"]) do
            v[2] = "#3e9820+"..kropki(tonumber(v[2])*14)
        end
        players_stats["green"].total = "#3e9820+"..kropki(tonumber(players_stats["green"].total)*14)

        for i,v in ipairs(players_stats["black"]) do
            v[2] = "#b92323-"..kropki(v[2])
        end
        players_stats["black"].total = "#b92323-"..kropki(players_stats["black"].total)

        for i,v in ipairs(players_stats["red"]) do
            v[2] = "#b92323-"..kropki(v[2])
        end
        players_stats["red"].total = "#b92323-"..kropki(players_stats["red"].total)

        stats_up[1] = "#b92323-"..kropki(stats_up[1])
        stats_up[2] = "#3e9820+"..kropki(tonumber(stats_up[2])*14)
        stats_up[3] = "#b92323-"..kropki(stats_up[3])
    else
        if color == "red" then
            for i,v in ipairs(players_stats["red"]) do
                v[2] = "#3e9820+"..kropki(tonumber(v[2])*2)
            end
            players_stats["red"].total = "#3e9820+"..kropki(tonumber(players_stats["red"].total)*2)

            for i,v in ipairs(players_stats["black"]) do
                v[2] = "#b92323-"..kropki(v[2])
            end
            players_stats["black"].total = "#b92323-"..kropki(players_stats["black"].total)
    
            for i,v in ipairs(players_stats["green"]) do
                v[2] = "#b92323-"..kropki(v[2])
            end
            players_stats["green"].total = "#b92323-"..kropki(players_stats["green"].total)

            stats_up[1] = "#3e9820+"..kropki(tonumber(stats_up[1])*2)
            stats_up[2] = "#b92323-"..kropki(stats_up[2])
            stats_up[3] = "#b92323-"..kropki(stats_up[3])
        else
            for i,v in ipairs(players_stats["black"]) do
                v[2] = "#3e9820+"..kropki(tonumber(v[2])*2)
            end
            players_stats["black"].total = "#3e9820+"..kropki(tonumber(players_stats["black"].total)*2)

            for i,v in ipairs(players_stats["red"]) do
                v[2] = "#b92323-"..kropki(v[2])
            end
            players_stats["red"].total = "#b92323-"..kropki(players_stats["red"].total)
    
            for i,v in ipairs(players_stats["green"]) do
                v[2] = "#b92323-"..kropki(v[2])
            end
            players_stats["green"].total = "#b92323-"..kropki(players_stats["green"].total)

            stats_up[1] = "#b92323-"..kropki(stats_up[1])
            stats_up[2] = "#b92323-"..kropki(stats_up[2])
            stats_up[3] = "#3e9820+"..kropki(tonumber(stats_up[3])*2)
        end
    end
end)

addEvent("enonek-casino:start", true)
addEventHandler("enonek-casino:start", resourceRoot, function(newINDEX, newTEX)
    x_los = 0
    if newTEX then
        random_textures = newTEX
    end

    if (isEventHandlerAdded("onClientRender", root, render)) then
        if not isEventHandlerAdded("onClientPreRender", root, preRender) then
            addEventHandler("onClientPreRender", root, preRender)
        end
    end

    for i=1,150 do
        animate(random_textures[i].alpha, 0, 3, 300, function(v) random_textures[i].alpha = v end)
    end
    index_textures = newINDEX
    index_textures = index_textures * -133 
    index_textures = index_textures - 20
    index_textures = index_textures + (7*133)
    --index_textures = 133
    animate(alpha_losowanieza, 0, 3, 300, function(v) alpha_losowanieza = v end)
    animate(alpha_pointer, 255, 3, 300, function(v) alpha_pointer = v end)
    setTimer(function()
        animate(x_los, index_textures, 3, 5000, function(v) x_los = v end)
    end, 500, 1)
end)

addEvent("enonek-casino:end", true)
addEventHandler("enonek-casino:end", resourceRoot, function(random_tex, newINDEX, tick, wins)
    random_textures = random_tex

    last_wins = wins

    for i=1,150 do
        animate(random_textures[i].alpha, 255, 3, 300, function(v) random_textures[i].alpha = v end)
    end

    start_tick = getTickCount()
    start_tick = start_tick - tick

    setTimer(function()
        if (isEventHandlerAdded("onClientPreRender", root, preRender)) then
            removeEventHandler("onClientPreRender", root, preRender)
        end
    end, 301, 1)

    animate(alpha_losowanieza, 255, 3, 300, function(v) alpha_losowanieza = v end)
    animate(alpha_pointer, 0, 3, 300, function(v) alpha_pointer = v end)

    stats_up, players_stats = {0,0,0}, {["red"] = {total=0}, ["green"] = {total=0}, ["black"] = {total=0}}
end)

addEvent("enonek-casino:toggleUI", true)
addEventHandler("enonek-casino:toggleUI", resourceRoot, function(st, tick)
    if st then
        if tick then
            start_tick = getTickCount()
            start_tick = start_tick - tick
        end
        fonts = {
            [1] = exports['since-fonts']:getFont('Inter-Medium', 17/zoom),
            [2] = exports['since-fonts']:getFont('Inter-Regular', 13/zoom),
            [3] = exports['since-fonts']:getFont('Inter-SemiBold', 22/zoom),
            [4] = exports['since-fonts']:getFont('Inter-Medium', 12/zoom),
            [5] = exports['since-fonts']:getFont('Inter-SemiBold', 25/zoom),
            [6] = exports['since-fonts']:getFont('Inter-Medium', 11/zoom),
        }
        textures = {
            [1] = dxCreateTexture("files/bg.png","argb",false,"clamp"),
            [2] = dxCreateTexture("files/logo.png","argb",false,"clamp"),
            [3] = dxCreateTexture("files/icon_roulette.png","argb",false,"clamp"),
            [4] = dxCreateTexture("files/icon_coinflip.png","argb",false,"clamp"),
            [5] = dxCreateTexture("files/bg2.png","argb",false,"clamp"),
        
            [6] = dxCreateTexture("files/coin_black_small.png","argb",false,"clamp"),
            [7] = dxCreateTexture("files/coin_green_small.png","argb",false,"clamp"),
            [8] = dxCreateTexture("files/coin_red_small.png","argb",false,"clamp"),
            [9] = dxCreateTexture("files/bg3.png","argb",false,"clamp"),
            [10] = dxCreateTexture("files/bg4.png","argb",false,"clamp"),
            [11] = dxCreateTexture("files/bg5.png","argb",false,"clamp"),
        
            [12] = dxCreateTexture("files/button.png","argb",false,"clamp"),
            [13] = dxCreateTexture("files/button_l.png","argb",false,"clamp"),
            [14] = dxCreateTexture("files/button_red.png","argb",false,"clamp"),
        
            [15] = false,
            [16] = false,
            [17] = false,
            [18] = false,
            [19] = false,
            [20] = false,
        
            [21] = dxCreateTexture("files/button_zaklad.png","argb",false,"clamp"),
        
            [22] = dxCreateTexture("files/pointer.png","argb",false,"clamp"),
            
            [23] = dxCreateTexture("files/icon_mycoins.png","argb",false,"clamp"),
        
            [24] = false,
        
            [25] = dxCreateTexture("files/coin_small.png","argb",false,"clamp"),
        
            [26] = dxCreateTexture("files/cflip_bg1.png","argb",false,"clamp"),
            [27] = dxCreateTexture("files/cflip_bg2.png","argb",false,"clamp"),
            [28] = dxCreateTexture("files/cflip_game.png","argb",false,"clamp"),
            [29] = dxCreateTexture("files/cflip_game2.png","argb",false,"clamp"),
            [30] = dxCreateTexture("files/cflip_cblack.png","argb",false,"clamp"),
            [31] = dxCreateTexture("files/cflip_cred.png","argb",false,"clamp"),
            [32] = dxCreateTexture("files/cflip_button.png","argb",false,"clamp"),
            [33] = dxCreateTexture("files/cflip_avatar.png","argb",false,"clamp"),
            [34] = dxCreateTexture("files/cflip_button2.png","argb",false,"clamp"),
            [35] = dxCreateTexture("files/cflip_price.png","argb",false,"clamp"),
            [36] = dxCreateTexture("files/cflip_iprice.png","argb",false,"clamp"),
            [37] = dxCreateTexture("files/cflip_rcoin.png","argb",false,"clamp"),
            [38] = dxCreateTexture("files/cflip_bcoin.png","argb",false,"clamp"),
            [39] = dxCreateTexture("files/icon_bombs.png","argb",false,"clamp"),
            [40] = dxCreateTexture("files/icon_slots.png","argb",false,"clamp"),
            [41] = dxCreateTexture("files/crash.png","argb",false,"clamp"), 

            [42] = dxCreateTexture("files/crash/arrow.png","argb",false,"clamp"), 
            [43] = dxCreateTexture("files/crash/autocashoutButton.png","argb",false,"clamp"), 
            [44] = dxCreateTexture("files/crash/bar.png","argb",false,"clamp"), 
            [45] = dxCreateTexture("files/crash/betIcon.png","argb",false,"clamp"), 
            [46] = dxCreateTexture("files/crash/bg1.png","argb",false,"clamp"), 
            [47] = dxCreateTexture("files/crash/bg2.png","argb",false,"clamp"), 
            [48] = dxCreateTexture("files/crash/bg3.png","argb",false,"clamp"), 
            [49] = dxCreateTexture("files/crash/bg4.png","argb",false,"clamp"), 
            [50] = dxCreateTexture("files/crash/bg4bar.png","argb",false,"clamp"), 
            [51] = dxCreateTexture("files/crash/button.png","argb",false,"clamp"), 
            [52] = dxCreateTexture("files/crash/cashIcon.png","argb",false,"clamp"), 
            [53] = dxCreateTexture("files/crash/chart.png","argb",false,"clamp"), 
            [54] = dxCreateTexture("files/crash/crashedCircle.png","argb",false,"clamp"), 
            [55] = dxCreateTexture("files/crash/crashedIcon.png","argb",false,"clamp"), 
            [56] = dxCreateTexture("files/crash/editbox.png","argb",false,"clamp"), 
            [57] = dxCreateTexture("files/crash/optionsButton.png","argb",false,"clamp"), 
            [58] = dxCreateTexture("files/crash/playerIcon.png","argb",false,"clamp"), 
            [59] = dxCreateTexture("files/crash/winIcon.png","argb",false,"clamp"),
            [60] = dxCreateTexture("files/crash/lastBar.png","argb",false,"clamp"),

        }
        if not isEventHandlerAdded("onClientRender", root, render) then
            addEventHandler("onClientRender", root, render)
        end
        addEventHandler("onClientClick", getRootElement(), onClick)
        showChat(false)
        setElementData(localPlayer, "ogloszenia:off", true)
        alpha_main, alpha_roulette, alpha_coinflip, alpha_crash = 0, 0, 0, 0
        x_line, width_line = 150, 120
        state = "roulette"
        animate(alpha_main, 255, 3, 300, function(v) alpha_main = v end)
        animate(alpha_roulette, 255, 3, 300, function(v) alpha_roulette = v end)
        exports["since-casinoeditbox"]:createEditbox("insert_coin", "Wpisz kwotę zakładu", sx/2 - 555/zoom, sy/2 - 30/zoom, 278/zoom, 50/zoom, 0, 6, false, 15)
        createSlots()
        createMines()
    else
        animate(alpha_main, 0, 3, 300, function(v) alpha_main = v end)
        animate(alpha_roulette, 0, 3, 300, function(v) alpha_roulette = v end)
        animate(alpha_coinflip, 0, 3, 300, function(v) alpha_coinflip = v end)
        animate(alpha_slots, 0, 3, 300, function(v) alpha_slots = v end)
        animate(alpha_mines, 0, 3, 300, function(v) alpha_mines = v end)
        animate(alpha_crash, 0, 3, 300, function(v) alpha_crash = v end)
        toggleCrash(false)
        removeEventHandler("onClientClick", getRootElement(), onClick)
        setTimer(function()
            removeEventHandler("onClientRender", root, render)
            exports["since-casinoeditbox"]:destroyEditbox("insert_coin")
            exports["since-casinoeditbox"]:destroyEditbox("insert_coin2")
            showChat(true)
            setElementData(localPlayer, "ogloszenia:off", false)
            for i,v in ipairs(textures) do
                if isElement(v) then
                    destroyElement(v)
                end
            end
            destroySlots()
            destroyMines()
            fonts = {}
            textures = {}
        end, 301, 1)
    end
end)

local click_tick = false

function onClick(b, s)
    if b == "left" and s == "down" then
        if click_tick then
            if getTickCount() - click_tick < 700 then
                return false
            end
        end

        if state == 'slots' and spinning then return end

        if isMouseIn(150/zoom, 25/zoom, 120/zoom, 46/zoom) and state ~= "roulette" then
            animate(x_line, 150, 3, 300, function(v) x_line = v end)
            animate(width_line, 120, 3, 300, function(v) width_line = v end)
            animate(alpha_coinflip, 0, 3, 300, function(v) alpha_coinflip = v end)
            animate(alpha_slots, 0, 3, 300, function(v) alpha_slots = v end)
            animate(alpha_mines, 0, 3, 300, function(v) alpha_mines = v end)
            toggleCrash(false)
            setTimer(function()
                exports["since-casinoeditbox"]:destroyEditbox("insert_coin2")
                exports["since-casinoeditbox"]:createEditbox("insert_coin", "Wpisz kwotę zakładu", sx/2 - 555/zoom, sy/2 - 30/zoom, 278/zoom, 50/zoom, 0, 6, false, 15)
                animate(alpha_roulette, 255, 3, 300, function(v) alpha_roulette = v end)
                state = "roulette"
            end, 301, 1)
            click_tick = getTickCount()

        elseif isMouseIn(320/zoom, 25/zoom, 115/zoom, 46/zoom) and state ~= "coinflip" then
            animate(x_line, 320, 3, 300, function(v) x_line = v end)
            animate(width_line, 115, 3, 300, function(v) width_line = v end)
            animate(alpha_roulette, 0, 3, 300, function(v) alpha_roulette = v end)
            animate(alpha_slots, 0, 3, 300, function(v) alpha_slots = v end)
            animate(alpha_mines, 0, 3, 300, function(v) alpha_mines = v end)
            animate(alpha_crash, 0, 3, 300, function(v) alpha_crash = v end)
            toggleCrash(false)
            setTimer(function()
                exports["since-casinoeditbox"]:destroyEditbox("insert_coin")
                exports["since-casinoeditbox"]:createEditbox("insert_coin2", "Wpisz kwotę zakładu", sx/2 - 555/zoom, sy/2 - 280/zoom, 278/zoom, 50/zoom, 0, 6, false, 15)
                animate(alpha_coinflip, 255, 3, 300, function(v) alpha_coinflip = v end)
                state = "coinflip"
            end, 301, 1)
            click_tick = getTickCount()

        elseif isMouseIn(490/zoom, 25/zoom, 115/zoom, 46/zoom) and state ~= "slots" then
            animate(x_line, 490, 3, 300, function(v) x_line = v end)
            animate(width_line, 110, 3, 300, function(v) width_line = v end)
            animate(alpha_roulette, 0, 3, 300, function(v) alpha_roulette = v end)
            animate(alpha_coinflip, 0, 3, 300, function(v) alpha_coinflip = v end)
            animate(alpha_mines, 0, 3, 300, function(v) alpha_mines = v end)
            animate(alpha_crash, 0, 3, 300, function(v) alpha_crash = v end)
            toggleCrash(false)
            setTimer(function()
                exports["since-casinoeditbox"]:destroyEditbox("insert_coin")
                -- exports["since-casinoeditbox"]:createEditbox("insert_coin2", "Wpisz kwotę zakładu", sx/2 - 555/zoom, sy/2 - 280/zoom, 278/zoom, 50/zoom, 0, 6, false, 15)
                animate(alpha_slots, 255, 3, 300, function(v) alpha_slots = v end)
                state = "slots"
            end, 301, 1)
            click_tick = getTickCount()

        elseif isMouseIn(620/zoom, 25/zoom, 115/zoom, 46/zoom) and state ~= "mines" then
            animate(x_line, 620, 3, 300, function(v) x_line = v end)
            animate(width_line, 105, 3, 300, function(v) width_line = v end)
            animate(alpha_roulette, 0, 3, 300, function(v) alpha_roulette = v end)
            animate(alpha_coinflip, 0, 3, 300, function(v) alpha_coinflip = v end)
            animate(alpha_slots, 0, 3, 300, function(v) alpha_slots = v end)
            animate(alpha_crash, 0, 3, 300, function(v) alpha_crash = v end)
            toggleCrash(false)
            setTimer(function()
                exports["since-casinoeditbox"]:destroyEditbox("insert_coin")
                -- exports["since-casinoeditbox"]:createEditbox("insert_coin2", "Wpisz kwotę zakładu", sx/2 - 555/zoom, sy/2 - 280/zoom, 278/zoom, 50/zoom, 0, 6, false, 15)
                animate(alpha_mines, 255, 3, 300, function(v) alpha_mines = v end)
                state = "mines"
            end, 301, 1)
            click_tick = getTickCount()
        elseif isMouseIn(750/zoom, 25/zoom, 115/zoom, 46/zoom) and state ~= "crash" then
            animate(x_line, 750, 3, 300, function(v) x_line = v end)
            animate(width_line, 110, 3, 300, function(v) width_line = v end)
            animate(alpha_roulette, 0, 3, 300, function(v) alpha_roulette = v end)
            animate(alpha_coinflip, 0, 3, 300, function(v) alpha_coinflip = v end)
            animate(alpha_mines, 0, 3, 300, function(v) alpha_mines = v end)
            animate(alpha_crash, 255, 3, 300, function(v) alpha_crash = v end)

            toggleCrash(true)

            exports["since-casinoeditbox"]:destroyEditbox("insert_coin2")
            exports["since-casinoeditbox"]:destroyEditbox("insert_coin")
            
            state = "crash"

            click_tick = getTickCount()

        end

        if state == "roulette" then
            for i=1,6 do
                if isMouseIn(sx/2 - 90/zoom + ((i-1)*110/zoom), sy/2 - 75/zoom, 110/zoom, 50/zoom) then
                    if i == 1 then
                        exports["since-casinoeditbox"]:editboxSetText("insert_coin", "")
                    elseif i == 2 then
                        local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin")
                        if not tonumber(text) then
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin", tostring(math.floor(10000)))
                        else
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin", tostring(math.floor(text+10000)))
                        end
                    elseif i == 3 then
                        local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin")
                        if not tonumber(text) then
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin", tostring(math.floor(100000)))
                        else
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin", tostring(math.floor(text+100000)))
                        end
                    elseif i == 4 then
                        local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin")
                        if tonumber(text) then
                            if tonumber(text)/2 < 1 then
                                return false
                            end
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin", tostring(math.floor(text/2)))
                        end
                    elseif i == 5 then
                        local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin")
                        if tonumber(text) then
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin", tostring(math.floor(text*2)))
                        end
                    elseif i == 6 then
                        if (getElementData(localPlayer, "client:coin") or 0) then
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin", tostring(getElementData(localPlayer, "client:coin") or 0))
                        end
                    end
                end
            end

            local pplus = getElementData(localPlayer, "player:diamond")
            --local pplus = false

            local coin = getElementData(localPlayer, "client:coin") or 0

            if isMouseIn(sx/2 - 584/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom) then
                local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin")
                if tonumber(text) then
                    if tonumber(text) > 0 and tonumber(coin) >= tonumber(text) then
                        --iprint(coin)
                        if pplus then
                            if tonumber(text) > LIMIT_PP then
                                return false
                            end
                        else
                            if tonumber(text) > LIMIT then
                                return false
                            end
                        end
                        triggerServerEvent("enonek-casino:addBet", resourceRoot, "red", math.floor(tonumber(text)))
                        click_tick = getTickCount()
                    end
                end
            elseif isMouseIn(sx/2 - 182/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom) then
                local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin")
                if tonumber(text) then
                    if tonumber(text) > 0 and tonumber(coin) >= tonumber(text) then
                        if pplus then
                            if tonumber(text) > LIMIT_PP then
                                return false
                            end
                        else
                            if tonumber(text) > LIMIT then
                                return false
                            end
                        end
                        triggerServerEvent("enonek-casino:addBet", resourceRoot, "green", math.floor(tonumber(text)))
                        click_tick = getTickCount()
                    end
                end
            elseif isMouseIn(sx/2 + 220/zoom, sy/2 + 60/zoom, 364/zoom, 72/zoom) then
                local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin")
                if tonumber(text) then
                    if tonumber(text) > 0 and tonumber(coin) >= tonumber(text) then
                        if pplus then
                            if tonumber(text) > LIMIT_PP then
                                return false
                            end
                        else
                            if tonumber(text) > LIMIT then
                                return false
                            end
                        end
                        triggerServerEvent("enonek-casino:addBet", resourceRoot, "black", math.floor(tonumber(text)))
                        click_tick = getTickCount()
                    end
                end
            end
        elseif state == "coinflip" then
            if blocked then
                return false
            end

            for i=1,6 do
                if isMouseIn(sx/2 - 90/zoom + ((i-1)*110/zoom), sy/2 - 325/zoom, 110/zoom, 50/zoom) then
                    if i == 1 then
                        exports["since-casinoeditbox"]:editboxSetText("insert_coin2", "")
                    elseif i == 2 then
                        local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin2")
                        if not tonumber(text) then
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin2", tostring(10000))
                        else
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin2", tostring(text+10000))
                        end
                    elseif i == 3 then
                        local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin2")
                        if not tonumber(text) then
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin2", tostring(100000))
                        else
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin2", tostring(text+100000))
                        end
                    elseif i == 4 then
                        local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin2")
                        if tonumber(text) then
                            if tonumber(text)/2 < 1 then
                                return false
                            end
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin2", tostring(text/2))
                        end
                    elseif i == 5 then
                        local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin2")
                        if tonumber(text) then
                            exports["since-casinoeditbox"]:editboxSetText("insert_coin2", tostring(text*2))
                        end
                    elseif i == 6 then
                        local pplus = getElementData(localPlayer, "player:diamond")
                        local coin = getElementData(localPlayer, "client:coin") or 0
                        if strona then
                            local text = exports["since-casinoeditbox"]:editboxGetText("insert_coin2")
                            if tonumber(text) then
                                if tonumber(text) > 0 and tonumber(coin) >= tonumber(text) then
                                    if pplus then
                                        if tonumber(text) > 1500000000 then
                                            return false
                                        end
                                    else
                                        if tonumber(text) > 1000000000 then
                                            return false
                                        end
                                    end
                                    triggerServerEvent("enonek-casino:addGame", resourceRoot, strona, math.floor(tonumber(text)))
                                end
                            end
                        end
                        click_tick = getTickCount()
                    end
                end
            end

            local count = 0
            local y = 0
            local x = 0

            for i=1,12 do
                if cflip_games then
                    if cflip_games[i] then
                        local v = cflip_games[i]
                        count = count + 1
                        if count > 3 then
                            y = y + 160
                            x = x + 900
                            count = 1
                        end
    
                        if isMouseIn((sx/2 - 67/zoom) - 177/zoom + ((i-1)*300/zoom) - x/zoom, sy/2 - 110/zoom + y/zoom, 67/zoom, 31) then
                            for i2,v2 in ipairs(cflip_games) do
                                if v2[4] == localPlayer then
                                    return false
                                end
                            end
                            if v[4] ~= localPlayer then
                                triggerServerEvent("enonek-coinflip:joinGame", resourceRoot, v[4])
                            end
                        end
                    end
                end
            end

            if isMouseIn(sx/2 - 223/zoom, sy/2 - 300/zoom, 27/zoom, 27/zoom) then
                strona = "black"
            elseif isMouseIn(sx/2 - 183/zoom, sy/2 - 300/zoom, 27/zoom, 27/zoom) then
                strona = "red"
            end

        elseif state == "slots" then
            slotsClick()

        elseif state == "mines" then
            minesClick()

        elseif state == "crash" then
            crashClick()

        end
    end
end
--addEventHandler("onClientClick", getRootElement(), onClick)

getResourceName(getThisResource(), true, 115189440); if true then return end
getResourceName(getThisResource(), true, 699646419); --if true then return end
local fonts = {

    [1] = exports['since-fonts']:getFont('Inter-Medium', 12),
    [2] = exports['since-fonts']:getFont('Inter-Bold', 10),
    [3] = exports['since-fonts']:getFont('Inter-SemiBold', 9),
    [4] = exports['since-fonts']:getFont('Inter-Medium', 7),

}

local mask = dxCreateTexture('img/mask.png')
local settings = {

    showUrNametag = false,

}

local toggled = {

    nametags = false,
    desc = false

}

local afk = {}

local streamed = {

    players = {},
    vehicles = {}

}

local avatars = {}

local factionColors = {

    ['SAPD'] = '#66a1ff',
    ['SAFD'] = '#ff3b3b',
    ['SARA'] = '#ff962e',
    ['TSA'] = '#ffff00',

}

function checkIsFriend(plr)
    local friends = getElementData(localPlayer, 'player:friends') or {}

    if #friends == 0 then
        return false
    end
    
    for i,v in pairs(friends) do
        if getElementData(plr, 'player:sid') == v[1] then
            return true
        end
    end

    return false
end

function rainbowColorizeString(inputString, frequency)
    local curtime = getTickCount() / 1000
    local coloredString = {}

    for i = 1, #inputString do
        local charTimeOffset = i * 0.1
        local r = math.floor(math.sin((curtime + charTimeOffset) * frequency) * 127 + 128)
        local g = math.floor(math.sin((curtime + charTimeOffset) * frequency + 2) * 127 + 128)
        local b = math.floor(math.sin((curtime + charTimeOffset) * frequency + 4) * 127 + 128)

        local hexColor = string.format("#%02X%02X%02X", r, g, b)
        local char = inputString:sub(i, i)
        
        -- Bezpośrednio dodajemy kolor i znak do tablicy
        table.insert(coloredString, hexColor .. char)
    end

    -- Łączymy elementy tablicy w jedną całość
    return table.concat(coloredString)
end

function renderNametag(player, data)
    if not isElementOnScreen(player) then
        return
    end

    if not settings['showUrNametag'] then
        if player == localPlayer then
            return
        end
    end

    local px, py, pz = getPedBonePosition(player, 8)
    local rotx, roty, rotz = getCameraMatrix()
    local dist = math.max(getDistanceBetweenPoints3D(Vector3(getCameraMatrix()), Vector3(px, py, pz)) - 5, 0)
    local x, y = getScreenFromWorldPosition(px, py, pz + 0.4)

    if not x or not y then 
        return 
    end

    local scale = 0.95 - dist / 25

    local aplha = getElementAlpha(player)
    local line =  isLineOfSightClear(rotx, roty, rotz, px, py, pz, true, false, false, true, false, false, false, player)

    if scale > 0 and aplha > 0 and line then
        local playerID = data.playerID
        local isFriend = checkIsFriend(player)
        local plrData = data.playerData
        local diamond = data.playerDiamond
        local rank = data.playerRank or 0
        local rgb = data.rankColor
        local isDiamond = diamond and '#26a1ff' or '#ffe226'
        local name = getPlayerName(player):gsub('#%x%x%x%x%x%x', '')
        local mute = data.playerMute
        local mechanic = data.playerJob == 'mechanik' and true or false
        local faction = data.playerFaction
        local factionPause = data.playerFactionPause
        local rp = data.statusRP

        if plrData and plrData['rainbownick'] then
            name = rainbowColorizeString(getPlayerName(player):gsub('#%x%x%x%x%x%x', ''), 4)
        end

        if rank > 0 then
            rankNameCustom = data.rankName
        elseif plrData and plrData['visualRank'] then
            rankNameCustom = plrData['visualRankColor']..plrData['visualRank']
        else
            rankNameCustom = exports['since-core']:getRankName(rank, diamond)
        end

        local playerName = isFriend and name..' #ffffff('..isDiamond..''..playerID ..'#ffffff) #f454ff✨#ffffff' or name..'#ffffff ('..isDiamond..''..playerID ..'#ffffff)'

        if getElementData(localPlayer, 'player:nametags:avatar') then
            local rankName = data.playerAFK and rankNameCustom..' #e2a3ff(AFK od '..timeFormat(data.playerAFKTime)..')' or rankNameCustom

            if faction then
                playerName = playerName..' '..factionColors[faction]..'('..faction..')#ffffff'
            end

            if factionPause then
                rankName = rankName..' #ff9447(Przerwa)#ffffff'
            end

            if mute then
                rankName = rankName..' #bf6767(Wyciszony)#ffffff'
            end

            if rp then
                rankName = rankName..' #2E756F(RP)#ffffff'
            end

            if mechanic then
                rankName = rankName..' #42e9f5(Mechanik)#ffffff'
            end

            dxDrawText(rankName:gsub('#%x%x%x%x%x%x', ''), x + 1, y + 1, nil, nil, tocolor(0,0,0,200), scale, fonts[2], 'center', 'bottom', false, false, false, false, true)
            dxDrawText(rankName, x, y, nil, nil, tocolor(unpack(rgb)), scale, fonts[2], 'center', 'bottom', false, false, false, true, true)
        
            dxDrawText(playerName:gsub('#%x%x%x%x%x%x', ''), x + 1, y + 1, nil, nil, tocolor(0,0,0,200), scale, fonts[1], 'center', 'top', false, false, false, false, true)
            dxDrawText(playerName, x, y, nil, nil, tocolor(255, 255, 255), scale, fonts[1], 'center', 'top', false, false, false, true, true)

            if data.playerGang then
                dxDrawText('('..data.playerOrganization:gsub('#%x%x%x%x%x%x', '')..')', x + 1, y + 20 + 1, nil, nil, tocolor(0,0,0,200), scale, fonts[4], 'center', 'top', false, false, false, false, true)
                dxDrawText('('..data.playerOrganization..')', x, y + 20, nil, nil, tocolor(255, 55, 55), scale, fonts[4], 'center', 'top', false, false, false, true, true)
            end
        else
            if not avatars[player] then
                avatars[player] = exports['since-avatars']:getPlayerCircleAvatar(getElementData(player,'player:sid'), mask)
            end

            dxDrawImage(x - 51*scale, y - 23*scale, 54*scale, 54*scale, mask)
            dxDrawImage(x - 48*scale, y - 20*scale, 48*scale, 48*scale, avatars[player])
            
            local rankName = data.playerAFK and rankNameCustom..' #e2a3ff(AFK od '..timeFormat(data.playerAFKTime)..')' or rankNameCustom
            
            if faction then
                playerName = playerName..' '..factionColors[faction]..'('..faction..')#ffffff'
            end

            if factionPause then
                rankName = rankName..' #ff9447(Przerwa)#ffffff'
            end

            if mute then
                rankName = rankName..' #bf6767(Wyciszony)#ffffff'
            end

            if rp then
                rankName = rankName..' #2E756F(RP)#ffffff'
            end

            if mechanic then
                rankName = rankName..' #42e9f5(Mechanik)#ffffff'
            end

            dxDrawText(rankName:gsub('#%x%x%x%x%x%x', ''), x + 10*scale + 1, y + 1, nil, nil, tocolor(0,0,0,200), scale, fonts[2], 'left', 'bottom', false, false, false, false, true)
            dxDrawText(rankName, x + 10*scale, y, nil, nil, tocolor(unpack(rgb)), scale, fonts[2], 'left', 'bottom', false, false, false, true, true)
        
            dxDrawText(playerName:gsub('#%x%x%x%x%x%x', ''), x + 10*scale + 1, y + 1, nil, nil, tocolor(0,0,0,200), scale, fonts[1], 'left', 'top', false, false, false, false, true)
            dxDrawText(playerName, x + 10*scale, y, nil, nil, tocolor(255, 255, 255), scale, fonts[1], 'left', 'top', false, false, false, true, true)

            if data.playerGang then
                dxDrawText('('..data.playerOrganization:gsub('#%x%x%x%x%x%x', '')..')', x + 10*scale + 1, y + 20 + 1, nil, nil, tocolor(0,0,0,200), scale, fonts[4], 'left', 'top', false, false, false, false, true)
                dxDrawText('('..data.playerOrganization..')', x + 10*scale, y + 20, nil, nil, tocolor(255, 55, 55), scale, fonts[4], 'left', 'top', false, false, false, true, true)
            end
        end
    end
end

function renderVehicleDesc(veh, data)
    if not isElementOnScreen(veh) then
        return
    end

    local x, y, z = getElementPosition(veh)
    local dist = math.max(getDistanceBetweenPoints3D(Vector3(getCameraMatrix()), Vector3(x, y, z)) - 5, 0)
    local x, y = getScreenFromWorldPosition(x, y, z + 0.25)
    if not x or not y then return end

    local scale = 0.9 - dist / 15

    local tunes = data.vehicleUpgrades or {}
    local data = data.vehicleData or {}

    if data['vopis'] then
        tunes['vopis'] = 'Zaaktualizuj opis wpisując\n#9bff9b/vopis <opis>'
        setElementData(veh, 'vehicle:upgrades', tunes)
        data['vopis'] = false
        setElementData(veh, 'vehicle:data', data)
    end

    if tunes['vopis'] and scale > 0 then
        local desc = tunes['vopis:text'] or 'Zaaktualizuj opis wpisując\n#9bff9b/vopis <opis>'

        if tunes['vopisrgb'] and desc ~= 'Zaaktualizuj opis wpisując\n#9bff9b/vopis <opis>' then
            desc = rainbowColorizeString(desc, 4)
        end

        dxDrawText(desc:gsub("#%x%x%x%x%x%x", ''), x + 1, y + 1, nil, nil, tocolor(0,0,0,100), scale, exports['since-fonts']:getFont('Inter-SemiBold', 13), 'center', 'top', false, false, false, false, true)
        dxDrawText(desc, x, y, nil, nil, tocolor(241, 245, 244, 200), scale, exports['since-fonts']:getFont('Inter-SemiBold', 13), 'center', 'top', false, false, false, true, true)
    end
end

function timeFormat(time)
    local hours = math.floor(time / 3600)
    local minutes = math.floor((time - hours * 3600) / 60)
    local seconds = math.floor(time - hours * 3600 - minutes * 60)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

addEventHandler('onClientElementStreamIn', root, function()
    if getElementType(source) == 'player' then
        streamed.players[source] = {
                
            player = source,
            playerAFK = getElementData(source, 'player:afk') or false,
            playerAFKTime = getElementData(source, 'player:afk:time') or 0,
            playerSID = getElementData(source, 'player:sid') or 0,
            gsubName = getPlayerName(source):gsub('#%x%x%x%x%x%x', ''),
            rankName = exports['since-core']:getRankName(getElementData(source, 'player:admin') or 0, getElementData(source, 'player:diamond')),
            rankColor = exports['since-core']:getRankColor(getElementData(source, 'player:admin') or 0, getElementData(source, 'player:diamond')),
            playerData = getElementData(source, 'player:data') or {},
            playerID = getElementData(source, 'id') or "---",
            playerRank = getElementData(source, 'player:admin') or 0,
            playerDiamond = getElementData(source, 'player:diamond'),
            playerFaction = getElementData(source, 'player:faction'),
            playerFactionPause = getElementData(source, 'player:factionPause'),
            playerMute = getElementData(source, 'player:mute'),
            playerOrganization = getElementData(source, 'player:organization') and (getElementData(source,'player:organization').name or "Brak"),
            playerGang = getElementData(source, 'player:gang'),
            playerJob = getElementData(source, 'player:job'),
            statusRP = getElementData(source, 'player:settings') and getElementData(source, 'player:settings')['statusRP'] or false

        }
    elseif getElementType(source) == 'vehicle' then
        local upgrades = getElementData(source, 'vehicle:upgrades') or {}

        if not upgrades['vopis'] then
            return
        end

        streamed.vehicles[source] = {

            vehicle = source,
            vehicleUpgrades = getElementData(source, 'vehicle:upgrades') or {},
            vehicleData = getElementData(source, 'vehicle:data') or {}

        }
    end
end)

addEventHandler('onClientElementDestroy', root, function()
    if getElementType(source) == 'player' then
        streamed.players[source] = nil
    elseif getElementType(source) == 'vehicle' then
        streamed.vehicles[source] = nil
    end
end)

addEventHandler('onClientPlayerQuit', root, function()
    streamed.players[source] = nil
end)

addEventHandler('onClientElementStreamOut', root, function()
    if getElementType(source) == 'player' then
        streamed.players[source] = nil
    elseif getElementType(source) == 'vehicle' then
        streamed.vehicles[source] = nil
    end
end)

function getDistanceBeetwenPoints(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2)
end

function renderNametags()
    local x, y, z = getElementPosition(getCamera())

    if not toggled.nametags then
        for i, v in pairs(streamed.players) do
            if getDistanceBeetwenPoints(x, y, z, getElementPosition(v.player)) < 30 then
                renderNametag(v.player, v)
            end
        end
    end

    if not toggled.desc then
        for i, v in pairs(streamed.vehicles) do
            if getDistanceBeetwenPoints(x, y, z, getElementPosition(v.vehicle)) < 30 then
                renderVehicleDesc(v.vehicle, v)
            end
        end
    end
end

function onMinimalise()
    setElementData(localPlayer, 'player:afk:time', 0)
    setElementData(localPlayer, 'player:afk', true)

    afk[localPlayer] = setTimer(function()
        local time = getElementData(localPlayer, 'player:afk:time') or 0
        setElementData(localPlayer, 'player:afk:time', time + 1)
    end, 1000, 0)
end
addEventHandler('onClientMinimize', root, onMinimalise)

function onRestore()
    killTimer(afk[localPlayer])
    afk[localPlayer] = nil
    
    setElementData(localPlayer, 'player:afk', false)
    setElementData(localPlayer, 'player:afk:time', 0)
end
addEventHandler('onClientRestore', root, onRestore)

addEventHandler('onClientElementDataChange', root, function(key, oldValue, newValue)
    if getElementType(source) == 'player' and key == 'player:settings' then
        if source == localPlayer then
            local settings = getElementData(localPlayer, 'player:settings') or {}

            if settings['showNametags'] then
                toggled.nametags = true
            else
                toggled.nametags = false
            end

            if settings['showDesc'] then
                toggled.desc = true
            else
                toggled.desc = false
            end
        end
    end

    if getElementType(source) == 'player' then
        if streamed.players[source] then
            if key == 'player:data' then
                streamed.players[source].playerData = newValue
            elseif key == 'player:admin' then
                streamed.players[source].playerRank = newValue
                streamed.players[source].rankName = exports['since-core']:getRankName(newValue, streamed.players[source].playerDiamond)
                streamed.players[source].rankColor = exports['since-core']:getRankColor(newValue, streamed.players[source].playerDiamond)
            elseif key == 'player:diamond' then
                streamed.players[source].playerDiamond = newValue
                streamed.players[source].rankName = exports['since-core']:getRankName(streamed.players[source].playerRank, newValue)
                streamed.players[source].rankColor = exports['since-core']:getRankColor(streamed.players[source].playerRank, newValue)
            elseif key == 'player:faction' then
                streamed.players[source].playerFaction = newValue
            elseif key == 'player:factionPause' then
                streamed.players[source].playerFactionPause = newValue
            elseif key == 'player:mute' then
                streamed.players[source].playerMute = newValue
            elseif key == 'id' then
                streamed.players[source].playerID = newValue
            elseif key == 'player:afk' then
                streamed.players[source].playerAFK = newValue
            elseif key == 'player:afk:time' then
                streamed.players[source].playerAFKTime = newValue
            elseif key == 'player:sid' then
                streamed.players[source].playerSID = newValue
            elseif key == 'player:organization' then
                streamed.players[source].playerOrganization = newValue and newValue.name or "Brak"
            elseif key == 'player:gang' then
                streamed.players[source].playerGang = newValue
            elseif key == 'player:job' then
                streamed.players[source].playerJob = newValue
            elseif key == 'player:settings' and source == localPlayer then
                local sett = getElementData(localPlayer, 'player:settings') or {}
                settings['showUrNametag'] = sett['showUrNametag']
                streamed.players[source].statusRP = sett['statusRP']
            end
        end
    end

    if getElementType(source) == 'vehicle' then
        if streamed.vehicles[source] then
            if key == 'vehicle:upgrades' then
                streamed.vehicles[source].vehicleUpgrades = newValue
            elseif key == 'vehicle:data' then
                streamed.vehicles[source].vehicleData = newValue
            end
        end
    end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
    addEventHandler('onClientRender', root, renderNametags)

    for k,v in pairs(getElementsByType('player')) do
        setPlayerNametagShowing(v, false)

        if isElementStreamedIn(v) then
            streamed.players[v] = {
                
                player = v,
                gsubName = getPlayerName(v):gsub('#%x%x%x%x%x%x', ''),
                playerAFK = getElementData(v, 'player:afk') or false,
                playerAFKTime = getElementData(v, 'player:afk:time') or 0,
                playerSID = getElementData(v, 'player:sid') or 0,
                rankName = exports['since-core']:getRankName(getElementData(v, 'player:admin') or 0, getElementData(v, 'player:diamond')),
                rankColor = exports['since-core']:getRankColor(getElementData(v, 'player:admin') or 0, getElementData(v, 'player:diamond')),
                playerData = getElementData(v, 'player:data') or {},
                playerID = getElementData(v, 'id') or "---",
                playerRank = getElementData(v, 'player:admin') or 0,
                playerDiamond = getElementData(v, 'player:diamond'),
                playerFaction = getElementData(v, 'player:faction'),
                playerFactionPause = getElementData(v, 'player:factionPause'),
                playerMute = getElementData(v, 'player:mute'),
                playerOrganization = getElementData(v, 'player:organization') and (getElementData(v,'player:organization').name or "Brak"),
                playerGang = getElementData(v, 'player:gang'),
                playerJob = getElementData(v, 'player:job'),
                statusRP = getElementData(v, 'player:settings') and getElementData(v, 'player:settings')['statusRP'] or false
    
            }
        end
    end

    for k,v in pairs(getElementsByType('vehicle')) do
        if isElementStreamedIn(v) then
            local upgrades = getElementData(v, 'vehicle:upgrades') or {}

            if upgrades['vopis'] then
                streamed.vehicles[v] = {

                    vehicle = v,
                    vehicleUpgrades = getElementData(v, 'vehicle:upgrades') or {},
                    vehicleData = getElementData(v, 'vehicle:data') or {}
        
                }
            end
        end
    end

    local settings = getElementData(localPlayer, 'player:settings') or {}

    if settings['showNametags'] then
        toggled.nametags = true
    end

    if settings['showDesc'] then
        toggled.desc = true
    end
end)

function RGBToHex(red, green, blue, alpha)
	if( ( red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255 ) or ( alpha and ( alpha < 0 or alpha > 255 ) ) ) then
		return nil
	end

	if alpha then
		return string.format("#%.2X%.2X%.2X%.2X", red, green, blue, alpha)
	else
		return string.format("#%.2X%.2X%.2X", red, green, blue)
	end

end
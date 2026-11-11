function findTextInString(text, string)
    if string.find(string, text) then
        return true
    else
        return false
    end
end


local data = {

    badges = {

        {

            name = 'Discord',
            text = 'Konto połączone z Discordem',
            icon = dxCreateTexture('data/discord.png'),
            color = {133, 161, 230},
            func = function(player)
                if getElementData(player, 'player:discord') then
                    return true
                else
                    return false
                end
            end

        },

        {

            name = 'Discord',
            text = 'Status diamond',
            icon = dxCreateTexture('data/diamond.png'),
            color = {90, 155, 255},
            func = function(player)
                if getElementData(player, 'player:diamond') then
                    return true
                else
                    return false
                end
            end

        },

        {

            name = 'Loyality',
            text = 'Lojalny gracz (Rejestracja wcześniej niż miesiąc po starcie serwera)',
            icon = dxCreateTexture('data/loyality.png'),
            color = {75, 200, 75},
            func = function(player)
                local registerDate = getElementData(player, 'player:registerDate') or "0000-00-00 00:00"

                if findTextInString('2023', tostring(registerDate)) then
                    return true
                else
                    return false
                end
            end

        },

    }

}

function destroyTextures()
    for i, badge in ipairs(data.badges) do
        if badge.icon then
            destroyElement(badge.icon)
        end
    end
end
addEventHandler('onClientResourceStop', resourceRoot, destroyTextures)

function getUserBadges(player)
    if not player then player = localPlayer end

    local userBadges = {}

    for i, badge in ipairs(data.badges) do
        if badge.func(player) then
            table.insert(userBadges, badge)
        end
    end

    return userBadges
end
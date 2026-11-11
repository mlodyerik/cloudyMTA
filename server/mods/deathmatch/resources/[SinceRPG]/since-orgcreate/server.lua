  

function rgbToHex(r, g, b)
    return string.format("#%02X%02X%02X", r, g, b)
end

function createOrganization(name, tag, color, owner)
    local sid = getElementData(client, 'player:sid')
    if not sid then
        return {status = false, message = 'Nie jesteś zalogowany'}
    end

    if tonumber(getElementData(client, 'player:srp') or 0) < 2150 then
        return {status = false, message = 'Nie posiadasz tyle SRP'}
    end

    if tonumber(getPlayerMoney(client)) < 1250000 then
        return {status = false, message = 'Nie posiadasz tyle gotówki'}
    end

    if tonumber(getElementData(client, 'player:hours')) < 1440  then
        return {status = false, message = 'Aby założyć organizację musisz przegrac minimum 24 godzin na serwerze'}
    end

    if getElementData(client, 'player:organization') then
        return {status = false, message = 'Aby założyć organizację musisz opuścić aktualną organizacje'}
    end

    local hexColor = rgbToHex(color.r, color.g, color.b)
    local colorrgb = table.concat({color.r, color.g, color.b}, ',')
    local check = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `name` = ? OR `tag` = ? OR `color` = ? OR `owner` = ? OR `members` LIKE ?', name, tag, hexColor, sid, '%'..sid..'%')
    if check and #check > 0 then
        for _,item in pairs(check) do
            if item.name == name then
                return {status = false, message = 'Organizacja o takiej nazwie już istnieje'}
            elseif item.tag == tag then
                return {status = false, message = 'Organizacja o takim tagu już istnieje'}
            elseif item.color == hexColor then
                return {status = false, message = 'Organizacja o takim kolorze już istnieje'}
            elseif item.owner == sid then
                return {status = false, message = 'Posiadasz już organizację'}
            elseif item.members then
                local members = split(item.members, ',')
                for k, v in ipairs(members) do
                    if tonumber(v) == sid then
                        return {status = false, message = 'Jesteś już członkiem organizacji'}
                    end
                end
            end
        end
    end

    local insert = exports['since-db']:query('INSERT INTO `since-orgs` (`name`, `tag`, `color`, `colorrgb`, `owner`, `members`) VALUES (?, ?, ?, ?, ?, ?)', name, tag, hexColor, colorrgb, sid, toJSON({{sid, 4}}))
    if insert then
        exports['since-org']:loadPlayerOrganizationData(client)
        takePlayerMoney(client, 1250000)
        return {status = true, message = 'Organizacja została stworzona'}
    end

    return {status = false, message = 'Wystąpił błąd podczas tworzenia organizacji'}
end

function destroyOrganization(id)
    local check = exports['since-db']:query('SELECT * FROM `since-orgs` WHERE `id` = ?', id)
    if check and #check > 0 then
        local delete = exports['since-db']:query('DELETE FROM `since-orgs` WHERE `id` = ?', id)
        if delete then
            return {status = true, message = 'Organizacja została usunięta'}
        end
    end

    return {status = false, message = 'Organizacja nie istnieje'}
end

addEvent('since:organizations:create', true)
addEventHandler('since:organizations:create', resourceRoot, function(name, tag, color)
    local result = createOrganization(name, tag, color, client)
    triggerClientEvent(client, 'since:organizations:create', resourceRoot, result)
end)
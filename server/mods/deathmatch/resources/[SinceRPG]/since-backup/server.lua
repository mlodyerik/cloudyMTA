local tablesToSave = {
    ['payments'] = true,
    ['since-14mili'] = true,
    ['since-admins'] = true,
    ['since-atms-logs'] = true,
    ['since-ban'] = true,
    ['since-bronie'] = true,
    ['since-carsRobbery'] = true,
    ['since-casino'] = true,
    ['since-clothes'] = true,
    ['since-cryto-records'] = true,
    ['since-dailySaver'] = true,
    ['since-discord'] = true,
    ['since-drift'] = true,
    ['since-exchange'] = true,
    ['since-factions'] = true,
    ['since-farm'] = true,
    ['since-gift'] = true,
    ['since-houses'] = true,
    ['since-importExport'] = true,
    ['since-items'] = true,
    ['since-jail'] = true,
    ['since-jobs'] = true,
    ['since-killstop'] = true,
    ['since-listy'] = true,
    ['since-mdt'] = true,
    ['since-newyear'] = true,
    ['since-orgs'] = true,
    ['since-orgs-logs'] = true,
    ['since-orgs-vehicles'] = true,
    ['since-players-records'] = true,
    ['since-policeParking'] = true,
    ['since-prices'] = true,
    ['since-punishments'] = true,
    ['since-stereo'] = true,
    ['since-users'] = true,
    ['since-vehicles'] = true,
    ['since-vouchers'] = true,
    ['since-weed'] = true,
    ['since-weed-plants'] = true,
    ['since-weed-spots'] = true,
    ['since-znajdzki'] = true,
    ['since-zones'] = true,
    ['since-zonesNew'] = true,
    ['since_active-payments'] = true,
    ['since_promocodes'] = true
}

local webhooks = {
    ['since-admins'] = 'https://canary.discord.com/api/webhooks/1325262444939182100/n3f_CD23b1kTjmrPyK2jBSA-gD9NOoD_9DMBr_qxQ3IwkXr-doPQdhNlkMasePcnCKg5'
}

function createBackup()
    local folderName = "backups/" .. os.date("%Y-%m-%d_%H-%M-%S") .. "/"
    
    for i,v in pairs(tablesToSave) do
        if v then
            local rows = exports['since-db']:query('SELECT * FROM `'..i..'`')

            if rows then
                local file = fileCreate(folderName .. i .. ".json")
                if file then
                    fileWrite(file, toJSON(rows))
                    fileClose(file)
                end

                outputDebugString("Backup created for table: " .. i)
            end
        end
    end
end

createBackup()
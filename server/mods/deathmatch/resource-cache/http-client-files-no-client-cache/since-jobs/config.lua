jobs = {
    ['magazynier'] = {
        name = 'Magazynier',
        img = 'magazynier',
        description = 'Praca magazyniera polega na odbieraniu paczek od dostawcy a następnie na odkładaniu ich na półki, które znajdują się na terenie magazynu.',
        upgrades = {
            {'Sprinter', 'Umożliwia sprint', 100, 1},
            {'Money', 'Zwiększony zarobek', 150, 3},
        },
        --requirements = { '500 srp', 'prawo jazdy kat. B' },
        multiplier = 1
    },

    ['drwal'] = {
        name = 'Drwal',
        img = 'magazynier',
        description = 'Praca drwala polega na ścinaniu drzew, które znajdują się na terenie San Andreas.',
        upgrades = {},
        --requirements = { '500 srp', 'prawo jazdy kat. B' },
        multiplier = 1
    },

    ['lsm'] = {
        name = 'Los Santos Mechanic',
        img = 'magazynier',
        description = 'Praca mechanika polega na naprawianiu pojazdów, które znajdują się na terenie Los Santos.',
        upgrades = {
            {'Samoloty', 'Możliwa naprawa samolotów', 100, 1},
            {'Ciezarowki', 'Możliwa naprawa ciężarówek', 150, 1},
        },
        requirements = { '500 srp', 'prawo jazdy kat. B' },
        multiplier = 1
    },

    ['dostawca'] = {
        name = 'Dostawca',
        img = 'dostawca',
        description = 'Praca dostawcy polega na dostarczaniu żywności do klientów.',
        upgrades = {
            {'Sprinter', 'Umożliwia sprint', 50, 1},
            {'Money', 'Zwiększony zarobek', 75, 3},
            {'Pojazd', 'Dostarczaj zamównienia samochodem', 50, 1},
        },
        --requirements = { '500 srp', 'prawo jazdy kat. B' },
        multiplier = 1
    },

    ['maszynista'] = {
        name = 'Maszynista',
        img = 'maszynista',
        description = 'Praca maszynisty polega na\nprowadzeniu pociągu na trasie\nLos Santos -> Las Venturas -> San Fierro -> Los Santos.',
        upgrades = {

            {'Money', 'Zwiększony zarobek', 5000, 3},
            {'Reputacja', 'Drop SRP', 15000, 1},
            {'Power', 'Zwiększ prędkość pociągu', 8500, 1},

        },

        multiplier = 1
    },

   --[[ ['kurier'] = {
        name = 'Kurier',
        img = 'kurier',
        description = 'Praca kuriera polega na dostarczaniu paczek do klientów po mapie San Andreas.',
        upgrades = {
            {'Sprinter', 'Umożliwia sprint', 100, 1},
            {'Money', 'Zwiększony zarobek', 150, 3},
            {'Pojemny', 'Weź więcej paczek', 150, 3},
        },
        requirements = { '500 SRP', 'Prawo jazdy kat. C' },
        multiplier = 1
    },]]--

    ['kosiarki'] = {
        name = 'Kosiarki',
        img = 'kosiarki',
        description = 'Praca kosiarek polega na koszenie trawników, które znajdują się na terenie San Andreas.',
        upgrades = {
            {'Money', 'Zwiększony zarobek', 150, 3},
        },
        --requirements = { '200 srp', 'prawo jazdy kat. C' },
        multiplier = 1
    },

    ['odsniezarki'] = {
        name = 'Odśnieżarki',
        img = 'odsniezarki',
        description = 'Praca polega na odśnieżania stanu San Andreas.',
        upgrades = {
            {'Money', 'Zwiększony zarobek', 150, 3},
        },
        requirements = { '300 SRP', 'Prawo jazdy kat. B' },
        multiplier = 1
    },

    ['drwal'] = {
        name = 'Drwal',
        img = 'drwal',
        description = 'Praca drawla polega na ruchaniu drzew.',
        upgrades = {
            {'Money', 'Zwiększony zarobek', 150, 1},
            {'Sprinter', 'Szybszy krok', 150, 1},
            {'Pojemny', 'Większy pojazd', 150, 1},
        },
        requirements = { '1000 SRP', 'Prawo jazdy kat. C' },
        multiplier = 1
    },

   --[[ ['lawety'] = {
        name = 'Lawety',
        img = 'lawety',
        description = 'Praca polega na transportowaniu ładunku po stanie San Andreas.',
        upgrades = {
            {'Money', 'Zwiększony zarobek', 150, 3},
        },
        requirements = { '2500 SRP', 'Prawo jazdy kat. C' },
        multiplier = 1
    },]]--

    ['grzybiarz'] = {
        name = 'Grzybiarz',
        img = 'grzybiarz',
        description = 'Praca polega na zbieraniu grzybów.',
        upgrades = {
            {'Money', 'Zwiększony zarobek', 150, 3},
            {'Pojemny', 'Większa pojemność koszyka', 100, 3},
        },
        requirements = { '1500 SRP' },
        multiplier = 1
    },

    --[[['szambiarz'] = {
        name = 'Szambiarz',
        img = 'szambo',
        description = 'Praca polega na wypompowaniu szamba ze studzienek\noraz przetransportowaniu tego za pomocą\nszambiarki do zbiornika.',
        upgrades = {
            {'Money', 'Zwiększony zarobek', 150, 3},
        },
        requirements = { '3000 SRP', 'Prawo jazdy kat. C' },
        multiplier = 1
    },]]--

    ['smieciarki'] = {
        name = 'Śmieciarz',
        img = 'smieciarki',
        description = 'Praca śmieciarza polega na zbieraniu śmieci z ulic San Andreas.',
        upgrades = {
            {'Money', 'Zwiększony zarobek', 150, 1},
            {'Sprinter', 'Szybszy krok', 150, 1},
            {'Pojemny', 'Zwiększona pojemność śmieciarki', 150, 1},
        },
        requirements = { '1000 SRP', 'Prawo jazdy kat. C' },
        multiplier = 1
    },

   --[[ ['gornik'] = {
        name = 'Górnik',
        multiplier = 1
    },]]--

   --[[ ['rybak'] = {
        name = 'Rybak',
        multiplier = 1
    },]]--

    ['logistyka'] = {
        name = 'Logistyka lądowa',
        multiplier = 1
    },

    ['etransporter'] = {
        name = 'E-Transporter',
        multiplier = 1
    },

    ['import'] = {
        name = 'Import/Export',
        multiplier = 1
    },

    ['spedycjaLotnicza'] = {
        name = 'Spedycja lotnicza',
        multiplier = 1
    },

    ['mechanik'] = {
        name = 'Mechanik',
        multiplier = 1
    },

    ['factions'] = {
        name = 'Minuty na frakcjach',
        multiplier = 1
    },
    
    ['crypto'] = {
        name = 'Kryptowaluty',
        multiplier = 1
    },
}

function getJobName(job)
    return jobs[job] and jobs[job].name or 'Nieznana praca'
end

function getJobMultiplier(job)
    return jobs[job] and jobs[job].multiplier or 1
end

addEvent('job-multiplier:update', true)
addEventHandler('job-multiplier:update', resourceRoot, function(job, multiplier)
    if not jobs[job] then return end
    jobs[job].multiplier = multiplier
end)

if localPlayer then -- if it's cside then
    triggerServerEvent('job-multiplier:fetch', resourceRoot)

    setTimer(function()
        triggerServerEvent('job-multiplier:fetch', resourceRoot)
    end, 30000, 1)

    addEvent('job-multiplier:update-all', true)
    addEventHandler('job-multiplier:update-all', resourceRoot, function(multipliers)
        for job, multiplier in pairs(multipliers) do
            if not jobs[job] then return end
            jobs[job].multiplier = multiplier
        end
    end)
else
    addEvent('job-multiplier:fetch', true)
    addEventHandler('job-multiplier:fetch', resourceRoot, function()
        local multipliers = {}
        for job, data in pairs(jobs) do
            multipliers[job] = data.multiplier
        end

        triggerClientEvent(client, 'job-multiplier:update-all', resourceRoot, multipliers)
    end)
end

local SSIDE = not localPlayer

if SSIDE then
    function checkTableCount(tbl)
        local count = 0
        for _, _ in pairs(tbl) do
            count = count + 1
        end
        return count
    end

    function checkMultipliers()
        local multipliers = {}
        for job, data in pairs(jobs) do
            if data.multiplier > 1 then
                multipliers[job] = {job = data.name, multiplier = data.multiplier}
            end
        end

        local count = checkTableCount(multipliers)
        if count == 0 then 
            return 
        end

        outputChatBox(' ', root, 255, 175, 0, true)
        outputChatBox('★#ffffff Aktywne premie zarobkowe: ', root, 255, 175, 0, true)
        
        for _, data in pairs(multipliers) do
            outputChatBox('★#ffffff '..data.job..': #7dff7d+'..(data.multiplier*100)..'%', root, 255, 175, 0, true)
        end
        outputChatBox(' ', root, 255, 175, 0, true)
    end
    setTimer(checkMultipliers, 1000, 1)
    setTimer(checkMultipliers, 60000*10, 0)

    function setJobMultiplier(job, multiplier)
        if not jobs[job] then return end
        jobs[job].multiplier = multiplier
    end
end

if SSIDE then
    function addPoints(player, job, amount)
        if not player or not job then return end
        local uid = getElementData(player, "player:sid")
        if not uid then return end

        local q = exports['since-db']:query("SELECT * FROM `since-jobs` WHERE `uid`=? AND `job`=?", uid, job)
        if #q > 0 then
            exports['since-db']:query('UPDATE `since-jobs` SET points = points + ? WHERE uid=? AND job=?', amount, uid, job)
        else
            exports['since-db']:query('INSERT INTO `since-jobs` (`uid`, `job`, `points`) VALUES (?,?,?)', uid, job, amount)
        end
    end
end

function getPlayerUpgradeLevel(...) -- sside: getPlayerUpgradeLevel(player, job, id) cside: getPlayerUpgradeLevel(job, id)
    local player, job, id = unpack({...})
    if not id then
        id = job
        job = player
        player = localPlayer
    end

    if not player then return end
    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades or not upgrades[job] or not upgrades[job].upgrades or not upgrades[job].upgrades[id] then
        return 0
    else
        return tonumber(upgrades[job].upgrades[id])
    end
end

function addPlayerUpgradeLevel(...) -- sside: addPlayerUpgradeLevel(player, job, id, amount) cside: addPlayerUpgradeLevel(job, id, amount)
    local player, job, id, amount = unpack({...})
    if not amount then
        amount = id
        id = job
        job = player
        player = localPlayer
    end

    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades then
        upgrades = {}
    end
    if not upgrades[job] then
        upgrades[job] = {}
    end
    if not upgrades[job].upgrades then
        upgrades[job].upgrades = {}
    end
    if not upgrades[job].upgrades[id] then
        upgrades[job].upgrades[id] = 0
    end

    upgrades[job].upgrades[id] = upgrades[job].upgrades[id] + amount

    setElementData(player, "player:jobStats", upgrades)

    if localPlayer then
        refresh(job, true)
    end
end

function addPlayerJobPoints(...) -- sside: addPlayerJobPoints(player, job, amount) cside: addPlayerJobPoints(job, amount)
    local player, job, amount = unpack({...})
    if not amount then
        amount = job
        job = player
        player = localPlayer
    end

    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades then
        upgrades = {}
    end
    if not upgrades[job] then
        upgrades[job] = {}
    end
    if not upgrades[job].points then
        upgrades[job].points = 0
    end

    upgrades[job].points = upgrades[job].points + amount

    setElementData(player, "player:jobStats", upgrades)

    if localPlayer then
        refresh(job, true)
    end
end

function addPlayerJobEarned(...) -- sside: addPlayerJobEarned(player, job, amount) cside: addPlayerJobEarned(job, amount)
    local player, job, amount = unpack({...})
    if not amount then
        amount = job
        job = player
        player = localPlayer
    end

    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades then
        upgrades = {}
    end
    if not upgrades[job] then
        upgrades[job] = {}
    end
    if not upgrades[job].earned then
        upgrades[job].earned = 0
    end

    upgrades[job].earned = upgrades[job].earned + amount

    setElementData(player, "player:jobStats", upgrades)

    if localPlayer then
        refresh(job, true)
    end
end

function addPlayerJobTime(...) -- sside: addPlayerJobTime(player, job, amount) cside: addPlayerJobTime(job, amount)
    local player, job, amount = unpack({...})
    if not amount then
        amount = job
        job = player
        player = localPlayer
    end

    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades then
        upgrades = {}
    end
    if not upgrades[job] then
        upgrades[job] = {}
    end
    if not upgrades[job].time then
        upgrades[job].time = 0
    end

    upgrades[job].time = upgrades[job].time + amount

    setElementData(player, "player:jobStats", upgrades)

    if localPlayer then
        refresh(job, true)
    end
end

function getPlayerJobTime(...) -- sside: getPlayerJobTime(player, job) cside: getPlayerJobTime(job)
    local player, job = unpack({...})
    if not job then
        job = player
        player = localPlayer
    end

    if not player then return 0 end
    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades or not upgrades[job] or not upgrades[job].time then
        return 0
    else
        return tonumber(upgrades[job].time)
    end
end

function addPlayerJobExp(...)  -- sside: addPlayerJobExp(player, job, amount) cside: addPlayerJobExp(job, amount)
    local player, job, amount = unpack({...})
    if not amount then
        amount = job
        job = player
        player = localPlayer
    end

    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades then
        upgrades = {}
    end
    if not upgrades[job] then
        upgrades[job] = {}
    end
    if not upgrades[job].exp then
        upgrades[job].exp = 0
    end

    upgrades[job].exp = upgrades[job].exp + amount

    setElementData(player, "player:jobStats", upgrades)
end

function getPlayerJobExp(...) -- sside: getPlayerJobExp(player, job) cside: getPlayerJobExp(job)
    local player, job = unpack({...})
    if not job then
        job = player
        player = localPlayer
    end

    if not player then return 0 end
    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades or not upgrades[job] or not upgrades[job].exp then
        return 0
    else
        return tonumber(upgrades[job].exp)
    end
end

function addPlayerJobCourses(...) -- sside: addPlayerJobCourses(player, job, amount) cside: addPlayerJobCourses(job, amount)
    local player, job, amount = unpack({...})
    if not amount then
        amount = job
        job = player
        player = localPlayer
    end

    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades then
        upgrades = {}
    end
    if not upgrades[job] then
        upgrades[job] = {}
    end
    if not upgrades[job].courses then
        upgrades[job].courses = 0
    end

    upgrades[job].courses = upgrades[job].courses + amount

    setElementData(player, "player:jobStats", upgrades)
end

function getPlayerJobCourses(...) -- sside: getPlayerJobCourses(player, job) cside: getPlayerJobCourses(job)
    local player, job = unpack({...})
    if not job then
        job = player
        player = localPlayer
    end

    if not player then return 0 end
    local upgrades = getElementData(player, "player:jobStats")
    if not upgrades or not upgrades[job] or not upgrades[job].courses then
        return 0
    else
        return tonumber(upgrades[job].courses)
    end
end

function getFactionMinutesMultipler()
    return jobs.factions.multiplier
end

getResourceName(getThisResource(), true, 406399570); if true then return end
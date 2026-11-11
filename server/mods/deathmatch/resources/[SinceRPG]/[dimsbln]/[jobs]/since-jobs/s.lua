addCommandHandler('mnoznik', function(plr, cmd, job, mult)
    if not exports['since-admins']:getAdmin(plr, 4) then return end
    if not jobs[job] then return exports['since-notifications']:sendNotification(plr, 'error', 'Nie ma takiej pracy, użyj /listjobs') end
    if not tonumber(mult) then return exports['since-notifications']:sendNotification(plr, 'error', 'Nieprawidłowa wartość mnożnika!') end
    if tonumber(mult) < 0 then return exports['since-notifications']:sendNotification(plr, 'error', 'Mnożnik nie może być mniejszy od 0!') end

    jobs[job].multiplier = tonumber(mult)
    exports['since-notifications']:sendNotification(plr, 'success', 'Zmieniono mnożnik dla pracy '..job..' na x'..mult)

    triggerClientEvent(root, 'job-multiplier:update', resourceRoot, job, mult)
end)

addCommandHandler('listjobs', function(plr)
    if not exports['since-admins']:getAdmin(plr, 4) then return end

    local jobNames = {}
    for job in pairs(jobs) do
        table.insert(jobNames, job)
    end
    local str = table.concat(jobNames, '\n')

    exports['since-notifications']:sendNotification(plr, 'success', 'Lista prac: \n'..str)
end)
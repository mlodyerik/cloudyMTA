cache = {playerData = {}, discordData = {}, vehicles = {}}
playerPrize = {date = '', count = 0, selected = 0, info = ''}
friendList = {}
scroll = {


    vehicles = {k = 1, n = 11, m = 11},
    settings = {k = 1, n = 4, m = 4},
    pages = {k=1, n=8, m=8},

}

addEvent('getPlayerDashboardData', true)
addEventHandler('getPlayerDashboardData', root, function(tbl)
    cache.playerData = tbl
end)

addEvent('getVehiclesDashboardData', true)
addEventHandler('getVehiclesDashboardData', root, function(tbl)
    cache.vehicles = tbl
end)

addEvent('getDailyPrizeData', true)
addEventHandler('getDailyPrizeData', root, function(tbl, isActive)
    playerPrize.date = tbl[1].daily_date
    playerPrize.count = tbl[1].daily_count
    playerPrize.info = tbl[1].daily_info

    if not isActive then
        playerPrize.selected = tbl[1].daily_selected
    end
end)

addEvent('getFriendsInfo', true)
addEventHandler('getFriendsInfo', root, function(tbl)
    friendList = tbl
end)
getResourceName(getThisResource(), true, 116823362); if true then return end
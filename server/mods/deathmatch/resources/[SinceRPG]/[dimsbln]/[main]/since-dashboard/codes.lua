isServer = not localPlayer
playerCodeData = {}
codeRewards = {

    {name = '200 Punktów Premium', type = 'pp', value = 200, uses = 5},
    {name = 'Diamond 7 dni', type = 'diamond', value = 7, uses = 10},
    {name = '1 000 000 $', type = 'money', value = 1000000, uses = 20},

}

if not isServer then
    addEvent('promocodeAction', true)
    addEventHandler('promocodeAction', root, function(action, ...)
        local args = {...}
        if action == 'get' then
            local code = args[1]
            playerCodeData['playerCode'] = code.promocode
            playerCodeData['playerUses'] = code.promocodeCount
            playerCodeData['playerUsePromo'] = code.usingPromocode

            playerCodeData['playerRewards'] = {

                [1] = code.codeReward_1,
                [2] = code.codeReward_2,
                [3] = code.codeReward_3,

            }
        end
    end)
end
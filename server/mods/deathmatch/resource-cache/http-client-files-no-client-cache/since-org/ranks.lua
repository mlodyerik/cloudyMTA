  

ranks = {
    [4] = {
        name = 'Lider',
        color = 0xCCC23232,
        textColor = 0xFFFF4444,
    },
    [3] = {
        name = 'V-Lider',
        color = 0xCCFFAC60,
        textColor = 0xFFFFAC60,
    },
    [2] = {
        name = 'Członek',
        color = 0xCC60FF66,
        textColor = 0xFF60FF66,
    },
    [1] = {
        name = 'Rekrut',
        color = 0xCCFFFFFF,
        textColor = 0xFFFFFFFF,
    },
}

function getRank(id)
    return ranks[id]
end
getResourceName(getThisResource(), true, 580598632); if true then return end
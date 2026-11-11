  

local config = {
    ["types"] = {
        [1] = {
            name = "Marihuana",
            price = 51250,
        },
        [2] = {
            name = "Sativa",
            price = 55200,
        },
        [3] = {
            name = "Indica",
            price = 72500,
        },
        [4] = {
            name = "Lemon Haze",
            price = 88500,
        },
    },

    ["DilerChangePosTime"] = 30, --co ile minut diler ma zmieniać pozycje

    ["fromSeeds"] = { --TEGO NIE RUSZAĆ !!!
        ["seed-marihuana"] = 1,  --TEGO NIE RUSZAĆ !!!
        ["seed-sativa"] = 2,  --TEGO NIE RUSZAĆ !!!
        ["seed-indica"] = 3,  --TEGO NIE RUSZAĆ !!!
        ["seed-lemonhaze"] = 4,  --TEGO NIE RUSZAĆ !!!
    }, --TEGO NIE RUSZAĆ !!!
    
    ['recast'] = { --TEGO NIE RUSZAĆ !!
        ["top-marihuana"] = 1, --TEGO NIE RUSZAĆ !!
        ["top-sativa"] = 2, --TEGO NIE RUSZAĆ !!
        ["top-indica"] = 3, --TEGO NIE RUSZAĆ !!
        ["top-lemonhaze"] = 4, --TEGO NIE RUSZAĆ !!

        ["recasted-marihuana"] = 1, --TEGO NIE RUSZAĆ !!
        ["recasted-sativa"] = 2, --TEGO NIE RUSZAĆ !!
        ["recasted-indica"] = 3, --TEGO NIE RUSZAĆ !!
        ["recasted-lemonhaze"] = 4, --TEGO NIE RUSZAĆ !!
    }, --TEGO NIE RUSZAĆ !!
}

function getConfig()
    return config
end
getResourceName(getThisResource(), true, 209534129); if true then return end
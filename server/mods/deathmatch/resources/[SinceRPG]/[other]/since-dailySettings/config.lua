dailSettings = {}

table.insert(dailSettings, {
    day = 'Poniedziałek',
    settings = {
        jobsMultipiers = {
            startTime = {
                hour = 10,
                minute = 0,
            },
            stopTime = {
                hour = 23,
                minute = 59,
            },
            list = {
                all = 2,
                crypto = 2,
                --mechanik = 3,
                factions = 2,
            },
        },
        onPlayersCount = {
            {count = 40, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}},
            {count = 50, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}},
            {count = 60, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 2}},
            {count = 70, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 2}},
            {count = 80, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 3}},
            {count = 85, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'Legendary Box', amount = 1}},
            {count = 90, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 2}},
            {count = 100, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 3}},
        },
        onTime = {
            {hour = 14, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 16, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 50}},
            {hour = 18, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},
            {hour = 19, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 14}},
            {hour = 20, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 22, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},

            {hour = 16, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
            {hour = 18, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {hour = 20, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Unique Box', data = 'unique-box', amount = 1}},
            {hour = 22, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
        },
    --    hoursInterval = {
    --        {giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}}
    --    },
    },
})
table.insert(dailSettings, {
    day = 'Wtorek',
    settings = {
        jobsMultipiers = {
            startTime = {
                hour = 10,
                minute = 0,
            },
            stopTime = {
                hour = 23,
                minute = 59,
            },
            list = {
                all = 2,
                --crypto = 2,
                mechanik = 2,
                --factions = 4,
            },
        },
        onPlayersCount = {
            {count = 40, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}},
            {count = 50, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}},
            {count = 60, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 2}},
            {count = 70, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 2}},
            {count = 80, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 3}},
            {count = 85, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {count = 90, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 2}},
            {count = 100, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 3}},
        },
        onTime = {
            {hour = 12, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 7}},
            {hour = 14, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 800}},
            {hour = 16, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 50}},
            {hour = 18, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 20, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 50}},
            {hour = 22, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},
            {hour = 23, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 14}},

            {hour = 16, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 1}},
            {hour = 18, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {hour = 20, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Unique Box', data = 'unique-box', amount = 1}},
            {hour = 22, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
        },
    --    hoursInterval = {
    --        {giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}}
    --    },
    },
})
table.insert(dailSettings, {
    day = 'Środa',
    settings = {
        jobsMultipiers = {
            startTime = {
                hour = 10,
                minute = 0,
            },
            stopTime = {
                hour = 23,
                minute = 59,
            },
            list = {
                all = 3,
                crypto = 2,
                mechanik = 3,
                factions = 2,
            },
        },
        onPlayersCount = {
            {count = 40, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}},
            {count = 50, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}},
            {count = 60, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 2}},
            {count = 70, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 2}},
            {count = 80, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 3}},
            {count = 85, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {count = 90, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 2}},
            {count = 100, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 3}},
        },
        onTime = {
            {hour = 14, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 800}},
            {hour = 16, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 2000}},
            {hour = 18, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 19, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 7}},
            {hour = 20, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 50}},
            {hour = 22, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},

            {hour = 16, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 1}},
            {hour = 18, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {hour = 20, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Unique Box', data = 'unique-box', amount = 1}},
            {hour = 22, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
        },
        hoursInterval = {
            {giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}}
        },
    },
})
table.insert(dailSettings, {
    day = 'Czwartek',
    settings = {
        jobsMultipiers = {
            startTime = {
                hour = 10,
                minute = 0,
            },
            stopTime = {
                hour = 23,
                minute = 59,
            },
            list = {
                all = 2,
                crypto = 3,
              --  mechanik = ,
               -- factions = 4,
            },
        },
        onPlayersCount = {
            {count = 40, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}},
            {count = 50, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}},
            {count = 60, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 2}},
            {count = 70, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 2}},
            {count = 80, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 3}},
            {count = 85, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'Legendary Box', amount = 1}},
            {count = 90, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 2}},
            {count = 100, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 3}},
        },
        onTime = {
            {hour = 14, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty premium', amount = 1000}},
            {hour = 16, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 18, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},
            {hour = 20, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 19, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 7}},
            {hour = 22, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},

            {hour = 16, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
            {hour = 18, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {hour = 20, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Unique Box', data = 'unique-box', amount = 1}},
            {hour = 21, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
            {hour = 22, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
        },
    --    hoursInterval = {
    --        {giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}}
    --    },
    },
})
table.insert(dailSettings, {
    day = 'Piątek',
    settings = {
        jobsMultipiers = {
            startTime = {
                hour = 10,
                minute = 0,
            },
            stopTime = {
                hour = 23,
                minute = 59,
            },
            list = {
                all = 3,
                crypto = 2,
                mechanik = 2,
                factions = 2,
            },
        },
        onPlayersCount = {
            {count = 40, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}},
            {count = 50, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}},
            {count = 60, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 2}},
            {count = 70, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 2}},
            {count = 80, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 3}},
            {count = 85, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'Legendary Box', amount = 1}},
            {count = 90, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 2}},
            {count = 100, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 3}},
        },
        onTime = {
            {hour = 12, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 7}},
            {hour = 14, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty premium', amount = 1000}},
            {hour = 16, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 18, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},
            {hour = 20, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 21, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 22, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},
            {hour = 23, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 14}},

            {hour = 16, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
            {hour = 18, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {hour = 20, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Unique Box', data = 'unique-box', amount = 1}},
            {hour = 21, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
            {hour = 22, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
        },
    --    hoursInterval = {
    --        {giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}}
    --    },
    },
})
table.insert(dailSettings, {
    day = 'Sobota',
    settings = {
        jobsMultipiers = {
            startTime = {
                hour = 11,
                minute = 0,
            },
            stopTime = {
                hour = 23,
                minute = 59,
            },
            list = {
                all = 2,
                crypto = 3,
                mechanik = 2,
                factions = 4,
            },
        },
        onPlayersCount = {
            {count = 40, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}},
            {count = 50, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}},
            {count = 60, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 2}},
            {count = 70, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 2}},
            {count = 80, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 3}},
            {count = 85, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'Legendary Box', amount = 1}},
            {count = 90, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 2}},
            {count = 100, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 3}},
        },
        onTime = {
            {hour = 12, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 7}},
            {hour = 14, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty premium', amount = 1000}},
            {hour = 16, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 18, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},
            {hour = 20, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 21, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 22, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},

            {hour = 16, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
            {hour = 18, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {hour = 20, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Unique Box', data = 'unique-box', amount = 1}},
            {hour = 21, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
            {hour = 22, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
        },
        hoursInterval = {
            {giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}}
        },
    },
})
table.insert(dailSettings, {
    day = 'Niedziela',
    settings = {
        jobsMultipiers = {
            startTime = {
                hour = 11,
                minute = 0,
            },
            stopTime = {
                hour = 23,
                minute = 59,
            },
            list = {
                all = 4,
                crypto = 3,
                mechanik = 3,
                factions = 4,
            },
        },
        onPlayersCount = {
            {count = 40, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}},
            {count = 50, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 1}},
            {count = 60, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 2}},
            {count = 70, giveType = 'all', reward = {rewardType = 'item', name = 'Diamond Box', data = 'diamond-box', amount = 2}},
            {count = 80, giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 3}},
            {count = 85, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'Legendary Box', amount = 1}},
            {count = 90, giveType = 'all', reward = {rewardType = 'item', name = 'Car Box', data = 'car-box', amount = 2}},
            {count = 100, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 3}},
        },
        onTime = {
            {hour = 12, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 14, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty premium', amount = 1000}},
            {hour = 16, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 18, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},
            {hour = 19, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 20, minute = 0, giveType = 'giveaway', reward = {rewardType = 'diamond', name = 'dni konta Diamond', amount = 7}},
            {hour = 21, minute = 0, giveType = 'giveaway', reward = {rewardType = 'wpln', name = 'wPLN', amount = 100}},
            {hour = 22, minute = 0, giveType = 'giveaway', reward = {rewardType = 'pp', name = 'Punkty Premium', amount = 1000}},

            {hour = 16, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 2}},
            {hour = 18, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Legendary Box', data = 'legendary-box', amount = 1}},
            {hour = 20, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Unique Box', data = 'unique-box', amount = 1}},
            {hour = 21, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
            {hour = 22, minute = 0, giveType = 'all', reward = {rewardType = 'item', name = 'Winter Box', data = 'winter-box', amount = 1}},
        },
        hoursInterval = {
            {giveType = 'all', reward = {rewardType = 'item', name = 'Golden Box', data = 'golden-box', amount = 1}}
        },
    },
})
function getActualDay()
    local time = getRealTime()
    return time.monthday
end

function getActualHour()
    local time = getRealTime()
    return time.hour, time.minute
end

function getActualWeekday()
    local time = getRealTime()
    return time.weekday
end

days = {
    ['0'] = 'Niedziela',
    ['1'] = 'Poniedziałek',
    ['2'] = 'Wtorek',
    ['3'] = 'Środa',
    ['4'] = 'Czwartek',
    ['5'] = 'Piątek',
    ['6'] = 'Sobota',
}

function getTodaysData()
    local weekday = tostring(getActualWeekday())
    local data = {}
    for i,v in pairs(dailSettings) do
        if (v.day == days[weekday]) then
            return v.settings
        end
    end
    return false
end




jobs = {
    {'magazynier', 'Magazynier'}, {'dostawca', 'Dostawca'}, {'maszynista', 'Maszynista'}, {'kurier', 'Kurier'}, {'kosiarki', 'Kosiarki'},
    {'lawety', 'Lawety'}, {'grzybiarz', 'Grzybiarz'}, {'szambiarz', 'Szambiarz'}, {'smieciarki', 'Smieciarki'}, {'odsniezarki', 'Odśnieżarki'}, {'gornik', 'Górnik'}, 
    {'rybak', 'Rybak'}, {'logistyka', 'Logistyka lądowa'}, {'etransporter', 'E-Transporter'}, {'spedycjaLotnicza', 'Spedycja lotnicza'}, 
    {'import', 'Import/Export'},
}

othersJobs = {
    {'factions', 'Minuty na służbie frakcji'}, {'crypto', 'Kryptowalutach'}, {'mechanik', 'Minuty na mechaniku'}
}

function findJobName(job)
    for i,v in ipairs(jobs) do
        if v[1] == job then
            return v[2]
        end
    end
    for i,v in ipairs(othersJobs) do
        if v[1] == job then
            return v[2]
        end
    end
    return false
end

vouchers = {
    {'voucher-magazynier', 'Voucher pracy Magazynier'},
    {'voucher-kurier', 'Voucher pracy Kurier'},
    {'voucher-kosiarki', 'Voucher pracy Kosiarki'},
    {'voucher-lawety', 'Voucher pracy Lawety'},
    {'voucher-grzybiarz', 'Voucher pracy Grzybiarz'},
    {'voucher-szambiarz', 'Voucher pracy Szambiarz'},
    {'voucher-smieciarki', 'Voucher pracy Smieciarki'},
    {'voucher-gornik', 'Voucher pracy Górnik'},
    {'voucher-rybak', 'Voucher pracy Rybak'},
    {'voucher-logistyka', 'Voucher pracy Logistyka lądowa'},
    {'voucher-dostawca', 'Voucher pracy Dostawca'},
    {'voucher-maszynista', 'Voucher pracy Maszynista'},
    {'voucher-etransporter', 'Voucher pracy E-Transporter'},
    {'voucher-import', 'Voucher pracy Import/Export'},
    {'voucher-spedycjaLotnicza', 'Voucher pracy Spedycja lotnicza'},
}

texts = {
    ['getTimeFormat'] = function(data)
        return '> **'..data..'**'
    end,

    ['jobsMultipier'] = function(data) 
        return '- Wszystkie prace **x'..data..'** :money_with_wings:'
    end,
    ['faction'] = function(data)
        return '- Minuty na frakcjach **x'..data..'** :office_worker:'
    end,
    ['hoursBox'] = function(data)
        return '- Każdy otrzyma **'..formatReward(data)..'**'
    end,
    ['eventMultipier'] = function(data)
        return '- Drop punktów eventowych `(summer event)` mnożony **x'..data..'** :palm_tree:'
    end,

    ['timeReward'] = function(data)
        return formatRewardWithText(data)
    end,

    ['randomPlayer'] = function(data)
        return '- Losowanie o **'..formatReward(data, true)..'**'
    end,

    ['playersCountRewards'] = function(data)
        local text = '> **Nagrody za ilość graczy**'
        text = '\n'..text
        for i,v in ipairs(data) do
            text = text..'\n'..v.players..' Graczy - `'..formatReward(v.reward)..'`'
        end
        return text
    end,
}

function formatReward(v, emote)
    if v.rewardType == 'box' then
        return v.amount..'x '..v.name..' Box'..(emote and ' :gift:' or '')
    elseif v.rewardType == 'wpln' then
        return v.amount..' wPLN'..(emote and ' :money_with_wings:' or '')
    elseif v.rewardType == 'pp' then
        return v.amount..' PP'..(emote and ' :money_with_wings:' or '')
    else
        return v.amount..'x '..v.name
    end
end

function formatRewardWithText(v)
    if v.type == 'box' then
        return '- Darmowy **'..v.amount..'x '..v.name..' Box** dla każdego gracza :gift:'
    elseif v.type == 'wpln' then
        return '- Losowanie o **'..v.amount..' wPLN** :money_with_wings:' 
    end
end

function formatDailySettingsToDiscordFormat()
    local v = getTodaysData()
    if not v then return false end
    local text = '# :calendar: Plan dnia'
    local saver = {}

    if v.jobsMultipiers then
        local startTime = string.format("%02d:%02d", v.jobsMultipiers.startTime.hour, v.jobsMultipiers.startTime.minute)
        local stopTime = string.format("%02d:%02d", v.jobsMultipiers.stopTime.hour, v.jobsMultipiers.stopTime.minute)

        text = text..'\n## > **Zarobki na pracach** :money_with_wings:'
        text = text..'\n> `'..startTime..'` `-` `'..stopTime..'`'
        for i,k in pairs(v.jobsMultipiers.list) do
            if i == 'all' then
                text = text..'\n- Zarobki na wszystkich pracach **+'..(k*100)..'%**'
            end
        end
        for i,k in pairs(v.jobsMultipiers.list) do
            if i ~= 'all' then
                local name = findJobName(i)
                if name == 'Minuty na służbie frakcji' then
                    text = text..'\n- '..name..' **+'..(k*100)..'%**'
                else
                    text = text..'\n- Zarobek na '..name..' **+'..(k*100)..'%**'
                end
            end
        end

    end 

    if v.onTime then
        local saver, timeSaver = {}, {}

        text = text..'\n## > **W ciągu dnia** :gift:'
        for i,k in ipairs(v.onTime) do
            local time = string.format("%02d:%02d", k.hour, k.minute)
            local forWho = k.giveType == 'all' and 'Każdy otrzyma' or 'Losowanie o'
            local textSave = forWho..' **'..formatReward(k.reward)..'**'
            if saver[textSave] then
                table.insert(saver[textSave], '`'..time..'`')
            else
                saver[textSave] = {'`'..time..'`'}
            end
        end

        for textSave, times in pairs(saver) do
            local time = table.concat(times, ' ')
            if not timeSaver[time] then
                timeSaver[time] = {}
            end
            table.insert(timeSaver[time], '- '..textSave)
        end

        for time, texts in pairs(timeSaver) do
            text = text..'\n> '..time
            for l, v in ipairs(texts) do
                if l == #texts then
                    if id == all then
                        text = text..'\n'..v
                    else
                        text = text..'\n'..v..'\n'
                    end
                else
                    text = text..'\n'..v
                end
            end
        end

    end

    if v.hoursInterval then
        text = text..'\n## > **Nagrody co godzinę** :gift:'
        for i,k in ipairs(v.hoursInterval) do
            text = text..'\n'..texts['hoursBox'](k.reward)
        end
    end

    if v.onPlayersCount then
        text = text..'\n## > **Nagrody za ilość graczy** :gift:'
        for i,k in ipairs(v.onPlayersCount) do
            text = text..'\n- '..k.count..' Graczy - `'..formatReward(k.reward)..'`'
        end
    end

    text = text..'\n\n<@&1251811872248828027>'

    return text
end

function sendToDiscord()
    local v = formatDailySettingsToDiscordFormat()
    if not v then return false end
    local data = {
        queueName = 'planDnia',
        connectionAttempts = 3,
        connectTimeout = 5000,
        formFields = {
            username = 'Plan dnia',
            content = v,
        },
    }
    fetchRemote('https://discord.com/api/webhooks/1293695311545368589/f0NgaYLBavPtM9FzXIgIBsXnCi5AmfPkOeniluOGK0KsDz5uULrOQpZVQhFsQ9P-vPQl', data, function() end)
    return true
end

function sender()
    local time = getRealTime()
    local hour, minute = time.hour, time.minute
    if (hour >= 8 and minute >= 0) then
        local day, month = time.monthday, time.month
        local rows = exports['since-db']:query('Select * from `since-dailySaver` where `day` = ? and `month` = ?', day, month)
        if #rows == 0 then
            if sendToDiscord() then
                exports['since-db']:query('Insert into `since-dailySaver` (day, month) values (?, ?)', day, month)
            end
        end
    end
end

setTimer(sender, 60000, 0)
setTimer(sender, 1000, 1)
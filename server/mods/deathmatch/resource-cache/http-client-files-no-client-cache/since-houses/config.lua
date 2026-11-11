  

config = {
    days_limit = 14,
}

types = {
    [1] = { 
        size = 'Mała', 
        locators = 3, 
        cost = 500, 
        value = 51000, 
        interior = { 
            int = 6, 
            exit = {2196.16, -1204.32, 1049.02}
        }
    },
    [2] = { 
        size = 'Średnia', 
        locators = 4, 
        cost = 800, 
        value = 51000, 
        interior = { 
            int = 4, 
            exit = {-260.94, 1456.72, 1084.37}
        } 
    },
    [3] = { 
        size = 'Duża', 
        locators = 5, 
        cost = 1000, 
        value = 51000, 
        interior = { 
            int = 5, 
            exit = {140.29, 1366.48, 1083.86}, 
        } 
    },
    [4] = { 
        size = 'Ogromna', 
        locators = 6, 
        cost = 1500, 
        value = 51000, 
        interior = { 
            int = 5, 
            exit = {1261.00, -785.47, 1091.91}
        } 
    },
}
getResourceName(getThisResource(), true, 666754747); if true then return end
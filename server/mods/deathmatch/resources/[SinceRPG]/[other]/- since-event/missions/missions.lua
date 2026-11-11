missions = {
    [1] = {
        missionText = false, -- nie ma wiadomosci, trzeba podejsc do zajonca
        peds = {
            {7, 2090.00684, 1545.29346, 10.82031, 45, animation = {'GRAVEYARD', 'mrnF_loop', true, false}, dialog = 'first'},
        }
    },
    [2] = {
        missionText = 'Udaj sie do pomocnika zająca', -- nie ma wiadomosci, trzeba podejsc do zajonca
        peds = {
            {269, 2069.87354, 1586.02795, 10.6796, 180, animation = {'ped', 'IDLE_tired'}, dialog = 'pomocnik'},
        }
    },
    [3] = {
        missionText = function()
            local found = 0
            for i = 1, 50 do
                if getEventData('event:pickups:3:' .. i) then
                    found = found + 1
                end
            end

            if found == 3 then
                setMissionStatus(4)
                return
            end

            return 'Znajdz 50 jajek\nZnaleziono: ' .. found .. '/50'
        end,
        pickups = {
            {1254, 2078.81860, 1607.89746, 10.82031},
            {1254, 2086.11255, 1609.86121, 10.82031},
            {1254, 2081.61621, 1601.08142, 10.82030}
        }
    },
    [4] = {
        missionText = 'Brakuje jednego jajka, idz do przyjaciela pomocnika',
        peds = {
            {269, 2076.04150, 1584.71802, 10.67188, 45, animation = {'ped', 'IDLE_tired'}, dialog = 'przyjaciel'},
        }
    },
    [5] = {
        missionText = function()
            local found = getEventData('event:pickups:5:1')

            if found then
                setMissionStatus(6)
                return
            end

            return 'Jedz po ziolo na meline'
        end,
        pickups = {
            {1279, 2071.96411, 1599.44702, 10.67966},
        }
    },
    [6] = {
        missionText = 'Zanies ziolo do pomocnika',
        peds = {
            {269, 2076.04150, 1584.71802, 10.67188, 45, animation = {'ped', 'IDLE_tired'}, dialog = 'oddajziolo'},
        }
    },
    [7] = {
        missionText = 'Oddaj jajka pomocnikowi',
        peds = {
            {7, 2072.70752, 1571.20471, 10.67188, 45, animation = {'ped', 'IDLE_tired'}, dialog = 'oddajjajka'},
        }
    },
    [8] = {
        missionText = 'Zawiez polowe jajek do magazynu',
        peds = {
            {7, 2055.42896, 1598.41467, 10.80235, 90, animation = {'ped', 'IDLE_tired'}, dialog = 'zawiezjajka'},
        },
    },
    [9] = {
        missionText = 'Udaj sie do zajonca',
        peds = {
            {7, 2043.48596, 1598.17212, 10.67188, 90, animation = {'ped', 'IDLE_tired'}, dialog = 'okradlizajaca'},
        },
    },
    [10] = {
        -- missionText = 'Zawiez polowe jajek do magazynu\nMożesz zakradać się za ich plecami!',
        missionText = function()
            local found = getEventData('event:pickups:10:1')

            if found then
                setMissionStatus(11)
                return
            end

            return 'Znajdz ukradzione jajka'
        end,
        peds = {
            {7, 2042.65588, 1568.16187, 10.67188, 0, weapon = 31, seek = 10},
            {7, 2048.65588, 1568.16187, 10.67188, 0, weapon = 31, seek = 10},
        },
        objects = {
            {2604, 2042.54700, 1569.32727, 10.07188},
            {2604, 2045.54700, 1569.32727, 10.07188},
            {2604, 2047.54700, 1571.32727, 10.07188, 0, 0, 90},
            {2604, 2040.54700, 1571.32727, 10.07188, 0, 0, 90},
        },
        pickups = {
            {1254, 2044.86646, 1570.74817, 10.67188},
        }
    },
    [11] = {
        missionText = 'Zanies jajka do zajonca',
        peds = {
            {7, 2042.65588, 1568.16187, 10.67188, 0, weapon = 31, seek = 10},
            {7, 2048.65588, 1568.16187, 10.67188, 0, weapon = 31, seek = 10},
            {7, 2043.48596, 1598.17212, 10.67188, 90, animation = {'ped', 'IDLE_tired'}, dialog = 'finish'},
        },
        objects = {
            {2604, 2042.54700, 1569.32727, 10.07188},
            {2604, 2045.54700, 1569.32727, 10.07188},
            {2604, 2047.54700, 1571.32727, 10.07188, 0, 0, 90},
            {2604, 2040.54700, 1571.32727, 10.07188, 0, 0, 90},
        },
    },
}
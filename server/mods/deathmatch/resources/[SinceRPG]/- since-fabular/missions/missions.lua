missions = {
    [1] = {
        peds = {
            {20000, -1630.39, -2234.01, 31.48, 139.15, animation = {'ped', 'idle_gang1', true, false}, dialog = 'szkielet_poczatek'},
        }
    },
    
    [2] = {
        missionText = 'Udaj się do jednego z lasów obok Los Santos\nw kierunku Las Venturas i odnajdź chatkę czarownika',

        peds = {
            
            {20001, 2361.20, -645.39, 128.22, 'random', seek = 10},
            {20001, 2362.20, -646.39, 128.22, 'random', seek = 10},
            {20001, 2360.20, -647.39, 128.22, 'random', seek = 10},
            {20001, 2363.20, -648.39, 128.22, 'random', seek = 10},
            {20001, 2351.20, -649.39, 128.22, 'random', seek = 10},
            {20001, 2364.20, -650.39, 128.22, 'random', seek = 10},
            {20001, 2366.20, -651.39, 128.22, 'random', seek = 10},
            {20001, 2367.20, -652.39, 128.22, 'random', seek = 10},
            {20001, 2368.20, -653.39, 128.22, 'random', seek = 10},
            {20001, 2369.20, -654.39, 128.22, 'random', seek = 10},
            {20001, 2351.20, -655.39, 128.22, 'random', seek = 10},
            {20001, 2352.20, -656.39, 128.22, 'random', seek = 10},
            {20001, 2353.20, -657.39, 128.22, 'random', seek = 10},
            {20001, 2354.20, -658.39, 128.22, 'random', seek = 10},

            {20001, 2356.79, -647.31, 128.05, 133, animation = {'ped', 'IDLE_tired', true, false}, dialog = 'zombie_poczatek'},

        },

    },

    [3] = {
        missionText = function()
            local found = 0
            for i = 1, 6 do
                if getEventData('event:pickups:3:' .. i) then
                    found = found + 1
                end
            end

            if found == 6 then
                setMissionStatus(4)
                return
            end

            return 'Odnajdź butelki limitowanej\nwódki w okolicach jaskini Bone County #ffffff(' .. found .. ' / 6)'
        end,
        pickups = {

            {1484, -450.16, 1442.21, 21.06, -0.00, 0.00, 193.78},
            {1484, -453.28, 1419.49, 22.74, -0.00, 0.00, 331.15},
            {1484, -466.39, 1503.25, 25.55, -0.00, 0.00, 6.20},
            {1484, -432.06, 1419.64, 19.63, -0.00, 0.00, 192.16},
            {1484, -432.07, 1407.02, 17.81, -0.00, 0.00, 184.91},
            {1484, -424.37, 1392.06, 15.36, -0.00, 0.00, 212.71},

        },
        peds = {

            {20001, 2361.20, -645.39, 128.22, 'random', seek = 10},
            {20001, 2362.20, -646.39, 128.22, 'random', seek = 10},
            {20001, 2360.20, -647.39, 128.22, 'random', seek = 10},
            {20001, 2363.20, -648.39, 128.22, 'random', seek = 10},
            {20001, 2351.20, -649.39, 128.22, 'random', seek = 10},
            {20001, 2364.20, -650.39, 128.22, 'random', seek = 10},
            {20001, 2366.20, -651.39, 128.22, 'random', seek = 10},
            {20001, 2367.20, -652.39, 128.22, 'random', seek = 10},
            {20001, 2368.20, -653.39, 128.22, 'random', seek = 10},
            {20001, 2369.20, -654.39, 128.22, 'random', seek = 10},
            {20001, 2351.20, -655.39, 128.22, 'random', seek = 10},
            {20001, 2352.20, -656.39, 128.22, 'random', seek = 10},
            {20001, 2353.20, -657.39, 128.22, 'random', seek = 10},
            {20001, 2354.20, -658.39, 128.22, 'random', seek = 10},

            {20001, 2356.79, -647.31, 128.05, 133, animation = {'ped', 'IDLE_tired', true, false}, dialog = 'zombie_powrot_bez'},

        }
    },

    [4] = {
        missionText = 'Wróć z wódką do zombie',
        peds = {

            {20001, 2361.20, -645.39, 128.22, 'random', seek = 10},
            {20001, 2362.20, -646.39, 128.22, 'random', seek = 10},
            {20001, 2360.20, -647.39, 128.22, 'random', seek = 10},
            {20001, 2363.20, -648.39, 128.22, 'random', seek = 10},
            {20001, 2351.20, -649.39, 128.22, 'random', seek = 10},
            {20001, 2364.20, -650.39, 128.22, 'random', seek = 10},
            {20001, 2366.20, -651.39, 128.22, 'random', seek = 10},
            {20001, 2367.20, -652.39, 128.22, 'random', seek = 10},
            {20001, 2368.20, -653.39, 128.22, 'random', seek = 10},
            {20001, 2369.20, -654.39, 128.22, 'random', seek = 10},
            {20001, 2351.20, -655.39, 128.22, 'random', seek = 10},
            {20001, 2352.20, -656.39, 128.22, 'random', seek = 10},
            {20001, 2353.20, -657.39, 128.22, 'random', seek = 10},
            {20001, 2354.20, -658.39, 128.22, 'random', seek = 10},

            {20001, 2356.79, -647.31, 128.05, 133, animation = {'ped', 'IDLE_tired', true, false}, dialog = 'zombie_powrot'},

        }
    },

    [5] = {
        missionText = 'Znajdź Juzka na terenie Bayside Marina',
        peds = {
            {78, -2403.48, 2358.85, 5.08, 70, animation = {'CRACK', 'crckidle2'}, dialog = 'juzek_poczatek'},
        }
    },

    [6] = {
        missionText = 'Udaj się do Mareczka nieopodal molo Los Santos',
        peds = {
            {239, 850.52, -1874.91, 5.63, 42.08, animation = {'ped', 'IDLE_tired'}, dialog = 'mareczek_poczatek'},
        }
    },

    [7] = {
        missionText = 'Udaj się do szkieleta aby przekaż mu księgę',
        peds = {
            {20000, -1630.39, -2234.01, 31.48, 139.15, animation = {'ped', 'idle_gang1', true, false}, dialog = 'szkielet_koniec'},
        }
    },

}
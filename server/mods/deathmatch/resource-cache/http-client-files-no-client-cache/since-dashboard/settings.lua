settings = {

    {
        name = 'Cienie SSAQ',
        data = 'ssaqShadows',
        fnc = function(state)
            exports['enb_shadows']:toggleShader(state)
            
            return true
        end,
    },
    
    {
        name = 'Realistyczna woda',
        data = 'realWater',
        fnc = function(state)
            exports['enb_water']:toggleShader(state)

            return true
        end,
    },

    {
        name = 'Błyszcząca karoseria pojazdów',
        data = 'shinyVehs',
        fnc = function(state)
            exports['enb_car']:toggleShader(state)

            return true
        end,
    },

    {
        name = 'Rozmycie odległych terenów',
        data = 'terrainBlur',
        fnc = function(state)
            exports['enb_depth']:toggleShader(state)

            return true
        end,
    },

    {
        name = 'Realistyczne niebo',
        data = 'betterSky',
        fnc = function(state)
            exports['enb_sky']:toggleShader(state)

            return true
        end,
    },

    {
        name = 'Detale tekstur podłoża',
        data = 'texDetail',
        fnc = function(state)
            exports['enb_detail']:toggleShader(state)

            return true
        end,
    },

    {
        name = 'Zwiększony dystans rysowania obiektów',
        data = 'farClip',
        fnc = function(state)
            if not state then
                resetFarClipDistance()
            else
                setFarClipDistance(3500)
            end

            return true
        end,
    },

   -- {
   --     name = 'Wyłącz pogodę halloween',
   --     data = 'halloween',
   --     fnc = function(state)
   --         return true
   --     end,
   -- },

    {
        name = 'Renderuj chmury',
        data = 'showClouds',
        fnc = function(state)
            if not state then
                setCloudsEnabled(false)
            else
                setCloudsEnabled(true)
            end

            return true
        end,
    },

    {
        name = 'Wymuś używanie minimapy z GTA:SA',
        data = 'showRadars',
        fnc = function(state)
            if not state then
                exports['since-radar']:switchCustomRadar(true)
            else
                exports['since-radar']:switchCustomRadar(false)
            end

            return true
        end,
    },

    {
        name = 'Używaj celownika z GTA:SA',
        data = 'toggleCrosshair',
        fnc = function(state)
            if state then
                setPlayerHudComponentVisible('crosshair', true)
            else
                setPlayerHudComponentVisible('crosshair', false)
            end

            return true
        end,
    },

    {
        name = 'Wyłącz dźwięki stereo',
        data = 'stereoSounds',
        fnc = function(state)
            exports['since-stereo']:changeStereoToggle(not state)

            return true
        end,
    },

    {
        name = 'Śnieg #e35656(Wymaga wyłączenia shaderu detali tekstur podłoża)',
        data = 'renderSnow',
        fnc = function(state)
            exports['enb_snow']:toggleShader(state)

            return true
        end,
    },

    {
         name = 'Opady śniegu',
         data = 'snowFlakes',
         fnc = function(state)
             exports['enb_snowFlakes']:toggleShader(state)

             return true
         end,
     },

    {
        name = 'Szybki wybór w ekwipunku',
        data = 'quickEQ',
        fnc = function(state)
            if not state then
                setElementData(localPlayer, 'player:quickEQ', false)
            else
                setElementData(localPlayer, 'player:quickEQ', true)
            end

            return true
        end,
    },

    {
        name = 'Wyłącz kolorowy dym spod opon #8fff87(Dodaje FPS)',
        data = 'customSmoke',
        fnc = function(state)
            exports['since-tiresmoke']:toggleSmoke(state)

            return true
        end,
    },

    {
        name = 'Wyłącz dźwięki turbiny',
        data = 'turboSounds',
        fnc = function(state)
            return true
        end,
    },

    -- {
    --     name = 'Wyłącz rozmycie w interfejsie #8fff87(Dodaje FPS)',
    --     data = 'drawBlurUI',
    --     fnc = function(state)
    --         return true
    --     end,
    -- },

    {
        name = 'Wyłącz customowe koła #8fff87(Dodaje FPS)',
        data = 'hideWheels',
        fnc = function(state)
            if not state then
                exports['since-wheelmod']:hideWheels(false)
            else
                exports['since-wheelmod']:hideWheels(true)
            end

            return true
        end,
    },

    {
        name = 'Wyłącz neony #8fff87(Dodaje FPS)',
        data = 'hideNeons',
        fnc = function(state)
            if not state then
                exports['since-neons']:toggleNeons(true)
            else
                exports['since-neons']:toggleNeons(false)
            end

            return true
        end,
    },

    -- {
    --     name = 'Wyłącz paintjoby #8fff87(Dodaje FPS)',
    --     data = 'hidePaintjobs',
    --     fnc = function(state)
    --         if not state then
    --             exports['since-custompaintjob']:togglePaintjobs(true)
    --         else
    --             exports['since-custompaintjob']:togglePaintjobs(false)
    --         end

    --         return true
    --     end,
    -- },

    {
        name = 'Ukryj nametagi #8fff87(Dodaje FPS)',
        data = 'showNametags',
        fnc = function(state)
            return true
        end,
    },

    {
        name = 'Ukryj HUD serwera',
        data = 'hideHUD',
        fnc = function(state)
            return true
        end,
    },


    {
        name = "Użyj starego HUD'u",
        data = 'oldHUD',
        fnc = function(state)
            return true
        end,
    },

    {
        name = 'Pokaż swój nametag',
        data = 'showUrNametag',
        fnc = function(state)
            return true
        end,
    },

    {
        name = 'Ukryj vopisy #8fff87(Dodaje FPS)',
        data = 'showDesc',
        fnc = function(state)
            return true
        end,
    },

    {
        name = 'Wyłącz efekt kameleona #8fff87(Dodaje FPS)',
        data = 'showCameleon',
        fnc = function(state)
            return true
        end,
    },

    {
        name = 'Wyłącz efekt lamp RGB #8fff87(Dodaje FPS)',
        data = 'showRGBLights',
        fnc = function(state)
            return true
        end,
    },

    {
        name = 'Wyłącz radio w różnych miejscach',
        data = 'turnOffRadio',
        fnc = function(state)
            if not state then
                exports['since-radio3d']:setRadioVolume(1)
            else
                exports['since-radio3d']:setRadioVolume(0)
            end

            return true
        end,
    },

    {
        name = 'Ukryj avatary w nametagach',
        data = 'showNametagsAvatar',
        fnc = function(state)
            if not state then
                setElementData(localPlayer, 'player:nametags:avatar', false)
            else
                setElementData(localPlayer, 'player:nametags:avatar', true)
            end

            return true
        end,
    },

    {
        name = 'Ukryj ogłoszenia',
        data = 'showAnnouncements',
        fnc = function(state)
            return true
        end,
    },

    {
        name = 'Status RP',
        data = 'statusRP',
        fnc = function(state)
            return true
        end,
    },

}

function switchPassiveMode(state)
    if state then
        setElementData(localPlayer, 'player:passive', true)
    else
        setElementData(localPlayer, 'player:passive', false)
    end
end

function setPlayerSetting(tbl, state)
    local playerSettings = getElementData(localPlayer, 'player:settings') or {}

    playerSettings[tbl.data] = state
    
    local q = tbl.fnc(state)
    if q then setElementData(localPlayer, 'player:settings', playerSettings) else print('Settings error') end
end

function getSettingsState(data)
    local playerSettings = getElementData(localPlayer, 'player:settings') or {}

    return playerSettings[data]
end

addEvent("switchSettings", true)
addEventHandler("switchSettings", root, function()
    local plrsett = getElementData(localPlayer, 'player:settings') or {}

    for i, v in pairs(plrsett) do
        for ii,vv in ipairs(settings) do
            if v and v == true and i == vv.data then
                vv.fnc(true)
            end
        end
    end
end)
getResourceName(getThisResource(), true, 574951438); if true then return end
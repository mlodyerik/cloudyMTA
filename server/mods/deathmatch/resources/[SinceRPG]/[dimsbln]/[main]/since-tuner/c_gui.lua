local mechanic = nil

function calculateCost()
    local veh = getPedOccupiedVehicle(localPlayer)
    local original = getOriginalTune()
    local cost = 0

    if variants[getElementData(veh, 'vehicleID') or getElementModel(veh)] then
        local v1, v2 = getVehicleVariant(veh)
        if v1 ~= original.variant[1] or v2 ~= original.variant[2] then
            for i,v in ipairs(variants[getElementData(veh, 'vehicleID') or getElementModel(veh)]) do
                if type(v.id) == "table" then
                    if v.id[1] == v1 and v.id[2] == v2 then
                        cost = v.cena
                        break
                    end
                else
                    if v.id == v1 or v.id == v2 then
                        cost = v.cena
                        break
                    end
                end
            end
        end
    end
    
    for i = 0, 16 do
        local up = getVehicleUpgradeOnSlot(veh, i)
        if up and original[i] ~= up and partPrices[up] then
            cost = cost + partPrices[up]
        elseif (not up or up == 0) and (original[i] and original[i] ~= 0) then
            cost = cost - math.floor(partPrices[original[i]]*0.25)
        end
    end

    local data = (getElementData(veh, "vehicle:wheelTuning") or {
		innerSize = 1,
		wheelResize = 1,
		wheelTilt = 0,
	})
    local diff = math.floor(math.abs((original.data.innerSize or 0) - (data.innerSize or 0))*100)
    if diff > 0 then
        cost = cost + tonumber(diff)*partPrices.cale/5
    end

    local diff = math.floor(math.abs((original.data.wheelResize or 0) - (data.wheelResize or 0))*100)
    if diff > 0 then
        cost = cost + tonumber(diff)*partPrices.szerokosc/5
    end

    local diff = math.floor(math.abs((original.data.wheelTilt or 0) - (data.wheelTilt or 0))*100)
    if diff > 0 then
        cost = cost + tonumber(diff)*partPrices.negatyw/5*0.05
    end

    local tint = (getElementData(veh, "vehicle:carTint") or 0)
    local diff = math.floor(math.abs(original.tint - tint))
    if diff > 0 then
        cost = cost + tonumber(diff)*partPrices.szyby/5
    end

    local vehData = getElementData(veh, "vehicle:data") or {}
    local pojemnoscsilnika = tonumber(vehData.engine or 1.2)
    local diff = math.abs(original.pojemnoscsilnika - pojemnoscsilnika)
    if diff > 0 then
        cost = cost + tonumber(diff)*(1/0.2)*partPrices.pojemnoscsilnika
    end

    local fuelData = getElementData(veh, "vehicle:fuel") or {}
    local pojemnoscbaku = tonumber(fuelData.tank or 25)
    local diff = math.abs(original.pojemnoscbaku - pojemnoscbaku)
    if diff > 0 then
        cost = cost + tonumber(diff)*(1/5)*partPrices.pojemnoscbaku
    end

    return cost
end

local tuning = {
    ['category'] = {
        [1] = {
            ['name'] = "Wizualny",
            ['desc'] = "Ulepsz wygląd pojazdu",
            ['subCategory'] = {
                {name = "Felgi", type = 'felgi', inner=true},
                {name = "Spoiler", type = 'spoiler', inner=true},
                {name = "Wydech", type = 'wydech', inner=true},
                {name = "Progi", type = 'progi', inner=true},
                {name = "Przedni zderzak", type = 'p_zderzak', inner=true},
                {name = "Tylni zderzak", type = 't_zderzak', inner=true},
                {name = "Wloty powietrza", type = 'wloty', inner=true},
                {name = "Warianty", type = 'warianty', inner=true}
            },
        },
        [2] = {
            ['name'] = "Mechaniczny",
            ['desc'] = "Zwiększ osiągi pojazdu",
            ['subCategory'] = {
                {name = "Moduł MK1", desc="Regulacja prędkości maksymalnej", type = 'mk1', inner=false, cost=40000000},
                {name = "Moduł MK2", desc="Regulacja przyspieszenia", type = 'mk2', inner=false, cost=50000000},
                {name = "Moduł MK3", desc="Zmiana napędu", type = 'mk3', inner=false, cost=60000000},
                {name = "Regulacja zawieszenia", desc="Możliwość regulacji zawieszenia", type = 'gz', inner=false, cost=20000000},
                {name = "Turbo", desc="", type = 'turbo', inner=false, cost=35000000},
                {name = "Nitro", desc="Butla z podtlenkiem azotu", type = 'nitro', inner=false, cost=40000000},
                {name = "System ABS", desc="Przeciwblokujący układ hamulcowy", type = 'abs', inner=false, cost=25000000},
                {name = "Instalacja LPG", desc="", type = 'lpg', inner=false, cost=25000000},
                {name = "Aplikacja transportowa", desc="Pozwala pracować jako taksówkarz", type = 'taxi', inner=false, cost=50000000},
                {name = "Driftmode", desc="Handling do driftu", type = 'driftmode', inner=false, cost=60000000},
                {name = "Neony", desc="Oświetlenie pod pojazdem", type = 'neon', inner=false, cost=45000000},
                {name = "Remont silnika", desc="Zeruje przebieg pojazdu oraz dane techniczne silnika", type = 'remontsilnika', inner=false, cost=50000000},
            },
        },
        [3] = {
            ['name'] = "Modyfikatory",
            ['desc'] = "Modyfikuj pojazd",
            ['subCategory'] = "mods",
        },
        [4] = {
            ['name'] = "Zakup",
            ['desc'] = "Zapisuje aktualny tuning",
            ['use'] = function()
                if getPlayerMoney() < calculateCost() then
                    return exports['since-notifications']:sendNotification("error", "Nie posiadasz tyle gotówki")
                end
                exports['since-notifications']:sendNotification("success", "Zakupiono tuning!")
                buyTuning()
                hideUI()
            end
        },
        [5] = {
            ['name'] = "Zamknij",
            ['desc'] = "Porzuca aktualny tuning",
            ['use'] = function()
                restoreDefaultTuning()
                hideUI()
            end
        },
    },
    ['statistic'] = {
        {'Przyśpieszenie', 30, "engineAcceleration"},
        {'Prędkość maksymalna', 350, "maxVelocity"},
        {'Sterowanie', 50, "steeringLock"},
        {'Przyczepność', 1.5, "tractionLoss"}
    },
    ['selectedCategory'] = 1,
    ['selectedCategoryName'] = 'category',
    ['selectedSubCategoryName'] = nil,
}

function getDemontPrice(id)
    local original = getOriginalTune()
    local up = original[id]
    if not up or up == 0 then return 0 end

    return -math.floor(partPrices[up]*0.25)
end

local parts = {
    ["warianty"] = function()
        local t = {}
        local tbl = variants[getElementData(getPedOccupiedVehicle(localPlayer), 'vehicleID') or getElementModel(getPedOccupiedVehicle(localPlayer))] or {}
        for k,v in ipairs(tbl) do
            table.insert(t, {
                name = v.name,
                var = v.id,
                cena = v.cena,
            })
        end
        return t
    end,

    ["felgi"] = function()
        local t = {
            {
                name = "Brak (Demontaż)",
                id = "demontaz",
                demont = 12,
            }
        }
        local temp = createVehicle(getElementModel(getPedOccupiedVehicle(localPlayer)), 255, 255, 255)
        for k,v in pairs({1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098}) do
            if addVehicleUpgrade(temp, v) then
                table.insert(t, {
                    name=partNames[v] .. "  (" .. v .. ")",
                    id = v,
                    cost=1250,
                })
            end
        end
        destroyElement(temp)
        return t
    end,

    ["wloty"] = function()
        local t = {
            {
                name = "Brak (Demontaż)",
                id = "demontaz",
                demont = 7,
            }
        }
        local temp = createVehicle(getElementModel(getPedOccupiedVehicle(localPlayer)), 255, 255, 255)
        for k,v in pairs({1035, 1038, 1006, 1032, 1033, 1053, 1054, 1055, 1061, 1068, 1067, 1088, 1091, 1103, 1128, 1130, 1131, 1004, 1005, 1011, 1012, 1142, 1143, 1144, 1145}) do
            if addVehicleUpgrade(temp, v) then
                table.insert(t, {
                    name=((partNames[v]) and (partNames[v] .. "  (" .. v .. ")") or tostring(v)),
                    id = v,
                    cost=500,
                })
            end
        end
        destroyElement(temp)
        return t
    end,

    ["spoiler"] = function()
        local t = {
            {
                name = "Brak (Demontaż)",
                id = "demontaz",
                demont = 2,
            }
        }
        local temp = createVehicle(getElementModel(getPedOccupiedVehicle(localPlayer)), 255, 255, 255)
        for k,v in pairs({1000, 1001, 1002, 1003, 1014, 1015, 1016, 1023, 1049, 1050, 1058, 1060, 1138, 1139, 1146, 1147, 1158, 1162, 1163, 1164}) do
            if addVehicleUpgrade(temp, v) then
                table.insert(t, {
                    name=partNames[v] .. "  (" .. v .. ")",
                    id = v,
                    cost=500,
                })
            end
        end
        destroyElement(temp)
        return t
    end,

    ["p_zderzak"] = function()
        local t = {
            {
                name = "Brak (Demontaż)",
                id = "demontaz",
                demont = 14,
            }
        }
        local temp = createVehicle(getElementModel(getPedOccupiedVehicle(localPlayer)), 255, 255, 255)
        for k,v in pairs({1185, 1188, 1189, 1190, 1191, 1182, 1181, 1179, 1176, 1174, 1173, 1172, 1171, 1169, 1166, 1165, 1160, 1157, 1152, 1117}) do
            if addVehicleUpgrade(temp, v) then
                table.insert(t, {
                    name= 'Zderzak' .. "  (" .. v .. ")",
                    id = v,
                    cost=500,
                })
            end
        end
        destroyElement(temp)
        return t
    end,

    ["t_zderzak"] = function()
        local t = {
            {
                name = "Brak (Demontaż)",
                id = "demontaz",
                demont = 15,
            }
        }
        local temp = createVehicle(getElementModel(getPedOccupiedVehicle(localPlayer)), 255, 255, 255)
        for k,v in pairs({1141, 1140, 1148, 1149, 1150, 1151, 1154, 1156, 1159, 1167, 1168, 1175, 1177, 1180, 1183, 1184, 1192, 1193}) do
            if addVehicleUpgrade(temp, v) then
                table.insert(t, {
                    name= 'Zderzak' .. "  (" .. v .. ")",
                    id = v,
                    cost=500,
                })
            end
        end
        destroyElement(temp)
        return t
    end,

    ["progi"] = function()
        local t = {
            {
                name = "Brak (Demontaż)",
                id = "demontaz",
                demont = 3,
            }
        }
        local temp = createVehicle(getElementModel(getPedOccupiedVehicle(localPlayer)), 255, 255, 255)
        for k,v in pairs({1036, 1039, 1040, 1041, 1007, 1017, 1026, 1027, 1030, 1031, 1042, 1047, 1048, 1051, 1052, 1056, 1057, 1062, 1063, 1069, 1070, 1071, 1072, 1090, 1093, 1094, 1095, 1099, 1101, 1102, 1106, 1107, 1108, 1118, 1119, 1120, 1121, 1122, 1124, 1133, 1134, 1137}) do
            if addVehicleUpgrade(temp, v) then
                table.insert(t, {
                    name=partNames[v] .. "  (" .. v .. ")",
                    id = v,
                    cost=500,
                })
            end
        end
        destroyElement(temp)
        return t
    end,

    ["wydech"] = function()
        local t = {
            {
                name = "Brak (Demontaż)",
                id = "demontaz",
                demont = 13,
            }
        }
        local temp = createVehicle(getElementModel(getPedOccupiedVehicle(localPlayer)), 255, 255, 255)
        local c = {1034, 1037, 1044, 1046, 1018, 1019, 1020, 1021, 1022, 1028, 1029, 1043, 1044, 1045, 1059, 1064, 1065, 1066, 1089, 1092, 1104, 1105, 1113, 1114, 1126, 1127, 1129, 1132, 1135, 1136}
        for k,v in pairs(c) do
            if addVehicleUpgrade(temp, v) then
                table.insert(t, {
                    name=partNames[v] .. "  (" .. v .. ")",
                    id = v,
                    cost=500,
                })
            end
        end
        destroyElement(temp)
        return t
    end,

    ["mods"] = function()
        return {
            {
                name = "Cale felgi",
                id = "cale",

                suwak = true,
                min = function(veh) if veh then return 0.6 end end,
                max = function(veh) if veh then return 1.1 end end,
                snap = 0.05,

                get = function()
                    local data = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning") or {})
                    return (data.innerSize or 1)
                end,
                set = function(c)
                    local data = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning") or {})
                    data.innerSize = c
                    data.wheelResize = (data.wheelResize or 1)
                    data.wheelTilt = (data.wheelTilt or 0)
                    setElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning", data, false)
                end
            },
            {
                name = "Szerokość opon",
                id = "szerokosc",

                suwak = true,
                min = function(veh) if veh then return 0.8 end end,
                max = function(veh) if veh then return 1.9 end end,
                snap = 0.05,

                get = function()
                    local data = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning") or {})
                    return (data.wheelResize or 1)
                end,
                set = function(c)
                    local data = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning") or {})
                    data.wheelResize = c
                    data.innerSize = (data.innerSize or 1)
                    data.wheelTilt = (data.wheelTilt or 0)
                    setElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning", data, false)
                end
            },
            {
                name = "Negatyw",
                id = "negatyw",

                suwak = true,
                min = function(veh) if veh then return -15 end end,
                max = function(veh) if veh then return 10 end end,
                snap = 1,

                get = function()
                    local data = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning") or {})
                    return (data.wheelTilt or 1)
                end,
                set = function(c)
                    local data = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning") or {})
                    data.wheelTilt = c
                    data.innerSize = (data.innerSize or 1)
                    data.wheelResize = (data.wheelResize or 0)
                    setElementData(getPedOccupiedVehicle(localPlayer), "vehicle:wheelTuning", data, false)
                end
            },
            {
                name = "Przyciemniane szyby",
                id = "szyby",

                suwak = true,
                min = function(veh) if veh then return 0 end end,
                max = function(veh) if veh then return 100 end end,
                snap = 5,

                get = function()
                    local data = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:carTint") or 0)
                    return data
                end,
                set = function(c)
                    setElementData(getPedOccupiedVehicle(localPlayer), "vehicle:carTint", c, false)
                end
            },
            {
                name = "Pojemność silnika",
                id = "pojemnoscsilnika",

                suwak = true,
                min = function(veh) if veh then return 1.2 end end,
                max = function(veh) 
                    local upgrades = getElementData(veh, "vehicle:upgrades") or {}

                    if upgrades['sport'] then
                        return 6.0
                    else
                        return 4.0
                    end
                end,
                snap = 0.2,

                get = function()
                    local vehData = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:data") or {}
                    local data = tonumber(vehData.engine or 1.2)
                    return data
                end,
                set = function(c)
                    local vehData = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:data") or {}
                    vehData.engine = tostring(("%.1f"):format(c))
                    setElementData(getPedOccupiedVehicle(localPlayer), 'vehicle:data', vehData)
                end
            },
            {
                name = "Pojemność baku",
                id = "pojemnoscbaku",

                suwak = true,
                min = function(veh) if veh then return 25 end end,
                max = function(veh) if veh then return 100 end end,
                snap = 5,

                get = function()
                    local fuelData = (getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:fuel") or {})
                    local data = tonumber(fuelData.tank or 25)
                    return data
                end,
                set = function(c)
                    local fuelData = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:fuel") or {}
                    fuelData.tank = tonumber(c)
                    setElementData(getPedOccupiedVehicle(localPlayer), 'vehicle:fuel', fuelData)
                end
            },
        }
    end,
}

function getVehicleHandlingProperty(element, property)
    if isElement(element) and getElementType(element) == "vehicle" and type(property) == "string" then
        local handlingTable = getVehicleHandling(element) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
    return false
end

function renderUI()
    local veh = getPedOccupiedVehicle(localPlayer)

    exports['since-blur']:dxDrawBlur(0, 0, 350/zoom, sy)
    dxDrawRectangle(0, 0, 350/zoom, sy, tocolor(75, 75, 75, 200))
    dxDrawImage(0, 25/zoom, 350/zoom, 120/zoom, 'logo.png')

    if tuning['selectedCategoryName'] == 'category' then
        offsetY = 0
        for i, v in ipairs(tuning[tuning['selectedCategoryName']]) do
            local ifElse = tuning['selectedCategory'] == i and tocolor(46, 117, 111, 100) or tocolor(155, 155, 155, 100)
            dxDrawRectangle(0, 185/zoom + offsetY, 350/zoom, 50/zoom, ifElse)
            local ifElse = tuning['selectedCategory'] == i and 255 or 155
            dxDrawText(v['name'], 10/zoom, 211/zoom + offsetY, nil, nil, tocolor(255, 255, 255, ifElse), 1, font2, "left", "center", false, false, false, false, false)

            offsetY = offsetY + (50/zoom + 1)
        end
    elseif type(tuning['selectedCategoryName']) == "table" then
        offsetY = 0
        for i, v in ipairs(tuning['selectedCategoryName']['subCategory']) do
            local ifElse = tuning['selectedCategory'] == i and tocolor(46, 117, 111, 100) or tocolor(155, 155, 155, 100)
            dxDrawRectangle(0, 185/zoom + offsetY, 350/zoom, 50/zoom, ifElse)
            local ifElse = tuning['selectedCategory'] == i and 255 or 155
            if v.desc and #v.desc > 0 then
                dxDrawText(v.name, 10/zoom, 203/zoom + offsetY, nil, nil, tocolor(255, 255, 255, ifElse), 1, font2, "left", "center", false, false, false, false, false)
                dxDrawText(v.desc, 10/zoom, 219/zoom + offsetY, nil, nil, tocolor(255, 255, 255, ifElse), 1, font5, "left", "center", false, false, false, false, false)
            else
                dxDrawText(v.name, 10/zoom, 211/zoom + offsetY, nil, nil, tocolor(255, 255, 255, ifElse), 1, font2, "left", "center", false, false, false, false, false)
            end

            if v.cost then
                local upgrades = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:upgrades") or {}
                if upgrades[v.type] then
                    dxDrawText("Demont: ".. v.cost/2 .." $", 10/zoom + 1, 208/zoom + 1 + offsetY, 340/zoom + 1, nil, tocolor(55,225,55,ifElse), 1, font5, "right", "center", false, false, false, false, false)
                else
                    dxDrawText(v.cost .. " $", 10/zoom + 1, 208/zoom + 1 + offsetY, 340/zoom + 1, nil, v.cost > 0 and tocolor(85,155,255,ifElse) or (v.cost == 0 and tocolor(155, 155, 155, ifElse) or tocolor(55,200,55,ifElse)), 1, font5, "right", "center", false, false, false, false, false)
                end
            end

            offsetY = offsetY + (50/zoom + 1)
        end
    else
        local data = parts[tuning['selectedCategoryName']]
        if data then
            local c = data()
            offsetY = 0
            for i, v in ipairs(c) do
                if i >= (scroll or 1) and i <= (scroll or 1)+11 then
                    local ifElse = tuning['selectedCategory'] == i and tocolor(46, 117, 111, 100) or tocolor(155, 155, 155, 100)
                    dxDrawRectangle(0, 185/zoom + offsetY, 350/zoom, 50/zoom, ifElse)
                    local ifElse = tuning['selectedCategory'] == i and 255 or 155
                    dxDrawText(v.name, 10/zoom, 211/zoom + offsetY, nil, nil, tocolor(255, 255, 255, ifElse), 1, font2, "left", "center", false, false, false, false, false)
                    
                    if v.suwak then
                        local w = dxGetTextWidth(v.name, 1, font2)
                        local ifElse = tuning['selectedCategory'] == i and tocolor(46, 117, 111, 100) or tocolor(46, 117, 111, 55)
                        local x = 20/zoom + w
                        local tx = 260/zoom
                        local _w = tx - x
                        
                        local current = v.get()
                        
                        --dxDrawRectangle(x, 107/zoom + offsetY, _w, 5/zoom, ifElse)
                        dxDrawRectangle(x, 207/zoom + offsetY - 2/zoom, _w, 8/zoom, ifElse)
                        
                        local min = v.min(veh)
                        local max = v.max(veh)
                        local prg = (current - min)/(max - min)
                        local ifElse = tuning['selectedCategory'] == i and tocolor(46, 117, 111, 155) or tocolor(46, 117, 111, 75)
                        dxDrawRectangle(x, 207/zoom + offsetY - 2/zoom, _w*prg, 8/zoom, ifElse)

                        if getKeyState("arrow_l") and (lastTick or 0) < getTickCount() and tuning['selectedCategory'] == i then
                            v.set(math.max(current - v.snap, min))
                            lastTick = getTickCount() + 150
                        elseif getKeyState("arrow_r") and (lastTick or 0) < getTickCount() and tuning['selectedCategory'] == i then
                            v.set(math.min(current + v.snap, max))
                            lastTick = getTickCount() + 150
                        end
                    end
                    
                    local price = v.cena or partPrices[v.id]
                    if v.id == "demontaz" then
                        price = getDemontPrice(v.demont)
                    end
                    dxDrawText(price .. " $", 10/zoom, 210/zoom + offsetY, 340/zoom, nil, price > 0 and tocolor(46,117,111,ifElse) or (price == 0 and tocolor(255, 255, 255, ifElse) or tocolor(46,117,111,ifElse)), 1, font5, "right", "center", false, false, false, false, false)

                    offsetY = offsetY + (50/zoom + 1)
                end
            end
        end
    end

    dxDrawText("Portfel", 0, sy - 30/zoom, 350/zoom, nil, tocolor(67, 143, 135, 255), 1, font3, "center", "bottom", false, false, false, false, false)
    dxDrawText(convertNumber(getPlayerMoney(localPlayer)).." $", 0, sy - 30/zoom, 350/zoom, nil, tocolor(46, 117, 111, 255), 1, font2, "center", "top", false, false, false, false, false)
    dxDrawText("Koszt tuningu", 0, sy - 85/zoom, 350/zoom, nil, tocolor(67, 143, 135, 255), 1, font3, "center", "bottom", false, false, false, false, false)
    dxDrawText(convertNumber(calculateCost()).." $", 0, sy - 85/zoom, 350/zoom, nil, tocolor(46, 117, 111, 255), 1, font2, "center", "top", false, false, false, false, false)
    dxDrawText("Klawiszologia", sx - 20/zoom, sy - 115/zoom, nil, nil, tocolor(46, 117, 111, 255), 1, font3, "right", "bottom", false, false, false, false, false)
    dxDrawText("LPM - Poruszanie kamerą\nScroll - Przybliżanie/Oddalanie kamery\nEnter - Zatwierdź\nBackspace - Cofnij", sx - 20/zoom, sy - 115/zoom, nil, nil, tocolor(67, 143, 135, 255), 1, font4, "right", "top", false, false, false, false, false)

    dxDrawRoundedRectangle(20/zoom, sy - 320/zoom, 310/zoom, 200/zoom, 8/zoom, tocolor(55, 55, 55, 155))
    local vehData = getElementData(veh, 'vehicle:data') or {}
    local model = getElementData(veh, 'vehicle:model')
    local vehicleName = exports['since-vehiclenames']:getVehicleName(model)
    local engine = string.format("%.1f", vehData.engine or 1.2)

    dxDrawText(vehicleName.." "..(engine or "1.2").." dm³", 0, sy - 300/zoom, 350/zoom, nil, tocolor(67, 143, 135, 255), 1, font3, "center", "center", false, false, false, false, false)

    offsetY = 0
    for i, v in ipairs(tuning['statistic']) do
        dxDrawText(v[1], 0, sy - 265/zoom + offsetY, 350/zoom, nil, tocolor(67, 143, 135, 255), 1, font5, "center", "center", false, false, false, false, false)
        dxDrawRectangle(25/zoom, sy - 250/zoom + offsetY, 300/zoom, 5/zoom, tocolor(46, 117, 111, 75))

        local progress = (300/zoom*getVehicleHandlingProperty(veh, v[3])/v[2])
        local progress = math.min(progress, 300/zoom)
        dxDrawRectangle(25/zoom, sy - 250/zoom + offsetY, progress, 5/zoom, tocolor(46, 117, 111, 200))

        offsetY = offsetY + 35/zoom
    end
end

function enter()
    if data.toggleGUI == true then
        scroll = 1
        if tuning['selectedCategoryName'] == 'category' then
            if tuning['category'][tuning['selectedCategory']]["subCategory"] then
                if tuning['category'][tuning['selectedCategory']]["subCategory"] == "mods" then
                    tuning['selectedCategoryName'] = "mods"
                else
                    tuning['selectedCategoryName'] = tuning['category'][tuning['selectedCategory']]
                end
                tuning['selectedCategory'] = 1
            else
                tuning['category'][tuning['selectedCategory']].use()
            end
        elseif type(tuning['selectedCategoryName']) == "table" then
            if tuning['selectedCategoryName']['subCategory'][tuning['selectedCategory']].inner then
                tuning['selectedCategoryName'] = tuning['selectedCategoryName']['subCategory'][tuning['selectedCategory']].type
                tuning['selectedCategory'] = 1
                updateVehicleTuning()
            else
                triggerServerEvent("buyTuningCustom", resourceRoot, getPedOccupiedVehicle(localPlayer), tuning['selectedCategoryName']['subCategory'][tuning['selectedCategory']].type, tuning['selectedCategoryName']['subCategory'][tuning['selectedCategory']].cost)
            end
        end
    end
end

function backspace()
    if data.toggleGUI == true and tuning['selectedCategoryName'] ~= 'category' then
        tuning['selectedCategoryName'] = 'category'
        tuning['selectedCategory'] = 1
        scroll = 1
    end
end

function arrowDown()
    if data.toggleGUI == true then
        scrollDown()
    end
end

function arrowUp()
    if data.toggleGUI == true then
        scrollUp()
    end
end

function updateVehicleTuning()
    if type(tuning['selectedCategoryName']) ~= "table" and tuning['selectedCategoryName'] ~= "category" then
        local data = parts[tuning['selectedCategoryName']]
        if data then
            local c = data()
            local upgrade = c[tuning['selectedCategory']]

            if upgrade and type(upgrade.var) == "table" then
                setVehicleVariant(getPedOccupiedVehicle(localPlayer), upgrade.var[1], upgrade.var[2])
                setElementData(getPedOccupiedVehicle(localPlayer), 'newmodels:savedVariant', {upgrade.var[1], upgrade.var[2]})
            elseif upgrade and upgrade.var and tonumber(upgrade.var) then
                setVehicleVariant(getPedOccupiedVehicle(localPlayer), upgrade.var, upgrade.var)
                setElementData(getPedOccupiedVehicle(localPlayer), 'newmodels:savedVariant', {upgrade.var, upgrade.var})
            elseif upgrade and upgrade.id and tonumber(upgrade.id) then
                addVehicleUpgrade(getPedOccupiedVehicle(localPlayer), upgrade.id)
            elseif upgrade and upgrade.id == "demontaz" then
                removeVehicleUpgrade(getPedOccupiedVehicle(localPlayer), getVehicleUpgradeOnSlot(getPedOccupiedVehicle(localPlayer), upgrade.demont))
            end
        end
    end
end

function scrollDown()
    if tuning['selectedCategoryName'] == 'category' then
        if tuning['selectedCategory'] >= #tuning['category'] then return end
        tuning['selectedCategory'] = tuning['selectedCategory'] + 1
    elseif type(tuning['selectedCategoryName']) == "table" then
        if tuning['selectedCategory'] >= #tuning['selectedCategoryName']['subCategory'] then return end
        tuning['selectedCategory'] = tuning['selectedCategory'] + 1
    else
        local data = parts[tuning['selectedCategoryName']]
        if data then
            local c = data()
            if tuning['selectedCategory'] >= #c then return end
            tuning['selectedCategory'] = tuning['selectedCategory'] + 1

            updateVehicleTuning()

            if tuning['selectedCategory'] - scroll > 11 then
                scroll = scroll + 1
            end
        end
    end
end

function scrollUp()
    if 1 >= tuning['selectedCategory'] then return end
    tuning['selectedCategory'] = tuning['selectedCategory'] - 1
    updateVehicleTuning()
    if tuning['selectedCategory'] - (scroll or 0) < 0 then
        scroll = scroll - 1
    end
end

function showUI()
    mechanic = createObject(1910, 895.99, -1120.43, -38.62)
    setElementDimension(mechanic, getElementData(localPlayer, "player:sid"))
    setElementInterior(mechanic, 1)
    bindKey("arrow_d", "down", arrowDown)
    bindKey("arrow_u", "down", arrowUp)
    bindKey("backspace", "down", backspace)
    bindKey("enter", "down", enter)
    addEventHandler('onClientRender', root, renderUI)
    triggerServerEvent("setMyDimension2", resourceRoot, getElementData(localPlayer, "player:sid"))
    showChat(false)
    setElementData(localPlayer, "player:hudof", true)
    data.toggleGUI = true
    createTuningVehicle(getPedOccupiedVehicle(localPlayer))
    addEventHandler('onClientKey', root, zoomCamera)
end

local trucks = {

    [514] = true,
    [515] = true,
    [443] = true,
    [403] = true,

}

function hideUI()
    veh = getPedOccupiedVehicle(localPlayer)
    unbindKey("arrow_d", "down", arrowDown)
    unbindKey("arrow_u", "down", arrowUp)
    unbindKey("backspace", "down", backspace)
    unbindKey("enter", "down", enter)
    removeEventHandler('onClientRender', root, renderUI)
    triggerServerEvent("setMyDimension2", resourceRoot, 0, 0)
    showChat(true)
    showCursor(false)
    setElementData(localPlayer, "player:hudof", false)
    setCameraInterior(0)
    setElementInterior(getPedOccupiedVehicle(localPlayer), 0)
    data.toggleGUI = false
    local x, y, z, rotx, roty, rotz = unpack(getElementData(localPlayer, 'save:tuner'))

    -- if type is truck
    if trucks[getElementModel(veh)] then
        z = z + 1
    end

    setElementPosition(getPedOccupiedVehicle(localPlayer), x, y, z)
    setElementRotation(getPedOccupiedVehicle(localPlayer), rotx, roty, rotz)
    setElementData(localPlayer, 'save:tuner', false)
    leave = getTickCount() + 1500
    toggleAllControls(true)
    setCameraTarget(localPlayer)
    removeEventHandler('onClientKey', root, zoomCamera)
    if isElement(mechanic) then destroyElement(mechanic) end

    setTimer(function()
        setPedCanBeKnockedOffBike(localPlayer, true)
    end, 1500, 1)
end

local positions = {

    {1028.58, -1451.72, 13.65, {1012.80, -1459.51, 13.25, 359.9, 360.0, 359.6}},
    {1106.07, 1789.61, 10.82, {1095.77, 1789.44, 10.52, 0.0, 0.0, 89.3}},
    {1105.65, 1762.03, 10.82, {1094.85, 1762.13, 10.52, 0.0, 0.0, 87.7}},
    {1390.56, 788.62, 10.82, {1384.21, 776.17, 10.55, 0.0, 360.0, 180.7}},

}


for i, v in ipairs(positions) do
    local x, y, z = v[1], v[2], v[3]
    local marker = createMarker(x, y, z - 0.5, "cylinder", 4, 125, 255, 125)
    setElementData(marker, "marker:title", "Warsztat tuningowy")
    setElementData(marker, "marker:desc", "Ulepsz swój pojazd")
    setElementData(marker, "marker:icon", "repair")
    setElementData(marker, "marker:savePos", v[4])

    addEventHandler("onClientMarkerHit", marker, function(plr)
        if plr ~= localPlayer then return end
        local veh = getPedOccupiedVehicle(localPlayer)
        if not veh then return end
        if (leave or 0) > getTickCount() then return end
        local owned = getElementData(veh, "vehicle:owner")
        if not owned or tonumber(owned) ~= tonumber(getElementData(localPlayer, "player:sid")) then return end

        setElementData(localPlayer, 'save:tuner', getElementData(source, 'marker:savePos'))

        setPedCanBeKnockedOffBike(localPlayer, false)
        showUI()
    end)
end


function hideVinyls()
    addEventHandler('onClientRender', root, renderUI)
    bindKey("arrow_d", "down", arrowDown)
    bindKey("arrow_u", "down", arrowUp)
    bindKey("backspace", "down", backspace)
    bindKey("enter", "down", enter)
end
getResourceName(getThisResource(), true, 898605193); if true then return end


--[[
	Author: EnoNeK
	For: SinceRPG
--]]

local trees = {
    [1] = {
        [1] = {
            model = 843,
            pos= {860.16, -558.24, 17.33, -8.00, 0.00, 94.31},
            health = 100
        },

        [2] = {
            model = 836,
            pos = {402.66, -581.19, 38.08, -0.00, 0.00, 80.62},
            health = 100
        },

        [3] = {
            model = 837,
            pos = {364.09, -752.51, 17.00, -0.00, 0.00, 162.24},
            health = 100
        },

        [4] = {
            model = 837,
            pos = {225.25, -1729.56, 3.65, -0.00, 0.00, 90.53},
            health = 100
        },
    },

    [2] = {
        [1] = {
            model = 845,
            pos = {546.74, -1670.25, 18.53, -0.00, 0.00, 79.90},
            health = 100
        },

        [2] = {
            model = 844,
            pos = {1134.92, -2380.19, 11.32, -0.00, 0.00, 49.12},
            health = 100
        },

        [3] = {
            model = 848,
            pos = {292.71, -1298.15, 54.39, -0.00, 0.00, 123.25},
            health = 100
        },
    },

    [3] = {
        [1] = {
            model = 843,
            pos= {110.40, 894.59, 21.5, 0, 0, 78},
            health = 100
        },
        [2] = {
            model = 846,
            pos = {103.40, 890.79, 22, 0, 0, 300},
            health = 100
        },
    },

    [4] = {
        [1] = {
            model = 846,
            pos= {-745.90, 113.59, 14, 0, 0, 300},
            health = 100
        },
        [2] = {
            model = 844,
            pos = {-750.5, 107.59, 14.30, 0, 0, 116},
            health = 100
        },
        [3] = {
            model = 831,
            pos = {-752.70, 102.59, 14.60, 0, 0, 0},
            health = 100
        },
    },

    [5] = {
        [1] = {
            model = 845,
            pos= {232.30, -601.90, 32, 0, 0, 302},
            health = 100
        },
    },

    [6] = {
        [1] = {
            model = 838,
            pos= {-436.10, 594.90, 18.89, 0, 0, 0},
            health = 100
        },
        [2] = {
            model = 840,
            pos = {-440.10, 594.70, 17.5, 0, 0, 0},
            health = 100
        },
        [3] = {
            model = 845,
            pos = {-447.70, 578.5, 17.20, 0, 0, 339},
            health = 100,
            
        },
    },
}

local function generateRandomTrees()
	for i,v in ipairs(getElementsByType("object", resourceRoot)) do
		destroyElement(v)
	end

	local temptable = {}
	for i,v in pairs(trees) do
		table.insert(temptable, v)
	end

	for i=1,4 do
		if (#temptable == 0) then
			break
		end

		local random = math.random(1, #temptable)
		for i2,v in ipairs(temptable[random]) do
			local object = createObject(v.model, unpack(v.pos))
			setElementData(object, "tree:health", v.health)
		end
		table.remove(temptable, random)
	end
end
generateRandomTrees()
setTimer(generateRandomTrees, 14400000, 0)

addEvent("enonek-tree:destroy", true)
addEventHandler("enonek-tree:destroy", resourceRoot, function(tree)
    if (isElement(tree)) and getElementData(tree, 'tree:health') then
		destroyElement(tree)

        local randomMoney = math.random(300000, 650000)

		outputChatBox("#00ff00✔ #ffffffPomyślnie pocięto drzewo, otrzymujesz #59eb05$ "..comma(randomMoney), client, _, _, _, true)
		exports["since-db"]:query("UPDATE `since-users` SET bankMoney = bankMoney + ? WHERE uid = ?", randomMoney, getElementData(client, "player:sid"))
	end
end)

function comma( value )
    if not value then return end
    value = tostring( value )
    local formatted = value:gsub( "^(-?%d+)(%d%d%d)", '%1 %2' )
    while true do  
        formatted, k = formatted:gsub( "^(-?%d+)(%d%d%d)", '%1 %2' )
        if ( k==0 ) then
            break
        end
    end
    return formatted
end
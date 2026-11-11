isServer = not localPlayer

vehicles = {

    ['SARA'] = {

        [1] = {

            {
                name = 'Laweta',
                code = 'SARA',
                model = 578,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 175, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 12,
                    tractionLoss = 1,
                    maxVelocity = 210,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                },

            },
        },

        [2] = {

            {
                name = 'Utility Van',
                code = 'SARA',
                model = 552,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        -- nothing
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 15,
                    tractionLoss = 1.2,
                    maxVelocity = 350,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                },

            },

        },

        [6] = {

            {
                name = 'Premier',
                code = 'SARA',
                model = 426,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 175, 0, 255, 175, 0, 255, 255, 255, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                        setVehicleVariant(veh, 0, 0)
                    end
                end,
                handling = {},

            },

        },

        [8] = {

            {
                name = 'Huntley',
                code = 'SARA',
                model = 579,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 175, 0, 255, 175, 0, 255, 255, 255, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {},

            },

        },

        [11] = {

            {
                name = 'Bus',
                code = 'SARA',
                model = 431,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 175, 0, 175, 95, 0, 255, 255, 255, 255, 255, 255)
                    end
                end,
                handling = {},

            },
        },

        [12] = {

            {
                name = 'Bullet',
                code = 'SARA',
                model = 541,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleVariant(veh, 2, 1)
                        setVehicleColor(veh, 255, 175, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {},

            },

        },

        [13] = {

            {
                name = 'Sultan',
                code = 'SARA',
                model = 560,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleVariant(veh, 2, 1)
                        setVehicleColor(veh, 255, 175, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 35,
                    tractionLoss = 1.1,
                    tractionMultiplier = 1,
                    maxVelocity = 280,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 40,
                },

            },
        },

        [14] = {

            {
                name = 'Infernus',
                code = 'SARA',
                model = 411,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleVariant(veh, 0, 1)
                        setVehicleColor(veh, 255, 175, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 40,
                    tractionLoss = 1.1,
                    tractionMultiplier = 1,
                    maxVelocity = 320,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 40,
                },

            },

        },

    },

    ['TSA'] = {

        [1] = {

            {
                name = 'Cabbie',
                code = 'TSA',
                model = 438,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 8,
                    tractionLoss = 0.9,
                    maxVelocity = 210,
                    driveType = 'awd',
                    brakeDeceleration = 12,
                },

            },
        },

        [2] = {

            {
                name = 'Premier Sedan',
                code = 'TSA',
                model = 420,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleVariant(veh, 0, 2)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 12,
                    tractionLoss = 0.9,
                    maxVelocity = 350,
                    driveType = 'awd',
                    brakeDeceleration = 15,
                },

            },

            --[[{
                name = 'Premier Combi',
                code = 'TSA',
                model = 420,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleVariant(veh, 1, 2)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 12,
                    tractionLoss = 0.9,
                    maxVelocity = 350,
                    driveType = 'awd',
                    brakeDeceleration = 12,
                },

            },]]--

        },

        [4] = {

            {
                name = 'Sultan',
                code = 'TSA',
                model = 560,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 175, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 25,
                    tractionLoss = 1,
                    maxVelocity = 500,
                    driveType = 'awd',
                     brakeDeceleration = 20,
                },
            },
        },

        [6] = {

            {
                name = 'Stretch',
                code = 'TSA',
                model = 409,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 255, 255, 255, 255, 255, 75, 75, 75, 75, 75, 75)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1074)
                    end
                end,
                handling = {
                    engineAcceleration = 12,
                    tractionLoss = 0.8,
                    maxVelocity = 400,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                },

            },
        },

        [9] = {

            {
                name = 'Infernus',
                code = 'TSA',
                model = 411,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 255, 255, 255, 255, 255, 75, 75, 75, 75, 75, 75)
                        setVehicleVariant(veh, 0, 3)
                        addVehicleUpgrade(veh, 1077)
                    end
                end,
                handling = {
                    engineAcceleration = 22,
                    tractionLoss = 1.2,
                    maxVelocity = 400,
                    driveType = 'awd',
                    brakeDeceleration = 25,
                },
            },
        },

        [12] = {

            {
                name = 'Rancher FBI',
                code = 'TSA',
                model = 490,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 255, 255, 255, 255, 255, 75, 75, 75, 75, 75, 75)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 25,
                    tractionLoss = 1.2,
                    maxVelocity = 500,
                    driveType = 'awd',
                    brakeDeceleration = 25,
                },

            },
        },

        [13] = {

            {
                name = 'Bullet',
                code = 'TSA',
                model = 541,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 255, 255, 255, 255, 255, 75, 75, 75, 75, 75, 75)
                        setVehicleVariant(veh, 0, 3)
                        addVehicleUpgrade(veh, 1077)
                    end
                end,
                handling = {
                    engineAcceleration = 22,
                    tractionLoss = 1.2,
                    maxVelocity = 400,
                    driveType = 'awd',
                    brakeDeceleration = 25,
                },
            },
        },

    },

    ['SAFD'] = {

        [1] = {

            {
                name = 'Premier',
                code = 'SAFD',
                model = 426,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                        setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
                    end
                end,
                handling = {
                    engineAcceleration = 15,
                    tractionLoss = 0.6,
                    maxVelocity = 320,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 40,
                },

            },
        },

        [2] = {

            {
                name = 'GBA',
                code = 'SAFD',
                model = 407,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        -- nothing
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                	    setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
	                    setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {
                    engineAcceleration = 23,
                    tractionLoss = 0.8,
                    maxVelocity = 520,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 45,
                },

            },

        },

        [3] = {

            {
                name = 'Huntley',
                code = 'SAFD',
                model = 579,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        -- nothing
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                        setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
                    end
                end,
                handling = {},

            },
        },

        [4] = {

            {
                name = 'SCD',
                code = 'SAFD',
                model = 544,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        addVehicleUpgrade(veh, 1025)
                	    setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
	                    setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {
                    engineAcceleration = 23,
                    tractionLoss = 0.8,
                    maxVelocity = 520,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 45,
                },

            },
        },

        [5] = {

            {
                name = 'Burrito',
                code = 'SAFD',
                model = 482,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        addVehicleUpgrade(veh, 1025)
                        setVehicleVariant(veh, 0, 1)
                	    setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
	                    setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {
                    engineAcceleration = 22,
                    tractionLoss = 0.8,
                    maxVelocity = 520,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 45,
                },

            },
        },

        [16] = {

            {
                name = 'Sultan',
                code = 'SAFD',
                model = 560,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        addVehicleUpgrade(veh, 1025)
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                    end
                end,
                handling = {
                    engineAcceleration = 35,
                    tractionLoss = 1.1,
                    tractionMultiplier = 1,
                    maxVelocity = 280,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 40,
                },

            },
        },

        [18] = {

            {
                name = 'Ambulans',
                code = 'SAFD',
                model = 416,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        -- nothing
                        addVehicleUpgrade(veh, 1025)
                        setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
                        setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {
                    engineAcceleration = 25,
                    tractionLoss = 0.8,
                    maxVelocity = 520,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 45,
                },

            },

            {
                name = 'Leviatan',
                code = 'SAFD',
                model = 563,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
                        setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {},

            },

            {
                name = 'Quadbike',
                code = 'SAFD',
                model = 471,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
                        setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {},

            },

            {
                name = 'Sanchez',
                code = 'SAFD',
                model = 468,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
                        setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {},

            },

            {
                name = 'Maverick',
                code = 'SAFD',
                model = 487,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
                        setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {},

            },
        },

        [21] = {

            {
                name = 'Bus',
                code = 'SAFD',
                model = 431,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {},

            },
        },

        [23] = {

            {
                name = 'FBI Rancher',
                code = 'SAFD',
                model = 490,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        -- nothing
                        setVehicleColor(veh, 255, 0, 0, 255, 175, 0, 0, 0, 0, 0, 0, 0)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                        setElementData(veh, "vehicle:fraction:interaction", {state = true, mode=false})
                        setElementData(veh, "vehicle:linieg", 1)
                    end
                end,
                handling = {
                    engineAcceleration = 25,
                    tractionLoss = 0.8,
                    maxVelocity = 520,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 45,
                },

            },
        },
    },

    ['SAPD'] = {
        [1] = {
            {
                name = 'Police #1',
                code = 'TOM',
                model = 597,
                --model = 596,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 1, true, false, false, true )
                        addVehicleSirens(veh, 8, 6, true, false, false, true )
                        setVehicleSirens(veh, 1, 0.302, 2.430, -0.012, 0, 96, 255, 255, 255 )
                        setVehicleSirens(veh, 2, -0.302, 2.430, -0.012, 255, 0, 0, 255, 255 )
                        setVehicleSirens(veh, 3, -0.775, -2.700, 0.031, 255, 0, 0, 255, 255 )
                        setVehicleSirens(veh, 4, 0.768, -2.700, 0.031, 255, 0, 0, 255, 255 )
                        setVehicleSirens(veh, 5, 0.262, -0.405, 0.900, 0, 96, 255, 255, 255 )
                        setVehicleSirens(veh, 6, -0.262, -0.424, 0.900, 255, 0, 0, 255, 255 )
                        setVehicleSirens(veh, 7, 0.722, -0.405, 0.900, 0, 96, 255, 255, 255 )
                        setVehicleSirens(veh, 8, -0.722, -0.424, 0.900, 255, 0, 0, 255, 255 )
                        setVehicleColor(veh, 0, 111, 237, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                        setVehicleVariant(veh, 0,0)
                    end
                end,
                handling = {
                    engineAcceleration = 30,
                    tractionLoss = 1.1,
                    tractionMultiplier = 1,
                    maxVelocity = 320,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    steeringLock = 45,
                    mass = 3600,
                    turnMass = 5500,
                }
            },

            {
                name = 'Laweta',
                code = 'SAPA',
                model = 578,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 255, 255, 255, 65, 165, 255, 0, 0, 0, 0, 0, 0)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                    end
                end,
                handling = {
                    engineAcceleration = 30,
                    maxVelocity = 180,
                    driveType = 'awd',
                    brakeDeceleration = 15,
                },

            },

        },

        [2] = {
            {
                name = 'Police #2',
                code = 'SAPD',
                model = 597,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        --setVehicleColor(veh, 0, 111, 237, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                        setVehicleVariant(veh, 0,0)
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 1, true, false, false, true )
                    end
                end,
                handling = {
                    engineAcceleration = 60,
                    tractionLoss = 1.1,
                    tractionMultiplier = 1,
                    maxVelocity = 600,
                    driveType = 'awd',
                    brakeDeceleration = 50,
                    steeringLock = 45,
                    mass = 3600,
                    turnMass = 5500,
                }
            },
        },


--[[        [4] = {

            {
                name = 'Police Ranger',
                code = 'SAPD',
                model = 599,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        --setVehicleColor(veh, 0, 111, 237, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                        --setVehicleVariant(veh, 0,0)
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 6, true, false, false, true )
                       -- setVehicleSirens(veh, 1, -0.6, 0.2, 0.8, 0, 0, 255, 255, 255 )
                    end
                end,
                handling = {
                    engineAcceleration = 45,
                    tractionLoss = 1,
                    tractionMultiplier = 1.25,
                    maxVelocity = 600,
                    driveType = 'awd',
                    brakeDeceleration = 70,
                    steeringLock = 30,
                    mass = 7500,
                }
            },
        },]]--

        [3] = {
            {
                name = 'Sultan',
                code = 'SAPD',
                model = 598,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                    	local getVehicleHandlings = getModelHandling(560)
                    	for i, v in pairs(getVehicleHandlings) do
                    		setVehicleHandling(veh, i, v)
                    	end
                    	setVehicleHandling(veh, 'engineAcceleration', 75)
                    	setVehicleHandling(veh, 'tractionLoss', 1.3)
                    	setVehicleHandling(veh, 'tractionMultiplier', 1)
                    	setVehicleHandling(veh, 'maxVelocity', 500)
                    	setVehicleHandling(veh, 'driveType', 'awd')
                    	setVehicleHandling(veh, 'dragCoeff', 2)
                    	setVehicleHandling(veh, 'mass', 4000)
                    	setVehicleHandling(veh, 'brakeDeceleration', 80)
                        setVehicleColor(veh, 0, 0, 0, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                        --addVehicleUpgrade(veh, 1084)
                        addVehicleUpgrade(veh, 1026)
                        addVehicleUpgrade(veh, 1170)
                        addVehicleUpgrade(veh, 1140)
                        setVehicleVariant(veh, 0,0)
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 6, true, false, false, true )
                        setVehicleSirens(veh, 1, -0.6, 0.2, 0.8, 0, 0, 255, 255, 255 )
                    end
                end,
                handling = {
                    brakeDeceleration = 70,
                }
            },
        },
        [5] = {
            {
                name = 'Infernus',
                code = 'SAPD',
                model = 411,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 15, 0, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0)
                        addVehicleUpgrade(veh, 1025)
                        addVehicleUpgrade(veh, 1026)
                        addVehicleUpgrade(veh, 1170)
                        addVehicleUpgrade(veh, 1140)
                        setVehicleVariant(veh, 0, 2)
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 6, true, false, false, true )
                        setVehicleSirens(veh, 1, -0.6, 0.2, 0.8, 0, 0, 255, 255, 255 )
                    end
                end,
                handling = {
                    engineAcceleration = 110,
                    tractionLoss = 1.3,
                    tractionMultiplier = 1.2,
                    maxVelocity = 500,
                    driveType = 'awd',
                    tractionBias = 0.4,
                    brakeDeceleration = 20,
                    steeringLock = 45,
                    mass = 6800,
                    turnMass = 7400,
                    dragCoeff = 2.5,
                    brakeDeceleration = 50,
                },

            },
        },

        [6] = {

            {
                name = 'Enforcer',
                code = 'SAPD',
                model = 427,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        addVehicleUpgrade(veh, 1025)
                        setVehicleVariant(veh, 0,0)
                    end
                end,
                handling = {
                    engineAcceleration = 20,
                    tractionLoss = 0.94,
                    tractionMultiplier = 1.2,
                    maxVelocity = 500,
                    driveType = 'awd',
                    brakeDeceleration = 20,
                    turnMass = 3000,
                }
            },
            {
                name = 'SWAT',
                code = 'SAPD',
                model = 601,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 25, 35, 40, 0, 0, 0)
                        addVehicleUpgrade(veh, 1025)
                        --addVehicleUpgrade(veh, 1084)
                        addVehicleUpgrade(veh, 1026)
                        addVehicleUpgrade(veh, 1170)
                        addVehicleUpgrade(veh, 1140)
                        setVehicleVariant(veh, 0,0)
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 6, true, false, false, true )
                        setVehicleSirens(veh, 1, -0.6, 0.2, 0.8, 0, 0, 255, 255, 255 )
                    end
                end,
                handling = {
                    engineAcceleration = 35,
                    tractionLoss = 1.5,
                    maxVelocity = 500,
                    driveType = 'awd',
                    tractionBias = 0.4,
                    brakeDeceleration = 20,
                    steeringLock = 45,
                    mass = 5400,
                    brakeDeceleration = 50,
                }
            },
            {
                name = 'Cheetah',
                code = 'SAPD',
                model = 415,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 67, 84, 80)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 6, true, false, false, true )
                        setVehicleSirens(veh, 1, -0.4, -0.1, 0.6, 0, 0, 255, 255, 255 )

                    end
                end,
                handling = {
                    engineAcceleration = 98,
                    tractionLoss = 1.3,
                    tractionMultiplier = 1.2,
                    maxVelocity = 500,
                    driveType = 'awd',
                    tractionBias = 0.4,
                    brakeDeceleration = 20,
                    steeringLock = 45,
                    mass = 6800,
                    turnMass = 7400,
                    dragCoeff = 2.5,
                    brakeDeceleration = 50,
                }
            },
        },

        [7] = {
            {
                name = 'Sultan (um)',
                code = 'SAPD',
                model = 560,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                    	local getVehicleHandlings = getModelHandling(411)
                    	for i, v in pairs(getVehicleHandlings) do
                    		setVehicleHandling(veh, i, v)
                    	end
                    	setVehicleHandling(veh, 'engineAcceleration', 85)
                    	setVehicleHandling(veh, 'tractionLoss', 1.3)
                    	setVehicleHandling(veh, 'tractionMultiplier', 1)
                    	setVehicleHandling(veh, 'maxVelocity', 1200)
                    	setVehicleHandling(veh, 'driveType', 'awd')
                    	setVehicleHandling(veh, 'dragCoeff', 2)
                    	setVehicleHandling(veh, 'mass', 3500)
                    	setVehicleHandling(veh, 'brakeDeceleration', 80)
                        setVehicleColor(veh, 2, 0, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0)
                        addVehicleUpgrade(veh, 1025)
                        setVehicleVariant(veh, 0,0)
                        addVehicleSirens(veh, 8, 1, true, false, false, true )
                    end
                end,
                handling = {},
            },
        },
        [8] = {
            {
                name = 'FBI Rancher',
                code = 'FIBR',
                model = 490,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 0, 0, 0)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                        --removeVehicleSirens(veh)
                        --addVehicleSirens(veh, 8, 6, true, false, false, true )
                    end
                end,
                handling = {
                    engineAcceleration = 100,
                    tractionLoss = 1.3,
                    tractionMultiplier = 1.25,
                    maxVelocity = 1500,
                    driveType = 'awd',
                    brakeDeceleration = 500,
                    steeringLock = 50,
                    mass = 10000,
                    turnMass = 13000,
                    brakeDeceleration = 50,
                    suspensionLowerLimit = -0.08
                }
            },
        },
        [12] = {
            {
                name = 'Comet',
                code = 'SAPD',
                model = 480,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                    	local getVehicleHandlings = getModelHandling(411)
                    	for i, v in pairs(getVehicleHandlings) do
                    		setVehicleHandling(veh, i, v)
                    	end
                    	setVehicleHandling(veh, 'engineAcceleration', 85)
                    	setVehicleHandling(veh, 'tractionLoss', 1.3)
                    	setVehicleHandling(veh, 'tractionMultiplier', 1)
                    	setVehicleHandling(veh, 'maxVelocity', 1200)
                    	setVehicleHandling(veh, 'driveType', 'awd')
                    	setVehicleHandling(veh, 'dragCoeff', 2)
                    	setVehicleHandling(veh, 'mass', 3500)
                    	setVehicleHandling(veh, 'brakeDeceleration', 80)
                        setVehicleColor(veh, 0, 49, 58)
                        setVehicleVariant(veh, 1, 1)
                        addVehicleUpgrade(veh, 1025)
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 6, true, false, false, true )
                        setVehicleSirens(veh, 1, -0.4, -0.1, 0.6, 0, 0, 255, 255, 255 )
                    end
                end,
                handling = {},
            },
        },
        [17] = {
            {
                name = 'BUS',
                code = 'BUS',
                model = 431,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        removeVehicleSirens(veh)
                        setVehicleColor(veh, 0, 111, 237, 255, 255, 255)
                        addVehicleUpgrade(veh, 1025)
                        setVehicleVariant(veh, 0,0)
                    end
                end,
                handling = {
                    engineAcceleration = 12,
                    tractionLoss = 1,
                    maxVelocity = 500,
                    driveType = 'awd',
                }
            },
            {
                name = 'Bullet',
                code = 'BT',
                model = 541,
                allowTuning = false,
                specialData = function(veh)
                    if isServer then
                        setVehicleColor(veh, 0, 0, 0, 255, 255, 255, 0, 0, 0, 0, 0, 0)
                        addVehicleUpgrade(veh, 1025)
                        setVehicleVariant(veh, 0,0)
                        removeVehicleSirens(veh)
                        addVehicleSirens(veh, 8, 6, true, false, false, true )
                        setVehicleSirens(veh, 1, -0.5, -0.2, 0.6, 0, 0, 255, 255, 255 )
                    end
                end,
                handling = {
                    engineAcceleration = 120,
                    tractionLoss = 1.7,
                    tractionMultiplier = 1.2,
                    maxVelocity = 500,
                    driveType = 'awd',
                    tractionBias = 0.4,
                    brakeDeceleration = 20,
                    steeringLock = 50,
                    mass = 7800,
                    turnMass = 7400,
                    dragCoeff = 2.5,
                    brakeDeceleration = 50,
                }
            },
        }
    }
}

factionSpawns = {

    ['SAPD'] = {2007.93, -1899.87, 13.87, 0, 0, 270},
    ['SARA'] = {1803.05, -1702.66, 14.06, 0, 0, 0},
    ['SAFD'] = {857.34, 1858.26, 10.56, 0, 0, 270},
    ['TSA'] = {2194.70, 1447.08, 10.55, 0.0, 0.0, 179.4},

}
getResourceName(getThisResource(), true, 999813130); if true then return end
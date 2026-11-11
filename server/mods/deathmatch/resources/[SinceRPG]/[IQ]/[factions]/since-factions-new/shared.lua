isServer = not localPlayer

factions = {
    ['SAPD'] = {
        fullName = "San Andreas Police Department",
        blip = {
            id = 30,
            position = {1238.00, 319.92, 19.77},
        },
        markers = {
            startDuty = {1242.67, 319.25, 19.76},
            clothing = {1227.14, 322.47, 19.76},
            getVehicles = {1219.99, 309.35, 19.69},
            spawnVehicle = {1222.36, 302.02, 19.32, 359.9, 360.0, 155.7},
            returnVehicle = {1228.42, 292.71, 19.55},
            panel = {1251.97, 304.72, 19.75},
        },
        colors = {
            hex = "#1836CD",
            rgb = {24, 54, 205}
        },
        ranks = {
            [1] = 'Cadet',
        	[2] = 'Police Officer I',
        	[3] = 'Police Officer II',
        	[4] = 'Police Officer III',
        	[5] = 'Police Officer III+I',
        	[6] = 'Sergeant I',
        	[7] = 'Sergeant II',
        	[8] = 'Detective I',
        	[9] = 'Detective II',
        	[10] = 'Detective III',
        	[11] = 'Lieutenant',
        	[12] = 'Captain I',
        	[13] = 'Captain II',
        	[14] = 'Captain III',
        	[15] = 'Commander',
        	[16] = 'Deputy Chief',
        	[17] = 'Assistant Chief Of Police',
        	[18] = 'Chief Of Police',
        },
        skins = {

            {
                name = 'Cadet',
                id = 71,
                ranks = {1},
            },
            {
                name = 'Officer',
                id = 280,
                ranks = {2, 3, 4, 5},
            },
            {
                name = 'Gang Unit',
                id = 282,
                ranks = {6, 7},
            },
            {
                name = 'SWAT',
                id = 285,
                ranks = {8, 9, 10},
            },

            {
                name = 'Sergeant',
                id = 281,
                ranks = {6, 7},
            },
            {
                name = 'Detective',
                id = 284,
                ranks = {8, 9, 10},
            },
            {
                name = 'Captain',
                id = 283,
                ranks = {11, 12, 13, 14},
            },
            {
                name = 'Zarząd',
                id = 286,
                ranks = {15, 16, 17, 18},
            },
        },
        vehicles = {
            {
                name = 'Police #1',
                code = 'TOM',
                model = 597,
                rank = 1,
                allowTuning = false,
                specialData = function(veh)
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
                code = 'SAPA',
                model = 578,
                rank = 1,
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
            {
                code = 'SAPD',
                model = 597,
                rank = 2,
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
            {
                code = 'SAPD',
                model = 598,
                rank = 3,
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
            {
                rank = 5,
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
            {
                rank = 6,
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
                rank = 6,
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
                rank = 6,
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
            {
                rank = 7,
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
            {
                rank = 8,
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
            {
                rank = 12,
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
            {
                rank = 17,
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
                rank = 17,
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
    },
    ['SARA'] = {
        fullName = "San Andreas Road Assistance",
        blip = {
            id = 11,
            position = {62.77, -310.71, 1.77}
        },
        markers = {
            startDuty = {62.77, -310.71, 1.77},
            clothing = {54.98, -338.25, 1.77},
            getVehicles = {143.42, -278.10, 1.58},
            spawnVehicle = {133.68, -274.78, 1.24, 359.6, 360.0, 178.1},
            returnVehicle = {115.02, -275.28, 1.58, -0.00, 0.00, 88.73},
            panel = {69.34, -321.30, 6.59},
        },
        colors = {
            hex = "#d6680e",
            rgb = {214, 104, 14}
        },
        ranks = {
            [1] = "Adept",
            [2] = "Pracownik",
            [3] = "Budowlany",
            [4] = "Doświadczony Budowlany",
            [5] = "Specjalista",
            [6] = "Doświadczony Specjalista",
            [7] = "Operator",
            [8] = "Główny Operator",
            [9] = "Zastępca Inspektora",
            [10] = "Zastępca Głównego Inżyniera",
            [11] = "Główny Inżynier"
        },
        vehicles = {
            {
                rank = 1,
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
            {
                rank = 2,
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
            {
                rank = 6,
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
            {
                rank = 8,
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
            {
                rank = 10,
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
            {
                rank = 11,
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
            {
                rank = 11,
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
            {
                rank = 11,
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
        }
    }
}

function getFactionData(faction)
    return factions[faction]
end
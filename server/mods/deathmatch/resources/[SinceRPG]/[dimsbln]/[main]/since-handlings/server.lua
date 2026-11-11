  

local handlingList = {

    [80001] = { ------> BMW M2 <----- (200 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 2800)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },


    [80002] = { -----> NISSAN R34 <----- (300 WPLN)
 
        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 27)
            setVehicleHandling(veh, 'maxVelocity', 2800)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'steeringLock', 25)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
        end,



    },

    [80003] = { -----> AUDI RS6 <----- (200 WPLN)

        func = function(veh)
            

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 2650)
            setVehicleHandling(veh, 'steeringLock', 30)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            --setVehicleHandling(veh, 'mass', 5000)
            --setVehicleHandling(veh, 'turnmass', 2000)
            --setVehicleHandling(veh, "tractionMultiplier", 0.8)
            --setVehicleHandling(veh, "brakeDeceleration", 10)
            --setVehicleHandling(veh, "brakeBias", 0.5)
        end,

    },

    [80004] = { -----> BMW M4 <----- (300 WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(506) 
	        for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23)
            setVehicleHandling(veh, 'maxVelocity', 550)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            --setVehicleHandling(veh, 'mass', 3500)
            --setVehicleHandling(veh, 'turnmass', 3000)
            --setVehicleHandling(veh, 'brakeDeceleration', 25)
        end,

    },

    [573] = { -----> Dune

        func = function(veh)
            local getVehicleHandlings = getModelHandling(506) 
	        for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 12)
            setVehicleHandling(veh, 'maxVelocity', 200)

            setVehicleHandling(veh, 'steeringLock', 40)
        end,

    },

    [80005] = { -----> G WAGON <----- (200 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 2200)
            setVehicleHandling(veh, 'steeringLock', 23)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            --setVehicleHandling(veh, 'mass', 5500)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },


    [80006] = { -----> AUDI RS7 <----- (300 WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(560) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 550)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            --setVehicleHandling(veh, 'mass', 3500)
            --setVehicleHandling(veh, 'turnmass', 3000)
            --setVehicleHandling(veh, 'brakeDeceleration', 25)
        end,

    },

    [80007] = { -----> MERCEDES E63 S <----- (600 WPLN)

        func = function(veh)
            --local getVehicleHandlings = getModelHandling(560) 
            --for i, v in pairs(getVehicleHandlings) do
            --    setVehicleHandling(veh, i, v)
          --  end

            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 650)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.3)
        end,

    },

    [80008] = { -----> LANCER EVO <----- (800 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 30)
            setVehicleHandling(veh, 'maxVelocity', 2200)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80009] = { -----> MERCEDES C63 <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(560) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 30)
            setVehicleHandling(veh, 'maxVelocity', 950)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.10)
            setVehicleHandling(veh, 'mass', 1500)
        end,

    },

    [80011] = { -----> TOYOTA SUPRA <----- (300 WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(506) 
	        for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23)
            setVehicleHandling(veh, 'maxVelocity', 550)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            --setVehicleHandling(veh, 'mass', 3500)
            --setVehicleHandling(veh, 'turnmass', 3000)
            --setVehicleHandling(veh, 'brakeDeceleration', 25)
        end,

    },

    [80012] = { -----> LAMBORGHINI HURACAN <----- (400 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 20)
            setVehicleHandling(veh, 'maxVelocity', 900)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            --setVehicleHandling(veh, 'mass', 5000)
        end,

    },

    [80013] = { -----> SUBARU IMPREZA <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 27)
            setVehicleHandling(veh, 'maxVelocity', 900)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
        end,

    },

    [80014] = { -----> BMW M5 <----- (400 WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
	        for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 13)
            setVehicleHandling(veh, 'maxVelocity', 600)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.4)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.10)
            setVehicleHandling(veh, 'mass', 1500)
            setVehicleHandling(veh, 'tractionBias', 0.4)
        end,

    },

    [80015] = { -----> HONDA CIVIC <----- (100 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 14)
            setVehicleHandling(veh, 'maxVelocity', 500)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80016] = { -----> OPEL VECTRA <----- (100 WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(560) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 14)
            setVehicleHandling(veh, 'maxVelocity', 500)
            setVehicleHandling(veh, 'steeringLock', 30)
            setVehicleHandling(veh, 'tractionLoss', 1)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'mass', 1500)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.10)
        end,


    },

    [80020] = { -----> NISSAN GTR <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 23)
            setVehicleHandling(veh, 'maxVelocity', 400)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'tractionLoss', 1)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            --setVehicleHandling(veh, 'mass', 5000)
            --setVehicleHandling(veh, 'turnmass', 3000)
        end,

    },

    [80021] = { -----> DODGE CHALLENGER <----- (550 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 20)
            setVehicleHandling(veh, 'maxVelocity', 450)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80023] = { -----> MERCEDES 190 E <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 21)
            setVehicleHandling(veh, 'maxVelocity', 450)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80024] = { -----> McLaren P1 <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 900)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            --setVehicleHandling(veh, 'mass', 5000)
            --setVehicleHandling(veh, 'turnmass', 3000)
        end,

    },

    [80025] = { -----> MERCEDES GT 63 <----- (400 WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
	        for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 18)
            setVehicleHandling(veh, 'maxVelocity', 450)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80026] = { -----> HONDA NSX <----- (600 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 650)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'tractionBias', 0.5)
        end,

    },

    [80027] = { -----> HONDA S2000 <----- (400 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 650)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            --setVehicleHandling(veh, 'tractionBias', 0.5)
        end,

    },

    [80028] = { -----> KOENIGSEGG AGERA <----- (PRYWATNA PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 29)
            setVehicleHandling(veh, 'maxVelocity', 1200)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            setVehicleHandling(veh, 'turnmass', 1000)
            setVehicleHandling(veh, 'brakeDeceleration', 10)

        end,

    },

    [80029] = { -----> BUGATTI CHIRON <----- (800 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 700)
            setVehicleHandling(veh, 'steeringLock', 30)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            --setVehicleHandling(veh, 'mass', 5000)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80030] = { -----> LAMBORHGINI URUS <----- (600 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 900)
            setVehicleHandling(veh, 'steeringLock', 30)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80031] = { -----> Ferrari Laferrari <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 600)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            --setVehicleHandling(veh, 'driveType', 'awd')
            --setVehicleHandling(veh, 'turnmass', 3000)
            --setVehicleHandling(veh, 'brakeDeceleration', 50)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.35)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80032] = { -----> LAMBORGHINI AVENTADOR <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 600)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            --setVehicleHandling(veh, 'driveType', 'awd')
            --setVehicleHandling(veh, 'turnmass', 3000)
            --setVehicleHandling(veh, 'brakeDeceleration', 50)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80033] = { -----> BMW M3 TOURING <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 500)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            --setVehicleHandling(veh, 'mass', 5000)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80034] = { -----> PAGANI HUAYRA <----- (??? WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 26.5)
            setVehicleHandling(veh, 'maxVelocity', 500)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80035] = { -----> KOENIGSEGG CCXR <----- (600 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 700)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'mass', 1000)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
        end,

    },

    [80036] = { -----> AUDI R8 <----- (800 WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(506) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            --setVehicleHandling(veh, 'mass', 3500)
            --setVehicleHandling(veh, 'brakeDeceleration', 25)
        end,

    },

    [80037] = { -----> McLaren Senna <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 500)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            --setVehicleHandling(veh, 'mass', 5000)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
        end,

    },

    [80038] = { -----> MERCEDES CSL 63 <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 18)
            setVehicleHandling(veh, 'maxVelocity', 400)
            setVehicleHandling(veh, 'steeringLock', 30)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'mass', 1500)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.10)
        end,

    },

    [80039] = { -----> BMW X5 <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 3500)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
            --setVehicleHandling(veh, 'mass', 9500)
        end,

    },

    [80040] = { -----> PORSCHE 918 SPYDER <----- (??? WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 30)
            setVehicleHandling(veh, 'maxVelocity', 3500)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
            --setVehicleHandling(veh, 'mass', 9500)
        end,

    },

    [80041] = { -----> Buggati Divo <----- (1000 WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(558) 
	        for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 39)
            setVehicleHandling(veh, 'maxVelocity', 1500)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
            --setVehicleHandling(veh, 'mass', 5000)
        end,

    },

    [80042] = { -----> Mercedes Benz C63 Coupe <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 700)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'mass', 1500)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
        end,

    },

    [80043] = { -----> Mercedes Benz SL 65 AMG <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(506) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.35)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.10)
        end,

    },

    [80044] = { -----> Bentley Continental SuperSport <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(506) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.35)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
        end,

    },

    [80046] = { -----> BMW M3 E36 <----- (500 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 30)
            setVehicleHandling(veh, 'maxVelocity', 4500)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            --setVehicleHandling(veh, 'mass', 5000)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.10)
        end,

    },

    [80047] = { -----> BMW M3 E46 <----- (600 WPLN)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 32)
            setVehicleHandling(veh, 'maxVelocity', 4500)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            --setVehicleHandling(veh, 'mass', 5000)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
        end,

    },

    [80048] = { -----> Ferrari F8 Tributo <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(506) 
	        for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 35.5)
            setVehicleHandling(veh, 'maxVelocity', 4500)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
        end,

    },

    [80049] = { -----> McLaren 720s Spider <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 30)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,

    },

    [80050] = { -----> Nissan 240SX (S14) <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(560) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 33)
            setVehicleHandling(veh, 'maxVelocity', 4000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 25)
        end,

    },

    [80051] = { -----> Rolls-Royce Cullinan <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(579) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 40)
            setVehicleHandling(veh, 'maxVelocity', 3800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            setVehicleHandling(veh, 'brakeDeceleration', 25)
        end,

    },

    [80052] = { -----> Corvette C8 <----- (PW PODMIANKA)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 985)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'driveType', 'awd')
            setVehicleHandling(veh, 'brakeDeceleration', 10)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            --setVehicleHandling(veh, 'mass', 5000)
            --setVehicleHandling(veh, 'turnmass', 3000)
        end,

    },

    [80053] = { -----> Camaro SS <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 30)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,

    },

    [80054] = { -----> Toyota GT86 Rocket Bunny <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(602) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80055] = { -----> BMW E30 M3 <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(602) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 33)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            --setVehicleHandling(veh, 'mass', 3500)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80056] = { -----> CADILLAC ESCALADE <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 22)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80057] = { -----> BMW E60 M5 <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(405) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 47)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80058] = { -----> BMW Alpina B7 <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(602) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80059] = { -----> AUDI RS2 AVANT <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80060] = { -----> BMW E39 M5 <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 31)
            setVehicleHandling(veh, 'maxVelocity', 1500)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'tractionLoss', 2)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
            setVehicleHandling(veh, 'mass', 2000)
            --setVehicleHandling(veh, 'turnmass', 2000)
        end, 

    },

    [80061] = { -----> Maserati GranTurismo <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.7)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'mass', 2000)
            --setVehicleHandling(veh, 'turnmass', 2000)
        end, 

    },

    [80062] = { -----> BMW M4 <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 31)
            setVehicleHandling(veh, 'maxVelocity', 1500)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'tractionLoss', 2)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
            setVehicleHandling(veh, 'mass', 2000)
            --setVehicleHandling(veh, 'turnmass', 2000)
        end, 

    },

    [80063] = { -----> Mitsubishi Eclipse GSX <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80064] = { -----> SEAT LEON FR <----- (??? WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 12)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80065] = { -----> COQUETTE  <----- (??? WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 18)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80066] = { -----> Mercedes-Benz 560 Sec AMG  <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 20)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.4)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80067] = { -----> GROTTI VENOM  <----- (??? WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80070] = { -----> IMPONTE DELUXO  <----- (??? WPLN)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23.5)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80165] = { -----> IMPONTE DELUXO  <----- (??? WPLN)

    func = function(veh)
        local getVehicleHandlings = getModelHandling(581) 
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end

        setVehicleHandling(veh, 'engineAcceleration', 23.5)
        setVehicleHandling(veh, 'maxVelocity', 1200)
        setVehicleHandling(veh, 'steeringLock', 35)
        setVehicleHandling(veh, 'tractionLoss', 1.6)
        setVehicleHandling(veh, 'tractionBias', 0.44)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end, 

    },

    [80164] = { -----> IMPONTE DELUXO  <----- (??? WPLN)

    func = function(veh)
        local getVehicleHandlings = getModelHandling(581) 
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end

        setVehicleHandling(veh, 'engineAcceleration', 23.5)
        setVehicleHandling(veh, 'maxVelocity', 800)
        setVehicleHandling(veh, 'steeringLock', 35)
        setVehicleHandling(veh, 'tractionLoss', 1.6)
        setVehicleHandling(veh, 'tractionBias', 0.44)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end, 

    },

    [80163] = { -----> IMPONTE DELUXO  <----- (??? WPLN)

    func = function(veh)
        local getVehicleHandlings = getModelHandling(581) 
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end

        setVehicleHandling(veh, 'engineAcceleration', 23.5)
        setVehicleHandling(veh, 'maxVelocity', 1500)
        setVehicleHandling(veh, 'steeringLock', 35)
        setVehicleHandling(veh, 'tractionLoss', 1.6)
        setVehicleHandling(veh, 'tractionBias', 0.44)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end, 

    },

    [80071] = { -----> Mercedes AMG S65 <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(551) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80072] = { -----> GROTTI PICCOLO (MALUCH) <----- (PW PODMIANKA)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    [80073] = { -----> Jester NZX
 
        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 20)
            setVehicleHandling(veh, 'driveType', 'rwd')
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 0.8)
        end,

    },

    [80074] = { -----> ASTON MARTIN VULCAN <----- (PW PODMIANKA WGRANA PRZEZ: LEITO)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80075] = { -----> Ferrari FXXK Evo <----- (PW PODMIANKA WGRANA PRZEZ: Przezroczysty)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80076] = { -----> MERCEDES W124 <----- (PW PODMIANKA WGRANA PRZEZ: Lipcowy)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80077] = { -----> Porsche 911 Carrera S <----- (PW PODMIANKA WGRANA PRZEZ: plazma)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80078] = { -----> BMW E24 <----- (PW PODMIANKA WGRANA PRZEZ: TheFilipo)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23.5)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80079] = { -----> Mitsubishi Lancer Evolution VI <----- (PW PODMIANKA WGRANA PRZEZ: YhuZ)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80080] = { -----> BMW E92 M3 <----- (PW PODMIANKA WGRANA PRZEZ:)
    
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 31)
            setVehicleHandling(veh, 'maxVelocity', 1500)
            setVehicleHandling(veh, 'steeringLock', 45)
            setVehicleHandling(veh, 'tractionLoss', 2)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
            setVehicleHandling(veh, 'mass', 2000)
            --setVehicleHandling(veh, 'turnmass', 2000)
        end, 

    },


    [80166] = { -----> Rolls-Royce Cullinan <----- 
    
    func = function(veh)
        local getVehicleHandlings = getModelHandling(579) 
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end

        setVehicleHandling(veh, 'engineAcceleration', 40)
        setVehicleHandling(veh, 'maxVelocity', 3800)
        setVehicleHandling(veh, 'steeringLock', 45)
        setVehicleHandling(veh, 'tractionLoss', 2)
        setVehicleHandling(veh, 'tractionBias', 0.5)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
        setVehicleHandling(veh, 'mass', 3000)
        --setVehicleHandling(veh, 'turnmass', 2000)
    end, 

    },

    [80081] = { -----> BMW E92 M3 <----- (PW PODMIANKA WGRANA PRZEZ:)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80082] = { -----> Mercedes-Benz 600 AMG <----- (PW PODMIANKA WGRANA PRZEZ: KoKs)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80083] = { -----> Lamborghini Murcielago <----- (PW PODMIANKA WGRANA PRZEZ: kabanos)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25.5)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.25)
        end, 

    },

    [80084] = { -----> FORD SHELBY GT 500 <----- (PW PODMIANKA WGRANA PRZEZ: Szymon123)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24.5)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.25)
        end, 

    },

    [80085] = { -----> Ferrari F430 <----- (PW PODMIANKA WGRANA PRZEZ: Przezroczysty)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80086] = { -----> BMW E34 <----- (PW PODMIANKA WGRANA PRZEZ: YhuZ)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80087] = { -----> BMW M340i <----- (PW PODMIANKA WGRANA PRZEZ: LeiTo)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80088] = { -----> BMW E9 <----- (PW PODMIANKA WGRANA PRZEZ: mariusz701)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24)
            setVehicleHandling(veh, 'maxVelocity', 800)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80089] = { -----> Alfa-Romeo 159 Ti <----- (PW PODMIANKA WGRANA PRZEZ: Haku)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24.8)
            setVehicleHandling(veh, 'maxVelocity', 820)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.65)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80092] = { -----> BWM E38 <----- (PW PODMIANKA WGRANA PRZEZ: passacik)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 820)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80093] = { -----> BRABUS 850 XL <----- (PW PODMIANKA WGRANA PRZEZ: Derwanik)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 22)
            setVehicleHandling(veh, 'maxVelocity', 820)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80094] = { -----> Audi RS3 <----- (PW PODMIANKA WGRANA PRZEZ: slyzz)

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23.8)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 

    },

    [80095] = { -----> Weeny Tommy <----- (Unikatowa podmianka z mounth chilliad)
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 10)
            setVehicleHandling(veh, 'maxVelocity', 200)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 15)

        end,
    },

    [80096] = { -----> Sultan RS <----- (Unikatowy model 1/1)
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80097] = { -----> Tesla X <----- (PW PODMIANKA WGRANA PRZEZ: HaddiXon)
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 22.5)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.65)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80098] = { -----> Nissan Silvia S13 <----- (PW PODMIANKA WGRANA PRZEZ: BmwM5E61Touring507KM)
        func = function(veh)
            local getVehicleHandlings = getModelHandling(562) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 38)
            setVehicleHandling(veh, 'maxVelocity', 1500)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.5)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80099] = { -----> Mercedes Benz W140 <----- (PW PODMIANKA WGRANA PRZEZ: mahonesz)
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 22.8)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80100] = { -----> Tesla Cybertruck <-----
        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 19.8)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80101] = { -----> Tesla Roadster <-----
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23.8)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80102] = { -----> Tesla Model S <-----
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 16.8)
            setVehicleHandling(veh, 'maxVelocity', 500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80103] = { -----> Vapid RG21 <-----
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24.8)
            setVehicleHandling(veh, 'maxVelocity', 650)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80105] = { -----> Imponte Scorcher <-----
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 21.8)
            setVehicleHandling(veh, 'maxVelocity', 500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 18)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80106] = { -----> Benefactor Zweihander <-----
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 16.8)
            setVehicleHandling(veh, 'maxVelocity', 500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },
    

    [80107] = { -----> Ford Raptor <-----
        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 15)
            setVehicleHandling(veh, 'maxVelocity', 350)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.33)
            setVehicleHandling(veh, 'driveType', 'awd')
            setVehicleHandling(veh, 'brakeDeceleration', 12)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },


    [80108] = { -----> Ford Raptor <-----
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 24.8)
            setVehicleHandling(veh, 'maxVelocity', 650)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 
    },

    [80109] = { -----> BMW E28 <----- (PW PODMIANKA)
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80110] = { -----> Lamborghini Cellano <----- (PW PODMIANKA WGRANA PRZEZ: XeedTM (UID: 2468))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 23.8)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80111] = { -----> Mercedes AMG A250 <----- (PW PODMIANKA WGRANA PRZEZ: francvz (UID: 5138))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            --setVehicleHandling(veh, 'suspensionLowerLimit', -0.15)
        end, 
    },

    [80112] = { -----> Mercedes CLA65 Limousine <----- (PW PODMIANKA WGRANA PRZEZ: francvz (UID: 5138))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
        end,
    },

    [80113] = { -----> Maybach S650 <----- (PW PODMIANKA WGRANA PRZEZ: plazma (UID: 5237))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 25)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
        end,
    },

    [80114] = { -----> Volvo S40 <----- (PW PODMIANKA WGRANA PRZEZ: hoymnieswendzi (UID: 776))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 22)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
        end,
    },

    [80116] = { -----> Aston Martin DB9 <----- (PW PODMIANKA WGRANA PRZEZ: domiqz (UID: 2895))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 22.5)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80117] = { -----> Mercedes G63 6x6 <----- (PW PODMIANKA WGRANA PRZEZ: hoymnieswendzi (UID: 776))
        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 35)
            setVehicleHandling(veh, 'maxVelocity', 3500)
            setVehicleHandling(veh, 'steeringLock', 35)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'brakeDeceleration', 15)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
            --setVehicleHandling(veh, 'mass', 9500)
        end,
    },

    [80118] = { -----> Chevrolet Camaro C7 <----- (PW PODMIANKA WGRANA PRZEZ: DoMiqz (UID: 2895))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 25.3)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80119] = { -----> Polonez FSO <----- (PW PODMIANKA WGRANA PRZEZ: Ogmikooo (UID: 7365))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 21.8)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80120] = { -----> BMW M3 F80 <----- (PW PODMIANKA WGRANA PRZEZ: dawidpers (UID: 934))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 21.8)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.3)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80121] = { -----> Schyster Deviant <----- (PODMIANKA SALON)
        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 16)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'maxVelocity', 320)
        end,
    },

    [80123] = { -----> BMW M760Li <----- (PW PODMIANKA WGRANA PRZEZ: RZURAF (UID: 1343))

        func = function(veh)
            local getVehicleHandlings = getModelHandling(405) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 47)
            setVehicleHandling(veh, 'maxVelocity', 1000)
            setVehicleHandling(veh, 'steeringLock', 40)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.5)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.3)
        end, 

    },

    [80124] = { -----> BULLET GT <----- (PODMIANKA SALON)
        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 18)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'maxVelocity', 480)
        end,
    },

    [80125] = { -----> BMW Z4 GT3 <----- (PW PODMIANKA WGRANA PRZEZ: DoMiqz (UID: 2895))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 25.3)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80126] = { -----> COMET GT <----- (PODMIANKA SALON)
        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 20)
            setVehicleHandling(veh, 'tractionLoss', 1.2)
            setVehicleHandling(veh, 'maxVelocity', 520)
        end,
    },

    [80127] = { -----> Mercedes SLR McLaren 722 <----- (PW PODMIANKA WGRANA PRZEZ: Zagi (UID: 6834))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 25.3)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80128] = { -----> Nissan GT-R R35 Nismo R3 <----- (PW PODMIANKA WGRANA PRZEZ: DoMiqz (UID: 2895))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 25.3)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80129] = { -----> BMW E39 TOURING <----- (PW PODMIANKA WGRANA PRZEZ: Zagi (UID: 6834))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 750)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.6)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80130] = { -----> Bugatti Veyron Grand Spor <----- (PW PODMIANKA WGRANA PRZEZ: Zagi (UID: 6834))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80131] = { -----> GOLF IV <----- (PW PODMIANKA WGRANA PRZEZ: DUMA (UID: 3535))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },


    [80133] = { -----> BMW X7 <----- (PW PODMIANKA WGRANA PRZEZ: chuj wie)
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
        end,
    },


    [80135] = { -----> Audi a3 <----- (PW PODMIANKA WGRANA PRZEZ: DUMECZKA (UID: 3535))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 30)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
            setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
        end,
    },

    [80136] = { -----> Koenigsegg Jesko <----- (PW PODMIANKA WGRANA PRZEZ: Zagi (UID: 6834))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80138] = { -----> Chevrolet Corvette C5 <----- (PW PODMIANKA WGRANA PRZEZ: Estonski (UID: 2030))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80139] = { -----> Dodge Charger SRT Hellcat <----- (PW PODMIANKA WGRANA PRZEZ: dawidpers (UID: 934))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80140] = { -----> Urodzinowa podmianka <----- 
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 23)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80141] = { -----> Ferrari 458 Italia <----- (PW PODMIANKA WGRANA PRZEZ: dawidpers (UID: 934))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80142] = { -----> BMW E92 GT2 <----- (PW PODMIANKA WGRANA PRZEZ: carbo_47 (UID: 866))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 55)
            setVehicleHandling(veh, 'maxVelocity', 3500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80152] = { -----> Mercedes CLA65 Limousine <----- (PW PODMIANKA WGRANA PRZEZ: francvz (UID: 5138))
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 25)
        setVehicleHandling(veh, 'maxVelocity', 750)
        setVehicleHandling(veh, 'steeringLock', 42)
        setVehicleHandling(veh, 'tractionLoss', 1.63)
        setVehicleHandling(veh, 'tractionBias', 0.44)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
        setVehicleHandling(veh, 'suspensionLowerLimit', -0.2)
    end,
},

    [80143] = { -----> MERCEDES GT4 AMG <----- (PW PODMIANKA WGRANA PRZEZ: carbo_47 (UID: 866))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 30)
            setVehicleHandling(veh, 'maxVelocity', 2900)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80144] = { -----> BMW M3 E46 GTR <----- (PW PODMIANKA WGRANA PRZEZ: Zagi (UID: 6834))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 28)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80145] = { -----> BMW M8 GTE <----- (PW PODMIANKA WGRANA PRZEZ: mickosin (UID: 7365))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 25.5)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80146] = { -----> BMW M6 F13 <----- (PW PODMIANKA WGRANA PRZEZ: carbo_47 (UID: 866))
        func = function(veh)
            local getVehicleHandlings = getModelHandling(411)
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end
            setVehicleHandling(veh, 'engineAcceleration', 26)
            setVehicleHandling(veh, 'maxVelocity', 2500)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.8)
            setVehicleHandling(veh, 'tractionBias', 0.48)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end,
    },

    [80167] = { -----> Rolls-Royce Ghost <----- (PW PODMIANKA WGRANA PRZEZ: carbo_47 (UID: 866))
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 3500)
        setVehicleHandling(veh, 'steeringLock', 42)
        setVehicleHandling(veh, 'tractionLoss', 1.8)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
        setVehicleHandling(veh, 'mass', 2000)
    end,
    },

    [80168] = { -----> Aston Martin Victor
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 2500)
        setVehicleHandling(veh, 'steeringLock', 42)
        setVehicleHandling(veh, 'tractionLoss', 1.8)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end,
    },

    [80169] = { -----> Hennessey Venom F5
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 3500)
        setVehicleHandling(veh, 'steeringLock', 42)
        setVehicleHandling(veh, 'tractionLoss', 1.8)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end,
    },

    [80147] = { -- Chevrolet Corvette ZR1 (PW PODMIANKA WGRANA PRZEZ: Hokus (UID: 6769))
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 12000)
        setVehicleHandling(veh, 'steeringLock', 42)
        setVehicleHandling(veh, 'tractionLoss', 1.8)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end,
    },

    [80153] = { -- Toyota Supra 2020
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 3000)
        setVehicleHandling(veh, 'steeringLock', 42)
        setVehicleHandling(veh, 'tractionLoss', 1.8)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end,
    },

    [80154] = { -- BMW i8
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 4000)
        setVehicleHandling(veh, 'steeringLock', 41)
        setVehicleHandling(veh, 'tractionLoss', 2.1)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end,
    },

    [80155] = { -- Porsche carrera
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 3000)
        setVehicleHandling(veh, 'steeringLock', 38)
        setVehicleHandling(veh, 'tractionLoss', 1.9)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end,
    },

    [80156] = { -- Mercedes Benz Gle 350 Coupe
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 2000)
        setVehicleHandling(veh, 'steeringLock', 38)
        setVehicleHandling(veh, 'tractionLoss', 1.9)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end,
    },

    [80157] = { -- Dodge Viper SRT10
    func = function(veh)
        local getVehicleHandlings = getModelHandling(411)
        for i, v in pairs(getVehicleHandlings) do
            setVehicleHandling(veh, i, v)
        end
        setVehicleHandling(veh, 'engineAcceleration', 26)
        setVehicleHandling(veh, 'maxVelocity', 5000)
        setVehicleHandling(veh, 'steeringLock', 41)
        setVehicleHandling(veh, 'tractionLoss', 2.1)
        setVehicleHandling(veh, 'tractionBias', 0.48)
        setVehicleHandling(veh, 'brakeDeceleration', 20)
    end,
    },


}


local handlingListID = {

    [95] = { -- UID: 934 | FBI Rancher (custom hand za 2k wpln)

        func = function(veh)
            setVehicleHandling(veh, 'engineAcceleration', 29)
            setVehicleHandling(veh, 'maxVelocity', 4500)
        end, 

    },

    [7744] = { -- ogien kurwa

        func = function(veh)
            local getVehicleHandlings = getModelHandling(411) 
            for i, v in pairs(getVehicleHandlings) do
                setVehicleHandling(veh, i, v)
            end

            setVehicleHandling(veh, 'engineAcceleration', 75)
            setVehicleHandling(veh, 'maxVelocity', 5000)
            setVehicleHandling(veh, 'steeringLock', 42)
            setVehicleHandling(veh, 'tractionLoss', 1.63)
            setVehicleHandling(veh, 'tractionBias', 0.44)
            setVehicleHandling(veh, 'brakeDeceleration', 20)
        end, 

    },

    

    -- [26183] = { -- Chwytom cie za jaja | Tanker
        
    --     func = function(veh)
    --         setVehicleHandling(veh, 'engineAcceleration', 32)
    --         setVehicleHandling(veh, 'maxVelocity', 1500)
    --         setVehicleHandling(veh, 'tractionLoss', 1.7)
    --         setVehicleHandling(veh, 'mass', 6500)
    --     end, 

    -- },

}

function getVehicleHandlingProperty ( element, property )
    if isElement ( element ) and getElementType ( element ) == "vehicle" and type ( property ) == "string" then
        local handlingTable = getVehicleHandling ( element ) 
        local value = handlingTable[property] 
 
        if value then
            return value
        end
    end
 
    return false
end

function applyEngine(vehicle)
    local vehicleData = getElementData(vehicle, 'vehicle:data') or {}

    if vehicleData then
        local capacity = string.format("%.1f", vehicleData.engine)
        local capacity = tonumber(capacity)

        local maxVelocity = getVehicleHandlingProperty(vehicle, 'maxVelocity')
        local engineAcceleration = getVehicleHandlingProperty(vehicle, 'engineAcceleration')

        if capacity then
            setVehicleHandling(vehicle, 'engineAcceleration', engineAcceleration + (1 * capacity))
            setVehicleHandling(vehicle, 'maxVelocity', maxVelocity + (2 * capacity))
        end
    end
end

function loadVehicleCustomHandling(vehicle)
    local vehicleModel = getElementData(vehicle, 'vehicle:model') or getElementData(vehicle, 'vehicleID') or getElementModel(vehicle)

    if handlingList[vehicleModel] then
        handlingList[vehicleModel].func(vehicle)
    end

    local vehicleID = getElementData(vehicle, 'vehicle:id')
    local vehicleUpgrades = getElementData(vehicle, 'vehicle:upgrades') or {}

    if handlingListID[vehicleID] then
        handlingListID[vehicleID].func(vehicle)
    end

    if vehicleID then
        applyEngine(vehicle)
    end

    if vehicleUpgrades['sport'] then
        local maxVelocity = getVehicleHandlingProperty(vehicle, 'maxVelocity')
        local engineAcceleration = getVehicleHandlingProperty(vehicle, 'engineAcceleration')

        setVehicleHandling(vehicle, 'engineAcceleration', engineAcceleration + 8)
        setVehicleHandling(vehicle, 'maxVelocity', maxVelocity + 16)
    end

    if vehicleUpgrades['electric'] then
        local maxVelocity = getVehicleHandlingProperty(vehicle, 'maxVelocity')
        local engineAcceleration = getVehicleHandlingProperty(vehicle, 'engineAcceleration')

        setVehicleHandling(vehicle, 'engineAcceleration', engineAcceleration + 8)
        setVehicleHandling(vehicle, 'maxVelocity', maxVelocity + 12)
    end

    if vehicleUpgrades['twinturbo'] then
        local maxVelocity = getVehicleHandlingProperty(vehicle, 'maxVelocity')
        local engineAcceleration = getVehicleHandlingProperty(vehicle, 'engineAcceleration')

        setVehicleHandling(vehicle, 'engineAcceleration', engineAcceleration + 8)
        setVehicleHandling(vehicle, 'maxVelocity', maxVelocity + 12)
    end
end
--[[
	Author: https://github.com/Fernando-A-Rocha

	mod_list.lua

	
	Default mods are defined here in 'modList'.
	
	If you to add your mods with other resources (recommended) then you can delete this file.
		The server will assume an empty modList.
]]

-- ....................................... modList explained .......................................
	
-- The following mod list is stored in server only, then sent to client on request
-- These are the default mods, more than be added via functions from other resources

-- 'id' must be unique and out of the default GTA (& preferrably SA-MP too) ID ranges

-- 'base_id' is the model the mod will inherit some properties from
--	Doesn't make much difference on peds(skins), but it does on vehicles & objects

-- 'path' can be:
--		a string, in which case it expects files to be named ID.dff or ID.txd in that folder
-- 		an array(table), in which case it expects an array of file names like {dff="filepath.dff", txd="filepath.txd", col="filepath.col"}
--  		For files encrypted using NandoCrypt, don't add the .nandocrypt extension, it's defined by the 'NANDOCRYPT_EXT' setting
-- 	All paths defined manually in this file need to be local (this resource)
--		To add a mod from another resource see the examples provided in the documentation.

-- 'name' can be whatever you want (string)

-- + optional parameters:

-- 		'lodDistance' : custom LOD distance in GTA units (number), see possible values https://wiki.multitheftauto.com/wiki/EngineSetModelLODDistance
-- 		'ignoreTXD', 'ignoreDFF', 'ignoreCOL' : if true, the script won't try to load TXD/DFF/COL for the mod
--		'metaDownloadFalse' : if true, the mod will be only be downloaded when needed (when trying to set model)
-- 		'disableAutoFree' : if true, the allocated mod ID will not be freed when no element streamed in is no longer using the mod ID
--  		This causes the mod to stay in memory, be careful when enabling for big mods
-- 		'filteringEnabled' (engineLoadTXD)
-- 		'alphaTransparency' (engineReplaceModel)

modList = {
	
	ped = {
		--{id=90001, base_id=1, path="models/peds/", name="Organization Pruszkuf"},
	},

	vehicle = {
		-- {id=80001, base_id=562, path="models/vehicles/", name="BMW M2", disableAutoFree=true},
		-- {id=80002, base_id=562, path="models/vehicles/", name="Nissan Skyline GTR R34", disableAutoFree=true},
		-- {id=80003, base_id=561, path="models/vehicles/", name="Audi RS6 C7", disableAutoFree=true},
		-- {id=80004, base_id=477, path="models/vehicles/", name="BMW M4 Competition", disableAutoFree=true},
		-- {id=80005, base_id=579, path="models/vehicles/", name="Mercedes-Benz G-class G500", disableAutoFree=true},
		-- {id=80006, base_id=560, path="models/vehicles/", name="Audi RS7", disableAutoFree=true},
		-- {id=80007, base_id=516, path="models/vehicles/", name="Mercedes-Benz e63s", disableAutoFree=true},
		-- {id=80008, base_id=506, path="models/vehicles/", name="BMW M8 Competition", disableAutoFree=true},
		-- {id=80009, base_id=560, path="models/vehicles/", name="Mercedes-Benz C63", disableAutoFree=true},
		-- {id=80010, base_id=571, path="models/vehicles/", name="Sanie starego pijanego", disableAutoFree=true},
		-- {id=80011, base_id=559, path="models/vehicles/", name="Toyota Supra", disableAutoFree=true},
		-- {id=80012, base_id=558, path="models/vehicles/", name="Lamborghini Huracan", disableAutoFree=true},
		-- {id=80013, base_id=560, path="models/vehicles/", name="Subaru Impreza STI", disableAutoFree=true},
		-- {id=80014, base_id=560, path="models/vehicles/", name="Bmw m5", disableAutoFree=true},
		-- {id=80015, base_id=565, path="models/vehicles/", name="Honda Civic", disableAutoFree=true},
		-- {id=80016, base_id=547, path="models/vehicles/", name="Mazda RX-7", disableAutoFree=true},
		-- {id=80017, base_id=515, path="models/vehicles/", name="Tir1", disableAutoFree=true},
		-- {id=80018, base_id=514, path="models/vehicles/", name="Tir2", disableAutoFree=true},
		-- {id=80019, base_id=580, path="models/vehicles/", name="Rolls Royce Wraith", disableAutoFree=true},
		-- {id=80020, base_id=411, path="models/vehicles/", name="Nissan GTR-R35", disableAutoFree=true},
		-- {id=80021, base_id=411, path="models/vehicles/", name="Dodge Challenger", disableAutoFree=true},
		-- {id=80022, base_id=429, path="models/vehicles/", name="Pizza Delivery", disableAutoFree=true},
		-- {id=80023, base_id=445, path="models/vehicles/", name="Mercedes artidowski", disableAutoFree=true},
		-- {id=80024, base_id=541, path="models/vehicles/", name="McLaren P1", disableAutoFree=true},
		-- {id=80025, base_id=405, path="models/vehicles/", name="Mercedes GT63 AMG", disableAutoFree=true},
		-- {id=80026, base_id=411, path="models/vehicles/", name="Honda NSX", disableAutoFree=true},
		-- {id=80027, base_id=562, path="models/vehicles/", name="Honda S2000", disableAutoFree=true},
		-- {id=80028, base_id=411, path="models/vehicles/", name="Koenigsegg Agera", disableAutoFree=true},
		-- {id=80029, base_id=411, path="models/vehicles/", name="Bugatti Chiron", disableAutoFree=true},
		-- {id=80030, base_id=579, path="models/vehicles/", name="Lamborghini Urus", disableAutoFree=true},
		-- {id=80031, base_id=411, path="models/vehicles/", name="Ferrari Laferrari", disableAutoFree=true},
		-- {id=80032, base_id=411, path="models/vehicles/", name="Lamborghini Aventador", disableAutoFree=true},
		-- {id=80033, base_id=405, path="models/vehicles/", name="BMW M3 CS", disableAutoFree=true},
		-- {id=80034, base_id=541, path="models/vehicles/", name="Pagani Huayra", disableAutoFree=true},
		-- {id=80035, base_id=506, path="models/vehicles/", name="Koenigsegg CCXR", disableAutoFree=true},
		-- {id=80036, base_id=541, path="models/vehicles/", name="Audi R8", disableAutoFree=true},
		-- {id=80037, base_id=502, path="models/vehicles/", name="McLaren Senna", disableAutoFree=true},
		-- {id=80038, base_id=426, path="models/vehicles/", name="Mercedes CSL 63", disableAutoFree=true},
		-- {id=80039, base_id=579, path="models/vehicles/", name="Bmw X5", disableAutoFree=true},
		-- {id=80040, base_id=480, path="models/vehicles/", name="Porsche 918", disableAutoFree=true},
		-- {id=80041, base_id=411, path="models/vehicles/", name="Buggati Divo", disableAutoFree=true},
		-- {id=80042, base_id=562, path="models/vehicles/", name="Mercedes Benz C63 Coupe", disableAutoFree=true},
		-- {id=80043, base_id=541, path="models/vehicles/", name="Mercedes Benz SL 65 AMG", disableAutoFree=true},
		-- {id=80044, base_id=602, path="models/vehicles/", name="Bentley Continental SuperSport", disableAutoFree=true},
		-- {id=80045, base_id=562, path="models/vehicles/", name="BMW M3 GTR", disableAutoFree=true},
		-- {id=80046, base_id=562, path="models/vehicles/", name="BMW M3 E36", disableAutoFree=true},
		-- {id=80047, base_id=562, path="models/vehicles/", name="BMW M3 E46", disableAutoFree=true},
		-- {id=80048, base_id=415, path="models/vehicles/", name="Ferrari F8 Tributo", disableAutoFree=true},
		-- {id=80049, base_id=541, path="models/vehicles/", name="McLaren 720s Spider", disableAutoFree=true},
		-- {id=80050, base_id=560, path="models/vehicles/", name="Nissan 240SX (S14)", disableAutoFree=true},
		-- {id=80051, base_id=579, path="models/vehicles/", name="Rolls-Royce Cullinan", disableAutoFree=true},
		-- {id=80052, base_id=562, path="models/vehicles/", name="Chevrolet Corvette C8", disableAutoFree=true},
		-- {id=80053, base_id=587, path="models/vehicles/", name="Chevrolet Camaro SS", disableAutoFree=true},
		-- {id=80054, base_id=602, path="models/vehicles/", name="Toyota GT86", disableAutoFree=true},
		-- {id=80055, base_id=602, path="models/vehicles/", name="BMW E30 M3", disableAutoFree=true},
		-- {id=80056, base_id=579, path="models/vehicles/", name="Cadillac Escalade", disableAutoFree=true},
		-- {id=80057, base_id=405, path="models/vehicles/", name="BMW E60 M5", disableAutoFree=true},
		-- {id=80058, base_id=421, path="models/vehicles/", name="BMW Alpina B7", disableAutoFree=true},
		-- {id=80059, base_id=411, path="models/vehicles/", name="BMW E31", disableAutoFree=true},
		-- {id=80060, base_id=405, path="models/vehicles/", name="BMW E39 M5", disableAutoFree=true},
	    -- {id=80061, base_id=541, path="models/vehicles/", name="Maserati GranTurismo", disableAutoFree=true},
	    -- {id=80062, base_id=541, path="models/vehicles/", name="BMW M4", disableAutoFree=true},
	    -- {id=80063, base_id=587, path="models/vehicles/", name="Mitsubishi Eclipse GSX", disableAutoFree=true},
	    -- {id=80064, base_id=405, path="models/vehicles/", name="Seat Leon FR", disableAutoFree=true},
	    -- {id=80065, base_id=491, path="models/vehicles/", name="Coquette", disableAutoFree=true},
	    -- {id=80066, base_id=411, path="models/vehicles/", name="Mercedes 560 Sec AMG", disableAutoFree=true},
	    -- {id=80067, base_id=541, path="models/vehicles/", name="Grotti Venom", disableAutoFree=true},
	    -- {id=80068, base_id=585, path="models/vehicles/", name="Karin Empress", disableAutoFree=true},
	    -- {id=80069, base_id=445, path="models/vehicles/", name="Benefactor Schafter", disableAutoFree=true},
	    -- {id=80070, base_id=415, path="models/vehicles/", name="Deluxo", disableAutoFree=true},
	    -- {id=80071, base_id=551, path="models/vehicles/", name="Mercedes amg", disableAutoFree=true},
	    -- {id=80072, base_id=415, path="models/vehicles/", name="zygzak makalwin jebany", disableAutoFree=true},
	    -- {id=80073, base_id=559, path="models/vehicles/", name="Jester NZX", disableAutoFree=true},
	    -- {id=80074, base_id=415, path="models/vehicles/", name="Aston Martin Vulcan", disableAutoFree=true},
	    -- {id=80075, base_id=411, path="models/vehicles/", name="Ferrari FXXK Evo", disableAutoFree=true},
	    -- {id=80076, base_id=445, path="models/vehicles/", name="Ferrari FXXK Evo", disableAutoFree=true},
	    -- {id=80077, base_id=445, path="models/vehicles/", name="Porsche 911 Carrera", disableAutoFree=true},
	    -- {id=80078, base_id=587, path="models/vehicles/", name="Bmw E24", disableAutoFree=true},
	    -- {id=80079, base_id=560, path="models/vehicles/", name="Mitsubishi Lancer Evolution VI", disableAutoFree=true},
	    -- {id=80080, base_id=602, path="models/vehicles/", name="BMW E92 M3", disableAutoFree=true},
	    -- {id=80081, base_id=426, path="models/vehicles/", name="BMW F10", disableAutoFree=true},
	    -- {id=80082, base_id=587, path="models/vehicles/", name="Mercedes-Benz 600 AMG", disableAutoFree=true},
	    -- {id=80083, base_id=451, path="models/vehicles/", name="Lamborghini Murcielago", disableAutoFree=true},
	    -- {id=80084, base_id=402, path="models/vehicles/", name="Ford Shelby GT500", disableAutoFree=true},
	    -- {id=80085, base_id=506, path="models/vehicles/", name="Ferrari F430", disableAutoFree=true},
	    -- {id=80086, base_id=540, path="models/vehicles/", name="BMW E34", disableAutoFree=true},
	    -- {id=80087, base_id=560, path="models/vehicles/", name="Benefactor S", disableAutoFree=true},
	    -- {id=80088, base_id=555, path="models/vehicles/", name="BMW E9", disableAutoFree=true},
	    -- {id=80089, base_id=551, path="models/vehicles/", name="Alfa-Romeo 159 Ti", disableAutoFree=true},
	    -- {id=80090, base_id=602, path="models/vehicles/", name="Maibatsu Verdana", disableAutoFree=true},
	    -- {id=80091, base_id=602, path="models/vehicles/", name="Karin Vanguard", disableAutoFree=true},
	    -- {id=80092, base_id=507, path="models/vehicles/", name="BMW E38", disableAutoFree=true},
	    -- {id=80093, base_id=579, path="models/vehicles/", name="Brabus 850", disableAutoFree=true},
	    -- {id=80094, base_id=560, path="models/vehicles/", name="Infiniti Q50", disableAutoFree=true},
		-- {id=80095, base_id=436, path="models/vehicles/", name="Weeny Tommy", disableAutoFree=true},
		-- {id=80096, base_id=411, path="models/vehicles/", name="Sultan RS", disableAutoFree=true},
		-- {id=80097, base_id=579, path="models/vehicles/", name="Tesla Model X", disableAutoFree=true},
		-- {id=80098, base_id=562, path="models/vehicles/", name="Nissan Silvia S13", disableAutoFree=true},
		-- {id=80099, base_id=445, path="models/vehicles/", name="Mercedes-Benz W140", disableAutoFree=true},
		-- {id=80100, base_id=579, path="models/vehicles/", name="Tesla Cybertruck", disableAutoFree=true},
		-- {id=80101, base_id=541, path="models/vehicles/", name="Tesla Roadster", disableAutoFree=true},
		-- {id=80102, base_id=405, path="models/vehicles/", name="Tesla Model S", disableAutoFree=true},
		-- {id=80103, base_id=477, path="models/vehicles/", name="Vapid RG21", disableAutoFree=true},
		-- {id=80104, base_id=492, path="models/vehicles/", name="Schyster Warwick", disableAutoFree=true},
		-- {id=80105, base_id=558, path="models/vehicles/", name="Imponte Scorcher", disableAutoFree=true},
		-- {id=80106, base_id=445, path="models/vehicles/", name="Benefactor Zweihander", disableAutoFree=true},
		-- {id=80107, base_id=579, path="models/vehicles/", name="Ford Raptor", disableAutoFree=true},
		-- {id=80108, base_id=551, path="models/vehicles/", name="Merit Amaya", disableAutoFree=true},
		-- {id=80109, base_id=445, path="models/vehicles/", name="BMW E28", disableAutoFree=true},
		-- {id=80110, base_id=411, path="models/vehicles/", name="Lamborghini Centenario", disableAutoFree=true},
		-- {id=80111, base_id=560, path="models/vehicles/", name="Mercedes AMG 250", disableAutoFree=true},
		-- {id=80112, base_id=409, path="models/vehicles/", name="Mercedes CL65 Limousine", disableAutoFree=true},
		-- {id=80113, base_id=560, path="models/vehicles/", name="Mercedes CL65 Limousine", disableAutoFree=true},
		-- {id=80114, base_id=560, path="models/vehicles/", name="Volvo S40", disableAutoFree=true},
		-- {id=80115, base_id=413, path="models/vehicles/", name="Mercedes 307 Minibus", disableAutoFree=true},
		-- {id=80116, base_id=506, path="models/vehicles/", name="Aston Martin DB9", disableAutoFree=true},
		-- {id=80117, base_id=579, path="models/vehicles/", name="g klasa 6x6", disableAutoFree=true},
		-- {id=80118, base_id=415, path="models/vehicles/", name="Chevrolet Corvette C7", disableAutoFree=true},
		-- {id=80119, base_id=560, path="models/vehicles/", name="Polonez FSO", disableAutoFree=true},
		-- {id=80120, base_id=560, path="models/vehicles/", name="BMW F80 M3", disableAutoFree=true},
		-- {id=80121, base_id=439, path="models/vehicles/", name="Deviant", disableAutoFree=true},
		-- {id=80122, base_id=560, path="models/vehicles/", name="Sultan Wagon", disableAutoFree=true},
		-- {id=80123, base_id=560, path="models/vehicles/", name="bmw m760li", disableAutoFree=true},
		-- {id=80124, base_id=541, path="models/vehicles/", name="Bullet GT", disableAutoFree=true},
		-- {id=80125, base_id=415, path="models/vehicles/", name="BMW Z4 GT3", disableAutoFree=true},
		-- {id=80126, base_id=480, path="models/vehicles/", name="Comet GT", disableAutoFree=true},
		-- {id=80127, base_id=415, path="models/vehicles/", name="Mercedes SLR McLaren", disableAutoFree=true},
		-- {id=80128, base_id=415, path="models/vehicles/", name="Nissan GT-R R35 Nismo R3", disableAutoFree=true},
		-- {id=80129, base_id=560, path="models/vehicles/", name="BMW E39 Touring", disableAutoFree=true},
		-- {id=80130, base_id=415, path="models/vehicles/", name="Bugatti Veyron Grand Sport", disableAutoFree=true},
		-- {id=80131, base_id=415, path="models/vehicles/", name="Golf IV", disableAutoFree=true},
		-- {id=80132, base_id=579, path="models/vehicles/", name="Huntley/snieg", disableAutoFree=true},
	    -- {id=80133, base_id=579, path="models/vehicles/", name="BMW X7", disableAutoFree=true},
		-- {id=80134, base_id=436, path="models/vehicles/", name="Toyota MR2", disableAutoFree=true},
		-- {id=80135, base_id=589, path="models/vehicles/", name="Audi A3", disableAutoFree=true},
		-- {id=80136, base_id=415, path="models/vehicles/", name="Koenigsegg Jesko", disableAutoFree=true},
		-- {id=80137, base_id=411, path="models/vehicles/", name="Infernus GT", disableAutoFree=true},
		-- {id=80138, base_id=411, path="models/vehicles/", name="Chevrolet Corvette C5", disableAutoFree=true},
		-- {id=80139, base_id=560, path="models/vehicles/", name="Dodge Charger SRT Hellcat", disableAutoFree=true},
		-- {id=80140, base_id=436, path="models/vehicles/", name="urodzinowy wuz", disableAutoFree=true},
		-- {id=80141, base_id=415, path="models/vehicles/", name="Ferrari 458 Italia", disableAutoFree=true},
		-- {id=80142, base_id=558, path="models/vehicles/", name="BMW E92 GT2", disableAutoFree=true},
		-- {id=80143, base_id=411, path="models/vehicles/", name="MERCEDES GT4 AMG", disableAutoFree=true},
		-- {id=80144, base_id=562, path="models/vehicles/", name="BMW M3 GTR", disableAutoFree=true},
		-- {id=80145, base_id=562, path="models/vehicles/", name="BMW M8 GTE", disableAutoFree=true},
		-- {id=80146, base_id=415, path="models/vehicles/", name="BMW M6 F13", disableAutoFree=true},
		-- {id=80147, base_id=411, path="models/vehicles/", name="Chevrolet Corvette ZR1", disableAutoFree=true},
		-- {id=80148, base_id=579, path="models/vehicles/", name="Cadillac Presidential", disableAutoFree=true},
		-- {id=80149, base_id=543, path="models/vehicles/", name="Sadler", disableAutoFree=true},
		-- {id=80150, base_id=434, path="models/vehicles/", name="Hotknife christmas", disableAutoFree=true},
		-- {id=80151, base_id=560, path="models/vehicles/", name="Hotknife christmas", disableAutoFree=true},
		-- {id=80152, base_id=411, path="models/vehicles/", name="Ferrari SF90", disableAutoFree=true},
		-- {id=80153, base_id=411, path="models/vehicles/", name="Toyota Supra 2020", disableAutoFree=true},
		-- {id=80154, base_id=411, path="models/vehicles/", name="BMW I8", disableAutoFree=true},
		-- {id=80155, base_id=411, path="models/vehicles/", name="Porsche 911 Carrera", disableAutoFree=true},
		-- {id=80156, base_id=579, path="models/vehicles/", name="Mercedes Benz Gle 350 Coupe", disableAutoFree=true},
		-- {id=80157, base_id=411, path="models/vehicles/", name="Dodge Viper SRT10", disableAutoFree=true},
		-- {id=80158, base_id=411, path="models/vehicles/", name="2017 Ferrari J50", disableAutoFree=true},
		-- {id=80159, base_id=445, path="models/vehicles/", name="Mercedes Benz 500E W124", disableAutoFree=true},
		-- {id=80160, base_id=411, path="models/vehicles/", name="Chevrolet Camaro SS", disableAutoFree=true},
		-- {id=80161, base_id=411, path="models/vehicles/", name="BMW M6 GT3", disableAutoFree=true},
		-- {id=80162, base_id=411, path="models/vehicles/", name="Mercedes-Benz CLK GTR", disableAutoFree=true},
		-- {id=80163, base_id=581, path="models/vehicles/", name="Shitzu shinigami", disableAutoFree=true},
		-- {id=80164, base_id=581, path="models/vehicles/", name="BMW S1000RR", disableAutoFree=true},
		-- {id=80165, base_id=581, path="models/vehicles/", name="Kawasaki H2R", disableAutoFree=true},
		-- {id=80166, base_id=579, path="models/vehicles/", name="Rolls-Royce Cullinan", disableAutoFree=true},
		-- {id=80167, base_id=560, path="models/vehicles/", name="Rolls-Royce Ghost", disableAutoFree=true},
		-- {id=80168, base_id=411, path="models/vehicles/", name="Aston Martin Victor", disableAutoFree=true},
		-- {id=80169, base_id=411, path="models/vehicles/", name="Hennessey Venom F5", disableAutoFree=true},
		-- {id=80170, base_id=411, path="models/vehicles/", name="Lamborghini Trzeno", disableAutoFree=true},

	},

	object = {},
}


--{id=80006, base_id=507, path={dff="models/vehicles/elegant.dff", txd="models/vehicles/elegant.txd"}, name="Elegant Test"},
local naczepy={}
naczepy[435]=true
naczepy[450]=true
naczepy[584]=true
naczepy[591]=true

odczep=(
	function(plr)
		if isPedInVehicle(plr) then
			local veh=getPedOccupiedVehicle(plr)
			if veh and isElement(veh) then
				local naczepa=getElementData(veh,"naczepa")
				if naczepa and isElement(naczepa) then
					local rotx,roty,rotz=getElementRotation(naczepa)
					setElementRotation(naczepa, rotx+8,roty,rotz)
					setElementFrozen(naczepa,true)
				end
			end
		end
	end
)
addEventHandler("onVehicleEnter",root,
	function(plr,seat)
		if seat==0 then
			if getElementData(source,"naczepa") then
				setElementSyncer(getElementData(source,"naczepa"),plr)
			end
		end
	end
)

timer={}

addEventHandler("onTrailerDetach",root,
	function(truck)
		if truck and isElement(truck) and source and isElement(source) then
			local model = getElementModel(source)
			setElementData(truck,"naczepa",nil)
			setElementData(source,"tir",nil)
			if not naczepy[model] then return end
			setElementFrozen(source,true)
			setTimer(function(source)
				if source and isElement(source) then
					setElementFrozen(source, false)
				end
			end,10000,1,source)
			timer[source]=setTimer(function(source)
				if source and isElement(source) then
					setElementFrozen(source, true)
					timer[source]=nil
				end
			end,13000,1,source)
		end
	end
)

addEventHandler("onTrailerAttach",root,
	function(truck)
		if truck and isElement(truck) and source and isElement(source) then
			if timer[source] then
				if isTimer(timer[source]) then
					killTimer(timer[source])
				end
				timer[source]=nil
			end
			if naczepy[model] then
				setElementFrozen(source,false)
			end
			setElementData(truck,"naczepa",source)
			setElementData(source,"tir",truck)
			local driver=getVehicleController(truck)
			if driver and isElement(driver) then
				setElementSyncer(source,driver)
			end
		end
	end
)

addEvent("innydill",true)
addEventHandler("innydill",resourceRoot,
	function(nacz)
		if nacz and isElement(nacz) then
			if getElementData(nacz,"tir") then
				local syncer=getElementSyncer(nacz)
				if syncer then
					if client~=syncer then
						triggerClientEvent(syncer, "pobierz_dane",resourceRoot,nacz,client)
					end
				end
			end
		end
	end
)

addEvent("zwroc_dane",true)
addEventHandler("zwroc_dane",resourceRoot,
	function(nacz,x,y,z,rx,ry,rz,klijent)
		if klijent and isElement(klijent) then
			triggerClientEvent(klijent,"synchronizuj",resourceRoot,nacz,x,y,z,rx,ry,rz)
		end
	end
)

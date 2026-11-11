local naczepy={}
naczepy[435]=true
naczepy[450]=true
naczepy[584]=true
naczepy[591]=true

function findRotation( x1, y1, x2, y2 ) 
	local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
	return t < 0 and t + 360 or t
end

setTimer(function()
	for i,v in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(v) then
			if naczepy[getElementModel(v)] then
				if getElementData(v,"tir") then
					local x,y,z=getElementPosition(v)
					local z_poj=nil
					local veh=getElementData(v,"tir")
					if veh and isElement(veh) then
						local px,py,pz=getElementPosition(veh)
						if (getDistanceBetweenPoints3D(x,y,z,px,py,pz)<=10) then
							local rotBetween=findRotation(x,y,px,py)
							local _,_,rot=getElementRotation(v)
							local different=(rotBetween-rot)
							different=math.abs(different)
							if (different<=10) then
								z_poj=veh
							end
						end
						if not z_poj then
							triggerServerEvent("innydill", resourceRoot, v)
						end
					end
				end
			end
		end
	end
end, 1000, 0)

addEvent("synchronizuj",true)
addEventHandler("synchronizuj",resourceRoot,
	function(nacz,x,y,z,rx,ry,rz)
		if nacz and isElement(nacz) then
			local x2,y2,z2=getElementPosition(nacz)
			local rx2,ry2,rz2=getElementRotation(nacz)
			local dane_client=string.format("%d,%d,%d,%d,%d,%d",x2,y2,z2,rx2,ry2,rz2)
			local dane_server=string.format("%d,%d,%d,%d,%d,%d",x,y,z,rx,ry,rz)
			if dane_client==dane_server then
				return
			end
			setElementPosition(nacz,x,y,z)
			setElementRotation(nacz,rx,ry,rz)
		end
	end
)

addEvent("pobierz_dane",true)
addEventHandler("pobierz_dane",resourceRoot,
	function(natsz,klijent)
		local x,y,z=getElementPosition(natsz)
		local rx,ry,rz=getElementRotation(natsz)
		triggerServerEvent("zwroc_dane",resourceRoot,natsz,x,y,z,rx,ry,rz,klijent)
	end
)
getResourceName(getThisResource(), true, 693148775); if true then return end
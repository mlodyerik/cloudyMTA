local img=dxCreateTexture("tasma.png")

function findRotation( x001, y001, x002, y002 ) 
  local t = -math.deg( math.atan2( x002 - x001, y002 - y001 ) )
  return t < 0 and t + 360 or t
end

local x1,y1,z1=nil,nil,nil
local tasmy={}
local tasmy_clienta={}

local dxdraw=(
	function()
		if (#tasmy==0) then
			return
		end
		for i,v in ipairs(tasmy) do
			local bx,by,bz=nil,nil,nil
			if v.plr and isElement(v.plr) then
				bx,by,bz=getPedBonePosition(v.plr,35)
			end
			local rrz=findRotation(v.poczatek[1],v.poczatek[2],v.koniec[1] or bx,v.koniec[2] or by)
			rrz=math.rad(rrz+90)
			local px=(v.koniec[1] or bx) - (1 * math.sin(-rrz))
			local py=(v.koniec[2] or by) - (1 * math.cos(-rrz))
			dxDrawMaterialLine3D(v.poczatek[1],v.poczatek[2],v.poczatek[3],v.koniec[1] or bx,v.koniec[2] or by,v.koniec[3] or bz, img, 0.1, tocolor(255,255,255,255), px,py,v.koniec[3] or bz)
		end
	end
)
addEventHandler("onClientRender",root,dxdraw)

addEvent("evc",true)
addEventHandler("evc",resourceRoot,
	function(ev,arg1,arg2,arg3,arg4,arg5)
		if (ev=="tasma") then
			local plr=arg1
			local stojak=arg2
			local x1,y1,z1=arg3,arg4,arg5
			table.insert(tasmy,{poczatek={x1,y1,z1},koniec={nil,nil,nil},plr=plr,strefa=nil,stojak=stojak})
		elseif (ev=="przetnij_tasme") then
			local plr=arg1
			local stojak=arg2
			local x2,y2,z2=arg3,arg4,arg5
			for i,v in ipairs(tasmy) do
				if (v.plr==plr) and not v.koniec[1] and not v.koniec[2] and not v.koniec[3] then
					v.koniec[1]=x2
					v.koniec[2]=y2
					v.koniec[3]=z2
				end
			end
			table.insert(tasmy,{poczatek={x2,y2,z2},koniec={nil,nil,nil},plr=plr,strefa=nil,stojak=stojak})
		elseif (ev=="zakoncz_tasme") then
			local plr=arg1
			local px,py,pz=nil,nil,nil
			local kx,ky,kz=nil,nil,nil
			local ilosc_tasm_danego_gracza=0
			local stojak=nil
			for i,v in ipairs(tasmy) do
				if (v.plr==plr) then
					ilosc_tasm_danego_gracza=ilosc_tasm_danego_gracza+1
				end
			end
			if ilosc_tasm_danego_gracza<3 then
				if (plr==localPlayer) then
					exports['since-notifications']:sendNotification('error', 'Taśma musi mieć przynajmniej 3 wierzchołki (3 stojaki).')
				end
				return
			end
			for i,v in ipairs(tasmy) do
				if (v.plr==plr) then
					px,py,pz=v.poczatek[1],v.poczatek[2],v.poczatek[3]
					break
				end
			end
			for i,v in ipairs(tasmy) do
				if (v.plr==plr) then
					kx,ky,kz=v.poczatek[1],v.poczatek[2],v.poczatek[3]
					if not v.koniec[1] and not v.koniec[2] and not v.koniec[3] then
						if v.stojak then
							stojak=v.stojak
						end
						table.remove(tasmy,i)
						break
					end
				end
			end 
			table.insert(tasmy,{poczatek={px,py,pz},koniec={kx,ky,kz},plr=plr,strefa=nil,stojak=stojak})
			if (localPlayer==plr) then
				for i,v in ipairs(tasmy) do
					if (v.plr==plr) then
						table.insert(tasmy_clienta,{poczatek={v.poczatek[1],v.poczatek[2],v.poczatek[3]},koniec={v.koniec[1],v.koniec[2],v.koniec[3]},plr=plr,strefa=nil,stojak=v.stojak})
					end
				end
				triggerServerEvent("ev",resourceRoot,"zakoncz_tasme",tasmy_clienta)
				tasmy_clienta={}
			end
		elseif (ev=="pobierz_tasmy") then
			local player=nil
			if arg2 then
				player=arg2
			end
			local niedokonczone_tasmy={}
			if player then
				for i,v in ipairs(tasmy) do
					if not v.strefa and (v.plr~=player) then
						table.insert(niedokonczone_tasmy,v)
					end
				end
			end
			tasmy=arg1
			if player then
				if (#niedokonczone_tasmy>0) then
					for i,v in ipairs(niedokonczone_tasmy) do
						table.insert(tasmy,{poczatek={v.poczatek[1],v.poczatek[2],v.poczatek[3]},koniec={v.koniec[1],v.koniec[2],v.koniec[3]},plr=v.plr,strefa=v.strefa,stojak=v.stojak})
					end
				end
			end
		end
	end
)

local isNaSluzbie=(function(plr)
		if getElementData(plr, "player:faction") then
			return true
		end
		return false
end)

addEventHandler("onClientColShapeHit", resourceRoot,
	function(obj,dim)
		if (getElementType(obj)=="vehicle") or (getElementType(obj)=="player") then
			if (getElementType(obj)=="player") then
				if isPedInVehicle(obj) then
					return
				end
			end
			
			
			if not dim then
				return
			end
			
			local z_s=nil
			for i,v in ipairs(tasmy) do
				if (v.strefa==source) then
					z_s=v
				end
			end
			if z_s then
				local _,_,pozZ=getElementPosition(obj)
				local strZ=z_s.poczatek[3]
				if (math.abs(pozZ-strZ)>10) then
					return
				end
			end

			if (getElementType(obj)=="vehicle") then
				local controller=getVehicleController(obj)
				if controller and isElement(controller) then
					if isNaSluzbie(controller) then
						return
					end
				end
				
			end
			if isNaSluzbie(obj) then
				return
			end

			local x,y,z=getElementVelocity(obj)

			local dzielnik=0.1
			local mnoznikx=1
			local mnozniky=1
			if 0>x then
				x=x*(0-1)
				mnoznikx=0-1
			end
			if 0>y then
				y=y*(0-1)
				mnozniky=0-1
			end
			
			local odrzut=0.15
			
			if x>=y then
				dzielnik=x/y
				x=odrzut
				y=x/dzielnik
			elseif y>x then
				dzielnik=y/x
				y=odrzut
				x=y/dzielnik
			end

			x=x*mnoznikx
			y=y*mnozniky
			if (not tonumber(tostring(x)) or not tonumber(tostring(y)) or not tonumber(tostring(z))) then
				return
			end
			if (getElementType(obj)=="player") then
				if isPedInVehicle(obj) then
					return
				end
				setElementVelocity(obj, x,y,0.3)
				local _,_,rotacjaZ=getElementRotation(obj)
				setElementRotation(obj, 0,0,rotacjaZ+180)
				setPedCameraRotation(obj, rotacjaZ+180)
				setTimer(function()
					if obj and isElement(obj) then
						setElementVelocity(obj, (0-x),(0-y),0)
					end
				end, 50, 1)
			else
				setElementVelocity(obj, (0-x), (0-y), 0)
			end
		end
	end
)

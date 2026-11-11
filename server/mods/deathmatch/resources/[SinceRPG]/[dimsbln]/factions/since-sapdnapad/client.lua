local sx, sy = guiGetScreenSize()
local zoom = 1920/sx

local peds = {
    --{281, -1605.57, 700.4, 13.87, 0, "INT_OFFICE", "OFF_Sit_Idle_Loop"},
	{281, 1562.75, -1636.62, 84.51, 130, 'DEALER', 'dealer_idle'},
}

local cuboid = createColCuboid(606.80, -583.46, 15.62, 25.32, 23.42, 10.40)
setElementDimension(cuboid, 291)

--local cuboid = createColCuboid(1558.66, -1638.84, 83.51, 18.05, 8.53, 3.90)

for i,v in ipairs(peds) do
	if i == 2 then
    	myPed = createPed(v[1], v[2], v[3], v[4], v[5])
    	setElementFrozen(myPed, true)
    	setElementDimension(myPed, 291)
		--setElementData(myPed, "ped:nametag", "#ff0000Strażnik więzienny\n ")
		if v[6] == false then

		else
    		setPedAnimation(myPed, v[6], v[7], -1, true, false)
		end
    	setElementData(myPed, "napad:sapd:ped", true)
	else
    	local ped = createPed(v[1], v[2], v[3], v[4], v[5])
    	setElementFrozen(ped, true)
    	setElementDimension(ped, 291)
		if v[6] == false then

		else
    		setPedAnimation(ped, v[6], v[7], -1, true, false)
		end
    	--setElementData(ped, "napad:sapd:ped", true)
	end
end

addEventHandler("onClientPedDamage", resourceRoot, function()
    cancelEvent()
end)

local letters = {"q", "w", "e", "r", "i", "o", "a", "s", "d", "f", "h", "k", "l", "z", "x", "n", "m"}

local font = dxCreateFont("Poppins-Regular.ttf", 40) or "default"

local napad, stage, tick, m, s, try = false, 1, false, 0, 0, false

function render()
	if stage == 1 then
		dxDrawRectangle(0/zoom, 0/zoom, sx, sy, tocolor(34, 34, 34, 180), false)
		dxDrawRectangle(sx/2 - 80/zoom/2, sy - 300/zoom, 80/zoom, 80/zoom, tocolor(40, 40, 40, 220), false)

		dxDrawRectangle(sx/2 - 80/zoom/2, sy - 300/zoom, 80/zoom, 2/zoom, tocolor(35, 230, 80))
		dxDrawRectangle(sx/2 - 80/zoom/2, sy - 220/zoom, 80/zoom, 2/zoom, tocolor(35, 230, 80))
		--dxDrawRectangle(sx/2 - 100/zoom/2, sy - 300/zoom, 80/zoom, 2/zoom, tocolor(255, 140, 0))

		dxDrawText(LETTER, sx/2, sy - 255/zoom, center, center, white, 1/zoom, font, "center", "center", false, false, false, false)
	elseif stage == 2 then
		if getTickCount() - tick >= 1000 then
			if m <= 0 and s <= 0 then
				guiSetInputMode("allow_binds")
				triggerServerEvent("enonek-sapdnapad:end", resourceRoot)
				removeEventHandler("onClientCharacter", root, onCharacter)
				removeEventHandler("onClientRender", root, render)
				return false
			end
			if s <= 0 then
				s = 60
				m = m - 1
			end

			s = s - 1
			tick = getTickCount()
		end

		dxDrawText("Do końca napadu pozostało: "..string.format("%02d", m)..":"..string.format("%02d", s).."", sx/2, sy - 20/zoom, center, center, white, 2/zoom, "default", "center", "center", false, false, false, false)
	end
end
--addEventHandler("onClientRender", root, render)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if getElementData(localPlayer, "player:napad:sapd") then
		guiSetInputMode("allow_binds")
		removeEventHandler("onClientCharacter", root, onCharacter)
		removeEventHandler("onClientRender", root, render)
		setElementData(localPlayer, "player:napad:sapd", false)
	end
end)

addEvent("enonek-sapdnapad:przerwij", true)
addEventHandler("enonek-sapdnapad:przerwij", resourceRoot, function()
	if getElementData(localPlayer, "player:napad:sapd") then
		guiSetInputMode("allow_binds")
		removeEventHandler("onClientCharacter", root, onCharacter)
		removeEventHandler("onClientRender", root, render)
		setElementData(localPlayer, "player:napad:sapd", false)
	end
end)

addEventHandler("onClientColShapeLeave", cuboid, function(el)
	if el == localPlayer and getElementData(localPlayer, "player:napad:sapd") then
		guiSetInputMode("allow_binds")
		removeEventHandler("onClientCharacter", root, onCharacter)
		removeEventHandler("onClientRender", root, render)
		setElementData(localPlayer, "player:napad:sapd", false)
		exports['since-notifications']:sendNotification('info', 'Opuściłeś(aś) teren napadu, napad został anulowany')
		--outputChatBox("#ff0000✘ #ffffffOpuszczasz teren napadu, napad został anulowany.", 255, 255, 255, true)
	end
end)

function onCharacter(let)
	if napad then
		if let == LETTER then
			if current == 3 then
				removeEventHandler("onClientCharacter", root, onCharacter)
				tick = getTickCount()
				m, s = 4, 59
				stage = 2
				exports['since-notifications']:sendNotification('success', 'Napad na więzienie został rozpoczęty')
				exports['since-notifications']:sendNotification('info', 'Nie wychodź poza teren więzienia, gdyż napad zostanie przerwany. Frakcja San Andreas Police Deparmtent otrzymała zgłoszenie dot. napadu')
				triggerServerEvent("enonek-sapdnapad:info", resourceRoot)
				setElementData(localPlayer, "player:napad:sapd", true)
				return false
			end
			current = current + 1
			LETTER = letters[math.random(1, #letters)]
		else
			current = 0
			removeEventHandler("onClientRender", root, render)
			removeEventHandler("onClientCharacter", root, onCharacter)
			guiSetInputMode("allow_binds")
			napad = false
			exports['since-notifications']:sendNotification('error', 'Klawisz został nieprawidłowo wciśnięty')
		end
	end
end

function startRobbery()
	if napad then
		return false
	end

	napad = true
	LETTER = letters[math.random(1, #letters)]
	current = 0
	stage = 1
	addEventHandler("onClientRender", root, render)
	addEventHandler("onClientCharacter", root, onCharacter)
	guiSetInputMode("no_binds_when_editing")
end

addEvent("enonek-sapdnapad:settick", true)
addEventHandler("enonek-sapdnapad:settick", resourceRoot, function(state)
	if not state then
		exports['since-notifications']:sendNotification('error', 'Rozpocząć napad można co 15 minut')
		return false
	else
		startRobbery()
	end
end)

local light = dxCreateFont("Cabin-Regular.ttf", 13) or "default"

local function renders()
	--[[local rootx, rooty, rootz = getCameraMatrix()
	local x, y, z = getPedBonePosition(myPed, 8)
	local sxc, syc = getScreenFromWorldPosition(x, y, z+0.33)
	if sxc and syc then
		local distance = getDistanceBetweenPoints3D(rootx, rooty, rootz, x, y, z)       									 
		if(distance <= 12) then
			if isLineOfSightClear(rootx,rooty,rootz, x,y,z, true, false, false, true, false, false, true, localPlayer) then
				dxDrawText("#ff0000Strażnik więzienny", sxc+1, syc+1, sxc+1, syc+1, tocolor(255, 255, 255, 200), 1.00/zoom, light, "center", "center", false, false, false, true)	  
			end
		end
	end]]



	local target = getPedTarget(localPlayer)
	if getPedWeapon(localPlayer) == 0 then 
        return false
    end

	if target and isElement(target) and getElementType(target) == "ped" and isPedAiming(localPlayer) then
		local x, y, z = getElementPosition(localPlayer)
		local x2, y2, z2 = getElementPosition(target)
		if getDistanceBetweenPoints3D(x, y, z, x2, y2, z2) < 7 then
			if getElementData(target, "napad:sapd:ped") then
				if try then
					if getTickCount() - try < 2000 then
						return false
					end
				end

        	    triggerServerEvent("enonek-sapdnapad:gettick", resourceRoot)
				try = getTickCount()
			end
		end
	end
end

addEventHandler("onClientElementStreamIn", resourceRoot, function()
	if (source == myPed) then
		addEventHandler("onClientRender", root, renders)
	end
end)

addEventHandler("onClientElementStreamOut", resourceRoot, function()
	if (source == myPed) then
		removeEventHandler("onClientRender", root, renders)
	end
end)

function isPedAiming(thePedToCheck)
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(thePedToCheck) then
				return true
			end
		end
	end
	return false
end
getResourceName(getThisResource(), true, 567418620); if true then return end
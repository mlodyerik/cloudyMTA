--[[mig = {}

function pacholek(source,command)
if getElementData(source,'player:faction') and getElementData(source,'player:faction')=='SAFD' then
    local rbs = getElementData(source,'player:rbs') or {}

            local x,y,z = getElementPosition(source)

            local rotX,rotY,rotZ = getElementRotation(source)
            local ob = createObject(1238,x,y,z-0.65,0,0,rotZ)
            local s = createMarker(x,y,z-0.30,'corona',1,255,255,0,125)
            mig[s] = true
            --setElementAlpha(s,0)
			setElementFrozen(ob,true)
			triggerClientEvent("setBreakable",root,ob)
            setElementParent(s,ob)
            table.insert(rbs, ob  )
            setTimer(function() if isElement(ob) then destroyElement(ob) end end,60000 * 20,1)            
			--setElementID ( roadblockobject, rbo )
            setElementPosition ( source, x, y, z+1 )
            outputChatBox('Ustawiono pachołek świecący.',source,255,255,0)
            setElementData(source,'player:rbs',rbs)
            setElementInterior(ob, getElementInterior(source))
            setElementDimension(ob, getElementDimension(source))

end
end

function wentylator(source,command)
if getElementData(source,'player:faction') and getElementData(source,'player:faction')=='SAFD' then
    local rbs = getElementData(source,'player:rbs') or {}

            local x,y,z = getElementPosition(source)

            local rotX,rotY,rotZ = getElementRotation(source)
            local ob = createObject(323,x,y,z-0.65,0,0,rotZ)
            --local s = createMarker(x,y,z-0.30,'corona',1,255,255,0,125)
            --mig[s] = true
            --setElementAlpha(s,0)
			setElementFrozen(ob,true)
			triggerClientEvent("setBreakable",root,ob)
            setElementParent(s,ob)
            table.insert(rbs, ob  )
            setTimer(function() if isElement(ob) then destroyElement(ob) end end,60000 * 20,1)            
			--setElementID ( roadblockobject, rbo )
            setElementPosition ( source, x, y, z+1 )
            outputChatBox('Ustawiono wentylator.',source,255,255,0)
            setElementData(source,'player:rbs',rbs)
            setElementInterior(ob, getElementInterior(source))
            setElementDimension(ob, getElementDimension(source))

end
end


setTimer(function()
	if not mig then return end
	for key, value in pairs(mig) do
		if isElement(key) then
			if getElementType(key) ~= "marker" then return end
			local r, g, b = getMarkerColor(key)
			if ( r == 255 and g == 255 ) then
				setMarkerColor(key,255,0,0,125)
			else
				setMarkerColor(key,255,255,0,125)
			end
		end
	end
end, 1500, 0)

addCommandHandler('ustaw',function(source,cmd,arg)
if not arg then return end
if getElementData(source,'player:faction') and getElementData(source,'player:faction')=='SAFD' then
	outputChatBox("/ustaw [pacholek/barierka/bariera/swiatlo] Blokady znikają po 40min.",source)
	if arg == "pacholek" then
	pacholek(source)
	elseif arg == "barierka" then
	barierka(source)
	elseif arg == "parawan" then
	parawan(source)
	elseif arg == "bariera" then
	bariera(source)
	elseif arg == "swiatlo"then
	swiatlo(source)
	elseif arg == "wentylator"then
	wentylator(source)
	end
	end
end)

        function parawan(source,command)
    if getElementData(source,'player:faction') and getElementData(source,'player:faction')=='SAFD' then
        local rbs = getElementData(source,'player:rbs') or {}
    
                local x,y,z = getElementPosition(source)
    
                local rotX,rotY,rotZ = getElementRotation(source)
    
                local obj = createObject(1852, x,y,z-0.25,90,0,rotZ) --1239
                table.insert(rbs,obj )
                            setTimer(function() if isElement(obj) then destroyElement(obj) end end,120000 * 20,1)  
                setElementID ( roadblockobject, rbs )
                --setElementPosition ( source, x, y, z )
                triggerClientEvent("setBreakable",root,obj)
                setElementFrozen(obj,true)
                outputChatBox('#06B200(✔) #FFFFFFPomyślnie ustawiono parawan. ID: '..#rbs,source,255,255,0, true)
                setElementData(source,'player:rbs',rbs)
    
                setElementInterior(obj, getElementInterior(source))
                setElementDimension(obj, getElementDimension(source))
    
    end
    end
    

addCommandHandler('usun',function(source,cmd,arg,arg2)
if not arg then return end
if getElementData(source,'player:faction') and getElementData(source,'player:faction')=='SAFD' then
	outputChatBox("/usun [blokady/blokade]",source)
	if arg == "blokady" then
	blokady(source)
	elseif arg == "blokade" then
	if not arg2 then outputChatBox("Wpisz id blokady!",source) return end
	blokade(source,arg2)
	end
	end
end)
function barierka(source,command)
if getElementData(source,'player:faction') and getElementData(source,'player:faction')=='SAFD' then
    local rbs = getElementData(source,'player:rbs') or {}

            local x,y,z = getElementPosition(source)

            local rotX,rotY,rotZ = getElementRotation(source)

            local obj = createObject(1228,x,y,z-0.65,0,0,rotZ)
            table.insert(rbs,obj )
			setTimer(function() if isElement(obj) then destroyElement(obj) end end,60000 * 20,1)
            --setElementID ( roadblockobject, rbo )
            setElementPosition ( source, x, y, z+1 )
			triggerClientEvent("setBreakable",root,obj)
			setElementFrozen(obj,true)
            outputChatBox('Ustawiono barierkę.',source,255,255,0)
            setElementData(source,'player:rbs',rbs)
			setElementData(obj,"create:player",getPlayerName(source))
            setElementInterior(obj, getElementInterior(source))
            setElementDimension(obj, getElementDimension(source))

end
end]]
--[[
function swiatlo(source,command)
if getElementData(source,'player:faction') and getElementData(source,'player:faction')=='SAFD' then
    local rbs = getElementData(source,'player:rbs') or {}

            local x,y,z = getElementPosition(source)

            local rotX,rotY,rotZ = getElementRotation(source)

            local obj = createObject(1262,x,y,z+2,0,0,rotZ)
            table.insert(rbs,obj )
			setTimer(function() if isElement(obj) then destroyElement(obj) end end,60000 * 20,1)  
            --setElementID ( roadblockobject, rbo )
            setElementPosition ( source, x, y, z+1 )
			setElementFrozen(obj,true)
			triggerClientEvent("setBreakable",root,obj)
            outputChatBox('Ustawiono swiatlo.',source,255,255,0)
            setElementData(source,'player:rbs',rbs)
			setElementData(obj,"create:player",getPlayerName(source))
            setElementInterior(obj, getElementInterior(source))
            setElementDimension(obj, getElementDimension(source))

end
end

function bariera(source,command)
if getElementData(source,'player:faction') and getElementData(source,'player:faction')=='SAFD' then

    local rbs = getElementData(source,'player:rbs') or {}

            local x,y,z = getElementPosition(source)

            local rotX,rotY,rotZ = getElementRotation(source)

            local obj = createObject(3578,x,y,z-0.65,0,0,rotZ)
            table.insert(rbs,obj )
			setTimer(function() if isElement(obj) then destroyElement(obj) end end,60000 * 20,1)  
          setElementPosition ( source, x, y, z+1 )
			triggerClientEvent("setBreakable",root,obj)
            outputConsole(x..','..y..','..z)
            outputChatBox('Ustawiono barierę.',source,255,255,0)
			setElementData(obj,"create:player",getPlayerName(source))
            setElementData(source,'player:rbs',rbs)
			setElementFrozen(obj,true)
            setElementInterior(obj, getElementInterior(source))
            setElementDimension(obj, getElementDimension(source))

end
end
]]--


function blokady(plr)
if getElementData(plr,'player:rbs') then
for key, value in ipairs(getElementData(plr,'player:rbs')) do
if isElement(value) then
destroyElement(value)
end
end
outputChatBox('*Usunąłeś blokady.',plr,255,255,255,true)
removeElementData(plr,'player:rbs')
end
end



function blokade(plr,value)
if value then
local rbs = {}  
for key, v in ipairs(getElementData(plr,'player:rbs')) do
if isElement(v) and key == tonumber(value) then
destroyElement(v)
outputChatBox('Usunołeś Blokadę ID: '..key,plr,255,255,0)
else
table.insert(rbs,v)
end
setElementData(plr,'player:rbs',rbs)
end
else
--outputChatBox('Aby usunąc blokade wpisz /'..CommandName..' [id]',player,150,0,0)
end
end

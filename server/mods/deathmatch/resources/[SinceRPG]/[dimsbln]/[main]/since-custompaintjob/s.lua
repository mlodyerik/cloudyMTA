
--[[list = {}
function search_vehicles()
list = {}
	for i,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v,"veh:maskownice") then
			table.insert(list,{v,'vehicleshatter128','vehiclegeneric256','maskownice'})
		end
		if getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 7 then
			table.insert(list,{v,'zadyma_pj_elegy','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 7512 then
			table.insert(list,{v,'elegy1_Krycha','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 5763 then
			table.insert(list,{v,'zadyma_pj_elegy2','elegy2body256','pj'})
			table.insert(list,{v,'felgi/tarcze/124_bremze','bde4b713','tarcze',255,0,0})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 5913 then
			table.insert(list,{v,'As1k0_pj_elegy','elegy2body256','pj'})			
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 6024 then
			table.insert(list,{v,'elegy1_livery9','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 10526 then
			table.insert(list,{v,'lucyfer_pj_elegy','elegy2body256','pj'})	
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 742 then
			table.insert(list,{v,'pjlucyfer69','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 17048 then
			table.insert(list,{v,'lucyfer_pj_elegy','elegy2body256','pj'})	
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 19265 then
			table.insert(list,{v,'pandziaidiota','elegy2body256','pj'})	
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 8546 then
			table.insert(list,{v,'szwagierpaint','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 24 then
			table.insert(list,{v,'yokinashifrajer','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 15297 then
			table.insert(list,{v,'profekpj','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 17 then
			table.insert(list,{v,'lucyfersiur','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 3685 then
			table.insert(list,{v,'wesolyxd','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 770 then
			table.insert(list,{v,'ziomekcwelxd','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 137 then
			table.insert(list,{v,'ziomeksultan','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 605 then
			table.insert(list,{v,'toxicsultan','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 6525 then
			table.insert(list,{v,'nikorpj','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 15468 then
			table.insert(list,{v,'skun','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 5144 then
			table.insert(list,{v,'ajakcwel','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 12069 then
			table.insert(list,{v,'lucypj','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 32236 then
			table.insert(list,{v,'XDD','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 35115 then
			table.insert(list,{v,'spamer','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 131 then
			table.insert(list,{v,'pjyama','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 36 then
			table.insert(list,{v,'leokadia','sultan1body','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 33606 then
			table.insert(list,{v,'squpj','elegy2body256','pj'})
		elseif getElementData(v,"vehicle:id") and getElementData(v,"vehicle:id") == 8977 then
			table.insert(list,{v,'spamer','elegy2body256','pj'})
		end
	end
	triggerClientEvent( root, "refresh:tune:client", resourceRoot,list )			
end]]

function loadNeverToPedalMaska2(veh)
	--triggerClientEvent( root, "refresh:tune:client2", resourceRoot,veh )	
end

function Install_PaintJob(veh,name)
	--triggerClientEvent( root, "refresh:tune:Install_PaintJob", resourceRoot,veh,name )	


end

function el()
	for i,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v,"veh:Custom_PaintJob") then
			Install_PaintJob(v,getElementData(v,"veh:Custom_PaintJob"))
		
		end
	end
end

--[[setTimer(function()
el()
end,1000,1)]]

--setTimer(function()search_vehicles()end,6500,0)


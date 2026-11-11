local armas = {22,23,24,25,26,27,28,29,30,31,32,33,34,38}
local skills = {"pro","std","poor"}

function setNoRecoil(tipo)
	for _,id in ipairs(armas) do
		for _,skill in ipairs(skills) do
			if (tipo == "ativar") then
				setWeaponProperty ( id, skill, "accuracy", 10000 )
			elseif (tipo == "desativar") then
				local original = getOriginalWeaponProperty ( id, skill, "accuracy" )
				setWeaponProperty ( id, skill, "accuracy", original )
			end
		end
	end
end

addEventHandler( "onResourceStart", resourceRoot,
	function()
		setNoRecoil("ativar")
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function()
		setNoRecoil("desativar")
	end
)
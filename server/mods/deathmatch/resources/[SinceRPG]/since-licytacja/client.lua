--[[
	Author: EnoNeK
	For: cloudyMTA
--]]

local font = dxCreateFont("files/Poppins-Regular.ttf", 47)

--local object = createObject(7914, 405.26, 2476.20, 25.48, 0, 0, 180)
local object = createObject(7914, 405.26, 2433.3, 23.5, 0, 0, 180)
setElementDoubleSided(object, true)
--setObjectScale(object, 0.5)

function removeHex(s)
    return s:gsub ("#%x%x%x%x%x%x", "") or false
end

local function przecinek(amount) 
	local formatted = amount 
	while true do   
	  formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1.%2') 
	  if (k==0) then 
		break 
	  end 
	end 
	return formatted 
end

local licytacja = false
local przez = false
local minimalna = 1
local time_end = 30

local shader = dxCreateShader("files/shader.fx")
renderTarget = dxCreateRenderTarget(1400, 1000, true)

function loadTable()
	dxSetRenderTarget(renderTarget, false)
    dxSetBlendMode("modulate_add")
	    dxDrawRectangle(0, 0, 1400, 1000, tocolor(40, 40, 40), false)
        dxDrawImage(0, 0, 1400, 1000, ":since-licytacja/files/bg.png", 0, 0, 0)
        if licytacja then
            if time > 0 then
                dxDrawText(text.."\nLicytacja rozpocznie się za "..time.." sekund!", 700, 500, center, center, white, 1, font, "center", "center", false, false, false, false)
            elseif not przez and not licytacja_end then
                dxDrawText("Pozostały czas: 00:"..time_end.."\n\nNajwyższa oferta:\n\nBrak\n\n#ffffffKwota początkowa: #3dfc03"..przecinek(poczatkowa).." $\n\n#ffffffAby podbić kwote użyj: #3dfc03/podbij kwota\n\n#ffffffMinimalna kwota podbicia: #3dfc03"..przecinek(minimalna).." $", 700, 500, center, center, white, 1, font, "center", "center", false, false, false, true)
            elseif przez and not licytacja_end then
                dxDrawText("Pozostały czas: 00:"..time_end.."\n\nNajwyższa oferta:\n\n"..przez..": #FF8C00"..przecinek(aktualnie).." $\n\n#ffffffKwota początkowa: #3dfc03"..przecinek(poczatkowa).." $\n\n#ffffffAby podbić kwote użyj: #3dfc03/podbij kwota\n\n#ffffffMinimalna kwota podbicia: #FF8C00"..przecinek(minimalna).." $", 700, 500, center, center, white, 1, font, "center", "center", false, false, false, true)
            elseif licytacja_end then
                dxDrawText(licytacja_end, 700, 500, center, center, white, 1, font, "center", "center", false, false, false, true)
            end
        else
            dxDrawText("Licytacja w tej chwili jest wyłączona!", 700, 500, center, center, white, 1, font, "center", "center", false, false, false, false)
        end
    dxSetBlendMode("blend")  
	dxSetRenderTarget()  
    
	dxSetShaderValue(shader, "gTexture", renderTarget)
	engineApplyShaderToWorldTexture(shader, "didersachs01", object)
end
loadTable()

addEvent("enonek-licytacje", true)
addEventHandler("enonek-licytacje", resourceRoot, function(text2, time2, aktualnie2, minimalna2)
    text = text2
    time = time2
    aktualnie = aktualnie2
    poczatkowa = aktualnie2
    minimalna = minimalna2
    licytacja = true
    loadTable()

    timer = setTimer(function()
        if time > 0 then
            time = time - 1
        end

        if time_end == 0 and not przez then
            licytacja_end = "Licytacja została zakończona\n\nNikt nie brał udziału w licytacji"
        end
    
        if time_end == 0 and przez then
            licytacja_end = "Licytacja została zakończona\n\n"..removeHex(przez).." - #FF8C00"..przecinek(aktualnie).." $"
        end
        if time_end > 0 and time == 0 then
            time_end = time_end - 1
        end
        loadTable()
    end, 1000, 0)
end)

--local cooldown = false


addEvent("enonek-licytacje:podbij", true)
addEventHandler("enonek-licytacje:podbij", resourceRoot, function(player, price)
    if licytacja_end then
        return false
    end
    --[[if cooldown then
        return false
    end--]]
    --cooldown = true
    --[[setTimer(function()
        cooldown = false
    end, 3000, 1)--]]
    aktualnie = aktualnie + price
    local name = getPlayerName(player)
    przez = removeHex(name)
    time_end = 30
    loadTable()
end)

addEvent("enonek-licytacje:end", true)
addEventHandler("enonek-licytacje:end", resourceRoot, function()
    licytacja = false
    licytacja_end = false
    licytacja = false
    przez = false
    minimalna = 1
    time_end = 30
    killTimer(timer)
    loadTable()
end)
getResourceName(getThisResource(), true, 970756883); if true then return end
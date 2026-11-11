sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

local options = {
	['vehicle'] = {
		['SARA'] = {
			{'Spuść/Zaciągnij ręczny', 'reczny'},
			{'Zatankuj pojazd', 'tank'},
		},

		['SAPD'] = {
			{'Wystaw mandat', 'mandat'},
			{'Spuść/Zaciągnij ręczny', 'reczny'},
		},
	},
}

local options = {
    ["vehicle"] = {
        ["SAPD"] = {
            {"Wystaw mandat", "mandat"},
            {"Spuść/Zaciągnij ręczny", "reczny"},
        },

        ["SARA"] = {
            {"Spuść/Zaciągnij ręczny", "reczny"},
        },
    },
}

function renderUI()
	if (getPedWeapon(localPlayer) ~= 32) then
		return
	end
	if (isPedAiming() and getPlayerTarget(localPlayer) and getElementType(getPlayerTarget(localPlayer)) == 'vehicle') then
		ui.vehicle = getPlayerTarget(localPlayer)
	else
		ui.vehicle = false
		return
	end

	local vehicleID = getElementData(ui.vehicle, 'vehicle:id') or 'Zrespiony'
	local owner = getElementData(ui.vehicle, 'vehicle:ownedPlayer') or 'Zrespiony'
	local driver = getElementData(ui.vehicle, 'vehicle:driver') or 'Brak'

	dxDrawImage(sx/2 - 216/zoom, sy/2 + 342/zoom, 431.000/zoom, 178.000/zoom, 'data/bg.png')
	dxDrawText('Informacje o pojeździe', sx/2, sy/2 + 347/zoom, nil, nil, tocolor(35, 229, 82, 216), 1, getFigmaFont('Inter-Bold', 13.333/zoom), 'center', 'top')
	dxDrawText('Model:', sx/2 - 212/zoom, sy/2 + 375/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Medium', 13.333/zoom), 'left', 'top')
	dxDrawText('ID:', sx/2 - 212/zoom, sy/2 + 400/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Medium', 13.333/zoom), 'left', 'top')
	dxDrawText('Tablica rejestracyjna:', sx/2 - 212/zoom, sy/2 + 424/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Medium', 13.333/zoom), 'left', 'top')
	dxDrawText('Akcja: Spuść ręczny', sx/2 .5/zoom, sy/2 + 481/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Medium', 13.333/zoom), 'center', 'top')
	dxDrawText('Ostatni kierowca:', sx/2 - 212/zoom, sy/2 + 448/zoom, nil, nil, tocolor(255, 255, 255, 255), 1, getFigmaFont('Inter-Medium', 13.333/zoom), 'left', 'top')
	dxDrawText('123', sx/2 + 154/zoom, sy/2 + 371/zoom, nil, nil, tocolor(207, 207, 207, 255), 1, getFigmaFont('Inter-Medium', 32/zoom), 'center', 'top')
	dxDrawText('km/h', sx/2 + 156.5/zoom, sy/2 + 419/zoom, nil, nil, tocolor(35, 229, 82, 255), 1, getFigmaFont('Inter-Medium', 17.333/zoom), 'center', 'top')
end

local ui={}

ui.options={
    "OBRÓĆ POJAZD",
    "ZACIĄGNIJ RĘCZNY"
}

ui.option=1

ui.vehicle=false

ui.onRender=function()
    if(getPedWeapon(localPlayer) ~= 32)then return end

    if(isPedAiming() and getPlayerTarget(localPlayer) and getElementType(getPlayerTarget(localPlayer)) == "vehicle")then
        ui.vehicle=getPlayerTarget(localPlayer)
    else
        ui.vehicle=false

        return
    end

    dxDrawRectangle(sw/2-750/2/zoom, sh/2-300/zoom/2/zoom, 750/zoom, 300/zoom, tocolor(15,15,15,225))
    dxDrawRectangle(sw/2-750/2/zoom, sh/2-300/zoom/2/zoom, 750/zoom, 55/zoom, tocolor(15,15,15,225))
    dxDrawText("SUSZARKA SARA", sw/2-750/2/zoom, sh/2-300/zoom/2/zoom, sw/2-750/2/zoom+750/zoom, sh/2-300/zoom/2/zoom+55/zoom, tocolor(200,200,200), 1, font, "center", "center")

    -- info left
    local id=getElementData(ui.vehicle, "vehicle:id") or "0"
    local owner=getElementData(ui.vehicle, "vehicle:ownedPlayer") or "brak"
    local driver=getElementData(ui.vehicle, "vehicle:driver") or "brak"
    local info="Ostatni kierowca: "..driver.."\nWłaściciel: "..owner.."\nID pojazdu: "..id
    dxDrawText("INFORMACJE:", sw/2-750/2/zoom, sh/2-300/zoom/2/zoom+75/zoom, sw/2-750/2/zoom+750/2/zoom, 0, tocolor(200,200,200), 1, font2, "center", "top")
    dxDrawText("\n\n\n"..info, sw/2-750/2/zoom, sh/2-300/zoom/2/zoom+75/zoom, sw/2-750/2/zoom+750/2/zoom, 0, tocolor(200,200,200), 1, font2, "center", "top")
    --

    dxDrawRectangle(sw/2-750/2/zoom+750/2/zoom, sh/2-300/zoom/2/zoom+55/zoom, 1, (300-55)/zoom, tocolor(100,100,100))

    -- options right
    dxDrawText("WYBIERZ OPCJE:", sw/2-750/2/zoom+750/2/zoom, sh/2-300/zoom/2/zoom+75/zoom, sw/2-750/2/zoom+750/zoom, 0, tocolor(200,200,200), 1, font, "center", "top")

    dxDrawRectangle(sw/2-750/2/zoom+(750-200)/zoom-((750/2)-200)/2/zoom, sh/2-300/zoom/2/zoom+75/zoom+50/zoom, 200/zoom, 40/zoom, tocolor(15,15,15,200))
    dxDrawRectangle(sw/2-750/2/zoom+(750-200)/zoom-((750/2)-200)/2/zoom, sh/2-300/zoom/2/zoom+75/zoom+50/zoom+40/zoom-1, 200/zoom, 1, tocolor(255,140,0,200))
    dxDrawText(ui.options[ui.option], sw/2-750/2/zoom+(750-200)/zoom-((750/2)-200)/2/zoom, sh/2-300/zoom/2/zoom+75/zoom+50/zoom, 200/zoom+sw/2-750/2/zoom+(750-200)/zoom-((750/2)-200)/2/zoom, 40/zoom+sh/2-300/zoom/2/zoom+75/zoom+50/zoom, tocolor(200,200,200), 1, font2, "center", "center")
    
    dxDrawText("KLIKNIJ PPM ABY ZATWIERDZIĆ\nUŻYJ SCROLLA BY ZMIENIĆ", sw/2-750/2/zoom+750/2/zoom, sh/2-300/zoom/2/zoom+200/zoom, sw/2-750/2/zoom+750/zoom, 0, tocolor(200,200,200), 1, font2, "center", "top")
    --

    ui.options[2]=isElementFrozen(ui.vehicle) and "SPUŚĆ RĘCZNY" or "ZACIĄGNIJ RĘCZNY"
end

ui.onKey=function(key,state)
    if(not state or not ui.vehicle)then return end

    if(key == "mouse1")then
        triggerServerEvent("p_suszarka", resourceRoot, ui.vehicle, ui.options[ui.option])
    elseif(key == "mouse_wheel_up")then
        ui.option=ui.option+1
        if(ui.option > #ui.options)then
            ui.option=1
        end
    elseif(key == "mouse_wheel_down")then
        ui.option=ui.option-1
        if(ui.option < 1)then
            ui.option=#ui.options
        end
    end
end

addEventHandler("onClientRender", root, ui.onRender)
addEventHandler("onClientKey", root, ui.onKey)

function isPedAiming()
    if getPedTask(localPlayer, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
        return true
    end
    return false
end
getResourceName(getThisResource(), true, 938205858); if true then return end
  

local textRadio = ""
local currentRadio = ""
local currentIndex = 1
local localPlayer = getLocalPlayer()
local sx,sy = guiGetScreenSize ()
local loltimer = nil
local templol = false
local radios ={ 
  {"Radio wyłączone"},
  {"Playlista gracza"},
  --{"EnergyRemix"},
  {"SinceFM"},
  {"Radio Party"},
  {"Lata 80/90."},
  {"Radio7"},
  {"RMF FM"},
  {"Radio Plus"},
  {"Trap"},
  {"RMF MAXXX"},
  --{"Disco Polo"},
}
local radioPaths = {0,12,
  "https://s3.slotex.pl/shoutcast/7276/listen.pls?sid=1",
  "http://www.radioparty.pl/play/glowny_64.m3u",
  "http://www.kickradio.nl/tunein/listen.pls",
  "http://radio7.pl/listen.m3u",
  --"http://static.gaduradio.pl/64.m3u",
  "http://www.rmfon.pl/n/rmffm.pls",
  "http://plus-warszawa-01.eurozet.pl:8500/listen.pls",
  "http://radio.trap.fm/listen192.m3u",
  "http://www.rmfon.pl/n/rmfmaxxx.pls",
  --"http://s2.panelradiowy.pl:10078/listen.pls",
}

local playRadioThing = nil
function resetTimer ()
  textRadio = ""
end
setElementData(getLocalPlayer(),"radio-on",true)

addEventHandler("onClientResourceStart",resourceRoot,
function()
  showPlayerHudComponent ("radio",false)
  setRadioChannel (0)
  
  bindKey ("[","down",
    function(key,state)
	if getElementData(getLocalPlayer(),"radio-on") then
	if not getPedOccupiedVehicle(localPlayer) then  return end
      local nextIndex = ((currentIndex)%(#radioPaths)) +1
      currentIndex = nextIndex
      local radio = radioPaths[nextIndex]
      textRadio = radios[nextIndex][1]
      if loltimer and isTimer (loltimer) then
        killTimer (loltimer)
      end
      loltimer = setTimer (resetTimer,1000,1)
      if type (radio) == "number" then
	  
        setRadioChannel (radio)
        if playRadioThing then
			if isElement(playRadioThing) and getElementType (playRadioThing)=="sound" then
				stopSound (playRadioThing)
			end
        end
      else
        setRadioChannel (0)
        if playRadioThing then 
			if isElement(playRadioThing) and getElementType (playRadioThing)=="sound" then
				stopSound (playRadioThing)
			end
        end
        playRadioThing = playSound (radio)
      end
	end
    end
  )
  
  bindKey ("]","down",
    function(key,state)
	if getElementData(getLocalPlayer(),"radio-on") then
		if not getPedOccupiedVehicle(localPlayer) then  return end
      local nextIndex = ((currentIndex -2)%(#radioPaths)) +1
      currentIndex = nextIndex
      local radio = radioPaths[nextIndex]
      textRadio = radios[nextIndex][1]
      if loltimer and isTimer (loltimer) then
        killTimer (loltimer)
      end
      loltimer = setTimer (resetTimer,1000,1)
      if type (radio) == "number" then
			setRadioChannel (radio)
			if playRadioThing then
			if isElement(playRadioThing) and getElementType (playRadioThing)=="sound" then
				stopSound (playRadioThing)
			end
		end
      else
        setRadioChannel (0)
        if playRadioThing then 
			if isElement(playRadioThing) and getElementType (playRadioThing)=="sound" then
				stopSound (playRadioThing)
			end
        end
        playRadioThing = playSound (radio)
      end
	end
    end
  )
  
end)

local screenW, screenH = guiGetScreenSize()

fonte = dxCreateFont("font.ttf",16) or "defaul-bold"

function renderRadio ()

  if #textRadio>0 then
  	dxDrawText(textRadio, (screenW - 308) / 2, 0+41, ((screenW - 308) / 2) + 309, ( 0+100) + 23, tocolor(0,0,0,255), 1, fonte, "center", "center", false, false, true, false, false)
  dxDrawText(textRadio, (screenW - 308) / 2, 0+40, ((screenW - 308) / 2) + 308, ( 0+100) + 22, tocolor(125, 255, 125,255), 1, fonte, "center", "center", false, false, true, false, false)
  end
end
addEventHandler ("onClientRender",getRootElement(),renderRadio)

addEventHandler ("onClientVehicleStartExit",getRootElement(),
function(player)
  if localPlayer == player then
    if isElement(playRadioThing) then
      stopSound (playRadioThing)
    end
    setRadioChannel (0)
    textRadio = ""
  end
end)

addEventHandler ("onClientPlayerWasted",getLocalPlayer(),
function()
	if isElement(playRadioThing) then
		stopSound (playRadioThing)
		setRadioChannel (0)
		textRadio = ""
	end
end)

addEventHandler ("onClientVehicleStartEnter",getRootElement(),
function(player)
  if localPlayer == player then
    if isElement(playRadioThing) then
      stopSound (playRadioThing)
    end
    setRadioChannel (0)
    textRadio = ""
  end
end)

addEventHandler ("onClientVehicleExit",getRootElement(),
function(player)
  if localPlayer == player then
    if isElement(playRadioThing) then
      stopSound (playRadioThing)
    end
    setRadioChannel (0)
    textRadio = ""
  end
end)

addEventHandler ("onClientVehicleEnter",getRootElement(),
function(player)
  if localPlayer == player then
    local radio = radioPaths[currentIndex]
    textRadio = radios[currentIndex][1]
		if loltimer and isTimer (loltimer) then
		killTimer (loltimer)
		end
	loltimer = setTimer (resetTimer,1000,1)
    if type (radio) == "number" then
		setRadioChannel (radio)
		if isElement(playRadioThing) then
			stopSound (playRadioThing)
		end
    else
		setRadioChannel (0)
		if isElement(playRadioThing) then
			stopSound (playRadioThing)
		end
		playRadioThing = playSound (radio)
		end
  end
end)

_setRadioChannel = setRadioChannel

function setRadioChannel (index)
  templol = true
end

addEventHandler ("onClientPlayerRadioSwitch",getRootElement(),
function()
  if templol == true then
    if not isPedInVehicle (localPlayer) then
      setRadioChannel (0)
    end
    templol = false
  else
    cancelEvent (true)
    if not isPedInVehicle (localPlayer) then
      setRadioChannel (0)
    end
  end
end)

addEventHandler("onClientElementDestroy",getRootElement(),
function()
  if source and getElementType (source) == "vehicle" then
    if source == getPedOccupiedVehicle (localPlayer) then
      if isElement(playRadioThing) then
        stopSound (playRadioThing)
      end
      setRadioChannel (0)
      textRadio = ""
    end
  end
end)

addEventHandler("onClientVehicleExplode",getRootElement(),
function()
  if source and getElementType (source) == "vehicle" then
    if source == getPedOccupiedVehicle (localPlayer) then
      if isElement(playRadioThing) then
        stopSound (playRadioThing)
      end
      setRadioChannel (0)
      textRadio = ""
    end
  end
end)
getResourceName(getThisResource(), true, 628796220); if true then return end
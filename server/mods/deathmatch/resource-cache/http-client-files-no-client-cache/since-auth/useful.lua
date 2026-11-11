sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

textures = {

    editbox = dxCreateTexture('data/editbox_bg.png'),
    checkbox = dxCreateTexture('data/checkbox.png'),
    checkbox_active = dxCreateTexture('data/checkbox_active.png'),
    mask = dxCreateTexture('data/mask.png'),
    border = dxCreateTexture('data/border.png'),

}

data = {loginWindow = 'login', discordLink = 'https://discord.gg/cbhR4Gqj9e', selectedSpawn = 1}

spawns = {

    {
        name = 'Los Santos',
        pos = {395.33, -1800.95, 7.83,},
        camera = { 395.33, -1800.95, 10.83, 405.33, -1805.95, 10.83},

    },

    {
        name = 'Przechowalnia Los Santos',
        pos = {1009.79, -1437.56, 13.55},
        camera = {1009.79, -1437.56, 13.55, 1009.79, -1537.56, 13.55},

    },

    {
        name = 'Las Venturas',
        pos = {1888.21, 2339.56, 10.82},
        camera = {1923.32, 2349.24, 32.38, 0.0, 0.0, 133.6},

    },

    {
        name = 'Blueberry',
        pos = {209.20, -46.85, 1.78},
        camera = {214.66, -47.07, 1.78, 214.66, -57.07, 1.78},

    },

}

addEvent('addLoginSpawn', true)
addEventHandler('addLoginSpawn', root, function(name, pos, camera)
    table.insert(spawns, {

        name = name,
        pos = pos,
        camera = camera,

    })
end)

uiElements = {}

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil
 
local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end
 
local targetCamera = false

local function camRender()
	if not targetCamera then return end
	local cx, cy, cz, lx, ly, lz = getCameraMatrix()
	cx, cy, cz = interpolateBetween(cx, cy, cz, targetCamera[1], targetCamera[2], targetCamera[3], 0.01, 'Linear')
	lx, ly, lz = interpolateBetween(lx, ly, lz, targetCamera[4], targetCamera[5], targetCamera[6], 0.02, 'Linear')

	setCameraMatrix(cx, cy, cz, lx, ly, lz)
end

addEventHandler("onClientPreRender",root,camRender)

function smoothMoveCamera(cx, cy, cz, lx, ly, lz, time)
	targetCamera = {cx, cy, cz, lx, ly, lz, time}
end

function stopSmoothMoveCamera()
	targetCamera = false
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function loadAccountData()
    if (fileExists('data.json')) then
		local file = fileOpen('data.json')
		local data = fromJSON(fileRead(file, fileGetSize(file)))
        fileClose(file)
		return data
    end
    return false
end

function saveData(login, password)
	if (fileExists('data.json')) then
        fileDelete('data.json')
    end
    local file = fileCreate('data.json')
    local data = {
        login = login,
        password = password
    }
    fileWrite(file, toJSON(data))
    fileClose(file)
end
getResourceName(getThisResource(), true, 981194559); if true then return end
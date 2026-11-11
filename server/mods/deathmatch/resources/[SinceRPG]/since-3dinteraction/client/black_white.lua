local blackWhiteShader = false 
local blackWhiteScreen = false
sx, sy = guiGetScreenSize()

function drawBWRectangle(x, y, w, h, color, postgui)
	if not blackWhiteShader then 
		blackWhiteShader = dxCreateShader("assets/fx/blackwhite.fx", 0, 0, false, "other")
		blackWhiteScreen = dxCreateScreenSource(sx, sy)
	end

	dxUpdateScreenSource(blackWhiteScreen, true)
	dxSetShaderValue(blackWhiteShader, "screenSource", blackWhiteScreen)

	dxDrawImageSection (x, y, w, h, x, y, w, h, blackWhiteShader, 0, 0, 0, tocolor(67, 143, 135), type(postgui) == "boolean" and postgui or false)
end
  

local sx, sy = guiGetScreenSize()

local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

function getInterfaceZoom()
	return zoom
end

function dxCircle( x, y, width, height, color, angleStart, angleSweep, borderWidth, aaSize )
	height = height or width
	color = color or tocolor(255,255,255)
	borderWidth = borderWidth or 1e9
	angleStart = angleStart or 0
	angleSweep = angleSweep or 360 - angleStart
	if ( angleSweep < 360 ) then
		angleEnd = math.fmod( angleStart + angleSweep, 361 ) + 0
	else
		angleStart = 0
		angleEnd = 360
	end
	x = x - width / 2
	y = y - height / 2
	if not circleShader then
		circleShader = dxCreateShader ( "data/circle.fx" )
	end
	dxSetShaderValue ( circleShader, "sCircleWidthInPixel", width );
	dxSetShaderValue ( circleShader, "sCircleHeightInPixel", height );
	dxSetShaderValue ( circleShader, "sBorderWidthInPixel", borderWidth );
	dxSetShaderValue ( circleShader, "aaSize", aaSize );
	dxSetShaderValue ( circleShader, "sAngleStart", math.rad( angleStart ) - math.pi );
	dxSetShaderValue ( circleShader, "sAngleEnd", math.rad( angleEnd ) - math.pi );
	dxDrawImage( x, y, width, height, circleShader, 90, 0, 0, color )
end

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxCircle(x+radius, y+radius, radius*2, radius*2, color, 180, 90, 32, 1)
    dxCircle(x+radius, (y+height)-radius, radius*2, radius*2, color, 90, 90, 32, 1)
    dxCircle((x+width)-radius, (y+height)-radius, radius*2, radius*2, color, 0, 90, 32, 1)
    dxCircle((x+width)-radius, y+radius, radius*2, radius*2, color, 270, 90, 32, 1)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end
getResourceName(getThisResource(), true, 7763433); if true then return end
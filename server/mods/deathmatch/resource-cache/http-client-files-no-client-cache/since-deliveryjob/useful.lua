sx, sy = guiGetScreenSize()
zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1

noteTypes = {

    'Kurczak z rożna',
    'Burger serowy',
    'Burger tradycyjny',
    'Burger wegański',
    'Burger mięsny',
    'Kurczakburger',
    'Frytki (małe)',
    'Frytki (duże)',
    'Skrzydełka',
    'Nuggetsy',
    'Napój Cola 330ml',
    'Napój Cola 500ml',
    'Napój Cola 750ml',
    'Pizza hawajska',
    'Pizza pepperoni',
    'Pizza z szynką',
    'Pizza z serem',
    'Pizza z pieczarkami',
    'Pizza z kurczakiem',

}

positions = {

    [1] = {

        {2823.92, 2268.82, 14.66, -0.00, 0.00, 336.29},
        {2816.81, 2268.79, 14.66, -0.00, 0.00, 90.71},
        {2817.08, 2274.96, 14.66, -0.00, 0.00, 359.50},
        {2823.82, 2274.96, 14.66, -0.00, 0.00, 273.20},
        {2794.23, 2229.33, 10.82, -0.00, 0.00, 350.55},
        {2794.31, 2222.09, 10.82, -0.00, 0.00, 183.92},
        {2788.02, 2229.10, 10.82, -0.00, 0.00, 1.43},
        {2788.00, 2222.44, 10.82, -0.00, 0.00, 179.90},

    },

    [2] = {

        {1029.90, 2027.97, 11.47, -0.00, 0.00, 14.26},
        {1028.56, 2005.65, 11.46, -0.00, 0.00, 267.75},
        {984.83, 2030.21, 11.47, -0.00, 0.00, 356.62},
        {1029.75, 1976.04, 11.47, -0.00, 0.00, 272.74},
        {984.64, 1978.33, 11.47, -0.00, 0.00, 137.38},
        {1030.12, 1928.07, 11.47, -0.00, 0.00, 275.96},
        {985.54, 1930.63, 11.47, -0.00, 0.00, 87.42},
        {1028.14, 1905.96, 11.46, -0.00, 0.00, 345.26},

    },

    [3] = {

        {1897.31, 729.12, 10.82, -0.00, 0.00, 88.23},
        {1897.51, 736.70, 10.82, -0.00, 0.00, 94.67},
        {1908.88, 742.22, 10.82, -0.00, 0.00, 345.90},
        {1915.93, 742.31, 10.82, -0.00, 0.00, 1.21},
        {1929.32, 741.71, 10.82, -0.00, 0.00, 357.99},
        {1905.07, 664.74, 10.82, -0.00, 0.00, 162.60},
        {1956.63, 718.21, 14.28, -0.00, 0.00, 304.00},
        {1897.08, 677.39, 14.28, -0.00, 0.00, 106.76},

    },

    [4] = {

        {2572.20, 719.59, 10.82, -0.00, 0.00, 90.49},
        {2578.44, 719.52, 10.82, -0.00, 0.00, 268.95},
        {2571.93, 713.30, 10.82, -0.00, 0.00, 90.08},
        {2578.49, 713.29, 10.82, -0.00, 0.00, 269.76},
        {2532.27, 749.62, 10.82, -0.00, 0.00, 355.97},
        {2526.10, 743.24, 10.82, -0.00, 0.00, 178.07},
        {2660.34, 742.96, 14.74, -0.00, 0.00, 267.90},
        {2659.72, 719.63, 10.82, -0.00, 0.00, 203.04},

    },

    [5] = {

        {2066.01, 2722.08, 10.82, -0.00, 0.00, 181.45},
        {2049.57, 2763.62, 10.82, -0.00, 0.00, 359.35},
        {2039.69, 2765.20, 10.82, -0.00, 0.00, 0.56},
        {2037.31, 2722.11, 11.30, -0.00, 0.00, 181.04},
        {2018.56, 2765.92, 10.82, -0.00, 0.00, 0.56},
        {1992.62, 2764.06, 10.82, -0.00, 0.00, 4.19},
        {1931.23, 2722.11, 10.82, -0.00, 0.00, 180.64},
        {1929.56, 2774.35, 10.82, -0.00, 0.00, 270.72},

    }

}

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sxx, syy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sxx ), ( cy * syy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function dxDrawOctagon3D(x, y, z, radius, width, color)
	if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then
		return false
	end

	local radius = radius or 1
	local radius2 = radius/math.sqrt(2)
	local width = width or 1
	local color = color or tocolor(255,255,255,150)

	point = {}

		for i=1,8 do
			point[i] = {}
		end

		point[1].x = x
		point[1].y = y-radius
		point[2].x = x+radius2
		point[2].y = y-radius2
		point[3].x = x+radius
		point[3].y = y
		point[4].x = x+radius2
		point[4].y = y+radius2
		point[5].x = x
		point[5].y = y+radius
		point[6].x = x-radius2
		point[6].y = y+radius2
		point[7].x = x-radius
		point[7].y = y
		point[8].x = x-radius2
		point[8].y = y-radius2
		
	for i=1,8 do
		if i ~= 8 then
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[i+1].x,point[i+1].y,z
		else
			x, y, z, x2, y2, z2 = point[i].x,point[i].y,z,point[1].x,point[1].y,z
		end
		dxDrawLine3D(x, y, z, x2, y2, z2, color, width)
	end
	return true
end
getResourceName(getThisResource(), true, 511938424); if true then return end
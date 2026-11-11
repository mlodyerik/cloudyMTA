money = 150000

positions = {

    {1454.78, -1695.24, 13.54},
	{1927.05, -1625.98, 13.55},
	{2062.94, -1786.24, 13.55},
	{2529.57, -2252.50, 3.00},
	{2778.80, -2539.95, 16.22},
	{2796.19, -1466.15, 28.16},
	{2786.91, -1416.93, 16.25},
	{154.25, -1958.70, 3.77},
	{2664.77, -1107.94, 69.42},
	{2794.66, -1944.75, 17.32},
	{2606.67, -2123.26, 0.68},
	{2745.85, -2201.39, 13.55},
	{2614.18, -1392.96, 34.88},
	{2801.64, -1200.94, 25.49},
	{1803.92, -1150.12, 23.83},
	{2494.24, -952.65, 82.25},
	{2181.55, -979.46, 62.97},
	{1975.05, -1306.59, 20.84},
	{2109.07, -1567.70, 13.33},
	{1766.46, -1932.25, 13.56}, -- 20 LS

	{1984.80, 2194.26, 17.33}, -- przecho lv,dach
	{2233.26, 2466.87, -7.45}, -- komisariat lv 
	{2857.40, 1296.75, 11.39}, -- stacja kolejowa lv
	{2857.40, 1296.75, 11.39}, -- oczyszczalnia ścieków lv
	{976.62, 2085.10, 10.82}, -- magazyn lv
	{1022.61, 1676.58, 5.82}, -- stadion lv obok mechanika
	{1413.01, 2100.34, 12.02}, -- stadion basbollowy
	{2018.68, 2264.94, 23.91}, -- jakis parking piętrowy obok przecho
	{2823.46, 2274.42, 10.82},--  dom obok centrum handlowego
	{1300.45, 2799.21, 10.50}, -- pole golfowe 
	{2156.54, 2841.80, 10.82}, -- za burger shotem 
	{2369.80, 545.12, 1.80},  -- salon łodzi
	{1761.31, 604.75, 10.82}, -- most lv-ls
	{1084.11, 1073.07, 10.84}, -- baza obok mecha
	{943.70, 1700.05, 8.85}, -- baza niedaleko mecha,tunera
	{1058.21, 2365.17, 12.91}, -- logistyka lądowa
	{2476.76, 1878.12, 10.18}, -- opuszczona budowa
	{2196.29, 941.83, 10.82}, -- ammunation 
	{2126.04, 1145.11, 13.51}, -- most przy bazie
	{1351.42, 1033.55, 10.82}, -- sum obok autostrady lv-sf
	{2228.76, 2565.58, 12.68}, -- rampa niedaleko stacji paliw
	{2657.55, 1987.68, 13.87}, -- jakieś domki maruchy
	{2644.72, 1142.01, 11.18}, -- stacja paliw
	{2240.39, 1042.62, 10.82}, -- za baza
	{1918.45, 969.40, 10.82}, --za kasynem four dragons
	{1753.63, 660.45, 10.82}, -- magazyny obok autostrady lv-ls
	{1898.54, 665.63, 14.27}, -- motel
	{2259.15, 1397.62, 42.82}, -- g1
	{1999.99, 1519.04, 17.06}, --  statek piracki
	{1331.56, 1250.84, 14.27}, -- lotnisko lv | LV 30

	{2262.27, 60.84, 26.48}, -- między budynkamki
	{2128.59, 95.81, 35.84}, -- most
	{2329.13, -77.12, 26.48}, -- między budynkami 2 
	{2103.22, -103.49, 2.28}, -- pomost nawiedzony wózek inwalidzki
	{2253.74, -73.87, 31.60}, -- biblioteka | PALOMINO 5 

	{-155.79, -250.78, 1.43}, -- mech bb
	{-61.13, 47.67, 6.48}, -- farma BB
	{282.84, -2.13, 2.43}, -- final build construction
	{362.69, -103.23, 1.30}, -- altany
	{157.88, -107.55, 4.90}, -- motel BB | BB 5


    
}

function formatNumber(number) 
	while true do      
		number, k = string.gsub(number, "^(-?%d+)(%d%d%d)", '%1 %2')    
		if k==0 then      
			break   
		end  
	end  
	return number
end
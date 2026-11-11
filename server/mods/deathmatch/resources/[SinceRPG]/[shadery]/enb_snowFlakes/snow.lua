local sx, sy = guiGetScreenSize()
local sx2, sy2 = sx/2, sy/2
local snowflakes = {}
local snowing = false
local box_width, box_depth, box_height = 4, 4, 4
local position = {0, 0, 0}
local flake_removal = nil
local snow_fadein = 5

settings = {type = "real", density = 400, wind_direction = {0.0,0.02}, wind_speed = 0.8, snowflake_min_size = 0.8, snowflake_max_size = 3, fall_speed_min = 0.5, fall_speed_max = 6}


function random(lower, upper)
	return lower+(math.random() * (upper - lower))
end

function toggleWinterWeather(state)
	if state == true then setWeather(9) else setWeather(3) end
end

function startSnowFlakes()
	if not snowing then
		snowflakes = {}
			
		local lx,ly,lz = getWorldFromScreenPosition(0,0,1)
		local rx,ry,rz = getWorldFromScreenPosition(sx,0,1)
		box_width = getDistanceBetweenPoints3D(lx,ly,lz,rx,ry,rz)+2
		box_depth = box_width	

		lx,ly,lz = getWorldFromScreenPosition(sx2,sy2,box_depth)
		position = {lx,ly,lz}		
		
		-- let it snow
		for i=1, settings.density do
			local x,y,z = random(0,box_width*2),random(0,box_depth*2),random(0,box_height*2)
			createFlake(x-box_width,y-box_depth,z-box_height,0)
		end
		
		addEventHandler("onClientRender",root,drawSnow)
		snowing = true

		return true
	else
		return false
	end

	return false
end

function toggleShader(state)
	if state == true then startSnowFlakes() else stopSnowFlakes() end
end

function startScript()
	local shaders = getElementData(localPlayer, "player:settings") or {}

	if shaders['snowFlakes'] then
		startSnowFlakes()
	end
end

function stopSnowFlakes()
	if snowing then
		removeEventHandler("onClientRender",root,drawSnow)
		
		for i,flake in pairs(snowflakes) do
			snowflakes[i] = nil
		end

		snowflakes = nil
		flake_removal = nil
		snowing = false
		return true
	end

	return false
end

function createFlake(x,y,z,alpha,i)	
	if flake_removal then
		if (flake_removal[2] % flake_removal[3]) == 0 then
			flake_removal[1] = flake_removal[1] - 1

			if flake_removal[1] == 0 then
				flake_removal = nil
			end

			table.remove(snowflakes,i)
			return
		else
			flake_removal[2] = flake_removal[2] + 1
		end
	end
	
	if i then
		snowflakes[i] = {x = x, y = y, z = z, speed = math.random(settings.fall_speed_min,settings.fall_speed_max)/100, size = 2^math.random(settings.snowflake_min_size,settings.snowflake_max_size), image = math.random(1,4), rot = math.random(0,180), alpha = alpha}
	else
		table.insert(snowflakes,{x = x, y = y, z = z, speed = math.random(settings.fall_speed_min,settings.fall_speed_max)/100, size = 2^math.random(settings.snowflake_min_size,settings.snowflake_max_size), image = math.random(1,4), rot = math.random(0,180), alpha = alpha})
	end
end

function drawSnow()	
	local cx,cy,cz = getCameraMatrix()
	local lx,ly,lz = getWorldFromScreenPosition(sx2,sy2,box_depth)
	local check = getGroundPosition
	if testLineAgainstWater(cx,cy,cz,cx,cy,cz+20) then
		check = getWaterLevel
	end

	local grid = {(box_width*2)/6,(box_depth*2)/6}
	
	local gpx,gpy,gpz = lx+(-box_width),ly+(-box_depth),lz+15
	local ground = {
		[1] = {check(gpx+grid[1],gpy+grid[2],gpz),
		check(gpx+grid[1],gpy+grid[2]*3,gpz),
		check(gpx+grid[1],gpy+grid[2]*5,gpz)},
			
		[2] = {check(gpx+grid[1]*3,gpy+grid[2],gpz),
		check(gpx+grid[1]*3,gpy+grid[2]*3,gpz),
		check(gpx+grid[1]*3,gpy+grid[2]*5,gpz)},
			
		[3] = {check(gpx+grid[1]*5,gpy+grid[2],gpz),
		check(gpx+grid[1]*5,gpy+grid[2]*3,gpz),
		check(gpx+grid[1]*5,gpy+grid[2]*5,gpz)}
	}

	local dx,dy,dz = position[1]-lx,position[2]-ly,position[3]-lz
	
	local alpha = (math.abs(dx) + math.abs(dy) + math.abs(dz))*15

	for i,flake in pairs(snowflakes) do
		if flake then				
			if flake.z < (-box_height) then
				local x,y = random(0,box_width*2),random(0,box_depth*2)
				createFlake(x-box_width,y-box_depth,box_height,0,i)	
			else		
				local gx, gy
				if flake.x <= (-box_width)+grid[1]*2 then 
					gx = 1
				elseif flake.x >= (-box_width)+grid[1]*4 then 
					gx = 3
				else 
					gx = 2
				end
						
				if flake.y <= (-box_depth)+grid[2]*2 then 
					gy = 1
				elseif flake.y >= (-box_depth)+grid[2]*4 then 
					gy = 3
				else 
					gy = 2
				end						

				if ground[gx][gy] and (flake.z+lz) > ground[gx][gy] then
					local draw_x,draw_y = getScreenFromWorldPosition(flake.x+lx,flake.y+ly,flake.z+lz,15,false)						
					if draw_x and draw_y then
						dxDrawImage(draw_x,draw_y,flake.size,flake.size,"flakes/snowflake"..tostring(flake.image).."_".. settings.type ..".png",flake.rot,0,0,tocolor(222,235,255,flake.alpha))

						flake.rot = flake.rot + settings.wind_speed
										
						if flake.alpha < 155 then
							flake.alpha = flake.alpha + snow_fadein + alpha
							if flake.alpha > 155 then flake.alpha = 155 end
						end	
					end
				end
				
				flake.x = flake.x + (settings.wind_direction[1] * settings.wind_speed)
				flake.y = flake.y + (settings.wind_direction[2] * settings.wind_speed)
				
				flake.z = flake.z - flake.speed
		
				flake.x = flake.x + dx
				flake.y = flake.y + dy
				flake.z = flake.z + dz

				if flake.x < -box_width or flake.x > box_width or flake.y < -box_depth or flake.y > box_depth or flake.z > box_height then
					flake.x = flake.x - dx
					flake.y = flake.y - dy
					local x,y,z = (flake.x > 0 and -flake.x or math.abs(flake.x)),(flake.y > 0 and -flake.y or math.abs(flake.y)),random(0,box_height*2)
					
					createFlake(x,y,z-box_height,155,i)	
				end
			end
		end
	end

	position = {lx,ly,lz}
end

getResourceName(getThisResource(), true, 237201747); if true then return end
local sw,sh = guiGetScreenSize()
local baseX = 1920
local zoom = 1
local minzoom = 2
if sw < baseX then
    zoom = math.min(minzoom, baseX/sw)
end

memos = {}
local backspace_tick = getTickCount()

function dxCreateMemo(name, shadowText, x, y, w, h, bgImage, font, scale, maxCharacters)
	table.insert(memos, {name=name, shadowText=shadowText, text="", x=x, y=y, w=w, h=h, bgImage=bgImage, font=font, scale=scale, maxCharacters=maxCharacters, isActive=false})

	setMemoBinds(true)
end

function dxDestroyMemo(name)
	for i,v in ipairs(memos) do
		if name == v.name then
			table.remove(memos, i)
			break
		end
	end
end

function dxGetMemoText(name)
	local mText = ""
	for i,v in ipairs(memos) do
		if name == v.name then
			mText = v.text
			break
		end
	end
	return mText
end

function setSelectedMemoText(letter)
	for i,v in ipairs(memos) do
		if v.isActive then
			if string.len(v.text) < v.maxCharacters then
				v.text = v.text..letter
			end
			break
		end
	end
end

function setMemoBinds(state)
	if state then
		addEventHandler("onClientRender", root, memoUI)
		addEventHandler("onClientClick", root, onMemoClick)
		addEventHandler("onClientCharacter", root, setSelectedMemoText)
	else
		removeEventHandler("onClientRender", root, memoUI)
		removeEventHandler("onClientClick", root, onMemoClick)
		removeEventHandler("onClientCharacter", root, setSelectedMemoText)
	end
end

function memoUI()
	if #memos < 1 then
		setMemoBinds(false)
	end
	for i,v in ipairs(memos) do
		if v.isActive then
			dxDrawImage(v.x, v.y, v.w, v.h, v.bgImage, 0, 0, 0, tocolor(255, 255, 255, 255))
			dxDrawText(v.text ~= "" and v.text or v.shadowText, v.x+15/zoom, v.y+15/zoom, v.w+v.x-15/zoom, v.h+v.y-15/zoom, tocolor(240, 240, 240, 255), v.scale, v.font, "left", "top", true, true)
		else
			dxDrawImage(v.x, v.y, v.w, v.h, v.bgImage, 0, 0, 0, tocolor(225, 225, 225, 200))
			dxDrawText(v.text ~= "" and v.text or v.shadowText, v.x+15/zoom, v.y+15/zoom, v.w+v.x-15/zoom, v.h+v.y-15/zoom, tocolor(145, 163, 160, 220), v.scale, v.font, "left", "top", true, true)
		end
		if getKeyState("backspace") and v.isActive then
            if (getTickCount() - backspace_tick) / 100 > 1 then
                v.text = string.sub(v.text, 1, string.len(v.text) - 1);
                backspace_tick = getTickCount();
            end
        end
	end	
end

function onMemoClick(button, state)
	if button == "left" and state == "down" then
		for i,v in ipairs(memos) do
			if isMouseInPosition(v.x, v.y, v.w, v.h) then
				v.isActive = true
			else
				v.isActive = false
			end
		end
	end
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

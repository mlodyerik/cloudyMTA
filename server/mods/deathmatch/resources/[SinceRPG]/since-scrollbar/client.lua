local scrollbars = {}
local sx, sy = guiGetScreenSize()
local zoom = (sx < 2048) and math.min(2.2, 2048/sx) or 1
local pointTexture = dxCreateTexture("point.png")
local catch = false

fonts = {

    customFonts = {},

}

function unloadFonts()
    for k,v in pairs(fonts) do
        if v and isElement(v) then destroyElement(v) end
    end

    fonts = {

        customFonts = {},

    }
end

function getCustomFont(font, size)
    local customFonts = fonts.customFonts

    if not customFonts[font..size] then
        customFonts[font..size] = exports['since-fonts']:getFont(font, size)
    end

    return customFonts[font..size]
end

local font = getCustomFont('Inter-Medium', 11/zoom)
local font2 = getCustomFont('Inter-Medium', 10/zoom)

function dxDrawRoundedRectangle(x, y, width, height, radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+radius, width-(radius*2), height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawCircle(x+radius, y+radius, radius, 180, 270, color, color, 16, 1, postGUI)
    dxDrawCircle(x+radius, (y+height)-radius, radius, 90, 180, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, (y+height)-radius, radius, 0, 90, color, color, 16, 1, postGUI)
    dxDrawCircle((x+width)-radius, y+radius, radius, 270, 360, color, color, 16, 1, postGUI)
    dxDrawRectangle(x, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y+height-radius, width-(radius*2), radius, color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+width-radius, y+radius, radius, height-(radius*2), color, postGUI, subPixelPositioning)
    dxDrawRectangle(x+radius, y, width-(radius*2), radius, color, postGUI, subPixelPositioning)
end

function isMouseIn(x, y, width, height)
    if not isCursorShowing() then return false end
    local mx, my = getCursorPosition()
    mx, my = mx*sx, my*sy
    return mx >= x and mx <= x+width and my >= y and my <= y+height
end

function createScrollbar(x, y, w, h, color, click, prg, text, circleText, alpha)
    if not prg then prg = 0 end
    if not click then click = false end

    local scroll = {

        id = #scrollbars + 1,
        pos = {x, y, w, h},

        colors = {

            bar = {color[1]/2.5, color[2]/2.5, color[3]/2.5},
            progress = {color[1]/1.7, color[2]/1.7, color[3]/1.7},
            circle = {color[1], color[2], color[3]},

        },

        progress = prg,
        clickable = click,
        text = (text or false),
        circleText = (circleText or false),
        hold = false,
        alpha = alpha or 255,

    }

    table.insert(scrollbars, scroll)

    return scroll.id
end

function destroyScroll(id)
    for i = 1, #scrollbars do
        if scrollbars[i].id == id then
                table.remove(scrollbars, i)
            break
        end
    end
end

function getScrollProgress(id)
    for i = 1, #scrollbars do
        if scrollbars[i].id == id then
            local x, y, w, h = unpack(scrollbars[i].pos)
            return scrollbars[i].progress / (w - h/2) * 100
        end
    end
end

function setScrollProgress(id, progress)
    for i = 1, #scrollbars do
        if scrollbars[i].id == id then
            local x, y, w, h = unpack(scrollbars[i].pos)
            scrollbars[i].progress = progress / 100 * (w - h/2)
        end
    end
end

function changeProgress(scroll, progress)
    if scroll then
        local x, y, w, h = unpack(scroll.pos)
        local progress = math.min(math.max(progress, 0), w - h/2)
        scroll.progress = progress
    end
end

function setProgressClickable(id, clickable)
    for i = 1, #scrollbars do
        if scrollbars[i].id == id then
            scrollbars[i].clickable = clickable
        end
    end
end

function setScrollCircleText(id, text)
    for i = 1, #scrollbars do
        if scrollbars[i].id == id then
            scrollbars[i].circleText = text
        end
    end
end

function setScrollAlpha(id, alpha)
    for i = 1, #scrollbars do
        if scrollbars[i].id == id then
            scrollbars[i].alpha = alpha
        end
    end
end

function renderScrollbar()
    for i = 1, #scrollbars do
        local scroll = scrollbars[i]

        if scroll then
            local x, y, w, h = unpack(scroll.pos)
            local progress = math.min(math.max(scroll.progress, h), w)
            
            scroll.colors.bar[4] = scroll.alpha
            scroll.colors.progress[4] = scroll.alpha
            dxDrawRoundedRectangle(x, y, w, h, h/2, tocolor(unpack(scroll.colors.bar)))
            dxDrawRoundedRectangle(x, y, progress + 2/zoom, h, h/2, tocolor(unpack(scroll.colors.progress)))

            local pointPosition = math.min(math.max(scroll.progress, 0 + h / 2), w - h / 2)
            scroll.colors.circle[4] = scroll.alpha
            dxDrawImage(x + pointPosition - h, y - h / 2.2, h * 2, h * 2, pointTexture, 0, 0, 0, tocolor(unpack(scroll.colors.circle)))

            if scroll.circleText then
                dxDrawText(scroll.circleText, x + pointPosition + h * 0.4, y + h * 2, nil, nil, tocolor(255, 255, 255, 175*(scroll.alpha/255)), 1, font2, "center", "top")
            end

            if scroll.text then
                dxDrawText(scroll.text, x + w / 2, y - 15/zoom, nil, nil, tocolor(255, 255, 255, 195*(scroll.alpha/255)), 1, font, "center", "center")
            end

            local progress = scroll.progress / (w - h/2) * 100

            if getKeyState('mouse1') and isCursorShowing() then
                if not scroll.clickable then
                    return
                end

                local mouseX, mouseY = getCursorPosition()
                local mouseX, mouseY = mouseX * sx, mouseY * sy
                local mouseX, mouseY = mouseX - x, mouseY - y
                local mouseX, mouseY = mouseX / w, mouseY / h
                local mouseX, mouseY = mouseX * w, mouseY * w

                if isMouseIn(x, y - 2 / zoom, w, h + 4/zoom) and scroll.hold == false and catch == false then
                    changeProgress(scroll, mouseX)
                    scroll.hold = true
                    catch = true
                elseif scroll.hold == true then
                    changeProgress(scroll, mouseX)
                end
            else
                if scroll.hold ~= false then
                    scroll.hold = false
                    catch = false
                end
            end
        end
    end
end
addEventHandler("onClientRender", root, renderScrollbar, false, 'low-999')
getResourceName(getThisResource(), true, 664679403); if true then return end
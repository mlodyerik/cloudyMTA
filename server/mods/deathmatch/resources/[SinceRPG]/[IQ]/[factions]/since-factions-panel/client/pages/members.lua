local function dxDrawScrollbar(table, x, y, w, height, m_, k_, alpha)
    dxDrawRectangle(x, y, w, height, tocolor(148, 255, 139,alpha*0.2))

	if #table > m_ then
    	local scrollbarHeight = height/#table

   		if k_ == 1 then 
        	scrollbarPos = y
    	elseif k_ > 0 then 
        	scrollbarPos = ((k_)*scrollbarHeight)+y
    	end

    	if #table <= m_ then 
        	scrollbarHeight = height
    	end
		
        dxDrawRectangle(x, scrollbarPos, w, scrollbarHeight*(m_-1), tocolor(148, 255, 139, alpha))
    else
        dxDrawRectangle(x, y, w, height, tocolor(148, 255, 139,alpha))
	end
end

local function scrollDown()
    if Panel.scrolls.members.n < #Panel.data.mainData then
        Panel.scrolls.members.k = Panel.scrolls.members.k + 1
        Panel.scrolls.members.n = Panel.scrolls.members.n + 1
    end
end

local function scrollUp()
    if Panel.scrolls.members.k > 1 then
        Panel.scrolls.members.k = Panel.scrolls.members.k - 1
        Panel.scrolls.members.n = Panel.scrolls.members.n - 1
    end
end

Panel.pages.membersOnEnter = function ()
    bindKey('mouse_wheel_down', 'down', scrollDown)
    bindKey('mouse_wheel_up', 'down', scrollUp)

    Panel.elements[1] = exports['since-gui']:createEditbox('Wprowadź UID gracza.', sx/2 + 100/zoom, sy/2 - 241/zoom, 359/zoom, 32/zoom, {155, 155, 155}, {
        alignX = 'left',
        paddingX = 10/zoom,
        caretColor = {255, 255, 255, 100},
        caretWidth = 1,
        font = exports['since-fonts']:getFont('Inter-Medium', 9/zoom),
        image = Panel.textures['editbox'],
        placeholderColor = {155, 155, 155},
        specialCharacters = '.*[_].*',
        passworded = false,
        caretHeight = 18/zoom,
        textColor = {255, 255, 255, 200},
    })
end

Panel.pages.membersOnExit = function ()
    unbindKey('mouse_wheel_down', 'down', scrollDown)
    unbindKey('mouse_wheel_up', 'down', scrollUp)

    exports['since-gui']:destroyUIElement(Panel.elements[1])
    Panel.selectedMembers = {}
end

local function dxDrawButton(x, y, w, h, text, color)
    local alpha = isMouseInPosition(x, y, w, h) and 255 or 150

    dxDrawImage(x, y, w, h, 'data/images/button.png', 0, 0, 0, tocolor(color[1], color[2], color[3], alpha))
    dxDrawText(text, x + w/2, y + h/2, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'center', 'center')
end

Panel.selectedMembers = {}

local function isSelected(uid)
    for i,v in pairs(Panel.selectedMembers) do
        if v == uid then
            return true
        end
    end

    return false
end

Panel.pages.renderMembersPage = function()
    local x, y = sx/2-942/zoom/2 + 249/zoom, sy/2-500/zoom/2 + 47/zoom
    local padding = 10/zoom

    local members = Panel.data.mainData or {}

    dxDrawScrollbar(members, x + 687/zoom, y + padding, 4/zoom, 383/zoom, Panel.scrolls.members.m, Panel.scrolls.members.k, 255)
        
    local offset = 0
    for i, v in pairs(members) do
        if i >= Panel.scrolls.members.k and i <= Panel.scrolls.members.n then
            local alpha = isMouseInPosition(x + padding, y + padding + offset, 674/zoom, 47/zoom) and 15 or 0
            local color = (isSelected(v.uid) and tocolor(46, 117, 111, 25 + alpha) or tocolor(145, 163, 160, 25 + alpha))

            dxDrawRectangle(x + padding, y + padding + offset, 674/zoom, 47/zoom, color)
            dxDrawRectangle(x + padding, y + padding + 45/zoom + offset, 674/zoom, 1, tocolor(255, 255, 255, 65))

            dxDrawText(v.name, x + padding + 10/zoom, y + padding + 16/zoom + offset, nil, nil, tocolor(255, 255, 255, 255), 1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom), 'left', 'center')
            dxDrawText(v.rank, x + padding + 10/zoom, y + padding + 16/zoom + dxGetFontHeight(1, exports['since-fonts']:getFont('Inter-Bold', 12/zoom)) + offset, nil, nil, tocolor(46, 117, 111, 255), 1, exports['since-fonts']:getFont('Inter-Medium', 10/zoom), 'left', 'center')

            offset = offset + 47/zoom + 1
        end
    end

    if (#Panel.selectedMembers > 0) then
        dxDrawButton(x + padding, y + 405/zoom, 128/zoom, 32/zoom, 'Awansuj', {46, 117, 111})
        dxDrawButton(x + padding + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom, 'Degraduj', {255, 175, 125})
        dxDrawButton(x + padding + 128/zoom + 10/zoom + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom, 'Wyrzuć', {255, 125, 125})
        dxDrawButton(x + padding + 128/zoom + 10/zoom + 128/zoom + 5/zoom + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom, (#Panel.selectedMembers > 0 and 'Odznacz' or 'Zaznacz'), {125, 125, 255})
        dxDrawButton(x + padding + 128/zoom + 10/zoom + 128/zoom + 5/zoom + 128/zoom + 5/zoom + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom, 'Dodaj', {46, 117, 111})
    else
        dxDrawButton(x + padding, y + 405/zoom, 128/zoom, 32/zoom, (#Panel.selectedMembers > 0 and 'Odznacz' or 'Zaznacz'), {125, 125, 255})
        dxDrawButton(x + padding + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom, 'Dodaj', {46, 117, 111})
    end
end

Panel.pages.clickMembersPage = function ()
    local x, y = sx/2-942/zoom/2 + 249/zoom, sy/2-500/zoom/2 + 47/zoom
    local padding = 10/zoom

    local members = Panel.data.mainData or {}

    if (#Panel.selectedMembers > 0) then
        if (isMouseInPosition(x + padding + 128/zoom + 10/zoom + 128/zoom + 5/zoom + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom)) then
            Panel.selectedMembers = {}
        elseif (isMouseInPosition(x + padding + 128/zoom + 10/zoom + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom)) then
            for i,v in pairs(Panel.selectedMembers) do
                triggerServerEvent('since-factions-panel:onPlayerKick', resourceRoot, v)
            end

            Panel.selectedMembers = {}
        elseif (isMouseInPosition(x + padding + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom)) then
            for i,v in pairs(Panel.selectedMembers) do
                triggerServerEvent('since-factions-panel:onPlayerDemote', resourceRoot, v)
            end

            Panel.selectedMembers = {}
        elseif (isMouseInPosition(x + padding, y + 405/zoom, 128/zoom, 32/zoom)) then
            for i,v in pairs(Panel.selectedMembers) do
                triggerServerEvent('since-factions-panel:onPlayerPromote', resourceRoot, v)
            end

            Panel.selectedMembers = {}
        elseif (isMouseInPosition(x + padding + 128/zoom + 10/zoom + 128/zoom + 5/zoom + 128/zoom + 5/zoom + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom)) then
            local uid = exports['since-gui']:getEditboxText(Panel.elements[1])

            if (uid and #uid > 0 and tonumber(uid)) then
                triggerServerEvent('since-factions-panel:onPlayerAdd', resourceRoot, uid)
            else
                exports['since-notifications']:sendNotification('error', 'Wprowadź UID gracza.')
            end
        end
    else
        if isMouseInPosition(x + padding, y + 405/zoom, 128/zoom, 32/zoom) then
            for i,v in pairs(members) do
                table.insert(Panel.selectedMembers, v.uid)
            end
        elseif isMouseInPosition(x + padding + 128/zoom + 5/zoom, y + 405/zoom, 128/zoom, 32/zoom) then
            local uid = exports['since-gui']:getEditboxText(Panel.elements[1])

            if (uid and #uid > 0 and tonumber(uid)) then
                triggerServerEvent('since-factions-panel:onPlayerAdd', resourceRoot, uid)
            else
                exports['since-notifications']:sendNotification('error', 'Wprowadź UID gracza.')
            end
        end
    end

    local offset = 0

    for i, v in pairs(members) do
        if i >= Panel.scrolls.members.k and i <= Panel.scrolls.members.n then
            if isMouseInPosition(x + padding, y + padding + offset, 674/zoom, 47/zoom) then
                if (isSelected(v.uid)) then
                    for k, j in pairs(Panel.selectedMembers) do
                        if j == v.uid then
                            table.remove(Panel.selectedMembers, k)
                        end
                    end
                else
                    table.insert(Panel.selectedMembers, v.uid)
                end
            end

            offset = offset + 47/zoom + 1
        end
    end
end
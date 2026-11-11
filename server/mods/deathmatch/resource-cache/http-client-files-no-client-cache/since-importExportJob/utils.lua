sx,sy = guiGetScreenSize()
zoom = (sx < 2048 and math.min(2.2, 2048/sx) or 1)

function createTextures(path, tbl)
    local data = {}
    for i,v in ipairs(tbl) do
        if fileExists('files/images/'..path..'/'..v..'.png') then
            data[v] = dxCreateTexture('files/images/'..path..'/'..v..'.png')
        end
    end
    return data
end

function destroyTextures(tbl)
    for i,v in pairs(tbl) do
        if isElement(v) then
            destroyElement(v)
        end
    end
    return nil
end

function loadFonts()
    return {
        [1] = exports['since-fonts']:getFont("Inter-bold", 14/zoom),
        [2] = exports['since-fonts']:getFont("Inter-semiBold", 11/zoom),
        [3] = exports['since-fonts']:getFont("Inter-bold", 25/zoom),
        [4] = exports['since-fonts']:getFont('Inter-SemiBold', 14/zoom),
        [5] = exports['since-fonts']:getFont('Inter-Bold', 14/zoom),
        [6] = exports['since-fonts']:getFont('Inter-Regular', 11/zoom),
    }
end

function isEventHandlerAdded( sEventName, pElement, pFunction )
    if type( sEventName ) == 'string' and isElement( pElement ) and type( pFunction ) == 'function' then
        local tEventHandlers = getEventHandlers( sEventName, pElement )
        if type( tEventHandlers ) == 'table' and #tEventHandlers > 0 then
            for i, v in ipairs( tEventHandlers ) do
                if v == pFunction then
                    return true
                end
            end
        end
    end
    return false
end

function isMouseInPosition ( x, y, width, height )
    if isCursorShowing( ) then
        local sx, sy = guiGetScreenSize ( )
        local cx, cy = getCursorPosition ( )
        local cx, cy = ( cx * sx ), ( cy * sy )
        if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
            return true
        else
            return false
        end
    end
end

function formatNumber(n)
    n = tonumber(n)
    if not n then return '0' end
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end
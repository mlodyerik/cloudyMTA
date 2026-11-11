positions = {

    {

        marker = {-168.91, -234.14, 1.43, -0.00, 0.00, 263.53},
        cuboid = {-173.59, -237.47, 1.43, -0.00, 0.00, 88.69},

    },

    {

        marker = {-168.83, -228.38, 1.43, -0.00, 0.00, 269.17},
        cuboid = {-173.53, -231.20, 1.43, -0.00, 0.00, 88.29},


    },

    {


        marker = {-169.52, -222.51, 1.43, -0.00, 0.00, 358.62},
        cuboid = {-173.38, -225.49, 1.43, -0.00, 0.00, 178.95},


    }



}

cost = 2500000

function addCommas(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse())..right
end

if localPlayer then
    function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
        if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
            local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
            if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
                for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
                        return true
                    end
                end
            end
        end
        return false
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
end

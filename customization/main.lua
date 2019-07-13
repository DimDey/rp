
function createRetexShader()
    shader = dxCreateShader("shader.fx",10,0,true,"ped")
    outputDebugString(shader)
end
addEventHandler("onClientResourceStart",resourceRoot,createRetexShader)

function tdsa()
    local x,y,z = getElementPosition(localPlayer)
    local file = dxCreateTexture("skin.png")
    if file then
        local ped = createPed(185,x,y,z)
        dxSetShaderValue(shader,"Tex0",file)
        engineApplyShaderToWorldTexture(shader,"sbmyri")
    end
end
addCommandHandler("tead",tdsa)
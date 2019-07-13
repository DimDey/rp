
color = tocolor(255,106,19,195) ----цвет спидометра 
color2 = tocolor(255,106,19,195) ---- цвет тахометра

local sX, sY = guiGetScreenSize()
local screenWidth, screenHeight = sX, sY - 20 -- положение спидометра
local smothedRotation = 0
local maskShader
local tShader
local circleTexturesSpeed = {}
local circleTexturesTaxometr = {}

local scx,scy = guiGetScreenSize()
local px = scx/1920
---------------------------------
local sizeX,sizeY = 350*px,350*px
local posX,posY = scx-sizeX,scy-sizeY

addEventHandler( "onClientResourceStart", resourceRoot, function()

	maskShader = dxCreateShader("assets/shaders/mask3d.fx")
	local maskTexture = dxCreateTexture("assets/s_mask.png")
	dxSetShaderValue(maskShader, "sMaskTexture", maskTexture) 
	dxSetShaderValue(maskShader, "gUVRotCenter", 0.5, 0.5)
	for i = 1, 3 do
		circleTexturesSpeed[i] = dxCreateTexture("assets/s_circle"..tostring(i)..".png")
	end

	fShader = dxCreateShader("assets/shaders/mask3d.fx")
	local fTexture = dxCreateTexture("assets/fuel.png")
	dxSetShaderValue(fShader, "sMaskTexture", fTexture) 
	dxSetShaderValue(fShader, "gUVRotCenter", 0.5, 0.5)

    circleTexturesFuel = dxCreateTexture("assets/f_circle.png")
end)

function dxDrawSpeed()
    local veh = getPedOccupiedVehicle(localPlayer) 
	if not veh or getVehicleOccupant ( veh ) ~= localPlayer then return true end

    local vehicleSpeed = getVehicleSpeed()
	local fuel = 100
	local rot = math.floor(((175/12800)* getVehicleRPM(getPedOccupiedVehicle(getLocalPlayer()))) + 0.5)
	if (smothedRotation < rot) then smothedRotation = smothedRotation + 2.5 end
	if (smothedRotation > rot) then smothedRotation = smothedRotation - 2.5 end
	
	dxDrawImage(screenWidth-200, screenHeight-200, 162, 162, "assets/s_speedo.png")
	
	if vehicleSpeed < 243 then
		dxDrawImage(screenWidth-200, screenHeight-200, 160, 160, "assets/needle_s.png", vehicleSpeed - 3, 0.0, 0.0, tocolor(255,255,255,255), false)
	else
		dxDrawImage(screenWidth-200, screenHeight-200, 160, 160, "assets/needle_s.png", 240, 0.0, 0.0, tocolor(255,255,255,255), false)
	end

	--dxDrawText(mileage,posX-199,posY+280*px,posX+sizeX,posY+290*px,tocolor(255,255,255,255),1,"default","center","center") 
	
	--dxDrawText(tostring (math.round  (fuel)).."Л.",SizeX,SizeY - 145, SizeX - 240,SizeY, tocolor(255,255,255,255), 0.4,0.4, font1,"right","center")
	
	--dxDrawImage(screenWidth-65, screenHeight-45, 30, 27, stat_remen, 0,0,0, tocolor(255,255,255,255) )

	
    if vehicleSpeed < 90 then
		dxSetShaderValue(maskShader, "sPicTexture", circleTexturesSpeed[1])
		dxSetShaderValue(maskShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 0.2)
	elseif vehicleSpeed > 90 and vehicleSpeed < 170 then
		dxSetShaderValue(maskShader, "sPicTexture", circleTexturesSpeed[2])
		dxSetShaderValue(maskShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 4.9)
	elseif vehicleSpeed > 170 then
		dxSetShaderValue(maskShader, "sPicTexture", circleTexturesSpeed[3])
		dxSetShaderValue(maskShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 3.3)
	end
		
    dxDrawImage(screenWidth-200, screenHeight-200, 162, 162, maskShader, 0, 0, 0, color)
    
	----------------------------------------
	if vehicleSpeed > 50 then
		dxSetShaderValue(fShader, "sPicTexture", circleTexturesFuel)
		dxSetShaderValue(fShader, "gUVRotAngle", 0 + (vehicleSpeed/157) - 4.35)
	elseif vehicleSpeed < 50 then
		dxSetShaderValue(fShader, "sPicTexture", circleTexturesFuel)
		dxSetShaderValue(fShader, "gUVRotAngle", 0 - (vehicleSpeed/157) - 1.5)
	end 
	----------------------
	local speedx, speedy, speedz = getElementVelocity ( veh )
       local actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5)
       local speed = math.floor(actualspeed * 180)
	dxDrawText(speed, screenWidth, screenHeight-105, screenWidth-240, 300, tocolor ( 255,255,255 ), 1, "default", "center")
	dxDrawText( "км/ч", screenWidth-133, screenHeight-82, 240, 300, tocolor ( 255,255,255 ), 1, "default")

	if not (getVehicleEngineState(veh)) then
		dxDrawImage(screenWidth-185, screenHeight-45, 26, 26, "assets/engine_off.png")
	else
		dxDrawImage(screenWidth-185, screenHeight-45, 26, 26, "assets/engine_on.png")
	end
	
	if not isVehicleLocked ( veh ) then  
		dxDrawImage(screenWidth-125, screenHeight-45, 26, 26, "assets/door_open.png")
	else
		dxDrawImage(screenWidth-125, screenHeight-45, 26, 26, "assets/door_close.png")
	end
	
	if (getVehicleOverrideLights(veh) == 2) then
		dxDrawImage(screenWidth-95, screenHeight-45, 26, 26, "assets/lights_on.png")
	else
		dxDrawImage(screenWidth-95, screenHeight-45, 26, 26, "assets/lights_off.png")
	end

	if ccEnabled then 
		dxDrawImage(screenWidth-155, screenHeight-45, 26, 26, "assets/cc_on.png")
	else
		dxDrawImage(screenWidth-155, screenHeight-45, 26, 26, "assets/cc_off.png")
	end

	dxDrawImage(screenWidth-160, screenHeight-87, 26, 26, "assets/turnlight_l.png")
	dxDrawImage(screenWidth-107, screenHeight-87, 26, 26, "assets/turnlight_r.png")

	if getElementData(getPedOccupiedVehicle ( localPlayer ), "rightflash" ) then
		if ( getTickCount () % 1400 >= 600 ) then
			dxDrawImage(screenWidth-107, screenHeight-87, 26, 26, "assets/turnlight_r_a.png")
	    end
	end
   

	if getElementData(getPedOccupiedVehicle ( localPlayer ), "leftflash" ) then
		if ( getTickCount () % 1400 >= 600 ) then
			dxDrawImage(screenWidth-160, screenHeight-87, 26, 26, "assets/turnlight_l_a.png")
	    end
	end

	if getElementData(getPedOccupiedVehicle ( localPlayer ), "allflash" ) then
		if ( getTickCount () % 1400 >= 600 ) then
			dxDrawImage(screenWidth-160, screenHeight-87, 26, 26, "assets/turnlight_l_a.png")
			dxDrawImage(screenWidth-107, screenHeight-87, 26, 26, "assets/turnlight_r_a.png")
		end
	end


   
    if fuel >= 11 and fuel <= 100 then
	    dxDrawImage(screenWidth-35, screenHeight-60, 26, 26, "assets/fuel.png",0,0,0,tocolor(255,255,255))
    end 
	if fuel >= 1 and fuel <= 10 then
		alpha = 0
		if ( getTickCount () % 1500 >= 500 ) then
			dxDrawImage(screenWidth-35, screenHeight-60, 26, 26, "assets/fuel_empty.png",0,0,0,tocolor(255,255,255))
		end
    end 
	if fuel == 0 then
        --alpha = 0
		dxDrawImage(screenWidth-35, screenHeight-60, 26, 26, "assets/fuel_no.png",0,0,0,tocolor(255,255,255))
	end

	dxDrawCircle( screenWidth-(-320/5), screenHeight-120, 4.4, 230, 93, tocolor(40,40,40,255) )
	dxDrawCircle( screenWidth-(-320/5), screenHeight-120, 4.4, 230, math.floor(math.round(fuel)*0.93), tocolor(40,40,40,255) )
end

addEventHandler("onClientVehicleEnter", root, function (thePlayer, seat)
        if thePlayer == localPlayer and seat == 0 then
        addEventHandler("onClientRender", root, dxDrawSpeed)
    end
end)

addEventHandler("onClientVehicleStartExit", root, function(thePlayer, seat)
    if thePlayer == localPlayer and seat == 0 then
        removeEventHandler("onClientRender", root, dxDrawSpeed)
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" and getPedOccupiedVehicle(getLocalPlayer()) == source then
		removeEventHandler("onClientRender", root, dxDrawSpeed)
	end
end)

addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), function()
	if not getPedOccupiedVehicle(source) then return end
	removeEventHandler("onClientRender", root, dxDrawSpeed)
end)

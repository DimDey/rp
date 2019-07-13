function getVehicleSpeed()
    if isPedInVehicle(getLocalPlayer()) then
	    local theVehicle = getPedOccupiedVehicle (getLocalPlayer())
        local vx, vy, vz = getElementVelocity (theVehicle)
        return math.sqrt(vx^2 + vy^2 + vz^2) * 165
    end
    return 0
end

function getElementSpeed(element)
	speedx, speedy, speedz = getElementVelocity (element)
	actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	kmh = actualspeed * 180
	return math.round(kmh)
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getVehicleRPM(vehicle)
	local vehicleRPM = 0
    if (vehicle) then  
        if (getVehicleEngineState(vehicle) == true) then
            if getVehicleCurrentGear(vehicle) > 0 then   
				vehicleRPM = math.floor(((getElementSpeed(vehicle, "kmh")/getVehicleCurrentGear(vehicle))*180) + 0.5) 
				if getElementSpeed(vehicle, "kmh") == 0 then vehicleRPM  = math.random(1500, 1650) end
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            else
                vehicleRPM = math.floor((getElementSpeed(vehicle, "kmh")*80) + 0.5)
				if getElementSpeed(vehicle, "kmh") == 0 then vehicleRPM  = math.random(1500, 1650) end
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            end
        else
            vehicleRPM = 0
        end
        return tonumber(vehicleRPM)
    else
        return 0
    end
end

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 180
		end
	else
		return false
	end
end

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then 
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	else
		return false
	end
end

function round2(num, idp)
    return tonumber(string.format("%." .. (idp or 0) .. "f", num))
  end
  
  
  function angle(vehicle)
      local vx,vy,vz = getElementVelocity(vehicle)
      local modV = math.sqrt(vx*vx + vy*vy)
      
      if not isVehicleOnGround(vehicle) then return 0,modV end
      
      local rx,ry,rz = getElementRotation(vehicle)
      local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
      
      local cosX = (sn*vx + cs*vy)/modV
      return math.deg(math.acos(cosX))*0.5, modV
  end

localPlayerVehicle = nil
targetSpeed = 0
cruiseEnabled = false

function cruiseControl()
    if (not isElement(localPlayerVehicle)) then
		removeEventHandler("onClientRender", getRootElement(), cruiseControl)
		cruiseEnabled=false
		return false
	end
	if getVehicleEngineState(localPlayerVehicle) == false then
		removeEventHandler("onClientRender", getRootElement(), cruiseControl)
		cruiseEnabled=false
		return false
	end
	local x,y = angle(localPlayerVehicle)
	if (x<15) then
		local speed = getElementSpeed(localPlayerVehicle)
		local targetSpeedTmp = speed + 1
		if (targetSpeedTmp > targetSpeed) then
			targetSpeedTmp = targetSpeed
		end
		if (targetSpeedTmp > 3) then
			setElementSpeed(localPlayerVehicle, "k", targetSpeedTmp)
		end
	end
end

function cruiseKeyListener(btn,press)
    if btn == "c" and press then
        localPlayerVehicle = getPedOccupiedVehicle(localPlayer)
        if localPlayerVehicle then
            if (ccEnabled) then
				removeEventHandler("onClientRender", getRootElement(), cruiseControl)
				ccEnabled=false
			else
                targetSpeed = getElementSpeed(localPlayerVehicle)
                
				if math.floor(targetSpeed) < 90 then
					targetSpeed = round2(targetSpeed)
					addEventHandler("onClientRender", getRootElement(), cruiseControl)
                    ccEnabled=true
				end
			end
        end
    end
end
addEventHandler("onClientKey",root,cruiseKeyListener)
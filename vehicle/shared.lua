function isHaveVehKeys(player,veh)
    local vfrid = getElementData(veh,"frid")
    if vfrid then
        return vfrid == getElementData(player,"frid")
    end
    local vpid = getElementData(veh,"pid")
    if vpid then
        return vpid == 1
    end 
end
addEvent("checkVehKeys",true)
addEventHandler("checkVehKeys",root,isHaveVehKeys)
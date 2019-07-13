function RGBToHex(red, green, blue)
    if (red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) then
      return nil
    end
  
    return string.format("#%.2X%.2X%.2X", red, green, blue)
end

function onCommand(cmdName,args)
	local func = "command_" .. cmdName
	if _G[func] then
		assert(loadstring(func .. "(...)"))(args)
	end
end
addEvent("onPlayerSendCommand",true)
addEventHandler("onPlayerSendCommand",root,onCommand)

function command_me(args)
  if utf8.len(args) > 0 then
    triggerEvent("onPlayerChat", source, args, 3, RGBToHex(155,10,56), 5)
  end
end

function command_clearchat(args)
  triggerClientEvent(root,"onChat2Clear",root)
end

function command_ban(args)
  local player = exports.idsys:getPlayerByID(tonumber(args))
  if isElement(player) then
    banPlayer(player)
    triggerEvent("onPlayerChat",source,"Игрок "..getElementData(player,"nick").." был заблокирован администратором "..getElementData(source,"nick"), 4, RGBToHex(250,10,10), 0 )
  end
end
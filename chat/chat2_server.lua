addEvent("onChat2Message", true)

local isDefaultOutput = true
local minLength = 1
local maxLength = 96

function clear(player)
  triggerClientEvent(player, "onChat2Clear", player)
end

function show(player, bool)
  triggerClientEvent(player, "onChat2Show", player, bool)
end

function output(player, message)
  triggerClientEvent(player, "onChat2Output", player, message)
end

function useDefaultOutput(bool)
  isDefaultOutput = bool
end

function timeformat(time)
  if time <= 9 then
    return "0"..time
  else
    return time
  end
end

function onPlayerChat(message, messageType, messageColor, messageRange )
  if not isDefaultOutput then
    return
  end

  local sender = source
  local sx,sy,sz = getElementPosition(sender)
  local messageRange = messageRange or 5
  local players = getElementsWithinRange(sx,sy,sz,messageRange)
  local messageColor = messageColor or RGBToHex(255,255,255)

  local time = getRealTime()
  local hours = timeformat(time.hour)
	local minutes = timeformat(time.minute)
  local seconds = timeformat(time.second)

  if messageType == 0 then
    local text = messageColor.."[ ".. hours ..":".. minutes ..":".. seconds .." ] "..string.format("%s: %s", getElementData(sender,"nick"), message)
    for _,player in ipairs(players) do
      output(player,text)
    end
  end

  if messageType == 3 then
    local text = messageColor.."[ ".. hours ..":".. minutes ..":".. seconds .." ] "..string.format("%s %s", getElementData(sender,"nick"), message)
    for _,player in ipairs(players) do
      output(player,text)
    end
  end

  if messageType == 4 then
    local text = messageColor.."[ ".. hours ..":".. minutes ..":".. seconds .." ] "..message
    for _,player in ipairs(players) do
      output(player,text)
    end
  end
  
end

function handleCommand(client, input)
  local splittedInput = split(input, " ")
  local slashCmd = table.remove(splittedInput, 1)
  local cmd = utf8.sub(slashCmd, 2, utf8.len(slashCmd))

  local args = ""
  for _, arg in ipairs(splittedInput) do
    args = string.format("%s %s", args, arg)
  end
  args = utf8.sub(args, 2, utf8.len(args))

  triggerEvent("onPlayerSendCommand",client,cmd,args)
end

function onChatMessage(message, messageType)
  if type(message) ~= "string" or utf8.len(message) < minLength or utf8.len(message) > maxLength then
    return
  end

  if type(messageType) ~= "number" then
    return
  end

  if utf8.sub(message, 0, 1) == "/" then
    return handleCommand(client, message)
  end

  triggerEvent("onPlayerChat", client, message, 0)
end

function listenForOutputChatBox(_, _, _, _, _, message, receiver, r, g, b)
  receiver = receiver or root
  local hexColor = ""

  if (r and g and b) then
    hexColor = RGBToHex(r, g, b)
  end

  output(receiver, string.format("%s%s", hexColor, message))
  return "skip"
end

function listenForShowChat(_, _, _, _, _, player, bool)
  show(player, bool)
  return "skip"
end

function listenForClearChatBox(_, _, _, _, _, player)
  clear(player)
  return "skip"
end

function onResourceStart()
  addDebugHook("preFunction", listenForOutputChatBox, {"outputChatBox"})
  addDebugHook("preFunction", listenForShowChat, {"showChat"})
  addDebugHook("preFunction", listenForClearChatBox, {"clearChatBox"})
end

function onResourceStop()
  removeDebugHook("preFunction", listenForOutputChatBox)
  removeDebugHook("preFunction", listenForShowChat)
  removeDebugHook("preFunction", listenForClearChatBox)
end

addEventHandler("onPlayerChat", root, onPlayerChat)
addEventHandler("onChat2Message", resourceRoot, onChatMessage)
addEventHandler("onResourceStart", resourceRoot, onResourceStart)
addEventHandler("onResourceStop", resourceRoot, onResourceStop)

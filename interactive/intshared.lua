gIntRange = 3
function getElementsInPlayerRange(x,y,z)
     local elements = getElementsWithinRange(x,y,z,2)
     local match = {}
     for k,v in ipairs(elements) do
         if getIntElement(v) then
             local x1,y1,z1 = getElementPosition(v)
             if getDistanceBetweenPoints3D(x1,y1,z1,x,y,z) <= gIntRange then
                 table.insert(match,v)
             end
         end
     end
     return match
 end
 
function isElementInPlayerRange(x,y,z,element)
     local ox,oy,oz = getElementPosition(element)
     return getDistanceBetweenPoints3D(x,y,z,ox,oy,oz) <= gIntRange
end

function getIntElement(element)
     local parent = getElementParent(element)
     outputDebugString(getElementType(parent).." "..getElementType(element))
     if getElementType(parent) == "intelement" then
          return parent
     end
end

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
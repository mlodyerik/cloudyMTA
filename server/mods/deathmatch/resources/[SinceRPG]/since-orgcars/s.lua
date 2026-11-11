  

addEvent('since-orgcars:giveVehicleOnOrg', true)
addEventHandler('since-orgcars:giveVehicleOnOrg', resourceRoot, function(id, orgID)
  if id and tonumber(id) and orgID and tonumber(orgID) then
    local sid = getElementData(client, 'player:sid')
    if not sid then
        return
    end
    exports['since-db']:query('UPDATE `since-vehicles` SET organization=? WHERE id=? LIMIT 1', orgID, id)
    for i,v in ipairs(getElementsByType('vehicle')) do
      if getElementData(v, 'vehicle:id') and getElementData(v, 'vehicle:id')==id and getElementData(v, 'vehicle:owner') and getElementData(v, 'vehicle:owner')==sid then
        setElementData(v, 'vehicle:organization', orgID)
        break
      end
    end
    exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie przepisałeś pojazd na organizacje.')
    giveVehicleList(client)
  end
end)

addEvent('since-orgcars:getVehicleOutOrg', true)
addEventHandler('since-orgcars:getVehicleOutOrg', resourceRoot, function(id)
  if id and tonumber(id) then
    local sid = getElementData(client, 'player:sid')
    if not sid then
        return
    end
    exports['since-db']:query('UPDATE `since-vehicles` SET organization=0 WHERE id=? LIMIT 1', id)
    for i,v in ipairs(getElementsByType('vehicle')) do
      if getElementData(v, 'vehicle:id') and getElementData(v, 'vehicle:id')==id and getElementData(v, 'vehicle:owner') and getElementData(v, 'vehicle:owner')==sid then
        setElementData(v, 'vehicle:organization', nil)
        break
      end
    end
    exports['since-notifications']:sendNotification(client, 'success', 'Pomyślnie odpisałeś pojazd z organizacji.')
    giveVehicleList(client)
  end
end)

function giveVehicleList(plr)
  local sid = getElementData(plr, 'player:sid')
  if not sid then
      return
  end
  local db = exports['since-db']:query('SELECT id, model, organization FROM `since-vehicles` WHERE owner=? and state=1', sid)
  local tbl = {}
  for i,v in ipairs(db) do
    table.insert(tbl, { id = v.id, model = v.model, organization = v.organization })
  end
  for i,v in ipairs(getElementsByType('vehicle')) do
    if getElementData(v, 'vehicle:id') and getElementData(v, 'vehicle:owner') and getElementData(v, 'vehicle:owner')==sid then
      table.insert(tbl, { id = getElementData(v, 'vehicle:id'), model = getElementData(v, 'vehicleID') or getElementModel(v), organization = getElementData(v, 'vehicle:organization') })
    end
  end
  triggerClientEvent(plr, 'since-orgcars:getVehicles', resourceRoot, tbl)
end

addEvent('since-orgcars:getVehicles', true)
addEventHandler('since-orgcars:getVehicles', resourceRoot, function()
  giveVehicleList(client)
end)
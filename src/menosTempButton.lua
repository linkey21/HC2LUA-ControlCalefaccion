--[[ControlCalefaccion
	Dispositivo virtual
	menosTempButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

local tempMax = 28
local index
local tempAct = fibaro:get(_selfId, 'ui.tempParaLabel.value')
local para = string.sub(tempAct, -3, -2)
tempAct = string.sub(tempAct, 1, 2)
for t = 0, tempMax, 1 do
  if tempAct == string.format('%02d', tostring(t)) then
    index = t
    break
  end
  index = t
end
if index > 0 then
  tempAct = string.format('%02d', tostring(index - 1))
else
  tempAct = string.format('%02d', tostring(tempMax))
end
fibaro:call(_selfId, "setProperty", 'ui.tempParaLabel.value',
  tempAct..'ºC / '..para..'h')

local habitacion = fibaro:getRoomID(_selfId)
if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end
-- obtener termostato
response ,status, errorCode = HC2:GET("/api/panels/heating")
--local termostato = json.decode(response).defaultThermostat
--fibaro:call(termostato, "setTargetLevel", temp)
--fibaro:call(termostato, "setTime", os.time()-30)

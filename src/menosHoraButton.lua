--[[ControlCalefaccion
	Dispositivo virtual
	menosHoraButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

local modo = fibaro:get(_selfId, 'ui.modoLabel.value')
-- si el modo es vacacions mo se puede seleccionar hora
if modo ~= "Vacaciones" then
  local tempAct = fibaro:get(_selfId, 'ui.tempParaLabel.value')
  local tiemMax = 23
  local index
  local para = string.sub(tempAct, -3, -2)
  tempAct = string.sub(tempAct, 1, 2)
  for t = 0, tiemMax, 1 do
    fibaro:debug(para..' '..string.format('%02d', tostring(t)))
    if para == string.format('%02d', tostring(t)) then
      index = t
      break
    end
    index = t
  end
  if index > 0 then
    para = string.format('%02d', tostring(index - 1))
  else
    para = string.format('%02d', tostring(tiemMax))
  end
  fibaro:call(_selfId, "setProperty", 'ui.tempParaLabel.value',
    tempAct..'ºC / '..para..'h')

  local habitacion = fibaro:getRoomID(_selfId)
  if not HC2 then
    HC2 = Net.FHttp("127.0.0.1", 11111)
  end
end

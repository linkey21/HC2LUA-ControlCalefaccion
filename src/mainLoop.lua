--[[ControlCalefaccion
	Dispositivo virtual
	mainLoop.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- NO CAMBIAR EL CODIGO A PARTIR DE AQUI ------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]


--[[--------BUCLE DE CONTROL -------------------------------------------------]]
while true do
  --
  fibaro:sleep(1000)
  -- obtener estado
  local estado = fibaro:get(_selfId, 'ui.tempParaLabel.value')
  -- obtener zona
  local zona = fibaro:get(_selfId, 'ui.zonaLabel.value')
  zona = string.sub(zona, string.find(zona, '-', 1) + 1, #zona)
  --refrescar log
  fibaro:log(zona..' - '..estado)
end
--[[--------------------------------------------------------------------------]]

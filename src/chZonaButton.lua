--[[ControlCalefaccion
	Dispositivo virtual
	chZonaButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

if not HC2 then
  HC2 = Net.FHttp("127.0.0.1", 11111)
end
-- obtener zonas
response ,status, errorCode = HC2:GET("/api/panels/heating")
local zonas = json.decode(response)

-- seleccionar la siguiete zona que corresponda
local zona = fibaro:get(_selfId, 'ui.zonaLabel.value')
local myKey = 1
local zonas = json.decode(response)
for key, value in pairs(zonas) do
  if value.id..'-'..value.name == zona then
    if key < #zonas then myKey = key + 1 else myKey = 1 end
    break
  else
    myKey = #zonas
  end
end

-- actualizar la etiqueta de zona
fibaro:call(_selfId, "setProperty", "ui.zonaLabel.value",
 zonas[myKey].id..'-'..zonas[myKey].name) -- ..' '..'00ºC/00ºC'

-- actualizar las etiquetas con estado real de temperatura
fibaro:call(_selfId, "pressButton", "13")

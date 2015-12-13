-- Este dispositivo virtual
--[[ControlCalefaccion
	Dispositivo virtual
	downZonaButton.lua
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

local zona = fibaro:call(_selfId, 'getProperty', 'ui.zonaLabel.value')
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

fibaro:call(_selfId, "setProperty", "ui.zonaLabel.value",
  zonas[myKey].id..'-'..zonas[myKey].name)

--[[ControlCalefaccion
	Dispositivo virtual
	modoButton.lua
	por Manuel Pascual
------------------------------------------------------------------------------]]

--[[----- CONFIGURACION AVANZADA ---------------------------------------------]]
local _selfId = fibaro:getSelfId()  -- ID de este dispositivo virtual
--[[----- FIN CONFIGURACION AVANZADA -----------------------------------------]]

local modos = {'Manual', 'Vacaciones'}
local modo  = fibaro:get(_selfId, 'ui.modoLabel.value')

if modo == modos[1] then
  modo = modos[2]
else
  modo = modos[1]
end

-- actualizar la etiqueta del modo
fibaro:call(_selfId, "setProperty", "ui.modoLabel.value", modo)

-- actualizar las etiquetas con estado real de temperatura
fibaro:call(_selfId, "pressButton", "13")

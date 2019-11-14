--------------------------------------------------------------------------------
--         File:  constructors.lua
--
--        Usage:  ./constructors.lua
--
--  Description:
--
--      Options:  ---
-- Requirements:  ---
--         Bugs:  ---
--        Notes:  ---
--       Author:  Asheera Dolinsky <https://github.com/asheera-dolinsky>
-- Organization:
--      Version:  0.0.0
-- doc DD/MM/YY:  30/10/19
--     Revision:  ---
--------------------------------------------------------------------------------
local function Shallow_Immutable(obj, label, err)
  local mt = { __metatable = label }
  function mt.__index(_, k)
    local v = obj[k]
    return v
  end
  function mt.__newindex() error(err, 2) end
  function mt.__tostring() return label end
  local tc = setmetatable({}, mt)
  return tc
end

local function Symbol(kind, parent)
  return Shallow_Immutable({ parent }, kind, 'cannot modify a symbol')
end

return {
  Symbol = Symbol
}

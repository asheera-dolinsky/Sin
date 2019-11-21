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
local function Symbol(label)
  local mt = { __metatable = label }
  function mt.__index(_, _) end
  function mt.__newindex() error('cannot modify a symbol', 2) end
  function mt.__tostring() return label end
  return setmetatable({}, mt)
end

return {
  Symbol = Symbol
}

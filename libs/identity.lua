--------------------------------------------------------------------------------
--         File:  identity.lua
--
--        Usage:  ./identity.lua
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
-- doc DD/MM/YY:  18/11/19
--     Revision:  ---
--------------------------------------------------------------------------------
local symbols = require 'symbols'

local function last_exists_then(t, consequent, alternative, ...)
  if type(t) == 'table' and t[#t] ~= nil then return consequent(t[#t], ...) end
  return alternative(...)
end

local function identifier(current)
  if type(current) == 'table' then
    if current.symbol == symbols.identifier then return true end
    return identifier(current.value)
  end
  return false
end

local function invocation(current)
  if type(current) == 'table' then
    if current.symbol == symbols.invocation then return true end
    return invocation(current.value)
  end
  return false
end

return {
  last_exists_then = last_exists_then,
  identifier = identifier,
  invocation = invocation
}

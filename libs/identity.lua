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

local function inherits_identifier(current)
  if type(current) == 'table' then
    if current.symbol == symbols.identifier then return true end
    return inherits_identifier(current.value)
  end
  return false
end

return {
  inherits_identifier = inherits_identifier
}

--
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
--       Author:  YOUR NAME (), <>
-- Organization:
--      Version:  0.0.0
-- doc DD/MM/YY:  30/10/19
--     Revision:  ---
--------------------------------------------------------------------------------
--
local function immutable(obj, err)
  local mt = {}
  function mt.__index(_, k)
    local v = obj[k]
    if type(v) == 'table' then
      v = immutable(v)
    end
    return v
  end
  function mt.__newindex() error(err, 2) end
  local tc = setmetatable({}, mt)
  return tc
end

local function symbol(kind)
  return immutable({ kind = kind }, 'cannot modify a symbol')
end

return {
  symbol = symbol
}

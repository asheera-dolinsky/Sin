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
local function immutable(obj, label, err)
  local mt = { __metatable = label }
  function mt.__index(_, k)
    local v = obj[k]
    if type(v) == 'table' then return immutable(v. err) end
    return v
  end
  function mt.__newindex() error(err, 2) end
  function mt.__tostring() return label end
  local tc = setmetatable({}, mt)
  return tc
end

local function symbol(kind)
  return immutable({}, 'symbol:'..kind, 'cannot modify a symbol')
end

return {
  symbol = symbol
}

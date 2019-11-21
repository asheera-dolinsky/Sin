--------------------------------------------------------------------------------
--         File:  helpers.lua
--
--        Usage:  ./helpers.lua
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
-- doc DD/MM/YY:  09/10/19
--     Revision:  ---
--------------------------------------------------------------------------------
local utf8 = require 'utf8'

local function isupper(c)
  return utf8.upper(c) ~= utf8.lower(c) and c == utf8.upper(c)
end

local function head(s)
  return utf8.sub(s, 1, 1)
end

local function tail(s)
  return utf8.sub(s, 2, #s)
end

local function pop(t) return table.remove(t, table.maxn(t)) end

local function pop2(t) return pop(t), pop(t) end

local function take2(t)
  local last, first = pop2(t)
  return first, last
end

local function give2(t, first, last)
  table.insert(t, first)
  table.insert(t, last)
end

local function get_value(current)
  -- will crash if a non-value object is passed, if it happens it's a bug, please report it
  if type(current) == 'table' then
    return get_value(current.value)
  else
    return current
  end
end

return {
  head = head,
  tail = tail,
  isupper = isupper,
  pop = pop,
  take2 = take2,
  give2 = give2,
  get_value = get_value
}

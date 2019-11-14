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
local ansicolors = require 'ansicolors'

local function isupper(c)
  return utf8.upper(c) ~= utf8.lower(c) and c == utf8.upper(c)
end

local function head(s)
  return utf8.sub(s, 1, 1)
end

local function tail(s)
  return utf8.sub(s, 2, #s)
end

local function print_ast(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    local formatting
    if type(tonumber(k)) == 'number' then
      formatting = string.rep('  ', indent)..ansicolors.colorize(k..': ', ansicolors.bright, ansicolors.blink)
    else
      formatting = string.rep('  ', indent)..ansicolors.colorize(k..': ', ansicolors.bright)
    end
    if type(v) == 'table' then
      local mt = getmetatable(v)
      if type(mt) == 'string' then
        local labels = mt
        local current = v
        while true do
          current = current[1]
          if current then
            labels = labels..'->'..getmetatable(current)
          else
            break
          end
        end
        print(formatting..ansicolors.colorize(labels, ansicolors.white, ansicolors.bright))
      else
        print(formatting)
        print_ast(v, indent+1)
      end
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      if k == 'val' then print(formatting..ansicolors.colorize(v, ansicolors.yellow, ansicolors.bright)) else print(formatting..v) end
    end
  end
end

local function shallow_clone(t) return { table.unpack(t) } end

local function pop2(t) return table.remove(t, table.maxn(t)), table.remove(t, table.maxn(t)) end

local function take2(t)
  local last, first = pop2(t)
  return first, last
end

local function give2(t, first, last)
  table.insert(t, first)
  table.insert(t, last)
end

local function get_value(current)
  if type(current) == 'table' then
    return get_value(current.val)
  else
    return current
  end
end

return {
  head = head,
  tail = tail,
  isupper = isupper,
  print_ast = print_ast,
  shallow_clone = shallow_clone,
  take2 = take2,
  give2 = give2,
  get_value = get_value
}

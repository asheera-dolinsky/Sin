--------------------------------------------------------------------------------
--         File:  representation.lua
--
--        Usage:  ./representation.lua
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
local ansicolors = require 'ansicolors'

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
        print(formatting..ansicolors.colorize(mt, ansicolors.white, ansicolors.bright))
      else
        print(formatting)
        print_ast(v, indent+1)
      end
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      if k == 'value' then print(formatting..ansicolors.colorize(v, ansicolors.yellow, ansicolors.bright)) else print(formatting..v) end
    end
  end
end

return {
  print_ast = print_ast
}

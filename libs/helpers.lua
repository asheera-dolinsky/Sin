--
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
--       Author:  YOUR NAME (), <>
-- Organization:  
--      Version:  0.0.0
-- doc DD/MM/YY:  09/10/19
--     Revision:  ---
--------------------------------------------------------------------------------
--
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

local function tprint(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    local formatting
    if type(tonumber(k)) == 'number' then
      formatting = string.rep("  ", indent)..ansicolors.colorize(k..": ", ansicolors.bright, ansicolors.blink)
    else
      formatting = string.rep("  ", indent)..ansicolors.colorize(k..": ", ansicolors.bright)
    end
    if type(v) == "table" then
      local mt = getmetatable(v)
        if type(mt) == 'string' then print(formatting..ansicolors.colorize(mt, ansicolors.blue, ansicolors.bright)) else
        print(formatting)
        tprint(v, indent+1)
      end
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      if k == 'val' then print(formatting..ansicolors.colorize(v, ansicolors.yellow, ansicolors.bright)) else print(formatting..v) end
    end
  end
end

return {
  head = head,
  tail = tail,
  isupper = isupper,
  tprint = tprint
}

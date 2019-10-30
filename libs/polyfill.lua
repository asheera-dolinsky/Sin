--
--------------------------------------------------------------------------------
--         File:  polyfill.lua
--
--        Usage:  ./polyfill.lua
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
-- doc DD/MM/YY:  13/09/19
--     Revision:  ---
--------------------------------------------------------------------------------
--
function table.sclone(t) return { table.unpack(t) } end
function table.pop(t) return table.remove(t, table.maxn(t)) end
function table.pop2(t) return table.remove(t, table.maxn(t)), table.remove(t, table.maxn(t)) end
function table.take2(t)
  local last, first = table.pop2(t)
  return first, last
end
function table.give2(t, first, last)
  table.insert(t, first)
  table.insert(t, last)
end

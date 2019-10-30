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

local function isupper(c)
  return utf8.upper(c) ~= utf8.lower(c) and c == utf8.upper(c)
end

local function head(s)
  return utf8.sub(s, 1, 1)
end

local function tail(s)
  return utf8.sub(s, 2, #s)
end

return {
  head = head,
  tail = tail,
  isupper = isupper
}

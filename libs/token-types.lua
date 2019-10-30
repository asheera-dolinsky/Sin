--
--------------------------------------------------------------------------------
--         File:  token-types.lua
--
--        Usage:  ./token-types.lua
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
local symbol = require('constructors').symbol

return {
  quotation = symbol 'quotation',
  identifier = symbol 'identifier',
  number = symbol 'number',
  left_paren = symbol 'left_paren',
  right_paren = symbol 'right_paren',
  left_brace = symbol 'left_brace',
  right_brace = symbol 'right_brace',
  whitespace = symbol 'whitespace',
  ignored = symbol 'ignored'
}

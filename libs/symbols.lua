--
--------------------------------------------------------------------------------
--         File:  symbols.lua
--
--        Usage:  ./symbols.lua
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
  err = symbol 'error',
  program = symbol 'program',
  list = symbol 'list',
  template = symbol 'template',
  quotation = symbol 'quotation',
  identifier = symbol 'identifier',
  number = symbol 'number',
  segment = symbol 'segment',
  left_paren = symbol 'left paren',
  right_paren = symbol 'right paren',
  left_brace = symbol 'left brace',
  right_brace = symbol 'right brace',
  whitespace = symbol 'whitespace',
  ignored = symbol 'ignored'
}

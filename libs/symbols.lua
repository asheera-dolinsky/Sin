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
--       Author:  Asheera Dolinsky <https://github.com/asheera-dolinsky>
-- Organization:
--      Version:  0.0.0
-- doc DD/MM/YY:  30/10/19
--     Revision:  ---
--------------------------------------------------------------------------------
local symbol = require('constructors').symbol

return {
  err = symbol 'error',
  program = symbol 'program',
  ignore = symbol 'ignore',
  list = symbol 'list',
  invocation = symbol 'invocation',
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
}

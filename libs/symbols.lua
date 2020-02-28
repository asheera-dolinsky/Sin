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
local Symbol = require('constructors').Symbol

return {
  err = Symbol 'error',
  program = Symbol 'program',
  ignore = Symbol 'ignore',
  list = Symbol 'list',
  invocation = Symbol 'invocation',
  template = Symbol 'template',
  quotation = Symbol 'quotation',
  identifier = Symbol 'identifier',
  number = Symbol 'number',
  segment = Symbol 'segment',
  left_paren = Symbol 'left paren',
  right_paren = Symbol 'right paren',
  left_brace = Symbol 'left brace',
  right_brace = Symbol 'right brace',
  whitespace = Symbol 'whitespace'
}

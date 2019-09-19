--
--------------------------------------------------------------------------------
--         File:  grammar.lua
--
--        Usage:  ./grammar.lua
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
-- doc DD/MM/YY:  19/09/19
--     Revision:  ---
--------------------------------------------------------------------------------
--

local peg = require 'lpeglabel'
local re = require 'relabel'


local function identifier(val)
  print('id = '..val)
  return {type = 'identifier', val = val}
end

local function number(val)
  print('num = '..val)
  return {type = 'number', val = val}
end

local function whitespace(val)
  return {type = 'whitespace', val = val}
end

local function ignored(token)
  local val = token.val
  local subtype = token.type
  return {type = 'ignored', subtype = subtype, val = val}
end


-- delimiters
local ws = re.compile '%s'
local left_paren = peg.P '('
local right_paren = peg.P ')'
local left_brace = peg.P '['
local right_brace = peg.P ']'
local left_curly = peg.P '{'
local right_curly = peg.P '}'
local semicolon = peg.P ';'

-- special tokens
local digit = peg.R '09'
local dot = peg.P '.'
local dash = peg.P '-'
local apostrophe = peg.P "'"
local exclamation = peg.P '!'
local match_all = re.compile '.'
local hexadecimal_signifier = peg.P '0x'
local lowercase_a2f = peg.R 'af'
local uppercase_a2f = peg.R 'AF'
local lowercase_e = peg.P 'e'
local uppercase_e = peg.P 'E'

-- combinators
local delimiter_tokens = left_paren + right_paren + left_brace + right_brace + left_curly + right_curly + semicolon
local whitespace_token = ws ^ 1

local decimal_token = (digit ^ 1) * ((dot * (digit ^ 0)) ^ -1) * (((lowercase_e + uppercase_e) * (digit ^ 1)) ^ -1)
local hexadecimal_token = hexadecimal_signifier * ((digit + lowercase_a2f + uppercase_a2f) ^ 1)
local number_token = ((dash ^ -1) * (hexadecimal_token + decimal_token)) * #(whitespace_token + delimiter_tokens + -1)

local identifier_token = (match_all - (whitespace_token + delimiter_tokens + -1)) ^ 1


local num = number_token / number
local id = identifier_token / identifier
local white = whitespace_token / whitespace

local grammar = white + num + id

return grammar

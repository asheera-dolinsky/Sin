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
local helpers = require 'helpers'

local function identifier_transformer(val)
  local head = helpers.head(val)
  if head == "'" then
    local tail = helpers.tail(val)
    print('quotation = '..val)
    return { type = 'quotation', transformed = tail, val = val }
  end
  print('id = '..val)
  return { type = 'identifier', val = val }
end

local function number_transformer(val)
  print('num = '..val)
  return { type = 'number', val = val }
end


local function left_paren_transformer(val)
  print('left paren = '..val)
  return { type = 'left_paren', val = val }
end

local function right_paren_transformer(val)
  print('right paren = '..val)
  return { type = 'right_paren', val = val }
end

local function left_brace_transformer(val)
  print('left brace = '..val)
  return { type = 'left_brace', val = val }
end

local function right_brace_transformer(val)
  print('right brace = '..val)
  return { type = 'right_brace', val = val }
end

local function whitespace_transformer(val)
  return { type = 'whitespace', val = val }
end

local function ignored_transformer(token)
  local val = token.val
  local subtype = token.type
  return { type = 'ignored', subtype = subtype, val = val }
end


-- delimiters
local ws = re.compile '%s'
local left_paren_token = peg.P '('
local right_paren_token = peg.P ')'
local left_brace_token = peg.P '['
local right_brace_token = peg.P ']'
local left_curly_token = peg.P '{'
local right_curly_token = peg.P '}'

-- special tokens
local digit = peg.R '09'
local dot = peg.P '.'
local dash = peg.P '-'
local match_all = re.compile '.'
local hexadecimal_signifier = peg.P '0x'
local lowercase_a2f = peg.R 'af'
local uppercase_a2f = peg.R 'AF'
local lowercase_e = peg.P 'e'
local uppercase_e = peg.P 'E'

-- combinators
local delimiter_tokens = left_paren_token +
  right_paren_token +
  left_brace_token +
  right_brace_token +
  left_curly_token +
  right_curly_token

local whitespace_token = ws ^ 1

local decimal_token = (digit ^ 1) * ((dot * (digit ^ 0)) ^ -1) * (((lowercase_e + uppercase_e) * (digit ^ 1)) ^ -1)
local hexadecimal_token = hexadecimal_signifier * ((digit + lowercase_a2f + uppercase_a2f) ^ 1)
local number_token = ((dash ^ -1) * (hexadecimal_token + decimal_token)) * #(whitespace_token + delimiter_tokens + -1)

local identifier_token = (match_all - (whitespace_token + delimiter_tokens + -1)) ^ 1

local whitespace = whitespace_token / whitespace_transformer / ignored_transformer
local left_paren = left_paren_token / left_paren_transformer
local left_brace = left_brace_token / left_brace_transformer
local number = number_token / number_transformer
local identifier = identifier_token / identifier_transformer

local program_grammar = whitespace + left_paren + left_brace + number + identifier


local function segment_transformer(val)
  print('segment = '..val)
  return {type = 'segment', val = val}
end

-- combinators
local template_delimiter_tokens = right_brace_token
local segment_token = (match_all - (template_delimiter_tokens + -1)) ^ 1

local segment = segment_token / segment_transformer
local right_brace = right_brace_token / right_brace_transformer

local template_grammar = right_brace + segment

local right_paren = right_paren_token / right_paren_transformer
local list_grammar = whitespace + left_paren + right_paren + left_brace + number + identifier

return {
  program_grammar = program_grammar,
  template_grammar = template_grammar,
  list_grammar = list_grammar
}

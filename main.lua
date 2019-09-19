--
--------------------------------------------------------------------------------
--         File:  main.lua
--
--        Usage:  ./main.lua
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

require 'polyfill'
local grammar = require 'grammar'

local pretty_print = (require 'pretty-print').prettyPrint
--[[
local peg = require 'lpeglabel'
local re = require 'relabel'

local pretty_print = (require 'pretty-print').prettyPrint


local function identifier(val)
  print('id', val)
  return {type = 'identifier', val = val}
end

local function number(val)
  print('num', val)
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
--]]

local function parse_chunk(args)
  local rest = args.rest
  local last_i = args.i
  local result, error, position = grammar:match(rest)
  if error then
    local input = args.input
    local line, col = re.calcline(input, last_i + position)
    return { error = error, line = line, col = col } 
  end
  local len = result.val:len()
  local i = len + 1
  return { result = result, rest = string.sub(rest, i), i = last_i + len }
end

local function program(input)
    local result = parse_chunk({ rest = input, i = 0, input = input })
    local acc = {}
    while result.rest ~= '' do
      table.insert(acc, result.result)
      local rest = result.rest
      local i = result.i
      result = parse_chunk({ rest = rest, i = i, input = input })
      if result.error ~= nil then
        return result
      end 
    end
    return acc
end


pretty_print(program([[  2x    10x1fe1 da10xffb10.1c 1 1. 1перацыяЫaad 0x1fe1d a10xffb10.1c1 cd 2 f 0x1fe1d 10.1 0xff 10.1e10 -sdf выаыв  sdf -10 -10.8 -0x1fe -10.10e10]]))

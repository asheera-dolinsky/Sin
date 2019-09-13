require 'polyfill'

local peg = require 'lpeglabel'
local re = require 'relabel'

local pretty_print = (require 'pretty-print').prettyPrint


local function identifier(val)
  print('identifier', val)
  return {type = 'identifier', val = val}
end

local function integer(val)
  print('integer', val)
  return {type = 'integer', val = val}
end

local function decimal(val)
  print('decimal', val)
  return {type = 'decimal', val = val}
end

local function hexadecimal(val)
  print('hexadecimal', val)
  return {type = 'hexadecimal', val = val}
end

local function decimal_exponentiation(val)
  print('decimal-exponentiation', val)
  return {type = 'decimal-exponentiation', val = val}
end

local function number(token)
  local val = token.val
  local subtype = token.type
  return {type = 'number', subtype = subtype, val = val}
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
local match_all = re.compile '.'
local hexadecimal_signifier = peg.P '0x'
local lowercase_a2f = peg.R 'af'
local uppercase_a2f = peg.R 'AF'
local lowercase_e = peg.P 'e'
local lowercase_E = peg.P 'E'

-- combinators
local classic_delimiter_tokens = left_paren + right_paren + left_brace + right_brace + left_curly + right_curly + semicolon
local delimiter_tokens = ws + classic_delimiter_tokens
local whitespace_token = ws ^ 1
local optional_digits = (digit ^ 0)
local digits = (digit ^ 1)
local integer_token = digits * #delimiter_tokens
local decimal_head = digits * dot * optional_digits
local decimal_token = decimal_head * #delimiter_tokens
local hexadecimal_letters = lowercase_a2f + uppercase_a2f
local hexadecimal_tail = (digit + hexadecimal_letters) ^ 1
local hexadecimal_token = (hexadecimal_signifier * hexadecimal_tail) * #delimiter_tokens
local exponentiation_letters = lowercase_e + lowercase_E
local decimal_exponentiation_token = (decimal_head * exponentiation_letters * digits) * #delimiter_tokens
local identifier_token = (match_all - delimiter_tokens) ^ 1


local num = (
  hexadecimal_token / hexadecimal +
  decimal_exponentiation_token / decimal_exponentiation +
  decimal_token / decimal +
  integer_token / integer
) / number
local id = identifier_token / identifier
local white = whitespace_token / whitespace

local grammar = white + num + id

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
    local result = parse_chunk({rest = input, i = 0, input = input})
    local acc = {}
    while not (result.rest == nil or result.rest == '') do
      table.insert(acc, result.result)
      local rest = result.rest
      local i = result.i
      result = parse_chunk({rest = rest, i = i, input = input})
      if result.error ~= nil then
        return result
      end 
    end
    return acc
end

pretty_print(program([[  2x    10x1fe1 da10xffb10.1c 1 1. 1перацыяЫaad 0x1fe1d a10xffb10.1c1 cd 2 f 0x1fe1d 10.1 0xff 10.1e10 -sdf выаыв  sdf]]))

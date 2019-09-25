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
local template_grammar = require 'template-grammar'
local re = require 'relabel'
local pretty_print = (require 'pretty-print').prettyPrint


local function parse_chunk(grammar, args)
  local rest = args.rest
  local last_i = args.i
  local result, error, position = grammar:match(rest)
  if error then
    local input = args.input
    local line, col = re.calcline(input, last_i + position)
    return { error = error, line = line, col = col, result = {} }
  end
  local len = result.val:len()
  local i = len + 1
  return { result = result, rest = string.sub(rest, i), i = last_i + len }
end

local function template(args)
  local input = args.input
  local acc = {}
  local state = { rest = args.rest, i = args.i }
  repeat
    local rest = state.rest
    local i = state.i
    state = parse_chunk(template_grammar, { rest = rest, i = i, input = input })
    --[[
    local parser = parsers[result.type]
    if parser ~= nil then
      result = parser({ rest = rest, i = i, input = input })
    end
    --]]
    if state.error ~= nil then
      return state
    end
    if state.result.type == 'right_brace' then
      acc.type = 'template'
      return { result = acc, rest = state.rest, i = state.i }
    end
    table.insert(acc, state.result)
  until state.rest == ''
  local line, col = re.calcline(input, args.i)
  return { error = 'non-delimited template literal', line = line, col = col, result = {} }
end

local parsers = {
  ['left_brace'] = template
}

local function program(input)
  local acc = {}
  local state = { rest = input, i = 0 }
  repeat
    state = parse_chunk(grammar, { rest = state.rest, i = state.i, input = input })
    local parser = parsers[state.result.type]
    if parser ~= nil then
      print('template')
      state = parser({ rest = state.rest, i = state.i, input = input, opener = state.result })
    end
    if state.error ~= nil then
      return state
    end
    table.insert(acc, state.result)
  until state.rest == ''
  return acc
end


pretty_print(program([[
   2x [this is a template literal] 10x1fe1   da10xffb10.1c 1 1. 1перацыяЫaad 0x1fe1d a10xffb10.1c1 cd 
     2 f 0x1fe1d 10.1 0xff 10.1e10 -sdf выаыв  sdf 
     -10 -10.8 -0x1fe -10.10e10
]]))


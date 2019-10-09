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

local re = require 'relabel'
local pretty_print = (require 'pretty-print').prettyPrint

local grammar = require 'grammar'
local template_grammar = require 'template-grammar'


local function parse_chunk(grammar, args)
  local result, error, position = grammar:match(args.rest)
  if error then
    local line, col = re.calcline(args.input, args.i + position)
    return { error = error == 'fail' and 'unexpected token' or error, line = line, col = col, result = {} }
  end
  local len = result.val:len()
  local i = len + 1
  return { result = result, rest = string.sub(args.rest, i), i = args.i + len }
end

local parsers = {
  program = {},
  template = {},
  call = {}
}

local function template(args)
  local acc = {}
  local state = { rest = args.rest, i = args.i }
  repeat
    state = parse_chunk(template_grammar, { rest = state.rest, i = state.i, input = args.input })
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
  local line, col = re.calcline(args.input, args.i)
  return { error = 'non-delimited template literal', line = line, col = col, result = {} }
end

local function program(args)
  local acc = {}
  local state = { rest = args.input, i = 1 }
  repeat
    state = parse_chunk(grammar.grammar, { rest = state.rest, i = state.i, input = args.input })
    local parser = parsers.program[state.result.type]
    if parser ~= nil then
      print('template')
      state = parser({ rest = state.rest, i = state.i, input = args.input, port = state.result })
    end
    if state.error ~= nil then
      return state
    end
    if state.result.type ~= 'ignored' then table.insert(acc, state.result) end
  until state.rest == ''
  return acc
end

parsers.program.left_brace = template

local input = [[
  \f!
  print!
  For i v
   2x  [this is a template literal] 10x1fe1    da10xffb10.1c 1 1. 1перацыяЫaad 0x1fe1d a10xffb10.1c1 cd 
     2 predicate? f 0x1fe1d 10.1 0xff 10.1e10 -sdf выаыв  sdf 
     -10 -10.8 -0x1fe -10.10e10
g!]]

local function construct(args) end

local constructs = {
  ['for'] = nil
}

pretty_print(program {
  input = input,
  constructs = constructs
})


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


local function parse_chunk(grammar, args)
  local result, error = grammar:match(args.rest)
  if error then
    local line, col = re.calcline(args.input, args.i)
    return { error = error == 'fail' and 'unexpected token' or error, line = line, col = col, result = {} }
  end
  local len = result.val:len()
  local i = len + 1
  return { result = result, rest = string.sub(args.rest, i), i = args.i + len }
end

local parsers = {
  program = {},
  list = {},
  template = {}
}

local cps = {}

cps.parse_chunk = function(continuation, grammar, input, i, rest, acc)
  local result, error = grammar:match(rest)
  if error then
    local line, col = re.calcline(input, i)
    return {
      type = 'error',
      val = error == 'fail' and 'unexpected token',
      line = line,
      col = col
    }
  end
  local len = result.val:len()
  return continuation(input, i + len, string.sub(rest, len + 1), result, acc)
end
cps.program = function(input, i, rest, result, acc)
  if rest == '' then return acc end
  local parser = parsers.program[result.type]
  if parser == nil then
    if result.type ~= 'ignored' then table.insert(acc, result) end
    return cps.parse_chunk(cps.program, grammar.program_grammar, input, i, rest, acc)
  else
    local state = parser({ rest = rest, i = i, input = input, port = result })
    if state.error ~= nil then return state end
    if state.result.type ~= 'ignored' then table.insert(acc, state.result) end
    return cps.parse_chunk(cps.program, grammar.program_grammar, input, state.i, state.rest, acc)
  end
end

local function list(args)
  local acc = {}
  local state = { rest = args.rest, i = args.i }
  repeat
    state = parse_chunk(grammar.list_grammar, { rest = state.rest, i = state.i, input = args.input })
    local parser = parsers.list[state.result.type]
    if parser ~= nil then
      state = parser({ rest = state.rest, i = state.i, input = args.input, port = state.result })
    end
    if state.error ~= nil then
      return state
    end
    if state.result.type == 'right_paren' then
      acc.type = 'list'
      return { result = acc, rest = state.rest, i = state.i }
    end
    if state.result.type ~= 'ignored' then table.insert(acc, state.result) end
  until state.rest == ''
  local line, col = re.calcline(args.input, args.i - 1)
  return { type = 'error', val = 'non-delimited list', line = line, col = col }
end

local function template(args)
  local acc = {}
  local state = { rest = args.rest, i = args.i }
  repeat
    state = parse_chunk(grammar.template_grammar, { rest = state.rest, i = state.i, input = args.input })
    -- placeholder here
    if state.error ~= nil then
      return state
    end
    if state.result.type == 'right_brace' then
      acc.type = 'template'
      return { result = acc, rest = state.rest, i = state.i }
    end
    table.insert(acc, state.result)
  until state.rest == ''
  local line, col = re.calcline(args.input, args.i - 1)
  return { type = 'error', val = 'non-delimited template literal', line = line, col = col }
end


parsers.program.left_brace = template
parsers.program.left_paren = list
parsers.list.left_paren = list
parsers.list.left_brace = template


local function parse(args)
  return cps.parse_chunk(cps.program, grammar.program_grammar, args.input, 1, args.input, { type = 'program' })
end


local input = [[
 ЫЫЫЫЫ
   
     (    (x))
  'this-is-a-quotation
  \f!
  print!
  For i v
   2x  [this is a template literal] 10x1fe1    da10xffb10.1c 1 1. 1перацыяЫaad 0x1fe1d a10xffb10.1c1 cd 
     2 predicate? f 0x1fe1d 10.1 0xff 10.1e10 -sdf выаыв  sdf 
     -10 -10.8 -0x1fe -10.10e10
g!]]


pretty_print(parse {
  input = input
})


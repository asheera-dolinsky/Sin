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

local pretty_print = (require 'pretty-print').prettyPrint

local grammar = require 'grammar'


local function parse_chunk_old(lexicon, args)
  local result, error = lexicon:match(args.rest)
  if error then
    return { type = 'error', val = 'unexpected token' }
  end
  local len = result.val:len()
  local i = len + 1
  return { result = result, rest = string.sub(args.rest, i) }
end

local parsers = {
  program = {},
  list = {},
  template = {}
}

local continuations = {
  program = {},
  list = {},
  template = {}
}

local grammars = {}

local function construct_error(msg)
  return {
    type = 'error',
    val = msg
  }
end

local function parse_chunk(global, acc)
  local rest = global.rest
  local continuation = acc.continuation
  local result, error = grammars[continuation]:match(rest)
  if error then return construct_error('unexpected token') else
    local len = result.val:len()
    global.rest = string.sub(rest, len + 1)
    return continuation(global, acc, result)
  end
end

local function program(global, acc, result)
  if global.rest == '' then return acc end
  local parser = parsers.program[result.type]
  if parser == nil then
    if result.type ~= 'ignored' then table.insert(acc, result) end
    return parse_chunk(global, acc)
  else
  -- cps this v
    local parser_state = parser({ rest = global.rest, input = global.input, aperture = result })
    if parser_state.type == 'error' then return parser_state end
    if parser_state.result.type ~= 'ignored' then table.insert(acc, parser_state.result) end
    return parse_chunk({ input = global.input, rest = parser_state.rest }, acc)
  -- cps that ^
  end
end

local function list(args)
  local acc = {}
  local state = { rest = args.rest }
  repeat
    state = parse_chunk_old(grammar.list_grammar, { rest = state.rest, i = state.i, input = args.input })
    local parser = parsers.list[state.result.type]
    if parser ~= nil then
      state = parser({ rest = state.rest, input = args.input, port = state.result })
    end
    if state.error ~= nil then
      return state
    end
    if state.result.type == 'right_paren' then
      acc.type = 'list'
      return { result = acc, rest = state.rest }
    end
    if state.result.type ~= 'ignored' then table.insert(acc, state.result) end
  until state.rest == ''
  print(args.rest)
  return construct_error('non-delimited list')
end

local function template(args)
  local acc = {}
  local state = { rest = args.rest }
  repeat
    state = parse_chunk_old(grammar.template_grammar, { rest = state.rest, input = args.input })
    -- placeholder here
    if state.error ~= nil then
      return state
    end
    if state.result.type == 'right_brace' then
      acc.type = 'template'
      return { result = acc, rest = state.rest }
    end
    table.insert(acc, state.result)
  until state.rest == ''
  return {
    type = 'error',
    val = 'non-delimited template literal'
  }
end


parsers.program.left_brace = template
parsers.program.left_paren = list
parsers.list.left_brace = template
parsers.list.left_paren = list


local function list_cps(input, rest, result, acc) -- aperture in acc
  if rest == '' then
    return {
      type = 'error',
      val = 'non-delimited list'
    }
  end
  if result.type == 'right_paren' then
    table.insert(acc.parent, acc)
    parse_chunk(input, i, rest, acc.parent)
  elseif result.type == 'left_paren' then
    return parse_chunk(input, rest, {
      type = 'list',
      aperture = {},
      continuation = list_cps
    })
  else
    if result.type ~= 'ignored' then table.insert(acc, result) end
    return parse_chunk(input, i, rest, acc)
  end
end

grammars[program] = grammar.program_grammar
grammars[list_cps] = grammar.list_grammar


local function parse(args)
  return parse_chunk({
      input = args.input,
      rest = args.input
    },
    { type = 'program', continuation = program }
  )
end


local input = [[
   
 ЫЫЫЫЫ
   
    ГК(    (Ф))
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


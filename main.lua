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

local function construct_error(msg)
  return {
    type = 'error',
    val = msg
  }
end

local function process(invariants, invariant, global, ancestors, acc)
  local result, error = invariant.grammar:match(global.rest)
  if error then return construct_error('unexpected token') end
  local len = result.val:len()
  global.rest = string.sub(global.rest, len + 1)
  return invariant.continuation(invariants, invariant, global, ancestors, acc, result)
end

local function program(invariants, invariant, global, ancestors, acc, result)
  if global.rest == '' then return acc end
  local child_invariant = invariants[program].invariants[result.type]
  if child_invariant == nil then
    if result.type ~= 'ignored' then table.insert(acc, result) end
    return process(invariants, invariant, global, ancestors, acc)
  else
    table.give2(ancestors, invariant, acc)
    return process(invariants, child_invariant, global, ancestors, { type = child_invariant.type })
  end
end

local function list(invariants, invariant, global, ancestors, acc, result)
  if result.type == 'right_paren' then
    local parent_invariant, parent_acc = table.take2(ancestors)
    return parent_invariant.continuation(invariants, parent_invariant, global, ancestors, parent_acc, acc)
  end
  if global.rest == '' then return construct_error('non-delimited list') end
  local child_invariant = invariants[program].invariants[result.type]
  if child_invariant == nil then
    if result.type ~= 'ignored' then table.insert(acc, result) end
    return process(invariants, invariant, global, ancestors, acc)
  else
    table.give2(ancestors, invariant, acc)
    return process(invariants, child_invariant, global, ancestors, { type = child_invariant.type })
  end
end

local function template_prototype(invariants, invariant, global, ancestors, acc, result)
  if result.type == 'right_paren' then
    local parent_invariant, parent_acc = table.take2(ancestors)
    return parent_invariant.continuation(invariants, parent_invariant, global, ancestors, parent_acc, acc)
  end
  if global.rest == '' then return construct_error('non-delimited list') end
  local child_invariant = invariants[program].invariants[result.type]
  if child_invariant == nil then
    if result.type ~= 'ignored' then table.insert(acc, result) end
    return process(invariants, invariant, global, ancestors, acc)
  else
    table.give2(ancestors, invariant, acc)
    return process(invariants, child_invariant, global, ancestors, { type = child_invariant.type })
  end
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
  return construct_error('non-delimited template literal')
end

local function parse(args)
  local program_invariant = {
    type = 'program',
    continuation = program,
    grammar = grammar.program_grammar,
    invariants = {}
  }
  local invariants = {
    [program] = program_invariant,
    [list] = {
      type = 'list',
      continuation = list,
      grammar = grammar.list_grammar,
      invariants = {}
    }
  }
  program_invariant.invariants.left_paren = invariants[list]
  invariants[list].invariants.left_paren = invariants[list]
  return process(invariants, program_invariant, { input = args.input, rest = args.input }, {}, { type = program_invariant.type })
end

-- [this is a template literal]

local input = [[
   
 ЫЫЫЫЫ
 
    ГК(    (Ф))
  'this-is-a-quotation
  \f!
  print!
  For i v
   2x   10x1fe1    da10xffb10.1c 1 1. 1перацыяЫaad 0x1fe1d a10xffb10.1c1 cd 
     2 predicate? f 0x1fe1d 10.1 0xff 10.1e10 -sdf выаыв  sdf 
     -10 -10.8 -0x1fe -10.10e10
g!]]


pretty_print(parse {
  input = input
})

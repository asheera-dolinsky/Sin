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
--       Author:  Asheera Dolinsky <https://github.com/asheera-dolinsky>
-- Organization:
--      Version:  0.0.0
-- doc DD/MM/YY:  13/09/19
--     Revision:  ---
--
-- TODO:
--       *combine lists into an invocation
--------------------------------------------------------------------------------
local grammar = require 'grammar'
local symbols = require 'symbols'
local helpers = require 'helpers'
local print_ast = (require 'representation').print_ast
local identity = require 'identity'

local function construct_error(msg) return {symbol = symbols.err, value = msg} end

local function process(state, invariant, ancestors, acc)
  if invariant.grammar then
    local result, error = invariant.grammar:match(state.rest)
    if error then return construct_error(invariant.err) end
    local len = helpers.get_value(result):len()
    state.rest = string.sub(state.rest, len + 1)
    return invariant.continuation(state, invariant, ancestors, acc, result)
  end
  return invariant.continuation(state, invariant, ancestors, acc)
end

local function program(state, invariant, ancestors, acc, result)
  if state.rest == '' then return acc end
  local child_invariant = state.invariants[program].invariants[result.symbol]
  if child_invariant then
    helpers.give2(ancestors, invariant, acc)
    return process(state, child_invariant, ancestors, {symbol = child_invariant.symbol})
  end
  table.insert(acc, result)
  return process(state, invariant, ancestors, acc)
end

local function list_last_exists_then_consequent(last, state, parent_invariant, ancestors,
                                                parent_acc, acc)
  if identity.identifier(last) then
    -- TODO: combine with acc
    -- last = helpers.pop(parent_acc)
    return parent_invariant.continuation(state, parent_invariant, ancestors, parent_acc, acc)
  end
  if identity.invocation(last) then
    return parent_invariant.continuation(state, parent_invariant, ancestors, parent_acc, acc)
  end
  return construct_error('a list must be preceded by either another list or an identifier')
end

local function list_last_exists_then_alternative()
  return construct_error('a list cannot be the first element in a sequence')
end

local function list(state, invariant, ancestors, acc, result)
  if result.symbol == invariant.terminator then
    local parent_invariant, parent_acc = helpers.take2(ancestors)
    return identity.last_exists_then(parent_acc, list_last_exists_then_consequent,
                                     list_last_exists_then_alternative, state, parent_invariant,
                                     ancestors, parent_acc, acc)
  end
  if state.rest == '' then return construct_error(invariant.err) end
  local child_invariant = state.invariants[program].invariants[result.symbol]
  if child_invariant then
    helpers.give2(ancestors, invariant, acc)
    return process(state, child_invariant, ancestors, {symbol = child_invariant.symbol})
  end
  table.insert(acc, result)
  return process(state, invariant, ancestors, acc)
end

local function template(state, invariant, ancestors, acc, result)
  if result.symbol == invariant.terminator then
    local parent_invariant, parent_acc = helpers.take2(ancestors)
    return parent_invariant.continuation(state, parent_invariant, ancestors, parent_acc, acc)
  end
  if state.rest == '' then return construct_error(invariant.err) end
  local child_invariant = state.invariants[program].invariants[result.symbol]
  if child_invariant then
    helpers.give2(ancestors, invariant, acc)
    return process(state, child_invariant, ancestors, {symbol = child_invariant.symbol})
  end
  table.insert(acc, result)
  return process(state, invariant, ancestors, acc)
end

local function ignore(state, _, ancestors)
  local parent_invariant, parent_acc = helpers.take2(ancestors)
  return process(state, parent_invariant, ancestors, parent_acc)
end

local function parse(args)
  local program_invariant = {
    symbol = symbols.program,
    continuation = program,
    grammar = grammar.program_grammar,
    invariants = {},
    err = 'unexpected token'
  }
  local invariants = {
    [program] = program_invariant,
    [list] = {
      symbol = symbols.list,
      continuation = list,
      grammar = grammar.list_grammar,
      invariants = {},
      terminator = symbols.right_paren,
      err = 'non-delimited list'
    },
    [template] = {
      symbol = symbols.template,
      continuation = template,
      grammar = grammar.template_grammar,
      invariants = {},
      terminator = symbols.right_brace,
      err = 'non-delimited template'
    },
    [ignore] = {
      symbol = symbols.ignore,
      continuation = ignore,
      grammar = nil -- will be ignored by process
    }
  }
  program_invariant.invariants[symbols.left_paren] = invariants[list]
  program_invariant.invariants[symbols.left_brace] = invariants[template]
  program_invariant.invariants[symbols.ignore] = invariants[ignore]
  invariants[list].invariants[symbols.left_paren] = invariants[list]
  invariants[list].invariants[symbols.left_brace] = invariants[template]
  invariants[list].invariants[symbols.ignore] = invariants[ignore]
  return process({invariants = invariants, input = args.input, rest = args.input},
                 program_invariant, {}, {symbol = program_invariant.symbol})
end

local input = [[
   
 ЫЫЫЫЫ
 [this is a template literal]
    ГК(  ПК  (Ф И О))
  'this-is-a-quotation
  \f!
  print!
  For i v
   2x   10x1fe1    da10xffb10.1c 1 1. 1перацыяЫaad 0x1fe1d a10xffb10.1c1 cd 
     2 predicate? f 0x1fe1d 10.1 0xff 10.1e10 -sdf выаыв  sdf 
     -10 -10.8 -0x1fe -10.10e10
g!]]

print_ast(parse {input = input})


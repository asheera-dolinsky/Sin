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

local function construct_error(msg)
  return {
    symbol = symbols.err,
    val = msg
  }
end

local function process(invariants, invariant, global, ancestors, acc)
  if invariant.grammar then
    local result, error = invariant.grammar:match(global.rest)
    if error then return construct_error(invariant.err) end
    local len = result.val:len()
    global.rest = string.sub(global.rest, len + 1)
    return invariant.continuation(invariants, invariant, global, ancestors, acc, result)
  else
    return invariant.continuation(invariants, invariant, global, ancestors, acc)
  end
end

local function program(invariants, invariant, global, ancestors, acc, result)
  if global.rest == '' then return acc end
  local child_invariant = invariants[program].invariants[result.symbol]
  if child_invariant then
    helpers.give2(ancestors, invariant, acc)
    return process(invariants, child_invariant, global, ancestors, { symbol = child_invariant.symbol })
  else
    table.insert(acc, result)
    return process(invariants, invariant, global, ancestors, acc)
  end
end

local function list(invariants, invariant, global, ancestors, acc, result)
  if result.symbol == invariant.terminator then
    local parent_invariant, parent_acc = helpers.take2(ancestors)
    return parent_invariant.continuation(invariants, parent_invariant, global, ancestors, parent_acc, acc)
  end
  if global.rest == '' then return construct_error(invariant.err) end
  local child_invariant = invariants[program].invariants[result.symbol]
  if child_invariant then
    helpers.give2(ancestors, invariant, acc)
    return process(invariants, child_invariant, global, ancestors, { symbol = child_invariant.symbol })
  else
    table.insert(acc, result)
    return process(invariants, invariant, global, ancestors, acc)
  end
end

local function template(invariants, invariant, global, ancestors, acc, result)
  if result.symbol == invariant.terminator then
    local parent_invariant, parent_acc = helpers.take2(ancestors)
    return parent_invariant.continuation(invariants, parent_invariant, global, ancestors, parent_acc, acc)
  end
  if global.rest == '' then return construct_error(invariant.err) end
  local child_invariant = invariants[program].invariants[result.symbol]
  if child_invariant then
    helpers.give2(ancestors, invariant, acc)
    return process(invariants, child_invariant, global, ancestors, { symbol = child_invariant.symbol })
  else
    table.insert(acc, result)
    return process(invariants, invariant, global, ancestors, acc)
  end
end

local function ignore(invariants, _, global, ancestors)
  local parent_invariant, parent_acc = helpers.take2(ancestors)
  return process(invariants, parent_invariant, global, ancestors, parent_acc)
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
  return process(invariants, program_invariant, { input = args.input, rest = args.input }, {}, { symbol = program_invariant.symbol })
end

local input = [[
   
 ЫЫЫЫЫ
 [this is a template literal]
    ГК(    (Ф И О))
  'this-is-a-quotation
  \f!
  print!
  For i v
   2x   10x1fe1    da10xffb10.1c 1 1. 1перацыяЫaad 0x1fe1d a10xffb10.1c1 cd 
     2 predicate? f 0x1fe1d 10.1 0xff 10.1e10 -sdf выаыв  sdf 
     -10 -10.8 -0x1fe -10.10e10
g!]]

helpers.print_ast(parse {
  input = input
})


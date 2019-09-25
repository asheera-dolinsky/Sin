--
--------------------------------------------------------------------------------
--         File:  grammar.lua
--
--        Usage:  ./template-grammar.lua
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
-- doc DD/MM/YY:  25/09/19
--     Revision:  ---
--------------------------------------------------------------------------------
--

local peg = require 'lpeglabel'
local re = require 'relabel'


local function char_transformer(val)
  print('segment = '..val)
  return {type = 'segment', val = val}
end

local function right_brace_transformer(val)
  print('right brace = '..val)
  return {type = 'right_brace', val = val}
end

-- delimiters
local right_brace_token = peg.P ']'
-- local left_curly = peg.P '{'
-- local right_curly = peg.P '}'

-- special tokens
local match_all = re.compile '.'

-- combinators
local delimiter_tokens = right_brace_token
local char_token = (match_all - (delimiter_tokens + -1)) ^ 1

local char = char_token / char_transformer
local rb = right_brace_token / right_brace_transformer

local grammar = rb + char

return grammar

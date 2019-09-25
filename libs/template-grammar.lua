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


local function segment_transformer(val)
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
local segment_token = (match_all - (delimiter_tokens + -1)) ^ 1

local segment = segment_token / segment_transformer
local right_brace = right_brace_token / right_brace_transformer

local grammar = right_brace + segment

return grammar

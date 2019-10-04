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

local grammar = require 'grammar'


local function segment_transformer(val)
  print('segment = '..val)
  return {type = 'segment', val = val}
end

-- combinators
local delimiter_tokens = grammar.right_brace_token
local segment_token = (grammar.match_all - (delimiter_tokens + -1)) ^ 1

local segment = segment_token / segment_transformer


return grammar.right_brace + segment

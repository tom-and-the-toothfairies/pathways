Definitions.

IDENT = [a-zA-Z0-9_]+
WS    = [\s\t\n\r]+
STRING = "[^"]*"
ACTION_TYPE  = (manual|executable)
COMMENT = \/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/

Rules.

\{            : {token, {'{', TokenLine}}.
\}            : {token, {'}', TokenLine}}.
drug          : {token, {drug, TokenLine}}.
process       : {token, {process, TokenLine}}.
task          : {token, {task, TokenLine}}.
action        : {token, {action, TokenLine}}.
branch        : {token, {branch, TokenLine}}.
selection     : {token, {selection, TokenLine}}.
iteration     : {token, {iteration, TokenLine}}.
sequence      : {token, {sequence, TokenLine}}.
requires      : {token, {requires, TokenLine}}.
provides      : {token, {provides, TokenLine}}.
agent         : {token, {agent, TokenLine}}.
script        : {token, {script, TokenLine}}.
tool          : {token, {tool, TokenLine}}.
input         : {token, {input, TokenLine}}.
output        : {token, {output, TokenLine}}.
{ACTION_TYPE} : {token, {action_type, TokenLine}}.
{COMMENT}     : skip_token.
{STRING}      : {token, {string, TokenLine, TokenChars}}.
\.            : {token, {dot, TokenLine}}.
==            : {token, {equals, TokenLine}}.
{IDENT}       : {token, {ident, TokenLine}}.
{WS}          : skip_token.

Erlang code.

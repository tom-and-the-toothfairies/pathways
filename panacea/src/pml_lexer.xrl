Definitions.

IDENT = [a-zA-Z0-9_]+
WS    = [\s\t\n\r]+
NUMBER = ([0-9]+(\.[0-9]+)?|\.[0-9]+)([eE][+-]?[0-9]+)?
STRING = "[^"]*"
COMMENT = \/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/

Rules.

% keywords

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
manual        : {token, {manual, TokenLine}}.
executable    : {token, {executable, TokenLine}}.

% symbols

\{            : {token, {'{', TokenLine}}.
\}            : {token, {'}', TokenLine}}.
\(            : {token, {'(', TokenLine}}.
\)            : {token, {')', TokenLine}}.
\|\|          : {token, {'||', TokenLine}}.
&&            : {token, {'&&', TokenLine}}.
==            : {token, {'==', TokenLine}}.
<             : {token, {'<', TokenLine}}.
>             : {token, {'>', TokenLine}}.
<=            : {token, {'<=', TokenLine}}.
>=            : {token, {'>=', TokenLine}}.
!=            : {token, {'!=', TokenLine}}.
!             : {token, {'!', TokenLine}}.
\.            : {token, {'.', TokenLine}}.

% primitives

{COMMENT}     : skip_token.
{WS}          : skip_token.
{STRING}      : {token, {string, TokenLine, TokenChars}}.
{NUMBER}      : {token, {number, TokenLine}}.
{IDENT}       : {token, {ident, TokenLine, TokenChars}}.

Erlang code.

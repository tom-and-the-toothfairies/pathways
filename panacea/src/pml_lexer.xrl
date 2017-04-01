Definitions.

IDENT   = [a-zA-Z0-9_]+
WS      = [\s\t\n\r]+
INTEGER = [0-9]+
FLOAT   = {INTEGER}?\.{INTEGER}([eE][+-]?{INTEGER})?
STRING  = "[^"]*"
COMMENT = \/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/

Rules.

% keywords

drug          : {token, {drug, TokenLine}}.
time          : {token, {time, TokenLine}}.
years         : {token, {years, TokenLine}}.
days          : {token, {days, TokenLine}}.
hours         : {token, {hours, TokenLine}}.
minutes       : {token, {minutes, TokenLine}}.
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
{INTEGER}     : {token, {integer, TokenLine, TokenChars}}.
{FLOAT}       : {token, {float, TokenLine, TokenChars}}.
{IDENT}       : {token, {ident, TokenLine, TokenChars}}.

Erlang code.

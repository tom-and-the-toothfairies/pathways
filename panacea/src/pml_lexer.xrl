Definitions.

IDENT = [a-zA-z_]+
WS    = [\s\t\n\r]+
ACTION_TYPE  = (manual|executable)

Rules.

\{                              : {token, {'{', TokenLine}}.
\}                              : {token, {'}', TokenLine}}.
process{WS}{IDENT}              : {token, {process, TokenLine}}.
task{WS}{IDENT}                 : {token, {task, TokenLine}}.
action{WS}{IDENT}{ACTION_TYPE}? : {token, {action, TokenLine}}.
branch{WS}{IDENT}?              : {token, {branch, TokenLine}}.
selection{WS}{IDENT}?           : {token, {selection, TokenLine}}.
iteration{WS}{IDENT}?           : {token, {iteration, TokenLine}}.
sequence{WS}{IDENT}?            : {token, {sequence, TokenLine}}.
requires                        : {token, {requires, TokenLine}}.
provides                        : {token, {provides, TokenLine}}.
agent                           : {token, {agent, TokenLine}}.
script                          : {token, {script, TokenLine}}.
tool                            : {token, {tool, TokenLine}}.
{WS}                            : skip_token.

Erlang code.

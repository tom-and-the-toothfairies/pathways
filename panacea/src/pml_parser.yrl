Nonterminals

pml primitive_block primitive_list primitive
action_block action_attributes action_attribute
expression variable operator.

Terminals

'process' '{' '}' 'task' 'action' 'branch'
'selection' 'iteration' 'sequence' 'provides'
'requires' 'agent' 'script' 'tool' 'string'
'input' 'output' 'ident' 'dot' 'equals'.

Rootsymbol pml.

pml ->
    'process' primitive_block : {'process', '$2'}.

primitive_block ->
    '{' primitive_list : '$2'.

primitive_list ->
    '}' : [].
primitive_list ->
    primitive primitive_list : ['$1'|'$2'].

primitive ->
    'task' primitive_block : {'task', '$2'}.
primitive ->
    'action' action_block : {'action', '$2'}.
primitive ->
    'branch' primitive_block : {'branch', '$2'}.
primitive ->
    'selection' primitive_block : {'selection', '$2'}.
primitive ->
    'sequence' primitive_block : {'sequence', '$2'}.
primitive ->
    'iteration' primitive_block : {'iteration', '$2'}.

action_block ->
    '{' action_attributes : '$2'.

action_attributes ->
    '}' : [].
action_attributes ->
    action_attribute action_attributes : ['$1'|'$2'].

action_attribute ->
    'requires' '{' expression '}' : 'requires'.
action_attribute ->
    'provides' '{' expression '}' : 'provides'.
action_attribute ->
    'agent' '{' expression '}'  : 'agent'.
action_attribute ->
    'script' '{' 'string' '}'  : 'script'.
action_attribute ->
    'tool' '{' 'string' '}'  : 'tool'.
action_attribute ->
    'input' '{' expression '}'  : 'input'.
action_attribute ->
    'output' '{' expression '}'  : 'output'.

expression ->
    'string' : 'string'.

expression ->
    variable : 'variable'.

expression ->
    variable operator variable : 'expr'.

variable ->
    'ident' : 'variable'.

variable ->
    'ident' 'dot' 'ident' : 'variable'.

operator ->
    'equals' : 'equals'.


Erlang code.

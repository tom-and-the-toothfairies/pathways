Nonterminals

pml primitive_block primitive_list primitive
action_block action_attributes action_attribute
expression variable operator.

Terminals

'process' '{' '}' 'task' 'action' 'branch'
'selection' 'iteration' 'sequence' 'provides'
'requires' 'agent' 'script' 'tool' 'string'
'input' 'output' 'ident' 'dot' 'equals'
'action_type' 'drug'.

Rootsymbol pml.

pml ->
    'process' 'ident' primitive_block : '$3'.

primitive_block ->
    '{' primitive_list : '$2'.

primitive_list ->
    '}' : [].
primitive_list ->
    primitive primitive_list : '$1' ++ '$2'.

primitive ->
    'task' ident primitive_block :  '$3'.
primitive ->
    'action' ident 'action_type' action_block :  '$4'.
primitive ->
    'action' ident action_block :  '$3'.
primitive ->
    'branch' primitive_block : '$2'.
primitive ->
    'branch' ident primitive_block :  '$3'.
primitive ->
    'selection' primitive_block :  '$2'.
primitive ->
    'selection' ident primitive_block :  '$3'.
primitive ->
    'sequence' primitive_block :  '$2'.
primitive ->
    'sequence' ident primitive_block : '$3'.
primitive ->
    'iteration' primitive_block :  '$2'.
primitive ->
    'iteration' ident primitive_block :  '$3'.

action_block ->
    '{' action_attributes : '$2'.

action_attributes ->
    '}' : [].
action_attributes ->
    action_attribute action_attributes : '$1' ++ '$2'.

action_attribute ->
    'requires' '{' expression '}' : '$3'.
action_attribute ->
    'provides' '{' expression '}' : [].
action_attribute ->
    'agent' '{' expression '}'  : [].
action_attribute ->
    'script' '{' 'string' '}'  : [].
action_attribute ->
    'tool' '{' 'string' '}'  : [].
action_attribute ->
    'input' '{' expression '}'  : [].
action_attribute ->
    'output' '{' expression '}'  : [].

expression ->
    'drug' : extract_drug('$1').
expression ->
    'string' : [].

expression ->
    variable : [].

expression ->
    variable operator variable : [].

variable ->
    'ident' : [].
variable ->
    'action_type' : [].
variable ->
    'ident' 'dot' variable : [].
variable ->
    'action_type' 'dot' variable : [].

operator ->
    'equals' : [].


Erlang code.

extract_drug({_,_,Drug}) ->
    [Drug].

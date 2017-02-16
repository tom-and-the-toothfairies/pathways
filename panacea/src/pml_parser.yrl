Nonterminals pml primitive_block primitive_list primitive.
Terminals 'process' '{' '}' 'task' 'action' 'branch' 'selection' 'iteration' 'sequence'.
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
    'action' '{' '}': 'action'.
primitive ->
    'branch' primitive_block : {'branch', '$2'}.
primitive ->
    'selection' primitive_block : {'selection', '$2'}.
primitive ->
    'sequence' primitive_block : {'sequence', '$2'}.
primitive ->
    'iteration' primitive_block : {'iteration', '$2'}.

Erlang code.

Nonterminals

pml
primitive_block
primitive_list
primitive
optional_name
action_block
action_attributes
action_attribute
optional_type
expression
expr
logical_combination
operator
requires_expr
operation
value
variable
accessor
identifier
prefix_list
prefix.

Terminals

% keywords

'process'
'task'
'action'
'branch'
'selection'
'iteration'
'sequence'
'provides'
'requires'
'agent'
'script'
'tool'
'input'
'output'
'manual'
'executable'

% symbols
'{'
'}'
'('
')'
'=='
'!='
'||'
'&&'
'.'
'<'
'>'
'<='
'>='
'!'

% primitives
'string'
'ident'
'drug'
'number'.

Rootsymbol pml.

% Associativity of 'operator' symbols.
% Allows shift/reduce conflicts to be resolved at compile time
% See https://www.gnu.org/software/bison/manual/html_node/Shift_002fReduce.html
Nonassoc 200 '==' '!=' '||' '&&' '<' '>' '<=' '>=' '!' '.' ')'.

pml ->
    'process' 'ident' primitive_block : '$3'.

primitive_block ->
    '{' primitive_list '}' : '$2'.

primitive_list ->
    '$empty' : [].
primitive_list ->
    primitive primitive_list : '$1' ++ '$2'.

primitive ->
    'branch' optional_name primitive_block    : '$3'.
primitive ->
    'selection' optional_name primitive_block :  '$3'.
primitive ->
    'iteration' optional_name primitive_block :  '$3'.
primitive ->
    'sequence' optional_name primitive_block  :  '$3'.
primitive ->
    'task' optional_name primitive_block      :  '$3'.
% action names are required and have a different block
% to other primitives
primitive ->
    'action' ident optional_type action_block :  '$4'.

optional_name ->
    '$empty' : [].
optional_name ->
    'ident' : [].

optional_type ->
    '$empty' : [].
optional_type ->
    'manual' : [].
optional_type ->
    'executable' : [].

action_block ->
    '{' action_attributes '}' : '$2'.

action_attributes ->
    '$empty' : [].
action_attributes ->
    action_attribute action_attributes : '$1' ++ '$2'.

action_attribute ->
    'provides' '{' expression '}' : [].
% `requires` uses a different expression production as
% drugs are only allowed in `requires `blocks
action_attribute ->
    'requires' '{' requires_expr '}' : '$3'.
action_attribute ->
    'agent' '{' expression '}'  : [].
action_attribute ->
    'script' '{' 'string' '}'  : [].
action_attribute ->
    'tool' '{' 'string' '}'  : [].
action_attribute ->
    'input' '{' 'string' '}'  : [].
action_attribute ->
    'output' '{' 'string' '}'  : [].

requires_expr ->
    'drug' '{' 'string' '}' : extract_drug('$3').

requires_expr ->
    expression : [].

expression ->
    expr logical_combination : [].

logical_combination ->
    '&&' expr logical_combination : [].
logical_combination ->
    '||' expr logical_combination : [].
logical_combination ->
    '$empty' : [].

expr ->
    value operation : [].

operation ->
    operator value : [].
operation ->
    '$empty' : [].

value ->
    '!' expression : [].
value ->
    '(' expression ')' :[].
value ->
    'string' : [].
value ->
    'number' : [].
value ->
    variable : [].

variable ->
    identifier accessor : [].
variable ->
    prefix prefix_list accessor : [].

identifier ->
    'ident' : [].
% some of jnoll's sample pml has these keywords
% on the RHS of expressions!
identifier ->
    'manual' : [].
identifier ->
    'executable' : [].

prefix ->
    '(' ident ')' : [].

prefix_list ->
    ident : [].
prefix_list ->
    prefix prefix_list : [].
prefix_list ->
    '$empty' : [].

accessor ->
    '$empty' : [].
accessor ->
    '.' 'ident' : [].

operator ->
    '==' : [].
operator ->
    '!=' : [].
operator ->
    '<' : [].
operator ->
    '>' : [].
operator ->
    '<=' : [].
operator ->
    '>=' : [].

Erlang code.

extract_drug({_,Line,DrugStr}) ->
    Drug = strip_quotes(DrugStr),
    [{Drug, Line}].

strip_quotes(Drug) ->
    CharList = string:strip(Drug,both,$"),
    list_to_binary(CharList).

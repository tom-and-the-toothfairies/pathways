Nonterminals

pml
primitive_block
primitive_list
primitive
optional_name
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
prefix_list
prefix.

Terminals

% keywords

process
task
action
branch
selection
iteration
sequence
provides
requires
agent
script
tool
input
output
manual
executable

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
string
ident
drug
number.

Rootsymbol pml.

% Associativity of 'operator' symbols.
% Allows shift/reduce conflicts to be resolved at compile time
% See https://www.gnu.org/software/bison/manual/html_node/Shift_002fReduce.html
Nonassoc 200 '==' '!=' '||' '&&' '<' '>' '<=' '>=' '!' '.' ')'.

pml ->
    process ident primitive_block : construct('$1', [{name, value_of('$2')}], '$3').

primitive_block ->
    '{' primitive_list '}' : '$2'.

primitive_list ->
    '$empty' : [].
primitive_list ->
    primitive primitive_list : ['$1'|'$2'].

primitive ->
    branch optional_name primitive_block    : construct('$1', [{name, '$2'}], '$3').
primitive ->
    selection optional_name primitive_block : construct('$1', [{name, '$2'}], '$3').
primitive ->
    iteration optional_name primitive_block : construct('$1', [{name, '$2'}], '$3').
primitive ->
    sequence optional_name primitive_block  : construct('$1', [{name, '$2'}], '$3').
primitive ->
    task optional_name primitive_block      : construct('$1', [{name, '$2'}], '$3').
% action names are required and have a different block
% to other primitives
primitive ->
    action ident optional_type '{' action_attributes '}' : construct('$1', [{name, value_of('$2')}, {type, '$3'}], '$5').

optional_name -> '$empty' : nil.
optional_name -> ident    : value_of('$1').

optional_type -> '$empty'   : nil.
optional_type -> manual     : manual.
optional_type -> executable : executable.

action_attributes ->
    '$empty' : [].
action_attributes ->
    action_attribute action_attributes : ['$1'|'$2'].

action_attribute ->
    provides '{' expression '}'    : construct('$1', [], '$3').
% `requires` uses a different expression production as
% drugs are only allowed in `requires `blocks
action_attribute ->
    requires '{' requires_expr '}' : construct('$1', [], '$3').
action_attribute ->
    agent '{' expression '}'       : construct('$1', [], '$3').
action_attribute ->
    script '{' string '}'          : construct('$1', [], value_of('$3')).
action_attribute ->
    tool '{' string '}'            : construct('$1', [], value_of('$3')).
action_attribute ->
    input '{' string '}'           : construct('$1', [], value_of('$3')).
action_attribute ->
    output '{' string '}'          : construct('$1', [], value_of('$3')).

requires_expr ->
    drug '{' string '}'            : construct('$1', [], value_of('$3')).

requires_expr ->
    expression : '$1'.

expression -> expr logical_combination : construct(expression, [], join_with_spaces(['$1', '$2'])).

logical_combination -> '&&' expr logical_combination : join_with_spaces(["&&", '$2', '$3']).
logical_combination -> '||' expr logical_combination : join_with_spaces(["||", '$2', '$3']).
logical_combination -> '$empty'                      : "".

expr -> value operation : join_with_spaces(['$1','$2']).

operation -> operator value : join_with_spaces(['$1', '$2']).
operation -> '$empty'       : "".

value -> '!' expression     : "!" ++ value_of('$2').
value -> '(' expression ')' : "(" ++ value_of('$2') ++ ")".
value -> string             : value_of('$1').
value -> number             : value_of('$1').
value -> variable           : '$1'.

variable -> ident accessor              : value_of('$1') ++ '$2'.
variable -> prefix prefix_list accessor : join_with_spaces(['$1','$2']) ++ '$3'.

prefix -> '(' ident ')' : "(" ++ value_of('$2') ++ ")".

prefix_list -> ident              : value_of('$1').
prefix_list -> prefix prefix_list : join_with_spaces(['$1', '$2']).
prefix_list -> '$empty'           : "".

accessor -> '$empty'  : "".
accessor -> '.' ident : "." ++ value_of('$2').

operator -> '==' : "==".
operator -> '!=' : "!=".
operator -> '<'  : "<".
operator -> '>'  : ">".
operator -> '<=' : "<=".
operator -> '>=' : ">=".

Erlang code.

value_of({_, _, Value}) ->
    Value.

construct({Type, Line}, Attributes, Value) ->
    Attrs = lists:filter(fun({_,X}) -> X /= nil end, Attributes),
    {Type, [{line, Line}|Attrs], Value};
construct(Type, Attributes, Value) ->
    Attrs = lists:filter(fun({_,X}) -> X /= nil end, Attributes),
    {Type, Attrs, Value}.

join_with_spaces(Strings) ->
    NonEmpty = lists:filter(fun(X) -> X /= [] end, Strings),
    string:join(NonEmpty, " ").

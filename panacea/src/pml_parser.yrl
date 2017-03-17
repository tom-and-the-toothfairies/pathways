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
    process ident primitive_block : construct('$1', [{name, ident('$2')}], '$3').

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
    action ident optional_type '{' action_attributes '}' : construct('$1', [{name, ident('$2')}, {type, '$3'}], '$5').

optional_name -> '$empty' : nil.
optional_name -> ident : ident('$1').

optional_type -> '$empty' : nil.
optional_type -> manual : manual.
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
    script '{' string '}'          : construct('$1', [], extract_string('$3')).
action_attribute ->
    tool '{' string '}'            : construct('$1', [], extract_string('$3')).
action_attribute ->
    input '{' string '}'           : construct('$1', [], extract_string('$3')).
action_attribute ->
    output '{' string '}'          : construct('$1', [], extract_string('$3')).

requires_expr ->
    drug '{' string '}'            : construct('$1', [], extract_string('$3')).

requires_expr ->
    expression : '$1'.

expression -> expr logical_combination : function_application('$1', '$2').

logical_combination -> '&&' expr logical_combination : construct('$1', [], function_application('$2', '$3')).
logical_combination -> '||' expr logical_combination : construct('$1', [], function_application('$2', '$3')).
logical_combination -> '$empty'                      : nil.

expr -> value operation : function_application('$1', '$2').

operation -> operator value : construct('$1', [], '$2').
operation -> '$empty'       : nil.

value -> '!' expression     : {negate, [], '$2'}.
value -> '(' expression ')' : {parenthesised, [], '$2'}.
value -> string             : extract_string('$1').
value -> number             : extract_string('$1').
value -> variable           : '$1'.

variable -> ident accessor              : function_application('$1', '$2').
variable -> prefix prefix_list accessor : function_application(['$1'|'$2'], '$3').

prefix -> '(' ident ')' : {prefix, [], extract_string('$2')}.

prefix_list -> ident              : [{ident, [], extract_string('$1')}].
prefix_list -> prefix prefix_list : ['$1'|'$2'].
prefix_list -> '$empty'           : [].

accessor -> '$empty'  : nil.
accessor -> '.' ident : construct('$1', [], extract_string('$2')).

operator -> '==' : '$1'.
operator -> '!=' : '$1'.
operator -> '<'  : '$1'.
operator -> '>'  : '$1'.
operator -> '<=' : '$1'.
operator -> '>=' : '$1'.

Erlang code.

extract_string({_,_,Str}) ->
    strip_quotes(Str).

strip_quotes(Str) ->
    CharList = string:strip(Str, both, $"),
    list_to_binary(CharList).

construct({Type, Line}, Attributes, Value) ->
    Attrs = lists:filter(fun({_,X}) -> X /= nil end, Attributes),
    {Type, [{line, Line}|Attrs], Value}.

ident({ident, _, Ident}) ->
    Ident.

function_application(Arg1, nil) ->
    Arg1;
function_application(Arg1, {Func, Attrs, Arg2}) ->
    {Func, Attrs, [Arg1, Arg2]}.

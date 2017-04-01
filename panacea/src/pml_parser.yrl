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
time_expr
time_expr_list
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
time
years
days
hours
minutes
integer
float.

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
    time '{' time_expr_list '}'    : construct('$1', [], value_of_time('$3')).
requires_expr ->
    expression : '$1'.

time_expr ->
    years '{' integer '}'          : construct('$1', [], value_of('$3')).
time_expr ->
    days '{' integer '}'           : construct('$1', [], value_of('$3')).
time_expr ->
    hours '{' integer '}'          : construct('$1', [], value_of('$3')).
time_expr ->
    minutes '{' integer '}'        : construct('$1', [], value_of('$3')).

time_expr_list ->
    '$empty'                       : [].
time_expr_list ->
    time_expr time_expr_list       : ['$1'|'$2'].

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
value -> integer            : value_of('$1').
value -> float              : value_of('$1').
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

time_out_of_range_error({TimeType, [{line, Line}], Val}, MaxVal) ->
  return_error(Line, "'" ++ atom_to_list(TimeType) ++ "' cannot be more than " ++ MaxVal ++ " (was " ++ Val ++ ")").

validate_time(Time = {TimeType, _, Val}) ->
  NewVal = list_to_integer(Val),
  case TimeType of
    years when NewVal >= 100 ->
      time_out_of_range_error(Time, "99");
    days when NewVal >= 365 ->
      time_out_of_range_error(Time, "364");
    hours when NewVal >= 24 ->
      time_out_of_range_error(Time, "23");
    minutes when NewVal >= 60 ->
      time_out_of_range_error(Time, "59");
    _Else ->
      NewVal
  end.

check_times([], T) ->
  T;
check_times([Time = {TimeType, [{line, Line}], Val}|T], Accum) ->
  case maps:is_key(TimeType,Accum) of
    true ->
      return_error(Line, "'" ++ atom_to_list(TimeType) ++ "' used more than once");
    false ->
      NewVal = list_to_integer(Val),
      NewVal = validate_time(Time),
      NewAccum = maps:put(TimeType, NewVal, Accum),
      check_times(T, NewAccum)
  end.

value_of_time(TimeList) ->
  check_times(TimeList, maps:new()),
  TimeList.

value_of({integer, _, Int}) ->
  integer_to_list(Int);
value_of({float, _, Float}) ->
  float_to_list(Float);
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


Motoko
/
Language Manual
On This Page
Language quick reference
This section serves as a technical reference for the previous chapters and has specific technical information for readers with specific interests. For example, this section provides technical details of interest to the following audiences:

Authors providing the higher-level documentation about the Motoko programming language.

Compiler experts interested in the details of Motoko and its compiler.

Advanced programmers who want to learn more about the lower-level details of Motoko.

The language quick reference is intended to provide complete reference information about Motoko, but this section does not provide explanatory text or usage information. Therefore, this section is typically not suitable for readers who are new to programming languages or who are looking for a general introduction to using Motoko.

Throughout, we use the term canister to refer to an Internet Computer canister smart contract.

Basic language syntax
This section describes the basic language conventions you need to know for programming in Motoko.

Whitespace
Space, newline, horizontal tab, carriage return, line feed and form feed are considered as whitespace. Whitespace is ignored but used to separate adjacent keywords, identifiers and operators.

In the definition of some lexemes, the quick reference uses the symbol ␣ to denote a single whitespace character.

Comments
Single line comments are all characters following // until the end of the same line.

// single line comment
x = 1
Single or multi-line comments are any sequence of characters delimited by /* and */:

/* multi-line comments
   look like this, as in C and friends */
Comments delimited by /* and */ may be nested, provided the nesting is well-bracketed.

/// I'm a documentation comment
/// for a function
Documentation comments start with /// followed by a space until the end of line, and get attached to the definition immediately following them.

Deprecation comments start with /// @deprecated followed by a space until the end of line, and get attached to the definition immediately following them. They are only recognized in front of public declarations.

All comments are treated as whitespace.

Keywords
The following keywords are reserved and may not be used as identifiers:


actor and assert async async* await await* break case catch class
composite continue debug debug_show do else flexible false for
from_candid func if ignore import in module not null object or label
let loop private public query return shared stable switch system throw
to_candid true try type var while with
Identifiers
Identifiers are alpha-numeric, start with a letter and may contain underscores:

<id>   ::= Letter (Letter | Digit | _)*
Letter ::= A..Z | a..z
Digit  ::= 0..9
Integers
Integers are written as decimal or hexadecimal, Ox-prefixed natural numbers. Subsequent digits may be prefixed a single, semantically irrelevant, underscore.

digit ::= ['0'-'9']
hexdigit ::= ['0'-'9''a'-'f''A'-'F']
num ::= digit ('_'? digit)*
hexnum ::= hexdigit ('_'? hexdigit)*
nat ::= num | "0x" hexnum
Negative integers may be constructed by applying a prefix negation - operation.

Floats
Floating point literals are written in decimal or Ox-prefixed hexadecimal scientific notation.

let frac = num
let hexfrac = hexnum
let float =
    num '.' frac?
  | num ('.' frac?)? ('e' | 'E') sign? num
  | "0x" hexnum '.' hexfrac?
  | "0x" hexnum ('.' hexfrac?)? ('p' | 'P') sign? num
The 'e' (or 'E') prefixes a base 10, decimal exponent; 'p' (or 'P') prefixes a base 2, binary exponent. In both cases, the exponent is in decimal notation.

the use of decimal notation, even for the base 2 exponent, is in keeping with the established hexadecimal floating point literal syntax of the C language.

Characters
A character is a single quote (') delimited:

Unicode character in UTF-8,

\-escaped newline, carriage return, tab, single or double quotation mark

\-prefixed ASCII character (TBR),

or \u{ hexnum } enclosed valid, escaped Unicode character in hexadecimal (TBR).

ascii ::= ['\x00'-'\x7f']
ascii_no_nl ::= ['\x00'-'\x09''\x0b'-'\x7f']
utf8cont ::= ['\x80'-'\xbf']
utf8enc ::=
    ['\xc2'-'\xdf'] utf8cont
  | ['\xe0'] ['\xa0'-'\xbf'] utf8cont
  | ['\xed'] ['\x80'-'\x9f'] utf8cont
  | ['\xe1'-'\xec''\xee'-'\xef'] utf8cont utf8cont
  | ['\xf0'] ['\x90'-'\xbf'] utf8cont utf8cont
  | ['\xf4'] ['\x80'-'\x8f'] utf8cont utf8cont
  | ['\xf1'-'\xf3'] utf8cont utf8cont utf8cont
utf8 ::= ascii | utf8enc
utf8_no_nl ::= ascii_no_nl | utf8enc

escape ::= ['n''r''t''\\''\'''\"']

character ::=
  | [^'"''\\''\x00'-'\x1f''\x7f'-'\xff']
  | utf8enc
  | '\\'escape
  | '\\'hexdigit hexdigit
  | "\\u{" hexnum '}'
  | '\n'        // literal newline

char := '\'' character '\''
Text
A text literal is "-delimited sequence of characters:

text ::= '"' character* '"'
Note that a text literal may span multiple lines.

Literals
<lit> ::=                                     literals
  <nat>                                         natural
  <float>                                       float
  <char>                                        character
  <text>                                        Unicode text
Literals are constant values. The syntactic validity of a literal depends on the precision of the type at which it is used.

Operators and types
To simplify the presentation of available operators, operators and primitive types are classified into basic categories:

Abbreviation	Category	Supported opertions
A	Arithmetic	arithmetic operations
L	Logical	logical/Boolean operations
B	Bitwise	bitwise and wrapping operations
O	Ordered	comparison
T	Text	concatenation
Some types have several categories. For example, type Int is both arithmetic (A) and ordered (O) and supports both arithmetic addition (+) and relational less than (<) (amongst other operations).

Unary operators
<unop>	Category	
-	A	numeric negation
+	A	numeric identity
^	B	bitwise negation
Relational operators
<relop>	Category	
==		equals
!=		not equals
␣<␣	O	less than (must be enclosed in whitespace)
␣>␣	O	greater than (must be enclosed in whitespace)
<=	O	less than or equal
>=	O	greater than or equal
Note that equality (==) and inequality (!=) do not have categories. Instead, equality and inequality are applicable to arguments of all shared types, including non-primitive, compound types such as immutable arrays, records, and variants.

Equality and inequality are structural and based on the observable content of their operands (as determined by their static type).

Numeric binary operators
<binop>	Category	
+	A	addition
-	A	subtraction
*	A	multiplication
/	A	division
%	A	modulo
**	A	exponentiation
Bitwise and wrapping binary operators
<binop>	Category	
&	B	bitwise and
\|	B	bitwise or
^	B	exclusive or
<<	B	shift left
␣>>	B	shift right (must be preceded by whitespace)
<<>	B	rotate left
<>>	B	rotate right
+%	A	addition (wrap-on-overflow)
-%	A	subtraction (wrap-on-overflow)
*%	A	multiplication (wrap-on-overflow)
**%	A	exponentiation (wrap-on-overflow)
Text operators
<binop>	Category	
#	T	concatenation
Assignment operators
:=, <unop>=, <binop>=	Category	
:=	*	assignment (in place update)
+=	A	in place add
-=	A	in place subtract
*=	A	in place multiply
/=	A	in place divide
%=	A	in place modulo
**=	A	in place exponentiation
&=	B	in place logical and
\|=	B	in place logical or
^=	B	in place exclusive or
<<=	B	in place shift left
>>=	B	in place shift right
<<>=	B	in place rotate left
<>>=	B	in place rotate right
+%=	B	in place add (wrap-on-overflow)
-%=	B	in place subtract (wrap-on-overflow)
*%=	B	in place multiply (wrap-on-overflow)
**%=	B	in place exponentiation (wrap-on-overflow)
#=	T	in place concatenation
The category of a compound assignment <unop>=/<binop>= is given by the category of the operator <unop>/<binop>.

Operator and keyword precedence
The following table defines the relative precedence and associativity of operators and tokens, ordered from lowest to highest precedence. Tokens on the same line have equal precedence with the indicated associativity.

Precedence	Associativity	Token
LOWEST	none	if _ _ (no else), loop _ (no while)
(higher)	none	else, while
(higher)	right	:=, +=, -=, *=, /=, %=, **=, #=, &=, \|=, ^=, <<=, >>=, <<>=, <>>=, +%=, -%=, *%=, **%=
(higher)	left	:
(higher)	left	`
(higher)	left	or
(higher)	left	and
(higher)	none	==, !=, <, >, <=, >, >=
(higher)	left	+, -, #, +%, -%
(higher)	left	*, /, %, *%
(higher)	left	\|
(higher)	left	&
(higher)	left	^
(higher)	none	<<, >>, <<>, <>>
HIGHEST	left	**, **%
Programs
The syntax of a program <prog> is as follows:

<prog> ::=             programs
  <imp>;* <dec>;*
A program is a sequence of imports <imp>;* followed by a sequence of declarations <dec>;* that ends with an optional actor or actor class declaration. The actor or actor class declaration determines the main actor, if any, of the program.

For now, compiled programs must obey the following additional restrictions (not imposed on interpreted programs):

a shared function can only appear as a public field of an actor or actor class;

a program may contain at most one actor or actor class declaration, i.e. the final main actor or actor class; and

any main actor class declaration should be anonymous; if named, the class name should not be used as a value within the class and will be reported as an unavailable identifier.

The last two restrictions are designed to forbid programmatic actor class recursion, pending compiler support.

Note that the parameters (if any) of an actor class must have shared type (see Sharability). The parameters of a program’s final actor class provide access to the corresponding canister installation argument(s); the Candid type of this argument is determined by the Candid projection of the Motoko type of the class parameter.

Imports
The syntax of an import <imp> is as follows:

<imp> ::=                           imports
  import <pat> =? <url>

<url> ::=
  "<filepath>"                      import module from relative <filepath>.mo
  "mo:<package-name>/<filepath>"    import module from package
  "canister:<canisterid>"           import external actor by <canisterid>
  "canister:<name>"                 import external actor by <name>
An import introduces a resource referring to a local source module, module from a package of modules, or canister (imported as an actor). The contents of the resource are bound to <pat>.

Though typically a simple identifier, <id>, <pat> can also be any composite pattern binding selective components of the resource.

The pattern must be irrefutable.

Libraries
The syntax of a library (that can be referenced in an import) is as follows:

<lib> ::=                                               library
  <imp>;* module <id>? <obj-body>                         module
  <imp>;* <shared-pat>? actor class                       actor class
    <id> <typ-params>? <pat> (: <typ>)? <class-body>
A library <lib> is a sequence of imports <imp>;* followed by:

a named or anonymous (module) declaration; or

a named actor class declaration.

Libraries stored in .mo files may be referenced by import declarations.

In a module library, the optional name <id>? is only significant within the library and does not determine the name of the library when imported. Instead, the imported name of a library is determined by the import declaration, giving clients of the library the freedom to choose library names (e.g. to avoid clashes).

An actor class library, because it defines both a type constructor and a function with name <id>, is imported as a module defining both a type and a function named <id>. The name <id> is mandatory and cannot be omitted. An actor class constructor is always asynchronous, with return type async T where T is the inferred type of the class body. Because actor construction is asynchronous, an instance of an imported actor class can only be created in an asynchronous context (i.e. in the body of a (non-query) shared function, asynchronous function, async expression or async* expression).

Declaration syntax
The syntax of a declaration is as follows:

<dec> ::=                                                               declaration
  <exp>                                                                  expression
  let <pat> = <exp>                                                      immutable, trap on match failure
  let <pat> = <exp> else <block-or-exp>                                  immutable, handle match failure
  var <id> (: <typ>)? = <exp>                                            mutable
  <sort> <id>? =? <obj-body>                                             object
  <shared-pat>? func <id>? <typ-params>? <pat> (: <typ>)? =? <exp>       function
  type <id> <typ-params>? = <typ>                                        type
  <shared-pat>? <sort>? class                                            class
    <id>? <typ-params>? <pat> (: <typ>)? <class-body>

<obj-body> ::=           object body
  { <dec-field>;* }       field declarations

<class-body> ::=         class body
  = <id>? <obj-body>     object body, optionally binding <id> to 'this' instance
  <obj-body>             object body
The syntax of a shared function qualifier with call-context pattern is as follows:

<query> ::=
 composite? query

<shared-pat> ::=
  shared <query>? <pat>?
For <shared-pat>, an absent <pat>? is shorthand for the wildcard pattern _.

<dec-field> ::=                                object declaration fields
  <vis>? <stab>? <dec>                           field

<vis> ::=                                      field visibility
  public
  private
  system

<stab> ::=                                     field stability (actor only)
  stable
  flexible
The visibility qualifier <vis>? determines the accessibility of every field <id> declared by <dec>:

An absent <vis>? qualifier defaults to private visibility.

Visibility private restricts access to <id> to the enclosing object, module or actor.

Visibility public extends private with external access to <id> using the dot notation <exp>.<id>.

Visibility system extends private with access by the run-time system.

Visibility system may only appear on func declarations that are actor fields, and must not appear anywhere else.

The stability qualifier <stab> determines the upgrade behaviour of actor fields:

A stability qualifier should appear on let and var declarations that are actor fields. An absent stability qualifier defaults to flexible.

<stab> qualifiers must not appear on fields of objects or modules.

The pattern in a stable let <pat> = <exp> declaration must be simple where, a pattern pat is simple if it (recursively) consists of

a variable pattern <id>, or

an annotated simple pattern <pat> : <typ>, or

a parenthesized simple pattern ( <pat> ).

Expression syntax
The syntax of an expression is as follows:

<exp> ::=                                      expressions
  <id>                                           variable
  <lit>                                          literal
  <unop> <exp>                                   unary operator
  <exp> <binop> <exp>                            binary operator
  <exp> <relop> <exp>                            binary relational operator
  _                                              placeholder expression
  <exp> |> <exp>                                 pipe operator
  ( <exp>,* )                                    tuple
  <exp> . <nat>                                  tuple projection
  ? <exp>                                        option injection
  { <exp-field>;* }                              object
  { <exp> (and <exp>)* (with <exp-field>;+)? }   object combination/extension
  # id <exp>?                                    variant injection
  <exp> . <id>                                   object projection/member access
  <exp> := <exp>                                 assignment
  <unop>= <exp>                                  unary update
  <exp> <binop>= <exp>                           binary update
  [ var? <exp>,* ]                               array
  <exp> [ <exp> ]                                array indexing
  <shared-pat>? func <func_exp>                  function expression
  <exp> <typ-args>? <exp>                        function call
  not <exp>                                      negation
  <exp> and <exp>                                conjunction
  <exp> or <exp>                                 disjunction
  if <exp> <block-or-exp> (else <block-or-exp>)? conditional
  switch <exp> { (case <pat> <block-or-exp>;)+ } switch
  while <exp> <block-or-exp>                     while loop
  loop <block-or-exp> (while <exp>)?             loop
  for ( <pat> in <exp> ) <block-or-exp>          iteration
  label <id> (: <typ>)? <block-or-exp>           label
  break <id> <exp>?                              break
  continue <id>                                  continue
  return <exp>?                                  return
  async <block-or-exp>                           async expression
  await <block-or-exp>                           await future (only in async)
  async* <block-or-exp>                          delay an asynchronous computation
  await* <block-or-exp>                          await a delayed computation (only in async)
  throw <exp>                                    raise an error (only in async)
  try <block-or-exp> catch <pat> <block-or-exp>  catch an error (only in async)
  assert <block-or-exp>                          assertion
  <exp> : <typ>                                  type annotation
  <dec>                                          declaration
  ignore <block-or-exp>                          ignore value
  do <block>                                     block as expression
  do ? <block>                                   option block
  <exp> !                                        null break
  debug <block-or-exp>                           debug expression
  actor <exp>                                    actor reference
  to_candid ( <exp>,* )                          Candid serialization
  from_candid <exp>                              Candid deserialization
  (system <exp> . <id>)                          System actor class constructor
  ( <exp> )                                      parentheses

<block-or-exp> ::=
  <block>
  <exp>

<block> ::=
  { <dec>;* }
Patterns
The syntax of a pattern is as follows:

<pat> ::=                                      patterns
  _                                              wildcard
  <id>                                           variable
  <unop>? <lit>                                  literal
  ( <pat>,* )                                    tuple or brackets
  { <pat-field>;* }                              object pattern
  # <id> <pat>?                                  variant pattern
  ? <pat>                                        option
  <pat> : <typ>                                  type annotation
  <pat> or <pat>                                 disjunctive pattern

<pat-field> ::=                                object pattern fields
  <id> (: <typ>) = <pat>                         field
  <id> (: <typ>)                                 punned field
Type syntax
Type expressions are used to specify the types of arguments, constraints (a.k.a bounds) on type parameters, definitions of type constructors, and the types of sub-expressions in type annotations.

<typ> ::=                                     type expressions
  <path> <typ-args>?                            constructor
  <sort>? { <typ-field>;* }                     object
  { <typ-tag>;* }                               variant
  { # }                                         empty variant
  [ var? <typ> ]                                array
  Null                                          null type
  ? <typ>                                       option
  <shared>? <typ-params>? <typ> -> <typ>        function
  async <typ>                                   future
  async* <typ>                                  delayed, asynchronous computation
  ( ((<id> :)? <typ>),* )                       tuple
  Any                                           top
  None                                          bottom
  <typ> and <typ>                               intersection
  <typ> or <typ>                                union
  Error                                         errors/exceptions
  ( <typ> )                                      parenthesized type

<sort> ::= (actor | module | object)

<shared> ::=                                 shared function type qualifier
  shared <query>?

<path> ::=                                   paths
  <id>                                         type identifier
  <path> . <id>                                projection
An absent <sort>? abbreviates object.
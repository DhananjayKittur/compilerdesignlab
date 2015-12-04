/*Testing first input*/
/*Waiting for the function declaration in the blocking statement below.
  Find a way to insert multiple statements that is what is needed here.*/
%{
	#include <stdio.h>	
	#include <string.h>
%}

%union {
	int i;
	char* s;
	float f;
}

/*Declare Tokens*/
%token KEYWORD IDENTIFIER COLON TYPE SWIZZLE SEMICOLON QUALIFIER EQUAL INT FLOAT LPARENTHESIS RPARENTHESIS
%token LBRACE RBRACE RETURN_KEY LT GT IF ELSE COMMA STATE SHADER_DEF WHILE FOR INC DEC MUL DIV ADD SUB
%token COLOR POW DOT SQRT HIT INVERSE PERPENDICULAR DOMINANTAXIS TRACE LUMINANCE RAND MIN MAX
%token ILLUMINANCE AMBIENT GE LE
%token EOL

%%
program: parse
	| program parse
	;
parse:  stmt
	| shader_def
	| function_def
	| decl
	| decl_qualifier
	;
shader_def: class_def SHADER_DEF SEMICOLON { printf("SHADER_DEF %s\n", yylval.s);}
class_def: KEYWORD id COLON
decl_qualifier: QUALIFIER deftype SEMICOLON { printf("DECLARATION\n");}
	| deftype EQUAL val SEMICOLON { printf("DECLARATION\n"); }
	| deftype EQUAL STATE SEMICOLON  { printf("DECLARATION\n"); }
	;
decl: deftype SEMICOLON { printf("DECLARATION\n");}
	| deftype EQUAL func_call SEMICOLON { printf("DECLARATION\n"); }
	| deftype EQUAL id SEMICOLON  { printf("DECLARATION\n"); }
	| deftype EQUAL type_with_initializers LPARENTHESIS param_list RPARENTHESIS  { printf("DECLARATION\n"); }
	| deftype EQUAL equation SEMICOLON { printf("DECLARATION\n"); }
	;
stmt: assignment SEMICOLON { printf("STATEMENT\n");}
	| func_stmt SEMICOLON { printf("STATEMENT\n");}
	| return_statement SEMICOLON { printf("STATEMENT\n"); }
	| if_statement { printf("STATEMENT\n");}
	| block { printf("STATEMENT\n"); }
	| while_loop { printf("STATEMENT\n");}
	| for_loop { printf("STATEMENT\n");}
	;
assignment: assign val
	| assign id
	| assign equation
	| assign binary_math_ops id
	;

binary_math_ops: MUL
	| DIV
	| ADD
	| SUB
	;

equation:
	param_type binary_math_ops param_type
	| param_type binary_math_ops parenthesis_equation
	| parenthesis_equation
	| equation binary_math_ops param_type
	| equation binary_math_ops parenthesis_equation
	;
parenthesis_equation:
	LPARENTHESIS equation RPARENTHESIS
	;
assign: 
	STATE EQUAL
	| id EQUAL
	;
deftype: TYPE id
	| type_with_initializers id
	;
type_with_initializers:
	COLOR
	;
func_stmt:
	assign func_call
	| func_call
	;
func_call: id LPARENTHESIS param_list RPARENTHESIS
	| type_with_initializers LPARENTHESIS param_list RPARENTHESIS
	| keyword_func LPARENTHESIS param_list RPARENTHESIS
	;
keyword_func: 
	POW
	| DOT
	| SQRT
	| TRACE
	;
param_list:
	| param_type
	| STATE
	| equation
	| param_list COMMA param_type
	| param_list COMMA equation
	| param_list COMMA STATE
	;
param_type:
	val
	| id
	| func_call
	;
function_def: deftype arg_list block { printf("FUNCTION_DEF\n");}
	;
args: 
	| deftype
	| equation
	| args COMMA deftype
	;
arg_list: LPARENTHESIS args RPARENTHESIS
	;
block: LBRACE code_block RBRACE
	;
code_block:
	| code_block stmt
	| code_block decl
	| code_block decl_qualifier
	;
val: INT
	| FLOAT
	;
id : IDENTIFIER
	;
return_statement: RETURN_KEY val
	| RETURN_KEY id
	;
if_statement: 
	IF bool_ops stmt { printf("IF\n");}
	| IF bool_ops stmt ELSE stmt { printf("IF - ELSE\n"); }
	;
while_loop: WHILE bool_ops stmt
	;
for_loop: FOR for_condition stmt
	;
for_condition:
	LPARENTHESIS assignment SEMICOLON bool_val SEMICOLON unary_ops RPARENTHESIS
	;
bool_ops:
	LPARENTHESIS bool_val RPARENTHESIS
	;
bool_val:
	id LT INT
	| id GT INT
	| id GE FLOAT
	| id LE FLOAT
	| id
	| func_call LT FLOAT
	| func_call GT FLOAT
	;
unary_ops:
	INC id
	| id INC
	| DEC id
	| id DEC
	;
%%

main(int argc, char **argv)
{
  yyparse();
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}

int yywrap(void) { }


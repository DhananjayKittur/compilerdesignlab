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
%token LBRACE RBRACE RETURN_KEY LT IF ELSE COMMA STATE
%token EOL

%%
program: parse
	| program parse
	;
parse: decl
	| stmt
	| shader_def
	| function_def
	;
shader_def: class_def TYPE SEMICOLON { printf("SHADER_DEF\n");}
class_def: KEYWORD id COLON
decl: deftype SEMICOLON { printf("DECLARATION\n");}
	;
stmt: expr SEMICOLON { printf("STATEMENT\n");}
	| func_stmt SEMICOLON { printf("STATEMENT\n");}
	| return_statement SEMICOLON { printf("STATEMENT\n"); }
	;
expr: assign val
	;
assign: 
	STATE EQUAL
	| id EQUAL
	;
deftype: TYPE id
	;
func_stmt:
	assign func_call
	| func_call
	;
func_call: id LPARENTHESIS param_list RPARENTHESIS
	;
param_list:
	| param_type
	| param_list COMMA param_type
	;
param_type:
	val
	| id
	;
function_def: deftype arg_list block { printf("FUNCTION_DEF\n");}
	;
args: 
	| deftype
	| args COMMA deftype
	;
arg_list: LPARENTHESIS args RPARENTHESIS
	;
block: LBRACE code_block RBRACE
	;
code_block: 
	| code_block stmt
	| code_block decl
	| code_block if_statement
	;
val: INT
	| FLOAT
	;
id : IDENTIFIER {}
	;
return_statement: RETURN_KEY val
	| RETURN_KEY id
	;
if_statement: 
	IF bool_ops stmt
	| IF bool_ops stmt ELSE stmt { printf("IF - ELSE\n"); }
	;
bool_ops:
	LPARENTHESIS id LT INT RPARENTHESIS
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


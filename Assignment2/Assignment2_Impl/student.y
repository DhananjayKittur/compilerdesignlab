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
%token LBRACE RBRACE RETURN_KEY LT IF ELSE COMMA STATE SHADER_DEF
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
	;
decl: deftype SEMICOLON { printf("DECLARATION\n");}
	;
stmt: expr SEMICOLON { printf("STATEMENT\n");}
	| func_stmt SEMICOLON { printf("STATEMENT\n");}
	| return_statement SEMICOLON { printf("STATEMENT\n"); }
	| if_statement { printf("STATEMENT\n");}
	;
expr: assign val
	| assign id
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
	| LPARENTHESIS id RPARENTHESIS
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


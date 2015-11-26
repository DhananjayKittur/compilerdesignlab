/*Testing first input*/
%{
	#include <stdio.h>	
	#include <string.h>
%}

/*Declare Tokens*/
%token KEYWORD IDENTIFIER COLON TYPE SWIZZLE SEMICOLON QUALIFIER
%token EOL

%%
SHADER_DEF:
		| KEYWORD IDENTIFIER COLON TYPE SEMICOLON { printf("SHADER_DEF %s", $4);}
		;
%%

main(int argc, char **argv)
{
  //yyin = fopen(argv[1],’r’);
  yyparse();
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}

int yywrap(void) { }


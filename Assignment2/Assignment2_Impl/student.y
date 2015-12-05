/*Testing first input*/
/*Waiting for the function declaration in the blocking statement below.
  Find a way to insert multiple statements that is what is needed here.*/
%{
	#include <stdio.h>	
	#include <string.h>
	char *shader_type;
	char *camera_methods[] = {"constructor","generateRay"};
	char *primitive_methods[] = {"constructor","intersect","computeBounds","computeNormal","computeTextureCoordinates","computeDerivatives","generateSample","samplePDF"};
	char *texture_methods[] = {"constructor","lookup"};
	char *material_methods[] = {"constructor","shade","BSDF","sampleBSDF","evaluatePDF","emission"};
	char *light_methods[] = {"constructor","illumination"};
	static void verify_method(char* str);
	static char* find_shader_type(char* method);

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
%token ILLUMINANCE AMBIENT GE LE METHOD VEC3
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
shader_def: class_def SHADER_DEF SEMICOLON { shader_type = yylval.s; printf("SHADER_DEF %s\n", yylval.s);}
class_def: KEYWORD id COLON
decl_qualifier: QUALIFIER deftype SEMICOLON { printf("DECLARATION\n");}
	| deftype EQUAL val SEMICOLON { printf("DECLARATION\n"); }
	| deftype EQUAL STATE SEMICOLON  { printf("DECLARATION\n"); }
	| deftype EQUAL binary_math_ops equation SEMICOLON{ printf("DECLARATION\n"); }
	| deftype EQUAL equation SEMICOLON{ printf("DECLARATION\n"); }
	;
decl: deftype SEMICOLON { printf("DECLARATION\n");}
	| deftype EQUAL func_call SEMICOLON { printf("DECLARATION\n"); }
	| deftype EQUAL id SEMICOLON  { printf("DECLARATION\n"); }
	| deftype EQUAL type_with_initializers LPARENTHESIS param_list RPARENTHESIS  { printf("DECLARATION\n"); }
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
	| assign binary_math_ops equation
	| assign STATE
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
	| VEC3
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
	| HIT
	;
param_list:
	| param_type
	| equation
	| param_list COMMA param_type
	| param_list COMMA equation
	;
param_type:
	val
	| id
	| func_call
	| STATE
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
	| METHOD { verify_method(yylval.s); }
	| SWIZZLE
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
	param_type comparator param_type
	| id
	;
comparator:
	LT 
	| GT
	| GE
	| LE
	;
unary_ops:
	INC id
	| id INC
	| DEC id
	| id DEC
	;
%%


static void verify_method(char* method) {
	char **method_type;
	int size=0, i;

	if( !strcmp( shader_type, "camera") ) {
		method_type = camera_methods;
		size = 2;
	} else if( !strcmp( shader_type, "primitive") ) {
		method_type = primitive_methods;
		size = 8;
	} else if( !strcmp( shader_type, "texture") ) {
		method_type = texture_methods;
		size = 2;
	} else if( !strcmp( shader_type, "material") ) {
		method_type = material_methods;
		size = 6;	
	} else if( !strcmp( shader_type, "light") ) {
		method_type = light_methods;
		size = 2;	
	} else {
		yyerror("Shader Definition Not found!!!");

		return;
	}
	for( i=0; i<size; i++ ) {
		if( !strcmp(method_type[i], method) ) {
			return;
		}
	}
	char a[100];
	char *shader_found = find_shader_type(method);
	//Search for it in another shader type
	sprintf(a, "%s cannot have an interface method of %s", shader_type, shader_found );
	yyerror(a);
}

static char* find_shader_type(char* method) {
	int i;

	for( i=0; i<sizeof(camera_methods)/sizeof(camera_methods[0]); i++ ) {
		if( !strcmp(method, camera_methods[i]))
			return "camera";
	}
	for( i=0; i<sizeof(primitive_methods)/sizeof(primitive_methods[0]); i++ ) {
		if( !strcmp(method, primitive_methods[i]))
			return "primitive";
	}
	for( i=0; i<sizeof(texture_methods)/sizeof(texture_methods[0]); i++ ) {
		if( !strcmp(method, texture_methods[i]))
			return "texture";
	}
	for( i=0; i<sizeof(material_methods)/sizeof(material_methods[0]); i++ ) {
		if( !strcmp(method, material_methods[i]))
			return "material";
	}
	for( i=0; i<sizeof(light_methods)/sizeof(light_methods[0]); i++ ) {
		if( !strcmp(method, light_methods[i]))
			return "light";
	}

	return NULL;
}

main(int argc, char **argv)
{
  yyparse();
}

yyerror(char *s)
{
  fprintf(stderr, "Error: %s\n", s);
}

int yywrap(void) { }


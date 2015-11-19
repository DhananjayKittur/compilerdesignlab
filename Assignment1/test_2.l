/******************************** Lab Assignment 1*******************************************
    *************Members: Niroj Pokhrel, Logesh, Dhananjay Kittur ***************************
    **************Git Repo: https://bitbucket.org/nirojpokhrel/compilerdesignlab **************/
/******************************** Confusion: *******************************************            
 ** 1. What is inside ? Used in file as identifier but is mentioned as KEYWORD in the pdf. Are we suppose to give error here ?***
 ** 2. What if some random string is encountered abcdef ? Should we identify it as an INDENTIFIER or report an error for undefined string ?*
 ** 3. Should we use c type naming conventions with underscore ? **/
%option noyywrap
%{
#include <stdio.h> 
int num_lines = 0;
%}
%x C_COMMENT
    
DIGIT    [0-9]
ID       [a-zA-Z_][A-Za-z0-9_]*
KEYWORD	 break|case|const|continue|default|do|double|else|enum|extern|for|goto|if|sizeof|static|struct|switch|typedef|union|unsigned|while|class|dot|sqrt|hit|inverse|perpendicular|dominantAxis|trace|hit|luminance|rand|pow|min|max|illuminance|ambient
/*Is inside Keyword ?? But is used as identifier in dieletric_material.rtsl*/

TYPE int|float|bool|vec2|vec3|vec4|ivec2|ivec3|ivec4|bvec2|bvec3|bvec4|rt_Primitive|rt_Camera|rt_Material|rt_Texture|rt_Light|void
QUALIFIER attribute|uniform|varying|const|public|private|scratch|void|color

IDENTIFIER constructor|generateRay|intersect|computeBounds|computeNormal|computeTextureCoordinates|computeDerivatives|generateSample|samplePDF|lookup|shade|BSDF|sampleBSDF|evaluatePDF|emission|illumination|Sphere|center|radius|newcenter|newradius|A|B|D|O|disc|C|r|t0|t1|eta|f0|absorption|inside|outside|absorb|I|P|NN|eta_temp|atten|negNdotV|k|R|T|Fr|Ft|refl_result|refr_result|SchlickDielectric|normalize|reflect|PinholeCamera|position|lower_left_corner|uvw_u|uvw_v|uvw_w|eye|up|gaze|uv0|uv1|d|cross
/*Is normalize and reflect and cross Identifier or keyword? I feel they are identifier but be sure. */


STATE RayOrigin|RayDirection|InverseRayDirectionEpsilon|HitDistance|ScreenCoord|LensCoord|du|dv|TimeSeedvec3|InverseRayDirection|Epsilon|BoundMin|BoundMax|GeometricNormal|ShadingNormal|TextureUV|TextureUVW|dsdu|dsdv|PDF|TimeSeed|TextureColor|FloatTextureValue|dtdu|dtdv|dPdu|dPdv|HitPoint|LightDirection|LightDistance|LightColor|EmissionColor|BSDFSeed|PDF|SampleColor|BSDFValue

%%
"+" { printf( "PLUS\n" ); }
"-" { printf( "MINUS\n" ); }
"*"	{ printf( "MUL\n" ); }
"/"	{ printf( "DIV\n" ); }
"="	{ printf( "ASSIGN\n" ); }
"=="	{ printf( "EQUAL\n" ); }
"!="	{ printf( "NOT_EQUAL\n" ); }
"<" { printf( "LT\n" ); }
">"	{ printf( "GT\n" ); }
">="	{ printf( "GE\n" ); }
"<="	{ printf( "LE\n" ); }
","	{ printf( "COMMA\n" ); }
"&&"	{ printf( "AND\n" ); }
"||"	{ printf( "OR\n" ); }
"++"	{ printf( "INC\n" ); }
"--"	{ printf( "DEC\n" ); }
":"	{ printf( "COLON\n" ); }
";"	{ printf( "SEMICOLON\n" ); }
"("	{ printf( "LPARENTHESIS\n" ); }
")"	{ printf( "RPARENTHESIS\n" ); }
"{"	{ printf( "LBRACE\n" ); }
"}"	{ printf( "RBRACE\n" ); }
"["	{ printf( "LBRACKET\n" ); }
"]"	{ printf( "RBRACKET\n" ); }

{DIGIT}+	{ printf( "INT %s\n", yytext ); }
     
{DIGIT}+"."{DIGIT}*	{ printf( "FLOAT %s\n", yytext); }
({DIGIT}+|({DIGIT}+"."{DIGIT}+))E{DIGIT}+ printf("EXP %s\n", yytext);
     
{KEYWORD} { printf( "KEYWORD %s\n", yytext ); }
{TYPE} { printf( "TYPE %s\n", yytext ); }
{QUALIFIER} { printf( "QUALIFIER %s\n", yytext ); }
rt_{STATE} { printf( "STATE %s\n", yytext ); }     
{ID} { printf("IDENTIFIER %s\n", yytext ); }
"."{ID} {printf("SWIZZLE %s\n", (char*)&yytext[1]);}
     
\n	++num_lines;
[ \t]+	/* eat up whitespace */
<INITIAL>{
     "/*"              BEGIN(C_COMMENT);
     }
     <C_COMMENT>{
     "*/"      BEGIN(INITIAL);
     [^*\n]+   // eat comment in chunks
     "*"       // eat the lone star
     \n        yylineno++; num_lines++;
     }
"//".*\n  num_lines++;
\r	//Recognizing carriage return I don't know why ???
.	{printf("Error(%d): Unrecognized symbol %s\n", num_lines+1, yytext ); }

%%
     
int main()
{
  yylex();
  return 0;
}


/******************************** Lab Assignment 2*******************************************
  **Members: Niroj Pokhrel (376630), Logesh Soma Sundaram(376635), , Dhananjaya Kumara Kittur Gonibasappa(376629)**************
    ****************************/
%option noyywrap
%{
#include "student.yy.h" 
int num_lines = 0;
%}
%x C_COMMENT
    
DIGIT    [0-9]
ID       [a-zA-Z_][A-Za-z0-9_]*
KEYWORD	 break|case|const|continue|default|do|double|else|enum|extern|for|goto|if|sizeof|static|struct|switch|typedef|union|unsigned|while|class|dot|sqrt|hit|inverse|perpendicular|dominantAxis|trace|hit|luminance|rand|pow|min|max|illuminance|ambient

TYPE int|float|bool|vec2|vec3|vec4|ivec2|ivec3|ivec4|bvec2|bvec3|bvec4|rt_Primitive|rt_Camera|rt_Material|rt_Texture|rt_Light|void
QUALIFIER attribute|uniform|varying|const|public|private|scratch|void
/*color should be a qualifier but is used as a function call in test1.rtsl ??? why ???*/

STATE RayOrigin|RayDirection|InverseRayDirectionEpsilon|HitDistance|ScreenCoord|LensCoord|du|dv|TimeSeedvec3|InverseRayDirection|Epsilon|BoundMin|BoundMax|GeometricNormal|ShadingNormal|TextureUV|TextureUVW|dsdu|dsdv|PDF|TimeSeed|TextureColor|FloatTextureValue|dtdu|dtdv|dPdu|dPdv|HitPoint|LightDirection|LightDistance|LightColor|EmissionColor|BSDFSeed|PDF|SampleColor|BSDFValue

METHODS constructor|generateRay|intersect|computeBounds|computeNormal|computeTextureCoordinates|computeDerivatives|generateSample|samplePDF|lookup|shade|BSDF|sampleBSDF|evaluatePDF|emission|illumination

%%  

":" { return COLON; }
";"	{ return SEMICOLON; }
"=" { return EQUAL; }
"("	{ return LPARENTHESIS; }
")"	{ return RPARENTHESIS; }
"{"	{ return LBRACE; }
"}"	{ return RBRACE; }
"<" { return LT; }
">" { return GT; }
">=" { return GE; }
"<=" { return LE; }
"," { return COMMA; }
"+=" { return EQUAL; }
"+"	{ return MUL; }
"-"	{ return DIV; }
"*"	{ return MUL; }
"/"	{ return DIV; }

return { return RETURN_KEY; }
rt_Primitive { yylval.s = "primitive"; return SHADER_DEF;}
rt_Camera { yylval.s = "camera"; return SHADER_DEF;}
rt_Material { yylval.s = "material"; return SHADER_DEF;}
rt_Texture { yylval.s = "texture"; return SHADER_DEF;}
rt_Light { yylval.s = "light"; return SHADER_DEF;}
if { return IF; }
else { return ELSE; }
while { return WHILE; }
for { return FOR; }
dot { return DOT; }
pow { return POW; }
sqrt { return SQRT; }
hit { return HIT; }
inverse { return INVERSE; }
perpendicular { return PERPENDICULAR; }
dominantAxis { return DOMINANTAXIS; }
trace { return TRACE; }
luminance { return LUMINANCE; }
rand { return RAND; }
min { return MIN; }
max { return MAX; }
illuminance { return ILLUMINANCE; }
ambient { return AMBIENT; }


color { return COLOR; }
vec3 { return VEC3; }

{KEYWORD} {  return KEYWORD; }
rt_{STATE} { yylval.s = yytext; return STATE; }  
{METHODS} { yylval.s = yytext; return METHOD; }   
{TYPE} { yylval.s = ((char*)&yytext[3]); return TYPE; }
{QUALIFIER} { return QUALIFIER; }  
{ID} { return IDENTIFIER; }
{ID}"."{ID}|{STATE}"."{ID} { return SWIZZLE;}
"++"	{ return INC; }
"--"	{ return DEC; }

{DIGIT}+	{ yylval.i = atoi(yytext); return INT; }
{DIGIT}*"."{DIGIT}+|{DIGIT}+"."{DIGIT}*	{ yylval.f = atof(yytext); return FLOAT; }
     
\n	++num_lines;
[ \t]+	/* eat up whitespace */
<INITIAL>{
     "/*"              BEGIN(C_COMMENT);
     }
     <C_COMMENT>{
     "*/"      BEGIN(INITIAL);
     [^*\n]+   
     \n        num_lines++;
     }
"//".*\n  num_lines++;
\r	//Recognizing carriage return I don't know why ???
.	{printf("Error(%d): Unrecognized symbol %s\n", num_lines+1, yytext ); }

%%


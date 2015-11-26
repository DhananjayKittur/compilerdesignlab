/******************************** Lab Assignment 2*******************************************
    *************Members: Niroj Pokhrel, Logesh, Dhananjay Kittur ***************************
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
/*Is inside Keyword ?? But is used as identifier in dieletric_material.rtsl*/

TYPE int|float|bool|vec2|vec3|vec4|ivec2|ivec3|ivec4|bvec2|bvec3|bvec4|rt_Primitive|rt_Camera|rt_Material|rt_Texture|rt_Light|void
QUALIFIER attribute|uniform|varying|const|public|private|scratch|void|color

STATE RayOrigin|RayDirection|InverseRayDirectionEpsilon|HitDistance|ScreenCoord|LensCoord|du|dv|TimeSeedvec3|InverseRayDirection|Epsilon|BoundMin|BoundMax|GeometricNormal|ShadingNormal|TextureUV|TextureUVW|dsdu|dsdv|PDF|TimeSeed|TextureColor|FloatTextureValue|dtdu|dtdv|dPdu|dPdv|HitPoint|LightDirection|LightDistance|LightColor|EmissionColor|BSDFSeed|PDF|SampleColor|BSDFValue

%%  

":" { return COLON; }
";"	{ return SEMICOLON; }
{KEYWORD} {  return KEYWORD; }
{TYPE} { yylval = yytext; return TYPE; }
{QUALIFIER} { return QUALIFIER; }  
{ID} { return IDENTIFIER; }
"."{ID} { return SWIZZLE;}
     
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


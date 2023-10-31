%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#ifndef yywrap
static int yywrap(void) { return 1; }
#endif
%}

IDENTIFICADOR [a-zA-Z][a-zA-Z0-9]*
CNST [0-9]+

%%
"inicio" { yylval.cadena = strdup(yytext); printf("Se leyo un INICIO\n"); return INICIO; }
"fin" { yylval.cadena = strdup(yytext); printf("Se leyo un FIN\n"); return FIN; }
"leer" { yylval.cadena = strdup(yytext); printf("Se leyo un LEER\n"); return LEER; }
";" { yylval.cadena = strdup(yytext); printf("Se leyo un PUNTOYCOMA\n"); return PYCOMA; }
"," { yylval.cadena = strdup(yytext); printf("Se leyo una COMA\n"); return COMA; }
":=" { yylval.cadena = strdup(yytext); printf("Se leyo una OP Asignacion\n"); return ASIGNACION; }
"(" { yylval.cadena = strdup(yytext); printf("Se leyo un Parentesis Izquierdo\n"); return PARENIZQUIERDO; }
")" { yylval.cadena = strdup(yytext); printf("Se leyo un Parentesis Derecho\n"); return PARENDERECHO; }
"+" { yylval.cadena = strdup(yytext); printf("Se leyo un MAS\n"); return SUMA; }
"-" { yylval.cadena = strdup(yytext); printf("Se leyo un MENOS\n"); return RESTA; }
{CNST} { yylval.cadena = strdup(yytext); printf("Se leyo una CONSTANTE\n"); return CONSTANTE; }
{IDENTIFICADOR} { yylval.cadena = strdup(yytext); printf("Se leyo un Identificador\n"); return ID; }
<<EOF>> { printf("Se llego al fin del archivo\n"); return FDT; }
[[:space:]]+ ;
. { printf("Error Lexico\n"); }
%%
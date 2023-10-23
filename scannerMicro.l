%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h" // Incluye el archivo de encabezado generado por Bison
#ifndef yywrap
static int yywrap(void) { return 1; }
#endif
%}
IDENTIFICADOR [a-zA-Z][a-zA-Z0-9]*
ASIGNACION :=
CNST [0-9]+
%%
"inicio" {yylval.cadena = strdup(yytext);  printf("Se leyo un INICIO\n"); return INICIO;}
"fin" {yylval.cadena = strdup(yytext);  printf("Se leyo un FIN\n"); return FIN;}
{IDENTIFICADOR} {yylval.cadena = strdup(yytext); printf("Se leyo un Identificador\n"); return ID;}
<<EOF>> {printf("Se llego al fin del archivo\n");return FDT;}
[[:space:]]+ ;
. printf("Error Lexico\n");
%%

%{
#include <stdlib.h>
#include <string.h>
#include "y.tab.h" // Incluye el archivo de encabezado generado por Bison
#ifndef yywrap
static int yywrap(void) { return 1; }
#endif
%}
IDENTIFICADOR [a-zA-Z][a-zA-Z0-9]*
CNST [0-9]+
%%
"inicio" {yylval.cadena = strdup(yytext);  printf("Se leyo un INICIO\n"); return INICIO;}
"fin" {yylval.cadena = strdup(yytext);  printf("Se leyo un FIN\n"); return FIN;}
";" {yylval.cadena = strdup(yytext); printf("Se leyo un PUNTOYCOMA\n"); return PYCOMA;}
":=" {yylval.cadena = strdup(yytext); printf("Se leyo una OP Asignacion\n"); return ASIGNACION;}
{IDENTIFICADOR} {yylval.cadena = strdup(yytext); printf("Se leyo un Identificador\n"); return ID;}
{CNST} {yylval.cadena = strdup(yytext); printf("Se leyo una CONSTANTE\n"); return CONSTANTE;}
<<EOF>> {printf("Se llego al fin del archivo\n");return FDT;}
[[:space:]]+ ;
. printf("Error Lexico\n");
%%

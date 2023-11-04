%{
#include <stdlib.h>
#include <string.h>
#include "RegistroExpresion.h"
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
"escribir" { yylval.cadena = strdup(yytext); printf("Se leyo un ESCRIBIR\n"); return ESCRIBIR; }
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
int main (int argc, char * argv[]){
    char nomArchi[TAMNOM];
    int l;
    FILE * archivo;
    /***************************Se abre el Archivo Fuente******************/
    // verifica errores posibles 
    if ( argc == 1 ) {
        printf("Debe ingresar el nombre del archivo fuente (en lenguaje Micro) en la linea de comandos\n");  
        return -1;  
    }// no puso nombre de archivo fuente
    if ( argc != 2 ) {
        printf("Numero incorrecto de argumentos\n");  
        return -1;  
    }//los argumentos deben ser 2
    strcpy(nomArchi, argv[1]);
    l = strlen(nomArchi);
    if ( l > TAMNOM ) {
        printf("Nombre incorrecto del Archivo Fuente\n"); 
        return -1; 
    }
    // requiere para compilar un archivo de extensiÃ³n.m archivo.m
    if ( nomArchi[l-1] != 'm' || nomArchi[l-2] != '.' ) {
        printf("Nombre incorrecto del Archivo Fuente\n"); 
        return -1; 
    }
    if ( (archivo = fopen(nomArchi, "r") ) == NULL )  {
            printf("No se pudo abrir archivo fuente\n");  
            return -1; //no pudo abrir archivo
    }

    yyin = archivo;
    yyparse();
    fclose(archivo);
    return 0;
}
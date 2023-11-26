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
"inicio" {return INICIO; }
"fin" {return FIN; }
"leer" {return LEER; }
"escribir" {return ESCRIBIR; }
";" {return PYCOMA; }
"," {return COMA; }
":=" {return ASIGNACION; }
"(" {return PARENIZQUIERDO; }
")" {return PARENDERECHO; }
"+" {return SUMA; }
"-" {return RESTA; }
{CNST} { yylval.cadena = strdup(yytext); return CONSTANTE; }
{IDENTIFICADOR} {
    // Identificador encontrado
    yylval.cadena = strdup(yytext);
    return ID;
}
<<EOF>> {return FDT; }
[[:space:]]+ ;
. { printf("Error Lexico\n"); return EL; }
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

/*char * formatearCadena(char * s, char * s2){
    if(yyleng > 33){
        int i = 0;
        while(i<32){
            s2[i] = s[i];
        }
        s2[i+1] = '\0';
        return cadena;
    }
    else return s;
}*/
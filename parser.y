%{
#include <stdio.h>
#include <stdlib.h> 
#include <math.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
int variable=0;
%}
%union{
   char* cadena;
   int num;
} 
%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO COMA FDT
%token <cadena> ID
%token <cadena> INICIO
%token <cadena> FIN
%token <num> CONSTANTE
%%
objetivo      : programa FDT {terminar();}
              ;
programa      : {comenzar();} INICIO identificador FIN;
              ;
identificador : ID {printf("%s\n", $1);}
              ;
%%
main(){
    /* Acciones Pre análisis */
    yyparse();
    /* Acciones Post análisis */
    return 0;
}

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
    // Puedes agregar más código para manejar errores aquí si lo deseas.
}

void comenzar(){
    
}

void terminar(){
    printf("Detiene ,,,\n");
    exit(0);
}
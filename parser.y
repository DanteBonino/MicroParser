%{
#include <stdio.h>
#include <stdlib.h> 
#include <math.h>
extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
int variable=0;
void Generar(char *, char *, char *, char *);
void Asignar(char*, char*);
void terminar();
void comenzar();
%}
%union{
   char* cadena;
} 
%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO COMA FDT
%token <cadena> ID
%token <cadena> INICIO
%token <cadena> FIN
%token <cadena> CONSTANTE
%type <cadena> identificador
%%
objetivo               : programa FDT {terminar();}
                       ;
programa               : {comenzar();} INICIO listaDeSentencias FIN;
                       ;
listaDeSentencias      : sentencia | listaDeSentencias sentencia
                       ;
sentencia              : identificador ASIGNACION CONSTANTE {Asignar($1, $3);} PYCOMA
                       ;
identificador          : ID {printf("%s\n", $1);}
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
    Generar("Detiene", "", "", "");
    exit(0);
}

void Asignar(char* nombreIdentificador, char* constante){
    Generar("Almacena", constante, nombreIdentificador, "");
}

void Generar(char * co, char * a, char * b, char * c) {
 /* Produce la salida de la instruccion para la MV por stdout */
 printf("%s %s%c%s%c%s\n", co, a, ',', b, ',', c);
}
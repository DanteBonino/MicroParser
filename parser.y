%{
#include <stdio.h>
#include <stdlib.h> 
#include <math.h>
#include <string.h>

#define TAMLEX 32+1
#define TAMNOM 20+1

typedef struct { //Regitro de la TABLA de SÍMBOLOS
     char identifi[TAMLEX];
    } RegTS;

RegTS TS[1000] = {{"$"} }; // Tabla de Registros

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

int variable=0;

void Generar(char *, char *, char *, char *);
void Asignar(char*, char*);
void terminar();
void comenzar();
void ProcesarId ();
void Chequear(char *);
int Buscar(char *, RegTS *);
void Colocar(char *, RegTS *);
void MostrarTablaDeSimbolos(RegTS *);
void Leer(char * );
char * GenInfijo(char *, char *, char *);
char * ProcesarConstante(int);


/*
"inicio" -> 0
"fin" -> 1
"leer" -> 2
"escribir" -> 3
Cualquier Identificador -> 4
"$" ?? Qué es? -> Marcador que sirve para determinar el fin de la TS -> Es un centinela -> Se usa, por ejemplo, en el while de la TS
*/
%}
%union{
   char* cadena;
   int numero;
} 
%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO COMA FDT
%token <cadena> ID
%token <cadena> INICIO
%token <cadena> FIN
%token <cadena> CONSTANTE
%token <cadena> LEER
%type <cadena> identificador
%type <cadena> listaDeIdentificadores
%type <cadena> expresion
%type <cadena> primaria

%%
objetivo               : programa FDT {terminar();}
                       ;
programa               : {comenzar();} INICIO listaDeSentencias FIN;
                       ;
listaDeSentencias      : sentencia | listaDeSentencias sentencia
                       ;
sentencia              : identificador ASIGNACION expresion {Asignar($1, $3);} PYCOMA
                       | LEER PARENIZQUIERDO listaDeIdentificadores PARENDERECHO PYCOMA
                       ;
listaDeIdentificadores : identificador {Leer($1);}
                       | listaDeIdentificadores COMA identificador{Leer($3);}
                       ;
expresion              : primaria 
                       | expresion SUMA primaria {$$ = GenInfijo($1, "+", $3);}
                       ;
primaria               : identificador | CONSTANTE  | PARENIZQUIERDO expresion PARENDERECHO
                       ;
identificador          : ID {ProcesarId($1);}
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
    /* No hace nada */
}

void terminar(){
    MostrarTablaDeSimbolos(TS);
    Generar("Detiene", "", "", "");
    exit(0);
}

void Asignar(char* nombreIdentificador, char* constante){
    Generar("Almacena",constante , nombreIdentificador, "");
}

void Generar(char * co, char * a, char * b, char * c) {
 /* Produce la salida de la instruccion para la MV por stdout */
 printf("%s %s%c%s%c%s\n", co, a, ',', b, ',', c);
}

void ProcesarId(char * unIdentificador){
    Chequear(unIdentificador);
}

void Chequear(char * s){
 /* Si la cadena No esta en la Tabla de Simbolos la agrega,
    y si es el nombre de una variable genera la instruccion */
 if ( !Buscar(s, TS) ) {
  Colocar(s, TS);
  Generar("Declara", s, "Entera", "");
 }
}

int Buscar(char * unIdentificador, RegTS * TS){
int i = 0;
  while ( strcmp("$", TS[i].identifi) ) {
    if ( !strcmp(unIdentificador, TS[i].identifi) )  {//
      return 1; 
    }
    i++;
  }
  return 0;
}

void Colocar(char * unIdentificador, RegTS * TS){
 int i = 0;
 while ( strcmp("$", TS[i].identifi) ) i++;
  if ( i < 999 ) {
  strcpy(TS[i].identifi, unIdentificador );
  strcpy(TS[++i].identifi, "$" );
 }
}

void MostrarTablaDeSimbolos(RegTS * TS){
   int i = 0;
   while(1){
      printf("El identificador es :%s\n", TS[i].identifi);
      i++;
      if(!strcmp("$", TS[i].identifi)){
         printf("El identificador es :%s\n", TS[i].identifi);
         break;
      }
   }
}

void Leer(char * unIdentificador) {
 /* Genera la instruccion para leer */
 Generar("Read", unIdentificador, "Entera", "");
}


char* GenInfijo(char * e1, char * op, char * e2){
    printf("En GenInfijo : %s, %s \n", e1, e2);
    static unsigned int numTemp = 1;
    char cadTemp[TAMLEX] ="Temp&";
    char cadNum[TAMLEX];
    char cadOp[TAMLEX];
    if ( op[0] == '-' ) strcpy(cadOp, "Restar"); //Ya generas el principio de la Instrucción
    if ( op[0] == '+' ) strcpy(cadOp, "Sumar");  //Ya generas el principio de la Instrucción
    sprintf(cadNum, "%d", numTemp);
    numTemp++;
    strcat(cadTemp, cadNum);
    if (sizeof(e1) != sizeof(int)) Chequear(e1);
    if (sizeof(e2) != sizeof(int)) Chequear(e2);
    Chequear(cadTemp); // Pq se chequea cadTemp en la TS? -> Para qué guardan las cadTemp? Pq son expresiones!!!!!!
    Generar(cadOp, e1, e2, cadTemp);
    return cadTemp;
}

char * ProcesarConstante(int constante){
    char constanteCaracter [TAMLEX]; 
    sprintf(constanteCaracter,"%d", constante);
    return constanteCaracter;
}
%{
#include <stdio.h>
#include <stdlib.h> 
#include <math.h>
#include <string.h>


#define TAMLEX 32+1
#define TAMNOM 20+1

typedef struct { //Registro de la TABLA de SÍMBOLOS
     char identifi[TAMLEX];
     int t;
    } RegTS;

RegTS TS[1000] = { { "inicio", 0}, {"fin", 1}, {"leer", 2}, {"escribir", 3}, {"$", 99} }; // Tabla de Símbolos

typedef struct {
    int clase;
    char nombre[TAMLEX];
    int valor;
} REG_EXPRESION;

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);

void Generar(char *, char *, char *, char *);
void Asignar(REG_EXPRESION, REG_EXPRESION);
void terminar();
void comenzar();
REG_EXPRESION ProcesarId (char *);
void Chequear(char *);
int Buscar(char *, RegTS *);
void Colocar(char *, RegTS *);
void MostrarTablaDeSimbolos(RegTS *);
void Leer(REG_EXPRESION );
void Escribir(REG_EXPRESION );
REG_EXPRESION GenInfijo(REG_EXPRESION, char *, REG_EXPRESION);
char * Extraer(REG_EXPRESION *);
REG_EXPRESION ProcesarConstante(char *);
void chequearId(char*);

%}

%union{
   char* cadena;
   REG_EXPRESION registro;
}

%token INICIO FIN LEER ESCRIBIR ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO COMA FDT EL
%token <cadena> ID
%token <cadena> CONSTANTE
%type <registro> identificador
%type <registro> expresion
%type <registro> primaria

%%
objetivo               : programa FDT {terminar();}
                       ;
programa               : {comenzar();} INICIO listaDeSentencias FIN;
                       ;
listaDeSentencias      : sentencia | listaDeSentencias sentencia
                       ;
sentencia              : identificador ASIGNACION expresion {Asignar($1, $3);} PYCOMA
                       | LEER PARENIZQUIERDO listaDeIdentificadores PARENDERECHO PYCOMA
                       | ESCRIBIR PARENIZQUIERDO listaDeExpresiones PARENDERECHO PYCOMA
                       ;
listaDeIdentificadores : identificador {Leer($1);}
                       | listaDeIdentificadores COMA identificador{Leer($3);}
                       ;
listaDeExpresiones     : expresion {Escribir($1);}
                       | listaDeExpresiones COMA expresion {Escribir($3);}
expresion              : primaria
                       | expresion SUMA primaria {$$ = GenInfijo($1, "+", $3);}
                       | expresion RESTA primaria {$$ = GenInfijo($1, "-", $3);}
                       ;
primaria               : identificador 
                       | CONSTANTE {$$ = ProcesarConstante($1);} 
                       | PARENIZQUIERDO expresion PARENDERECHO {$$ = $2;}
                       ;
identificador          : ID {chequearId($1);$$ = ProcesarId($1);}
                       ;
%%

void yyerror(char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

void comenzar(){
    /* No hace nada */
}

void terminar(){
    MostrarTablaDeSimbolos(TS);
    Generar("Detiene", "", "", "");
    exit(0);
}

void Asignar (REG_EXPRESION izquierda, REG_EXPRESION derecha) {
/* genera la instrucción para la asignación */
 Generar("Almacena", Extraer(&derecha), izquierda.nombre, "");
}

void Leer(REG_EXPRESION in) {
    /* Genera la instruccion para leer */
    Generar("Read", in.nombre, "Entera", "");
}

void Escribir (REG_EXPRESION out) {
 Generar("Write", Extraer(&out), "Entera", "");
}

char * Extraer(REG_EXPRESION * preg) {
 /* Retorna la cadena del registro semantico */
 return preg->nombre;
}

void Generar(char * co, char * a, char * b, char * c) {
 /* Produce la salida de la instruccion para la MV por stdout */
 printf("%s %s%c%s%c%s\n", co, a, ',', b, ',', c);
}

REG_EXPRESION GenInfijo(REG_EXPRESION e1, char * op, REG_EXPRESION e2){
 /* Genera la instruccion para una operacion infija y construye un registro semantico con el resultado */
    REG_EXPRESION reg;
    static unsigned int numTemp = 1;
    char cadTemp[TAMLEX] ="Temp&";
    char cadNum[TAMLEX];
    char cadOp[TAMLEX];
    if ( op[0] == '-' ) strcpy(cadOp, "Restar");
    if ( op[0] == '+' ) strcpy(cadOp, "Sumar");
    sprintf(cadNum, "%d", numTemp);
    numTemp++;
    strcat(cadTemp, cadNum);
    if ( e1.clase == 4) Chequear(Extraer(&e1));
    if ( e2.clase == 4) Chequear(Extraer(&e2));
    Chequear(cadTemp);
    Generar(cadOp, Extraer(&e1), Extraer(&e2), cadTemp);
    strcpy(reg.nombre, cadTemp);
    return reg;
}

REG_EXPRESION ProcesarConstante(char * unaConstante)
{
    /* Convierte cadena que representa numero a entero y construye un registro semantico */
    REG_EXPRESION reg;
    reg.clase = CONSTANTE;
    strcpy(reg.nombre, unaConstante);
    sscanf(unaConstante, "%d", &reg.valor);
    return reg;
}

REG_EXPRESION ProcesarId(char * unIdentificador) {
    /* Declara ID y construye el correspondiente registro semantico */
    REG_EXPRESION reg;
    Chequear(unIdentificador); //function auxiliar
    reg.clase = ID;
    strcpy(reg.nombre, unIdentificador);
    return reg;
}


void Chequear(char * s){
 /* Si la cadena No esta en la Tabla de Simbolos la agrega,
    y si es el nombre de una variable genera la instruccion */
 if ( !Buscar(s, TS) ) {
  Colocar(s, TS);
  Generar("Declara", s, "Entera", "");
 }
}

int Buscar(char * id, RegTS * TS){
 /* Determina si un identificador esta en la TS */
    int i = 0;
    while ( strcmp("$", TS[i].identifi) ) {
        if ( !strcmp(id, TS[i].identifi) )  {
            return 1; 
        }
        i++;
    }
    return 0;

}

void Colocar(char * id, RegTS * TS){
 /* Agrega un identificador a la TS */
    int i = 4;
    while ( strcmp("$", TS[i].identifi) ) i++;
    if ( i < 999 ) {
        strcpy(TS[i].identifi, id );
        TS[i].t = 4;
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


void chequearId(char * unId){
    if(yyleng>32){
        yyerror("El identificador es demasiado largo");
        printf("El proceso de compilacion no va a continuar");
        exit(0);
    }
}
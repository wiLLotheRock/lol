%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern int yylex(void);
extern char *yytext;
extern int linea;
extern FILE *yyin;
void yyerror(char *s);

float switch_val; // Valor del switch actual
int case_executed; // Flag para saber si ya se ejecutó un case
%}


%union {
    float real;
}

%start Exp_l

%token <real> NUMERO
%token MAS MENOS DIV POR PTOCOMA PAA PAC IGUAL
%token SWITCH CASE DEFAULT
%token DOSPUNTOS LLAVE_ABRE LLAVE_CIERRE

%left MAS MENOS
%left POR DIV

%type <real> Exp
%type <real> Calc

%%

Exp_l:
    Exp_l Stmt
    | Stmt
    ;

Stmt:
    Calc
    | SWITCH PAA Exp PAC LLAVE_ABRE { switch_val = $3; case_executed = 0; } CaseList OptDefaultCase LLAVE_CIERRE
    ;

Calc:
    Exp PTOCOMA    { printf("%4.1f\n", $1); }
    ;

CaseList:
    CaseList Case
    | /* vacío */
    ;

Case:
    CASE NUMERO DOSPUNTOS Exp PTOCOMA
        {
            if (!case_executed && switch_val == $2) {
                printf("%4.1f\n", $4);
                case_executed = 1;
            }
        }
    ;

DefaultCase:
    DEFAULT DOSPUNTOS Exp PTOCOMA
        {
            if (!case_executed) {
                printf("%4.1f\n", $3);
                case_executed = 1;
            }
        }
    ;

OptDefaultCase:
    DefaultCase
    | /* vacío */
    ;

Exp:
    NUMERO              { $$ = $1; }
    | Exp MAS Exp       { $$ = $1 + $3; }
    | Exp MENOS Exp     { $$ = $1 - $3; }
    | Exp POR Exp       { $$ = $1 * $3; }
    | Exp DIV Exp       {
        if ($3 == 0) {
            yyerror("división por cero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | PAA Exp PAC       { $$ = $2; }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "Error sintáctico en línea %d: %s\n", linea, s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        yyin = fopen(argv[1], "rt");
    } else {
        yyin = stdin;
    }
    yyparse();
    return 0;
}
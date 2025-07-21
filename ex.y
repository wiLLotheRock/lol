%{
    #include <stdlib.h>
    #include <stdio.h>
    #include <math.h>
    extern int yylex(void);
    extern char *yytext;
    extern int linea;
    extern FILE *yyin;
    void yyerror(char *s);
%}

%union{
    float real;
    int entero;
}

%start Exp_1

%token <real> NUMERO
%token MAS MENOS POR DIV IGUAL PTOCOMA PAA PAC
%token LLAVE_ABRE LLAVE_CIERRE
%token LIGUAL LDIFERENTE MENOR MAYOR MENORIGUAL MAYORIGUAL
%token AND OR IF ELSE WHILE DO THEN

%type <real> Exp
%type <real> Calc
%type <entero> Condicion
%type <entero> Stmt

%right ELSE                 // Resolver conflicto dangling-else
%left OR                    // Menor precedencia
%left AND
%left LIGUAL LDIFERENTE     
%left MENOR MAYOR MENORIGUAL MAYORIGUAL
%left MAS MENOS
%left POR DIV
%nonassoc THEN              // Para resolver conflicto if-else 

%%

Exp_1:      Exp_1 Calc
            | Exp_1 Stmt
            | Calc
            | Stmt
            ;

Calc:       Exp PTOCOMA      {printf("%4.1f\n" , $1);}
            ;

Stmt:       IF PAA Condicion PAC LLAVE_ABRE StmtList LLAVE_CIERRE %prec THEN
            {
                if($3) {
                    printf("Condicion verdadera - ejecutando bloque if\n");
                } else {
                    printf("Condicion falsa - no se ejecuta el bloque if\n");
                }
            }
            | IF PAA Condicion PAC LLAVE_ABRE StmtList LLAVE_CIERRE ELSE LLAVE_ABRE StmtList LLAVE_CIERRE
            {
                if($3) {
                    printf("Condicion verdadera - ejecutando bloque if\n");
                } else {
                    printf("Condicion falsa - ejecutando bloque else\n");
                }
            }
            | WHILE PAA Condicion PAC LLAVE_ABRE StmtList LLAVE_CIERRE
            {
                if($3) {
                    printf("Condicion while verdadera - ejecutando bloque while\n");
                } else {
                    printf("Condicion while falsa - no se ejecuta el bloque\n");
                }
            }
            | DO LLAVE_ABRE StmtList LLAVE_CIERRE WHILE PAA Condicion PAC PTOCOMA
            {
                printf("Ejecutando bloque do-while\n");
                if($7) {
                    printf("Condicion do-while verdadera - se repetiria\n");
                } else {
                    printf("Condicion do-while falsa - termina el bucle\n");
                }
            }
            ;

StmtList:   StmtList Calc
            | Calc
            | StmtList Stmt
            | Stmt
            | /* vacío */
            ;

Condicion:  Exp LIGUAL Exp      { $$ = ($1 == $3) ? 1 : 0; }
            | Exp LDIFERENTE Exp { $$ = ($1 != $3) ? 1 : 0; }
            | Exp MENOR Exp      { $$ = ($1 < $3) ? 1 : 0; }
            | Exp MAYOR Exp      { $$ = ($1 > $3) ? 1 : 0; }
            | Exp MENORIGUAL Exp { $$ = ($1 <= $3) ? 1 : 0; }
            | Exp MAYORIGUAL Exp { $$ = ($1 >= $3) ? 1 : 0; }
            | Condicion AND Condicion { $$ = ($1 && $3) ? 1 : 0; }
            | Condicion OR Condicion  { $$ = ($1 || $3) ? 1 : 0; }
            | PAA Condicion PAC  { $$ = $2; }
            ;



Exp:        NUMERO           {$$ = $1;}
            | Exp MAS Exp    {$$ = $1 + $3;}    
            | Exp MENOS Exp  {$$ = $1 - $3;}      
            | Exp POR Exp    {$$ = $1 * $3;}    
            | Exp DIV Exp    {
                if($3 == 0)
                {
                    yyerror("division por 0\n");
                    $$ = 0;
                }
                else
                {
                    $$ = $1 / $3;
                }
            }                                   
            | PAA Exp PAC    {$$ = $2;}
            ;
%%

void yyerror(char *s)
{
    printf("error sintactico %s",s);
}

int main(int argc,char **argv)
{
    if(argc>1)
    {
        yyin = fopen(argv[1],"rt");
    }
    else
    {
        yyin=stdin;
    }
    yyparse();
    return 0;
}
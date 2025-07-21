%option noyywrap
%{
#include <stdlib.h>
#include <stdio.h>
#include "ex.tab.h"
int linea = 1;
%}

DIGITO      [0-9]
NUMERO      {DIGITO}+("."{DIGITO}+)? 

%%


{NUMERO}    { yylval.real = atof(yytext); return NUMERO; }
"="         { return IGUAL; }
"+"         { return MAS; }
";"         { return PTOCOMA; }
"*"         { return POR; }
"("         { return PAA; }
")"         { return PAC; }
"-"         { return MENOS; }
"/"         { return DIV; }
"=="        { return LIGUAL;}
"!="        { return LDIFERENTE;}
"<"         { return MENOR;}
"<="        { return MENORIGUAL;}
">"         { return MAYOR;}
">="        { return MAYORIGUAL;}
"&&"        { return AND;}
"||"        { return OR;}
"if"        { return IF;}
"else"      { return ELSE;}
"while"     { return WHILE;}
"do"        { return DO;}
"{"         {return LLAVE_ABRE;}
"}"         { return LLAVE_CIERRE; }

"\n"        { linea++; }
[\t\r\f]    { /* ignora */ }
" "         { /* ignora */ }
.           { fprintf(stderr, "Error léxico en línea %d: carácter no reconocido '%s'\n", linea, yytext); }

%%
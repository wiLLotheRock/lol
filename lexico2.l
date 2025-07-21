%option noyywrap
%{
#include <stdlib.h>
#include <stdio.h>
#include "sintactico2.tab.h"
int linea = 1;
%}

DIGITO      [0-9]
NUMERO      {DIGITO}+("."{DIGITO}+)? 

%%
"switch"    { return SWITCH; }
"case"      { return CASE; }
"default"   { return DEFAULT; }
":"         { return DOSPUNTOS; }
"{"         { return LLAVE_ABRE; }
"}"         { return LLAVE_CIERRE; }
{NUMERO}    { yylval.real = atof(yytext); return NUMERO; }
"="         { return IGUAL; }
"+"         { return MAS; }
";"         { return PTOCOMA; }
"*"         { return POR; }
"("         { return PAA; }
")"         { return PAC; }
"-"         { return MENOS; }
"/"         { return DIV; }

"\n"        { linea++; }
[\t\r\f]    { /* ignora */ }
" "         { /* ignora */ }
.           { fprintf(stderr, "Error léxico en línea %d: carácter no reconocido '%s'\n", linea, yytext); }

%%
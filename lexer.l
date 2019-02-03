%{

#include <stdio.h>
#include "grammar.tab.h"
#include <string.h>
int line=0;


%}

DIGIT [0-9]
MESSAGE [A-Z]?[A-Z_]+
IDENTIFIER _[a-z][a-zA-Z]*[0-9]*

%%


"INTEGER" {return INT;}

"DECIMAL" {return FLOAT;}

"WORD" {return CHARACTER;}

"CONDITION" {return IF;}

"OTHERWISE" {return ELSE;}

"REPEAT" {return LOOP;}

"WHEN" {return WHILE;}

"SWITCH" {return SWITCH;}

"CASE" {return CASE;}

"DEFAULT" {return DEFAULT;}

"**" {return START;}

"##" {return END;}

"+" {return PLUS;}

"-" {return MINUS;}

"*" {return MULT;}

"/" {return DIV;}

">" {return ISGRTR;}

"<" {return ISLESS;}

">=" {return ISGRTREQU;}

"<=" {return ISLESSEQU;}

"=" {return EQU;}

":" {return ASSIGN;}

"(" {return LB;}

")" {return RB;}

"INC" {return INC;}

"DEC" {return DEC;}

"TILL" {return TILL;}




[\n] {	
		line++;
		return END_OF_STATEMENT;}

"ECHO" {return PRINT;}



{IDENTIFIER} {
	
	
	yylval.VAR=strdup(yytext);
	
	return VARIABLE;
}


{MESSAGE} {
	
	
	yylval.VAR=strdup(yytext);
	
	return STRING;
}



[-+]?{DIGIT}+ {
	yylval.DBL=atof(yytext);
	return NUMBER;
	}

[-+]?{DIGIT}+?"."{DIGIT}+ {
	yylval.DBL=atof(yytext);
	return NUMBER;
	}


[ \t]* ;

. {printf("Syntax Error %s on line %d\n", yytext, line);}



%%

int main()
{
	yyin = freopen("input.txt", "r", stdin);
	yyout = freopen("output.txt", "w", stdout);
	yyparse();
}
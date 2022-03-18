%{
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include "parser.tab.h"

	void yyerror(const char *s);
%}

%option noyywrap

%%

"BODY"								{return (BODY);}
"BEGINNING"						{return (BEGINNING);}
"TO"									{return (TO);}
"END"									{return (END);}
"MOVE"								{return (MOVE);}
"ADD"									{return (ADD);}
"INPUT"								{return (INPUT);}
"PRINT"								{return (OUTPUT);}
\"([^\\\"]|\\.)*\"		{return (STRING);}
[xX]+									{yylval.cap=strlen(yytext); return CAPACITY;}
[0-9]+                {yylval.num=atoi(yytext); return INTEGER; }
[\t ]+     						{ };
[A-Za-z][\-a-zA-Z0-9]*	{yylval.identifier = yytext; return IDENTIFIER;}
;											{return (SEMICOLON);}
\.										{return TERMINATE;}
.											return 0;

%%

int main()
{
	yylex();
}

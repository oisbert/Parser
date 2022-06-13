%{
	#include <stdlib.h>
	#include <ctype.h>
	#include <string.h>
	#include "parser.tab.h"

	void yyerror(const char *s);
%}

%option noyywrap
%option yylineno
%option caseless

%%
[\t ]+                  {}
"BODY"								{return (BODY);}
"BEGINING"						{return (BEGINING);}
"TO"									{return (TO);}
"END"									{return (END);}
"MOVE"								{return (MOVE);}
"ADD"									{return (ADD);}
"INPUT"								{return (INPUT);}
"PRINT"								{return (OUTPUT);}
\n   									{}
[xX]+									{yylval.cap=strlen(yytext); return (CAPACITY);}
[A-Za-z][\-a-zA-Z0-9]*	{yylval.identifier = yytext; return (IDENTIFIER);}
\.									{return (DELIMITER);}
\"([^\\\"]|\\.)*\"		{return (STRING);}
[0-9]+                {yylval.num=atoi(yytext); return (INTEGER); }
;											{return (SEMICOLON);}
.											return 0;

%%

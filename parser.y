
%{
  #include<stdio.h>
  #include <ctype.h>
  #include <string.h>
  #include <stdlib.h>
  #include <stdbool.h>

  extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	extern int yylineno;
  extern int yylex(void);


  void yyerror(char *);

%}

%name parse

%union{
    int num;
    char* identifier;
    int cap;
}

/*specify the tokens needed*/
%start beginning
%token BODY BEGINNING TO END INPUT TERMINATE OTHER
%token INTEGER
%token ADD MOVE STRING
%token IDENTIFIER
%token CAPACITY
%token SEMICOLON
%token INPUT OUTPUT

%type <int> CAPACITY
%type <identifier> IDENTIFIER

%%

beginning:      BEGINNING TERMINATE  declaration {}
                ;

declaration:    declaration declare {}
                | {}
                ;

declare:        CAPACITY IDENTIFIER TERMINATE {}
                | {}
                ;

body:           BODY TERMINATE functions {}
                ;

functions:     functions function {}
                ;

function:       add {}
                | move {}
                | input {}
                | output {}
                ;

output:         OUTPUT outputs {}
                ;

add:            ADD IDENTIFIER TO IDENTIFIER TERMINATE {}
                ;

move:           MOVE IDENTIFIER TO IDENTIFIER TERMINATE {}
                ;

outputs:       STRING SEMICOLON outputs {}
                | IDENTIFIER SEMICOLON outputs {}
                | STRING TERMINATE {}
                | IDENTIFIER TERMINATE {}
                ;

input:          INPUT inputfunc {}
                ;

inputfunc:      IDENTIFIER TERMINATE {}
                | IDENTIFIER SEMICOLON inputfunc {}
                ;

end:            END TERMINATE {}
                ;
%%

extern FILE *yyin;

int main()
{
  do yyparse();
    while(!feof(yyin));
}

void yyerror(char *s)
{
  fprintf(stderr, "%s\n", s);
}

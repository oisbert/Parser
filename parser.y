
%{
  #include<stdio.h>
  #include <ctype.h>
  #include <string.h>
  #include <stdlib.h>
  #include <stdbool.h>
  #define MAX 60

  extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	extern int yylineno;
  extern int yylex(void);



  /* function declaration */
  void add_variable(char *varName, const int size);
  void remove_delimiter(char *variable);
  void yyerror(char *);
  bool check_var_def(char *identifer);
  void get_identifier(char *identifer);

  /*public variables*/
  char identifierArray[MAX][32];
  int sizes[MAX];
  int arrayCounter = 0;

%}

%name parse

%union{
    int num;
    char* identifier;
    int cap;
}

/*specify the tokens needed*/
%start prog
%token BODY BEGINNING TO END INPUT TERMINATE OTHER
%token INTEGER
%token ADD MOVE STRING
%token <cap> CAPACITY
%token <identifier> IDENTIFIER
%token SEMICOLON
%token INPUT OUTPUT

%%
prog:            beginning body end {}
                    ;

beginning:      BEGINNING TERMINATE declaration {}
                ;

declaration:    declare declaration {}
                | {}
                ;

declare:        CAPACITY IDENTIFIER TERMINATE { add_variable($2, $1) }
                ;

body:           BODY TERMINATE functions {printf("declare the body")}
                ;

functions:     functions function {}
                | {}
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

end:            END TERMINATE {exit(EXIT_SUCCESS);}
                ;
%%

extern FILE *yyin;

int main()
{
  do yyparse();
    while(!feof(yyin));
}

void add_variable(char *varName, const int size)
{
  remove_delimiter(varName);
  if (!check_var_def(varName))
  {
    strcpy(identifierArray[arrayCounter], varName);
    sizes[arrayCounter] = size;
    arrayCounter++;
    for (int i = 0; i < arrayCounter; i++) {
     printf("%s \n", identifierArray[i]);
   }

  }
  else if (check_var_def(varName))
  {
      printf("you bro you already declared this try again later my home slice");
   }
  else {
    printf("error");
  }
}

void remove_delimiter(char *variable)
{
  const unsigned int length = strlen(variable);

  if((length > 0) && (variable[length-1] == '.'))
  {
    variable[length-1] = '\0';
  }
}

bool check_var_def(char *identifer)
{


  for (int i = 0; i < arrayCounter; i++)
  {
      if(strcmp(identifer, identifierArray[i])==0)
      {
          printf("got %s \n",identifer);
          return true;
      }
    }
        return false;
  }

  void yyerror(char *s)
  {
    fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
  }

void get_identifier(char *identifer){


}

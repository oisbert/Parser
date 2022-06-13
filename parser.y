
%{
  #include<stdio.h>
  #include <ctype.h>
  #include <string.h>
  #include <stdlib.h>
  #include <stdbool.h>
  #include <math.h>
  #define MAX 60

  extern int yylex();
	extern int yyparse();
	extern FILE *yyin;
	extern int yylineno;
  extern int yylex(void);



  /* function declaration */
  void add_variable(char *varName, const int size);
  void remove_delimiter(char *variable);
  void printArray();
  void yyerror(char *);
  bool check_var_def(char *identifer);
  void get_identifier(char *identifer);
  void moveVarToVar(char *identifier, char *identifer2);
  void moveIntToVar(char *identifier, int amount);
  void getIdentifier(char *variable);
  void checkDeclaration(char *identifier);
  void moveIntToVar(char *identifier, int amount);
  void printStruct(int length);
  void checkleadingZero(int number);

  struct variables
  {
    int sizesV;
    char identifiers[MAX];
  };

  struct variables var_array[MAX];

  /*Global variables/Datatypes*/
  char identifierArray[MAX][50]; //stores variables
  int sizes[MAX]; //stores the sizes/capacity of the variables
  int arrayCounter = 0;

%}


%union{
    int num;
    char* identifier;
    int cap;
}

/*specify the tokens needed*/
%start prog
%token BODY BEGINING END DELIMITER OTHER
%token TO
%token <num> INTEGER
%token ADD MOVE STRING
%token <cap> CAPACITY
%token <identifier> IDENTIFIER
%token SEMICOLON
%token INPUT OUTPUT

%%
prog:           beginning body end {};

beginning:      BEGINING DELIMITER declaration {};

declaration:    declare declaration {} | {};

declare:        CAPACITY IDENTIFIER DELIMITER { add_variable($2, $1); };

body:           BODY DELIMITER functions {};

functions:     functions function {} | {};

function:        output {} | add {} | input {} | move {};

add:            ADD IDENTIFIER TO IDENTIFIER DELIMITER { moveVarToVar($2, $4); }
                | ADD INTEGER TO IDENTIFIER DELIMITER { moveIntToVar($4, $2); };

move:           MOVE IDENTIFIER TO IDENTIFIER DELIMITER { moveVarToVar($2, $4); }
                | MOVE INTEGER TO IDENTIFIER DELIMITER { moveIntToVar($4, $2); };

output:        OUTPUT outputs {};

outputs:         STRING SEMICOLON outputs {}
                | IDENTIFIER SEMICOLON outputs {checkDeclaration($1);}
                | STRING DELIMITER {}
                | IDENTIFIER DELIMITER {checkDeclaration($1);}
                | error {};

input:          INPUT inputfunc {};

inputfunc:      IDENTIFIER SEMICOLON inputfunc {checkDeclaration($1);}
              | IDENTIFIER DELIMITER {checkDeclaration($1);};


end:            END DELIMITER {exit(EXIT_SUCCESS);};
%%

int main(int argc, char **argv)
{
	if (argc > 1)
	{
		yyin = fopen(argv[1], "r");
	}
	else
	{
		yyin = stdin;
	}

	yyparse();
	return 0;
}

/*
  adds a variable to the struct var_array created above
  if the variable is already created in the struct it will give a parser error
*/

void add_variable(char *varName, const int size)
{
  getIdentifier(varName);
	if (!check_var_def(varName))
	{
		strcpy(var_array[arrayCounter].identifiers, varName);	//add variable to the struct array
		var_array[arrayCounter].sizesV = size;	//add size to the struct array
		arrayCounter++;	//increment the index position
	}
	else if (check_var_def(varName))
	{
		printf("error on line %d: variable with the name %s already defined \n", yylineno, varName);
	}
	else
	{
		printf("error");
	}
}

/*
  this function searches through the structure and looks for the variable passed in
*/
bool check_var_def(char *identifer)
{

	getIdentifier(identifer);

	for (int i = 0; i < arrayCounter; i++)
	{
		if (strcmp(identifer, var_array[i].identifiers) == 0)
		{
			return true;
		}
	}
	return false;
}
/*
  function get the size of a variable in the array structure
  loops through the var_array structure
  If the variable is found it returns the size in that index position
*/
int getSize(char *variable)
{
	for (int i = 0; i < arrayCounter; i++)
	{
		if (strcmp(variable, var_array[i].identifiers) == 0)
		{
			return var_array[i].sizesV;
		}
	}
	return -1;
}
/*
  check if variable is declared in the struct
  if not found return eeror
*/
void checkDeclaration(char *identifier){

  	getIdentifier(identifier);

  	bool checkVar1 = check_var_def(identifier);

  	if (checkVar1 == false)
  	{
  		printf("A variable on line %d is not declared\n", yylineno);
  	}
}

/*
  check if move var to var function is correct
  check if identifer size is less than other identifer size.
  If it is return an error
*/
void moveVarToVar(char *identifier, char *identifier2)
{

	getIdentifier(identifier);
	getIdentifier(identifier2);

	checkDeclaration(identifier);
  checkDeclaration(identifier2);

	int getVar1Size = getSize(identifier);
	int getVar2Size = getSize(identifier2);

	if (getVar2Size < getVar1Size)
	{
		printf("error on line %d: Cant move %s to %s Capacity of %s is too small\n", yylineno, identifier, identifier2, identifier2);
	}
}

/*
  Check if move int to var is declared correctly.

  calculation performed:
  Needed to get the capacity size to fit number:

  Example
  get identifer size = 3 (XXX)
  put 10 to the power of 3 = 1000
  store 1000 in varsize
  1000 - 1 = 999 which is the max capacity

  If the if amount is greater than variable sizer give an error

*/
void moveIntToVar(char *identifier, int amount)
{
	getIdentifier(identifier);
	int getVar1Size = getSize(identifier);
	int varSize = pow(10, getVar1Size); //10 to the power of capacity
	int getVarLimit = varSize - 1; //take away 1 to get the maximum capacity

	bool checkVar = check_var_def(identifier);

	if (checkVar == true)
	{
		if (amount > getVarLimit)
		{
			printf("error on line %d: cant move %d to %s variable capacity is max: %d\n", yylineno, amount, identifier, getVarLimit);
		}
	}
	else
	{
		printf("A variable on line %d is not declared\n", yylineno);
	}
}

void printStruct(int length){
  for (int i = 0; i<length; i++){
    printf("%d %s \n",var_array[i].sizesV,var_array[i].identifiers);
  }
}

/*
  This method returns the identifer without
  . or ' ' or ;

  We need this to regocnise the variables stored in the struct
*/
void getIdentifier(char *variable)
{
	for (int i = 0; i < strlen(variable); i++)
	{
		if (variable[i] == '.')
		{
			variable[i] = '\0';
		}
    else if (variable[i] == ' ' || variable[i] == ';')
    {
      variable[i] = '\0';
      break;
    }
	}
}

void yyerror(char *s)
{
	fprintf(stderr, "Error on line %d: %s\n", yylineno, s);
}

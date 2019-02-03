/* Simple grammar rules*/

%{
	#include<stdio.h>
	#include<math.h>
	#include<stdlib.h>
	#include<string.h>
	
	int count1 = 0;
	int loop_count = 0;
	int go_to_default =1;
	
	int variable_value = 5;
	
	int if_condition_is_true=0;//0 for no condition, 1 for true, 2 for false
	int dont_do_this_else=0;
	
	char *variable[50];
	int value[50];
	
	int check_for_duplicate(char* term){
			int i;
			for(i=0;i<count1;i++)
			{
				if(strcmp(term, variable[i])==0)
					return 1;
			}						
			variable[count1]=term;
			count1++;
			return 0;
	
	}
	
	
	int assign_value(char* term, int a) {
			int i;
			for(i=0;i<count1;i++)
			{
				if(strcmp(term, variable[i])==0)
					{
						value[i]=a;
						return 1;
					}
			}
			return 0;
	}
	
	int get_variable_value (char* term) {
				int i;
				for(i=0;i<count1;i++)
				{	
					if(!strcmp( term, variable[i]))
						{
							return value[i];
						}
				}
				
				printf("%s not declared. May result to unintended output", term);
				return 0;
	
	}
	
%}

%union {
	double DBL;
	int INTG;
	char* VAR;
}


%token <DBL> NUMBER
%token <VAR> VARIABLE
%token <VAR> STRING
%token INT FLOAT CHARACTER INC DEC TILL IF ELSE LB RB LOOP WHILE SWITCH CASE DEFAULT PRINT START END END_OF_STATEMENT PLUS MINUS MULT DIV ISGRTR ISLESS ISGRTREQU ISLESSEQU EQU 
%left ASSIGN  
%nonassoc IFX
%nonassoc ELSE
%start START_POINT
%type <INTG> EXPRESSION STATEMENT TERM FACTOR CONDITION SINGLE_CASE CASES

%%

START_POINT: START PROGRAM END{
		printf("Compiled Successfully");
}
;

PROGRAM:/*empty*/
	|PROGRAM STATEMENT
;


STATEMENT: END_OF_STATEMENT{
				$$ = 1;
}
	| DECLARATION END_OF_STATEMENT {$$=1;}
	| EXPRESSION END_OF_STATEMENT{
				$$ = 1;

}
	| PRINT STRING {
						printf("%s\n", $2);
}
	| PRINT VARIABLE {
		int i;
		for(i=0;i<count1;i++)
			{
				if(strcmp( $2, variable[i])==0)
					{
						printf("%s value is: %d\n",$2, value[i]);
						break;
					}
			}
}
	| VARIABLE ASSIGN EXPRESSION END_OF_STATEMENT 
			{
					int i=0;
					i= assign_value($1, $3);
					if(i)
						printf("Value Assigned\n");
					else
						printf("Variable not declared\n");
}
        
	    |IF_ELSE END_OF_STATEMENT{
				$$ = 1;
} 
		| WHILE LB CONDITION RB LOOP LB PROGRAM RB {
				printf("Inside loop\n");
		}
		
		| SWITCH EXPRESSION LB CASES RB END_OF_STATEMENT {
			
		}
;

CASES : SINGLE_CASE
	| CASES SINGLE_CASE
	| CASES DEFAULT_CASE
;

SINGLE_CASE: CASE EXPRESSION LB PROGRAM RB END_OF_STATEMENT{ 
						if (variable_value == $2)
							{
								go_to_default = 0;
								printf("Currently in case number %d\n", $2);
							}
						}
;

DEFAULT_CASE : DEFAULT LB PROGRAM RB END_OF_STATEMENT {
				if (go_to_default)
								{
									printf("Inside default case.\n");
								}
			else 
				go_to_default = 1;
}

;



DECLARATION :  TYPE VARIABLE
		{
		int i;
		char* temp;
		temp = $2;
		i = check_for_duplicate(temp);
		if(i==1)
		printf("Duplicate declaration of variable %s\n", temp);
		else
		printf("Variable %s declared\n", temp);
		
};


TYPE :  INT
	| FLOAT
	| CHARACTER
;

EXPRESSION:   EXPRESSION PLUS TERM {
				$$ = $1 + $3;
}
	|EXPRESSION MINUS TERM{
				$$ = $1 - $3;
}
	|TERM
;

TERM: TERM MULT FACTOR{
				$$ = $1 * $3;
}
	|TERM DIV FACTOR{
				$$ = $1 / $3;
}
	|FACTOR
;

FACTOR: NUMBER { 
					$$ = $1; }
	|VARIABLE {
				variable_value = get_variable_value($1);
				$$ = get_variable_value($1);
		}
	|"(" EXPRESSION ")"{
				$$ = $2;
	}
	|"-" FACTOR {
				$$ = -$2;
	}
;


IF_ELSE: IF CONDITION LB PROGRAM RB ELSE LB PROGRAM RB {
		if($2)
			{
				printf("Inside IF \n");
				if_condition_is_true = 1;
			}
		else
		{		
				printf("Inside ELSE \n");
				if_condition_is_true = 2;
		}		
}
	|IF CONDITION LB PROGRAM RB %prec IFX {
		if($2)
			{
				printf("Inside SINGLE IF \n");
			}
		else{
				printf("SINGLE IF condition not true\n");
		}
}	
;



CONDITION: EXPRESSION ISGRTR EXPRESSION {
						$$ = $1 > $3? 1:0;
}
	|EXPRESSION ISLESS EXPRESSION {
						$$ = $1 < $3? 1:0;
}
	|EXPRESSION ISGRTREQU EXPRESSION {
						$$ = $1 >= $3? 1:0;
}
	|EXPRESSION ISLESSEQU EXPRESSION {
						$$ = $1 <= $3? 1:0;
}
	|EXPRESSION EQU EXPRESSION{
						$$ = ($1 == $3)? 1:0;
}
	|VARIABLE ASSIGN EXPRESSION INC TILL EXPRESSION {
					int i=0, j;
					printf ("I am here\n");
					i= assign_value($1, $3);
					if(i)
					{
						printf("Value INITIALIZED.. Entering into loop\n");
						for(j=$3; j<=$6; j++)
						{	
							loop_count++;
						}

						i=0;
						i= assign_value($1, j);
					
						printf("Loop ENDED.. Value: %d\n", j);
					
						if(i)
						{
							printf("Loop Ended Successfully. Total loop count: %d\n", loop_count);
							loop_count = 0;
						}
					else
						printf("Variable not declared\n");
					}
}
	
	|VARIABLE ASSIGN EXPRESSION DEC TILL EXPRESSION {
					int i=0, j;
					i= assign_value($1, $3);
					if(i)
					{
						printf("Value INITIALIZED.. Entering into loop\n");
						for(j=$6; j>=$3; j--)
						{	
							loop_count++;
						}

						i=0;
						i= assign_value($1, j);
					
						printf("Loop ENDED.. Value: %d\n", j);
					
						if(i)
						{
							printf("Loop Ended Successfully. Total loop count: %d\n", loop_count);
							loop_count = 0;
						}
					else
						printf("Variable not declared\n");	
					}
	}
;

%%

extern char* yytext;

int yywrap() {
	return 1;
}

yyerror(char* s) {
	printf("%s\n", s);
}

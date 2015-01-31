%{
#include <stdio.h>
#include <stdlib.h>
#include "json.h"
#include "printer.h"
#define YYDEBUG 1
  
%}

%union {
  char* str_value;
  int int_or_bool_value;
  double double_value;
  JSONPair *pair;
  JSONValue *value;
  JSONArray *array;
  JSONObject *obj;
}

%token <double_value> DOUBLE_LITERAL
%token <int_or_bool_value> INT_LITERAL
%token <str_value> STRING_LITERAL
%token <int_or_bool_value> BOOL_LITERAL

%token LB RB LC RC COMMA COLON

%type <obj> object_expression
%type <obj> pair_expression_list
%type <pair> pair_expression
%type <value> value_expression
%type <value> primary_expression
%type <array> expression_list
%type <array> array_expression

%%

object_expression
    : LC pair_expression_list RC
	{
	  print_object($2);
	  $$ = $2;
	  //	  printf("I am an object!!!");
	}
	;

pair_expression_list
    : pair_expression
	{
	  //printf("In pair_expression_list: ");	  
	  JSONObject* obj = malloc(sizeof(JSONObject));
	  obj->header = $1;
	  obj->header->next = NULL;
	  //obj->header->key = "I am a test";
	  
	  
	  //	  printf(" header: %s: ", obj.header->key);
	  //	  print_value(obj.header->value);
	  //	  printf("\n");

      $$ = obj;
	  //	  print_object(obj);
	}
	| pair_expression_list COMMA pair_expression
	{
	  //printf("In pair_expression_list1: ");
	  //	  printf(" %s -> %s \n",
	  //			 $1->header->key,
	  //			 $3->key);x-alternatives-map
	  //	  print_value($3->value);
	  //	  print_value($1->header->value);

	  $$ = append_pair($1, $3);
	  //	  JSONObject *temp = $1;
	  //	  print_object(temp);
	  //	  print_value($3->value);	  

	  //	  JSONPair *pair = $3;
	  //	  pair->next = temp->header;
	  //	  temp->header = pair;

	  //printf("In pair_expression_list2: ");
	  //	  printf(" %s -> %s \n", $1->header->key, $1->header->next->key);
	  
	  //	  $$ = temp;
	  //	  print_object($$);
	}
	;

pair_expression
    : STRING_LITERAL COLON value_expression
	{
	  //JSONPair pair = {$1, $3, NULL};
	  //	  pair.key = $1;
	  //pair.value = $3;
	  //	  $$ = &pair;	  
	  JSONPair *pair = malloc(sizeof(JSONPair));
	  pair->key = $1;
	  pair->value = $3;
	  pair->next = NULL;
	  $$ = pair;
	  

	  //	  printf("In pair_expression:  ");
	  //	  printf("%s -> ", $$->key);
	  //	  print_value($$->value);
	  //	  printf("\n");
	}
	;

array_expression
    : LB expression_list RB
	{
	  $$ = $2;
	  //	  printf("array_expression:");
	  //	  print_array($$);
	}
    ;

expression_list
    : value_expression
	{
	  JSONArray *array = malloc(sizeof(JSONArray));
	  array->header = $1;
	  $$ = array;
	  //	  printf("comes a json array! %p, %p\n", &array, array.header->next);
	  //	  print_array(&array);	  	  
	}
	| expression_list COMMA value_expression
	{
	  //	  printf("append %d to the array\n", $3->u.int_or_bool_value);
	  $$ = append_to_array($1, $3);
	  //	  append_to_array($1, $3);
	  //$$ = $1;
	  
	  //	  print_array($$);	  	  
	}
	;

value_expression
	: primary_expression
	{
	  $$ = $1;
	  //	  printf("In value_expression:  ");
	  //	  print_value($$);
	  //	  printf("\n");
	}
    | array_expression
	{
	  JSONValue *temp = malloc(sizeof(JSONValue));
	  temp->type = ARRAY;
	  temp->u.array_value = $1;
	  temp->next = NULL;
	  $$ = temp;
	}
    | object_expression
	{
	  JSONValue *val = malloc(sizeof(JSONValue));
	  val->type = OBJECT;
	  val->u.object_value = $1;
	  val->next = NULL;

	  $$ = val;
	}
	;

primary_expression
    : DOUBLE_LITERAL
	{
	  JSONValue *temp = malloc(sizeof(JSONValue));
	  temp->type = DOUBLE;
	  temp->u.double_value = $1;
	  temp->next = NULL;	  
	  $$ = temp;
	}
	| STRING_LITERAL
	{
	  JSONValue *temp = malloc(sizeof(JSONValue)); 
	  temp->type = STRING;
	  temp->u.str_value = $1;
	  temp->next = NULL;	  
	  $$ = temp;
	}
	| INT_LITERAL
	{
	  JSONValue *temp = malloc(sizeof(JSONValue)); 	  
	  temp->type = INT;
	  temp->u.int_or_bool_value = $1;
	  temp->next = NULL;	  
	  $$ = temp;
	}
	| BOOL_LITERAL
	{
	  JSONValue *temp = malloc(sizeof(JSONValue)); 	  	  
	  temp->type = BOOL;
	  temp->u.int_or_bool_value = $1;
	  temp->next = NULL;	  
	  $$ = temp;
	}
	;

%%

int
yyerror(char const *str)
{
    extern char *yytext;
    fprintf(stderr, "parser error near %s\n", yytext);
    return 0;
}

int main(int argc, char **argv)
{
    extern int yyparse(void);
    extern FILE *yyin;

	FILE *fp;
	if (argc > 1)
    {
	  fp = fopen(argv[1], "r");
	  yyin = fp;
    }
	else
    {
      yyin = stdin;		
    }

    if (yyparse()) {
        fprintf(stderr, "Error ! Error ! Error !\n");
        exit(1);
    }
}

%{
#include <stdio.h>
#include <stdlib.h>
#include "json.h"
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
	  $$ = $2;
	  JSONObject *obj = get_current_object();
    	obj->header = $$->header;
	}
	;

pair_expression_list
    : pair_expression
	{
	  JSONObject* obj = malloc(sizeof(JSONObject));
	  obj->header = $1;
	  obj->header->next = NULL;
      $$ = obj;
	}
	| pair_expression_list COMMA pair_expression
	{
	  $$ = append_pair($1, $3);
	}
	;

pair_expression
    : STRING_LITERAL COLON value_expression
	{
	  JSONPair *pair = malloc(sizeof(JSONPair));
	  pair->key = $1;
	  pair->value = $3;
	  pair->next = NULL;
	  $$ = pair;
	}
	;

array_expression
    : LB expression_list RB
	{
	  $$ = $2;
	}
    ;

expression_list
    : value_expression
	{
	  JSONArray *array = malloc(sizeof(JSONArray));
	  array->header = $1;
	  $$ = array;
	}
	| expression_list COMMA value_expression
	{
	  $$ = append_to_array($1, $3);
	}
	;

value_expression
	: primary_expression
	{
	  $$ = $1;
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
#include "json.h"
int
yyerror(char const *str)
{
    extern char *yytext;
    fprintf(stderr, "parser error near %s\n", yytext);
    return 0;
}

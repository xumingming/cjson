%{
#include <stdio.h>
#include "json.h"
#include "y.tab.h"


int
yywrap(void)
{
    return 1;
}

static char buffer[1024];
static int curr_size = 0;
void
open_string_literal()
{
  //  printf("open string literal\n");
  for (int i = 0; i < 1024; i++)
  {
	buffer[i] = '\0';
  }		 
  curr_size = 0;
}

void
append_char(char x)
{
//  printf("append char: %c\n", x);
  buffer[curr_size] = x;
  curr_size++;
}

char *
close_string_literal()
{
//  printf("close string literal\n");
  buffer[curr_size] = '\0';
  char *ret;
  ret = malloc(curr_size);
  memcpy(ret, buffer, curr_size);
//  printf("str: %s\n", ret);
  return ret;
}

%}

%start STRING_LITERAL_STATE
%%
<INITIAL>","    return COMMA;
<INITIAL>":"    return COLON;
<INITIAL>"{"    return LC;
<INITIAL>"}"    return RC;
<INITIAL>"["    return LB;
<INITIAL>"]"    return RB;
<INITIAL>\" {
  open_string_literal();
  BEGIN STRING_LITERAL_STATE;
}

<STRING_LITERAL_STATE>\" {
  char* str = close_string_literal();
  yylval.str_value = str;
  BEGIN INITIAL;
  return STRING_LITERAL;
}

<STRING_LITERAL_STATE>. {
  append_char(yytext[0]);
}

(true|false) {
  if (!strcmp("true", yytext)) 
  {
    yylval.int_or_bool_value = 1;
  }
  else 
  {
    yylval.int_or_bool_value = 0;
  }

  return BOOL_LITERAL;
}

([0-9]+\.[0-9]+) {
  double temp;
  sscanf(yytext, "%lf", &temp);
  yylval.double_value = temp;
  return DOUBLE_LITERAL;
}

([1-9][0-9]*)|0 {
  int temp;
  sscanf(yytext, "%d", &temp);
  yylval.int_or_bool_value = temp;
  return INT_LITERAL;
}


[ \t] ;

%%

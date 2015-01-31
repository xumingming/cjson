#include "json.h"

void
set_current_object(JSONObject *obj) {
  object = obj;
}

JSONObject *
get_current_object() {
  return object;
}

JSONObject*
create_object() {
  JSONObject *ret = malloc(sizeof(JSONObject));
  ret->header = NULL;
  set_current_object(ret);
  return ret;
}

void
print_value(JSONValue *value) {
  switch(value->type) {
  case INT:
	printf("%d", value->u.int_or_bool_value);
	break;
  case DOUBLE:
	printf("%lf", value->u.double_value);
	break;
  case STRING:
	printf("\"%s\"", value->u.str_value);
	break;
  case ARRAY:
	print_array(value->u.array_value);
	break;
  case OBJECT:
	print_object(value->u.object_value);
	break;
  default: {
	char *actual_value = "false";
	  
	if (value->u.int_or_bool_value == 1) {
	  actual_value = "true";
	}
	printf("%s", actual_value);
	break;
  }
  }
}

JSONArray *
append_to_array(JSONArray *array, JSONValue *value) {
  JSONValue *pos;
  for (pos = array->header; pos->next; pos = pos->next)
	;
  pos->next = value;  
  return array;
}
  
JSONObject *
append_pair(JSONObject *obj, JSONPair *pair) {
  JSONPair *pos;
  for (pos = obj->header; pos->next; pos = pos->next)
	;

  pos->next = pair;
  return obj;
}
  
void
print_array(JSONArray *array) {
  JSONValue *pos;
  printf("[");
  for (pos = array->header; pos != NULL; pos = pos->next) {
	printf("%d", pos->u.int_or_bool_value);
	if (pos->next) {
	  printf(", ");
	}
  }
  printf("]");
}

void print_pair(JSONPair *pair) {
  printf("\"%s\": ", pair->key);
  print_value(pair->value);
}

void print_indent() {
  for (int i = 0; i < tab_count; i++) {
	printf("    ");
  }
}

void
print_object(JSONObject *obj) {
  tab_count += 1;
  JSONPair *pos = NULL;
  printf("{\n");	
  for (pos = obj->header; pos != NULL; pos = pos->next) {
	print_indent();
	print_pair(pos);
	if (pos->next != NULL) {
	  printf(",");
	}
   	printf("\n");
  }
  tab_count -= 1;
  print_indent();	
  printf("}");	
}

void
compile(JSONObject *obj, FILE *fp) {
    extern int yyparse(void);
    extern FILE *yyin;
	yyin = fp;
	  
    if (yyparse()) {
        fprintf(stderr, "Error ! Error ! Error !\n");
        exit(1);
    }
}

void
interpret(JSONObject *obj) {
  print_object(obj);
}

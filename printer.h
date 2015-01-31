#ifndef PRINTER_H
#define PRINTER_H

#include <stdlib.h>
#include <stdio.h>

static JSONObject *json;
static int tab_count = 0;

void print_array(JSONArray *arr);
void print_object(JSONObject *obj);

void
  print_value(JSONValue *value) {
	//	printf("the value is type of %d", 1);
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
  
  JSONArray *
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
  
  void
  print_object(JSONObject *obj) {
	tab_count += 1;
	JSONPair *pos = NULL;
    printf("{\n");	
	for (pos = obj->header; pos != NULL; pos = pos->next) {
	  for (int i = 0; i < tab_count; i++) {
		printf("\t");
	  }
	  
	  print_pair(pos);
	  if (pos->next != NULL) {
		printf(",");
	  }
	  printf("\n");
	}
	tab_count -= 1;
	  for (int i = 0; i < tab_count; i++) {
		printf("\t");
	  }
    printf("}\n");	
  }

#endif

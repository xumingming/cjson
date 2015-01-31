#ifndef JSON_H
#define JSON_H

#include <stdio.h>
#include <stdlib.h>
typedef enum {
  INT,
  BOOL,
  DOUBLE,	
  STRING,
  ARRAY,
  OBJECT
} ValueType;
  
typedef struct JSONValue_tag {
  ValueType type;
  union {
	int int_or_bool_value;
	double double_value;
	char *str_value;
	struct JSONArray_tag *array_value;
	struct JSONObject_tag *object_value;
  } u;
  struct JSONValue_tag *next;
} JSONValue;

typedef struct JSONArray_tag {
  JSONValue *header;
} JSONArray;

typedef struct JSONPair_tag {
  char *key;
  JSONValue *value;
  struct JSONPair_tag *next;
} JSONPair;

typedef struct JSONObject_tag {
  JSONPair *header;
} JSONObject;

static JSONObject *object = NULL;
static int tab_count = 0;

void print_array(JSONArray *arr);
void print_object(JSONObject *obj);
void set_current_object(JSONObject *obj);
JSONObject* get_current_object();
JSONObject* create_object();
void print_value(JSONValue *value);
JSONArray* append_to_array(JSONArray *array, JSONValue *value);
JSONObject* append_pair(JSONObject *obj, JSONPair *pair) ;
void print_array(JSONArray *array) ;
void print_pair(JSONPair *pair) ;
void print_indent() ;
void print_object(JSONObject *obj) ;
void compile(JSONObject *obj, FILE *fp);
void interpret(JSONObject *obj);

#endif /* JSON_H */

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

#endif /* JSON_H */

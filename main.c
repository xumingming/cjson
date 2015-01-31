#include <stdio.h>
#include <stdlib.h>
#include "json.h"

int
main(int argc, char **argv) {
  	FILE *fp;
	if (argc > 1)
    {
	  fp = fopen(argv[1], "r");
    }
	else
    {
      fp = stdin;		
    }

	JSONObject *obj = create_object();
	compile(obj, fp);
	interpret(obj);
}

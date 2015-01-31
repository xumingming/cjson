bison --yacc -dv json.y && flex json.l && cc -o json -g y.tab.c lex.yy.c

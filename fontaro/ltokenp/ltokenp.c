/*
* ltokenp.c
* Lua token processor
* Luiz Henrique de Figueiredo <lhf@tecgraf.puc-rio.br>
* 03 May 2016 23:18:51
* This code is hereby placed in the public domain.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

#include "ltokenp.h"

static const char* progname="ltokenp";	/* actual program name */
int FILTERING=0;			/* read by proxy.c */

static void fatal(const char* message)
{
 fprintf(stderr,"%s: %s\n",progname,message);
 exit(EXIT_FAILURE);
}

static void load(lua_State *L, const char *file, int filter)
{
 int rc;
 if (file!=NULL && strcmp(file,"-")==0) file=NULL;
 FILTERING=filter;
 if (filter)
  rc=luaL_loadfile(L,file);
 else
  rc=luaL_dofile(L,file);
 if (rc!=0) fatal(lua_tostring(L,-1));
 lua_settop(L,0);
}

static int uzado(const char *programnomo)
{
   printf("uzado: %s -s filtro.lua programo.lupa aliprogramo.lupa ktp\n", programnomo); 
   return EXIT_SUCCESS;
}

int main(int argc, char* argv[])
{
 if(argc < 2)
     return uzado(argv[0]);

 lua_State *L=luaL_newstate();
 if (argv[0]!=NULL && *argv[0]!=0) progname=argv[0];
 if (L==NULL) fatal("not enough memory for state");
 luaL_openlibs(L);
 lua_getglobal(L,"print");
 lua_setglobal(L,FILTER);
 while (*++argv!=NULL)
 {
  if (strcmp(*argv,"-s")==0)
   load(L,*++argv,0);
  else
   load(L,*argv,1);
 }
 lua_close(L);
 return EXIT_SUCCESS;
}

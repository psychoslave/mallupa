/*
* proxy.c
* token filter for ltokenp for Lua 5.3
* Luiz Henrique de Figueiredo <lhf@tecgraf.puc-rio.br>
* 03 May 2016 23:13:27
* This code is hereby placed in the public domain.
*/

#include "ltokenp.h"

#if LUA_VERSION_NUM < 503
#define TK_INT	-1
#define TK_FLT	TK_NUMBER
#endif

static int filter(LexState *X, SemInfo *seminfo)
{
 lua_State *L=X->L;
 lua_getglobal(L,FILTER);
 lua_pushinteger(L,0);
 lua_pushinteger(L,-1);
 lua_pushstring(L,"<file>");
 lua_pushstring(L,getstr(X->source));
 lua_call(L,4,0);
 for (;;)
 {
  int t=llex(X,seminfo);
  lua_getglobal(L,FILTER);
  lua_pushinteger(L,X->linenumber);
  lua_pushinteger(L,t);
  if (t<FIRST_RESERVED)
  {
   char s[2]= {t,0};
   lua_pushstring(L,s);
  }
  else
   lua_pushstring(L,luaX_tokens[t-FIRST_RESERVED]);
  switch (t)
  {
    case TK_STRING:
    case TK_NAME:
     lua_pushstring(L,getstr(seminfo->ts));
     break;
    case TK_INT:
    case TK_FLT:
     lua_pushstring(L,X->buff->buffer);
     break;
    default:
     lua_pushvalue(L,-1);
     break;
  }
  lua_call(L,4,0);
  if (t==TK_EOS) return t;
 }
}

static int nexttoken(LexState *X, SemInfo *seminfo)
{
 if (FILTERING)
  return filter(X,seminfo);
 else
  return llex(X,seminfo);
}

#define llex nexttoken

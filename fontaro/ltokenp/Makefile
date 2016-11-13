# makefile for ltokenp

# change these to reflect your Lua installation
LUA= ../lua-5.3.3/
LUAINC= $(LUA)/src
LUALIB= $(LUA)/src
LUASRC= $(LUA)/src

# no need to change anything below here
CC= gcc -std=gnu99
CFLAGS= $(INCS) $(WARN) -O2 $G
WARN= -O2 -Wall -Wextra

INCS= -I$(LUAINC)
LIBS= -L$(LUALIB) -llua -lm -ldl

MYNAME= ltokenp
MYLIB= $(MYNAME)
T= $(MYNAME)
OBJS= $(MYNAME).o llex.o
TEST= test.lua

all:	test

test:	$T
	./$T -s strip.lua strip.lua

$T:	$(OBJS)
	$(CC) -o $@ $(OBJS) $(LIBS)

llex.c:
	sed '/void luaX_next/{h;s/.*/#include "proxy.c"/;p;g;}' $(LUASRC)/$@ > $@

llex.o:	proxy.c

clean:
	-rm -f $(OBJS) core core.* a.out $(MYNAME)

# eof

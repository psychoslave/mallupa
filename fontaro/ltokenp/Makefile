# makefile for ltokenp

# change these to reflect your Lua installation
LUA= ../lua-5.3.3/
LUAINC= $(LUA)/src
LUALIB= $(LUA)/src
LUASRC= $(LUA)/src

# == CHANGE THE SETTINGS BELOW TO SUIT YOUR ENVIRONMENT =======================

# Your platform. See PLATS for possible values.
PLAT= none

# Lua version and release.
V= 5.3
R= $V.3
# Where to install. The installation starts in the src and doc directories,
# so take care if INSTALL_TOP is not an absolute path. See the local target.
# You may want to make INSTALL_LMOD and INSTALL_CMOD consistent with
# LUA_ROOT, LUA_LDIR, and LUA_CDIR in luaconf.h.
INSTALL_TOP= /usr/local
INSTALL_BIN= $(INSTALL_TOP)/bin
INSTALL_INC= $(INSTALL_TOP)/include
INSTALL_LIB= $(INSTALL_TOP)/lib
INSTALL_MAN= $(INSTALL_TOP)/man/man1
INSTALL_LMOD= $(INSTALL_TOP)/share/lua/$V
INSTALL_CMOD= $(INSTALL_TOP)/lib/lua/$V

# How to install. If your install program does not support "-p", then
# you may have to run ranlib on the installed liblua.a.
INSTALL= install -p
INSTALL_EXEC= $(INSTALL) -m 0755
INSTALL_DATA= $(INSTALL) -m 0644
#
# If you don't have "install" you can use "cp" instead.
# INSTALL= cp -p
# INSTALL_EXEC= $(INSTALL)
# INSTALL_DATA= $(INSTALL)

# Other utilities.
MKDIR= mkdir -p
RM= rm -f
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

# What to install.
TO_BIN= $(MYNAME)
#TO_INC= 
#TO_LIB= 
#TO_MAN= 
MALLUPTEKO= mallupe.lua
TO_LMOD= ../${MALLUPTEKO}

all:	test

test:	$T
	./$T -s strip.lua strip.lua

$T:	$(OBJS)
	$(CC) -o $@ $(OBJS) $(LIBS)

llex.c:
	sed '/void luaX_next/{h;s/.*/#include "proxy.c"/;p;g;}' $(LUASRC)/$@ > $@

llex.o:	proxy.c

clean:
	-rm -f $(OBJS) core core.* a.out $(MYNAME) llex.c


install: dummy
	$(MKDIR) $(INSTALL_BIN) $(INSTALL_INC) $(INSTALL_LIB) $(INSTALL_MAN) $(INSTALL_LMOD) $(INSTALL_CMOD)
	$(INSTALL_EXEC) $(TO_BIN) $(INSTALL_BIN)
	#$(INSTALL_DATA) $(TO_INC) $(INSTALL_INC)
	#$(INSTALL_DATA) $(TO_LIB) $(INSTALL_LIB)
	#$(INSTALL_DATA) $(TO_MAN) $(INSTALL_MAN)
	$(INSTALL_DATA) $(TO_LMOD) $(INSTALL_LMOD)
	echo -e "#!/bin/sh\n${MYNAME} -s ${INSTALL_LMOD}/${MALLUPTEKO}" '$$@ | lua' >mallupe
	$(INSTALL_EXEC) mallupe $(INSTALL_BIN)

uninstall:
	cd $(INSTALL_BIN) && $(RM) $(TO_BIN)
	#cd $(INSTALL_INC) && $(RM) $(TO_INC)
	#cd $(INSTALL_LIB) && $(RM) $(TO_LIB)
	#cd $(INSTALL_MAN) && $(RM) $(TO_MAN)
	cd $(INSTALL_LMOD) && $(RM) $(TO_LMOD) 


# make may get confused with test/ and install/
dummy:

# eof

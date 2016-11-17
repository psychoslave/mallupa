# Targets start here.
all:
	cd fontaro/ltokenp && $(MAKE) $@

install:
	cd fontaro/ltokenp && $(MAKE) $@

$(PLATS) clean:
	cd fontaro/ltokenp && $(MAKE) $@

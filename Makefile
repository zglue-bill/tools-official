#!/usr/bin/make -f
# See debhelper(7) (uncomment to enable)
# output every command that modifies files on the build system.
export DH_VERBOSE = 1
KCONF_FRONT     = kconfig-frontends

define CHK_ACLOCAL
        grep generated.*aclocal aclocal.m4 | sed -e 's:^.*  *aclocal::' -e 's: .*::'
        if [ $(grep generated.*aclocal aclocal.m4 | sed -e 's:^.*  *aclocal::' -e 's: .*::')   \
        != $(aclocal --version | head -1 | sed -e 's:  *.*$:') ] ; then aclocal ; fi
endef

# see FEATURE AREAS in dpkg-buildflags(1)
export DEB_BUILD_MAINT_OPTIONS = hardening=+all

# see ENVIRONMENT in dpkg-buildflags(1)
# package maintainers to append CFLAGS
#export DEB_CFLAGS_MAINT_APPEND  = -Wall -pedantic
# package maintainers to append LDFLAGS
#export DEB_LDFLAGS_MAINT_APPEND = -Wl,--as-needed

.PHONY: distclean clean makefile_chk

tools:
	@cd $(KCONF_FRONT) && ./configure --enable-mconf
	@$(MAKE) -C $(KCONF_FRONT)

autofix:
	 cd $(KCONF_FRONT) && $(call CHK_ACLOCAL)
#	@cd $(KCONF_FRONT) && aclocal
#	@cd $(KCONF_FRONT) && aclocal && automake && autoconf

makefile_chk:
	@[ -f $(KCONF_FRONT)/Makefile ] || (echo "No Makefile found." && false)

install: makefile_chk
	@$(MAKE) DESTDIR=/home/hover -C $(KCONF_FRONT) install

clean: makefile_chk
	@$(MAKE) -C $(KCONF_FRONT) $@

distclean: makefile_chk
	@echo "====================="
	@cd $(KCONF_FRONT) && rm Makefile config.status config.log

# dh_make generated override targets
# This is example for Cmake (See https://bugs.debian.org/641051 )
#override_dh_auto_configure:
#	dh_auto_configure -- #	-DCMAKE_LIBRARY_PATH=$(DEB_HOST_MULTIARCH)


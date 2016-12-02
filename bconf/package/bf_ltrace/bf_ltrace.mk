################################################################################
#
# ltrace
#
################################################################################

BF_LTRACE_VERSION = c22d359433b333937ee3d803450dc41998115685
BF_LTRACE_SITE =  https://alioth.debian.org/anonscm/git/collab-maint/ltrace.git
BF_LTRACE_SITE_METHOD = git
BF_LTRACE_DEPENDENCIES = elfutils
BF_LTRACE_CONF_OPTS = --disable-werror
BF_LTRACE_LICENSE = GPLv2
BF_LTRACE_LICENSE_FILES = COPYING
BF_LTRACE_AUTORECONF = YES

define BF_LTRACE_CREATE_CONFIG_M4
	mkdir -p $(@D)/config/m4
endef
BF_LTRACE_POST_PATCH_HOOKS += BF_LTRACE_CREATE_CONFIG_M4

# ltrace can use libunwind only if libc has backtrace() support
# We don't normally do so for uClibc and we can't know if it's external
# Also ltrace with libunwind support is broken for MIPS so we disable it
ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC)$(BR2_mips)$(BR2_mipsel),)
# --with-elfutils only selects unwinding support backend. elfutils is a
# mandatory dependency regardless.
BF_LTRACE_CONF_OPTS += --with-libunwind=yes --with-elfutils=no
BF_LTRACE_DEPENDENCIES += libunwind
else
BF_LTRACE_CONF_OPTS += --with-libunwind=no
endif
endif

$(eval $(autotools-package))

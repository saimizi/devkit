LIBIPCON_VERSION = master
LIBIPCON_SITE = https://github.com/saimizi/libipcon.git
LIBIPCON_SITE_METHOD = git
LIBIPCON_INSTALL_STAGING = YES
LIBIPCON_INSTALL_TARGET = YES
LIBIPCON_AUTORECONF= YES

LIBIPCON_DEPENDENCIES= host-automake host-autoconf libnl

define LIBIPCON_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

define LIBIPCON_CREATE_M4
	[ ! -d $(@D)/m4 ] && mkdir -p $(@D)/m4 || true
endef

LIBIPCON_POST_PATCH_HOOKS += LIBIPCON_CREATE_M4

$(eval $(autotools-package))


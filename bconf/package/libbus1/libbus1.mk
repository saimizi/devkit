LIBBUS1_SITE = https://github.com/bus1/libbus1.git 
LIBBUS1_VERSION = master
LIBBUS1_SITE_METHOD = git
LIBBUS1_INSTALL_STAGING = YES
LIBBUS1_INSTALL_TARGET = YES
LIBBUS1_AUTORECONF= YES

IPCON_DEPENDENCIES= host-automake host-autoconf libnl

define LIBBUS1_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

define LIBBUS1_CREATE_M4
	[ ! -d $(@D)/build/m4 ] && mkdir -p $(@D)/build/m4
endef

LIBBUS1_POST_PATCH_HOOKS += LIBBUS1_CREATE_M4

$(eval $(autotools-package))


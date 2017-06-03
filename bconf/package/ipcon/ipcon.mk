IPCON_VERSION = master
IPCON_SITE = https://github.com/saimizi/ipcon2.git
IPCON_SITE_METHOD = git
IPCON_INSTALL_STAGING = NO
IPCON_INSTALL_TARGET = YES
IPCON_AUTORECONF= YES

IPCON_DEPENDENCIES= host-automake host-autoconf libnl

define IPCON_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

define IPCON_CREATE_M4
	[ ! -d $(@D)/m4 ] && mkdir -p $(@D)/m4 || true
endef

IPCON_POST_PATCH_HOOKS += IPCON_CREATE_M4


IPCON_DRV_OPTS= $(LINUX_MAKE_FLAGS)

IPCON_CONF_OPTS += --with-ksrc=$(LINUX_DIR)
IPCON_MAKE_OPTS += $(IPCON_DRV_OPTS)
IPCON_INSTALL_TARGET_OPTS = $(IPCON_DRV_OPTS) DESTDIR=$(TARGET_DIR) install

$(eval $(autotools-package))


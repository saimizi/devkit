NETMGR_VERSION = master
NETMGR_SITE = $(BR2_BF_GIT_SERVER)/netmgr.git
NETMGR_SITE_METHOD = gitj

define NETMGR_BUILD_CMDS
	 $(MAKE) CROSS_COMPILE=$(TARGET_CROSS) -C $(@D)
endef


define NETMGR_INSTALL_TARGET_CMDS
	$(INSTALL) -C $(@D)/netmgr $(TARGET_DIR)/usr/bin/
endef

define NETMGR_CLEAN_CMDS
	$(MAKE) -C $(@D)/	clean
endef


$(eval $(generic-package))

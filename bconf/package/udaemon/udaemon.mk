UDAEMON_VERSION = master
UDAEMON_SITE = $(BR2_BF_GIT_SERVER)/udaemon.git
UDAEMON_SITE_METHOD = gitj

define UDAEMON_BUILD_CMDS
	 $(MAKE) CC=$(TARGET_CC) -C $(@D)
endef


define UDAEMON_INSTALL_TARGET_CMDS
	install -d  $(TARGET_DIR)/usr/local/bin/
	install -m 0755 $(@D)/udaemon $(TARGET_DIR)/usr/local/bin/
endef

$(eval $(generic-package))

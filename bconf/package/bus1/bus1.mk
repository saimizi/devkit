BUS1_SITE = https://github.com/bus1/bus1.git 
BUS1_VERSION = master
BUS1_SITE_METHOD = git

define BUS1_BUILD_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) KERNELDIR=$(LINUX_DIR) -C $(@D)
endef


define BUS1_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/extra
	$(INSTALL) `find $(@D) -name "*.ko"` $(TARGET_DIR)/lib/modules/$(LINUX_VERSION)/extra
endef

define BUS1_CLEAN_CMDS
	$(MAKE) -C $(@D)/ clean
endef


$(eval $(generic-package))

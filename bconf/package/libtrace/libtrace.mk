LIBTRACE_VERSION = master
LIBTRACE_SITE = $(BR2_BF_GIT_SERVER)/libtrace.git
LIBTRACE_SITE_METHOD = gitj
LIBTRACE_INSTALL_STAGING = YES

define LIBTRACE_BUILD_CMDS
	 $(MAKE) CC=$(TARGET_CC) -j1 -C $(@D)
endef

define LIBTRACE_INSTALL_STAGING_CMDS
	ROOTFS=$(STAGING_DIR) make install -C $(@D)
endef

define LIBTRACE_INSTALL_TARGET_CMDS
	install -d $(TARGET_DIR)/usr/local/lib/
	cp -d $(@D)/libtrace.so* $(TARGET_DIR)/usr/local/lib/
	install -d $(TARGET_DIR)/usr/local/bin/
	install -m 0755 $(@D)/test/trace_test $(TARGET_DIR)/usr/local/bin/
endef

$(eval $(generic-package))

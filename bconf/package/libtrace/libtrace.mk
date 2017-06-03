LIBTRACE_VERSION = master
LIBTRACE_SITE = https://github.com/saimizi/libtrace.git
LIBTRACE_SITE_METHOD = git
LIBTRACE_INSTALL_STAGING = YES

define LIBTRACE_BUILD_CMDS
	 $(MAKE) CC=$(TARGET_CC) -j1 -C $(@D)
endef

define LIBTRACE_INSTALL_STAGING_CMDS
	install -d $(STAGING_DIR)/usr/lib/
	cp -d $(@D)/libtrace.so* $(STAGING_DIR)/usr/lib/
	install -d $(STAGING_DIR)/usr/include/
	install -m 0644 $(@D)/libtrace.h $(STAGING_DIR)/usr/include
endef

define LIBTRACE_INSTALL_TARGET_CMDS
	install -d $(TARGET_DIR)/usr/lib/
	cp -d $(@D)/libtrace.so* $(TARGET_DIR)/usr/lib/
	install -d $(TARGET_DIR)/usr/bin/
	install -m 0755 $(@D)/test/trace_test $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))

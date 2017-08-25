################################################################################
# Linux ipcon extensions
#
# Patch the linux kernel with ipcon extension
################################################################################

LINUX_EXTENSIONS += ipcon_driver

define IPCON_DRIVER_PREPARE_KERNEL
	rm -fr $(LINUX_DIR)/net/netlink/ipcon 2>/dev/null || true
	ln -s $(IPCON_DRIVER_DIR) $(LINUX_DIR)/net/netlink/ipcon
endef

define ADD_PATCH_TO_SETUP_IPCON_DRIVER
	$(APPLY_PATCHES) $(@D)  $(LINUX_PKGDIR)ipcon_driver/ *.patch
endef
LINUX_POST_PATCH_HOOKS += ADD_PATCH_TO_SETUP_IPCON_DRIVER

BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES += $(LINUX_PKGDIR)ipcon_driver/ipcon.cfg

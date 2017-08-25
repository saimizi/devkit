################################################################################
# Linux ipcon extensions
#
# Patch the linux kernel with ipcon extension
################################################################################

LINUX_EXTENSIONS += ipcon_driver

define IPCON_DRIVER_PREPARE_KERNEL
	mkdir -p $(LINUX_DIR)/net/netlink/ipcon
	cp -dpfr $(IPCON_DRIVER_DIR)/* $(LINUX_DIR)/net/netlink/ipcon/
endef

define IPCON_DRIVER_PATCH
	$(APPLY_PATCHES) $(@D)  $(LINUX_PKGDIR)ipcon_driver/ *.patch
endef
LINUX_POST_PATCH_HOOKS += IPCON_DRIVER_PATCH

BR2_LINUX_KERNEL_CONFIG_FRAGMENT_FILES += $(LINUX_PKGDIR)ipcon_driver/ipcon.cfg

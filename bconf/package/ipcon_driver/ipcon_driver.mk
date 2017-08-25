IPCON_DRIVER_VERSION = master
IPCON_DRIVER_SITE = https://github.com/saimizi/ipcon-drv.git
IPCON_DRIVER_SITE_METHOD = git

ifeq ($(IPCON_DRIVER_VERSION),master)
IPCON_DRIVER_POST_EXTRACT_HOOKS += GIT_PULL_TO_CURRENT
endif

$(eval $(generic-package))


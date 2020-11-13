ifneq ($(KERNELRELEASE),)

obj-m := demo.o
demo-objs := demo_core.o demo_dev.o demo_interface.o demo_proc.o demo_sysfs.o

obj-m += xxx_demo_driver.o

obj-m += xxx_demo_device.o

else

MDIR      := $(PWD)
KDIR      ?= /lib/modules/$(shell uname -r)/build
ARCH      ?= $(shell uname -m | sed -e s/arm.*/arm/ -e s/aarch64.*/arm64/)
HOST_ARCH ?= $(shell uname -m | sed -e s/arm.*/arm/ -e s/aarch64.*/arm64/)
CROSS_COMPILE ?= aarch64-linux-gnu-

ifneq  ($(HOST_ARCH), arm)
  ifeq ($(ARCH), arm)
   CROSS_COMPILE ?= arm-linux-gnueabihf-
 endif
endif
ifneq  ($(HOST_ARCH), arm64)
  ifeq ($(ARCH), arm64)
   CROSS_COMPILE ?= aarch64-linux-gnu-
  endif
endif

ifeq ($(HOST_ARCH),$(ARCH))
CROSS_COMPILE :=
endif

modules:
	$(MAKE) -C $(KDIR) M=$(MDIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules

modules_install:
	$(MAKE) -C $(KDIR) M=$(MDIR) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) modules_install

clean:
	$(MAKE) -C $(KDIR) M=$(MDIR) clean
	@rm -f *.o.ur-safe

endif
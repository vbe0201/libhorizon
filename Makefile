SOURCE_ROOT := .
BUILD_DIR := $(SOURCE_ROOT)/build

LIBHORIZON_BUILD := $(realpath .)/deps

ifeq ($(shell id -u),0)
	$(error "This script must not be run as root")
endif

include libhorizon.mk

export CC
export CXX
export LD
export AR
export AS
export RANLIB
export LD_FOR_TARGET = $(LD)
export CC_FOR_TARGET = $(CC)
export AR_FOR_TARGET = $(AR)
export AS_FOR_TARGET = $(AS) -arch=arm -mattr=+neon
export RANLIB_FOR_TARGET = $(RANLIB)
export CFLAGS_FOR_TARGET = $(CC_FLAGS) -Wno-unused-command-line-argument -Wno-error-implicit-function-declaration

.SUFFIXES:
.SECONDARY:

.PHONY: default

default:

include mk/newlib.mk

DEPS := $(DEP_NEWLIB)

.PHONY: dist

deps: $(DEPS)

clean:

cleandeps:
	@rm -rf $(BUILD_DIR)
	@rm -rf $(LIBHORIZON_BUILD)

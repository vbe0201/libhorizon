# Brew doesn't install LLVM/Clang to a global place on macOS.
ifeq ($(shell uname -s),Darwin)
	ifeq ($(shell brew --prefix llvm),)
		$(error LLVM needs to be installed via brew)
	else
		LLVM_CONFIG := $(shell brew --prefix llvm)/bin/llvm-config
	endif
else
	LLVM_CONFIG := llvm-config$(LLVM_POSTFIX)
endif

LLVM_BINDIR := $(shell $(LLVM_CONFIG) --bindir)
ifeq ($(LLVM_BINDIR),)
	$(error llvm-config needs to be installed)
endif

CC := $(LLVM_BINDIR)/clang
CXX := $(LLVM_BINDIR)/clang++
LD := $(LLVM_BINDIR)/ld.lld
AR := $(LLVM_BINDIR)/llvm-ar
AS := $(LLVM_BINDIR)/llvm-mc
RANLIB := $(LLVM_BINDIR)/llvm-ranlib

SYS_INCLUDES := -isystem $(LIBHORIZON_BUILD)/include/
CPP_INCLUDES := -isystem $(LIBHORIZON_BUILD)/include/c++/v1/

PKG_CONFIG_SYSROOT_DIR = $(LIBHORIZON_BUILD)

LD_FLAGS := -Bsymbolic \
	--shared \
	--gc-sections \
	--eh-frame-hdr \
	--no-undefined \
	-L $(LIBHORIZON_BUILD)/lib/

LD_SHARED_LIBRARY_FLAGS := --shared \
	--gc-sections \
	--eh-frame-hdr \
	-L $(LIBHORIZON_BUILD)/lib/ \
	-Bdynamic

CC_FLAGS := -g -fPIC -fexceptions -fuse-ld=lld -fstack-protector-strong -O3 -mfloat-abi=hard -mtp=soft -target arm-none-linux-gnu -nostdlib -nostdlibinc $(SYS_INCLUDES) -D_3DS=1 -Wno-unused-command-line-argument
CXX_FLAGS := $(CPP_INCLUDES) $(CC_FLAGS) -std=c++17 -stdlib=libc++ -nodefaultlibs -nostdinc++
AR_FLAGS := rcs
AS_FLAGS := -arch=arm -triple arm-none-3ds

# compatibility
CFLAGS := $(CC_FLAGS)
CXXFLAGS := $(CXX_FLAGS)

HORIZON_DEP_NEWLIB_LIBC := $(LIBHORIZON_BUILD)/lib/libc.a
LIBHORIZON_COMMON_LIB_DEPS := $(HORIZON_DEP_NEWLIB_LIBC)

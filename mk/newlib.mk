## newlib

$(BUILD_DIR)/newlib/Makefile:
	mkdir -p $(@D)
	cd $(@D); $(realpath $(SOURCE_ROOT))/newlib/configure --disable-multilib --disable-libm --without-libm --target=arm-3ds-eabi --without-rdimon --prefix=$(LIBHORIZON_BUILD)

$(LIBHORIZON_BUILD)/lib/libc.a: $(BUILD_DIR)/newlib/Makefile
	$(MAKE) -C $(BUILD_DIR)/newlib/ && $(MAKE) -C $(BUILD_DIR)/newlib/ install

DEP_NEWLIB := $(LIBHORIZON_BUILD)/lib/libc.a

.PHONY: dep_newlib clean_newlib

dep_newlib: $(DEP_NEWLIB)

clean_newlib:
	@rm -rf $(BUILD_DIR)/newlib

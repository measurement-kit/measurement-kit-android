PHONIES += check dist download-and-verify help javah jni-libs
PHONIES += jni-libs-no-unpack unpack unpack-clean
.PHONY: $(PHONIES)

GPG2      = gpg2
JAVAH     = javah
NDK_BUILD = ndk-build
WGET      = wget

BASEURL   = https://github.com/measurement-kit/measurement-kit/releases/download
VERSION   = v0.1.0-beta.4
TAG       = -2-g17a7acb
INPUT     = measurement_kit-jni-$(VERSION)$(TAG).tar.bz2
OVERSION  = $$(git describe --tags)
OUTPUT    = measurement_kit-jni-libs-$(OVERSION).tar.bz2
PACKAGE   = io.github.measurement_kit.jni

ABIS      = arm64-v8a armeabi armeabi-v7a mips mips64 x86 x86_64

help:
	@printf "Targets:\n"
	@for TARGET in `grep ^PHONIES Makefile|sed 's/^PHONIES += //'`; do     \
	  if echo $$TARGET|grep -qv ^_; then                                   \
	    printf "  - $$TARGET\n";                                           \
	  fi;                                                                  \
	done

dist: jni-libs
	@echo "Creating $(OUTPUT)..."
	@tar -cjf $(OUTPUT) java jniLibs

jni-libs: unpack javah jni-libs-no-unpack

javah:
	@echo "Creating header files in jni using $(JAVAH)..."
	@cd jni && $(JAVAH) -cp ../java $(PACKAGE).sync.OoniSyncApi
	@cd jni && $(JAVAH) -cp ../java $(PACKAGE).sync.PortolanSyncApi
	@cd jni && $(JAVAH) -cp ../java $(PACKAGE).LoggerApi

jni-libs-no-unpack:
	$(NDK_BUILD) NDK_LIBS_OUT=./jniLibs

unpack: unpack-clean download-and-verify
	@echo "Unpack $(INPUT) inside jni"
	@tar xf $(INPUT)

unpack-clean:
	@echo "Cleanup jni dirs: $(ABIS)"
	@for ABI in $(ABIS); do                                                \
	  rm -rf jni/$$ABI/*;                                                  \
	done

download-and-verify: check $(INPUT) $(INPUT).asc
	$(GPG2) --verify $(INPUT).asc

check:
	@if [ -z "$$(which $(GPG2))" ]; then                                   \
	  echo "FATAL: install $(GPG2) or make sure it's in PATH" 1>&2;        \
	  exit 1;                                                              \
	fi
	@echo "Using $(GPG2): $$(which $(GPG2))"
	@if [ -z "$$(which $(JAVAH))" ]; then                                  \
	  echo "FATAL: install $(JAVAH) or make sure it's in PATH" 1>&2;       \
	  exit 1;                                                              \
	fi
	@echo "Using $(JAVAH): $$(which $(JAVAH))"
	@if [ -z "$$(which $(NDK_BUILD))" ]; then                              \
	  echo "FATAL: install $(NDK_BUILD) or make sure it's in PATH" 1>&2;   \
	  exit 1;                                                              \
	fi
	@echo "Using $(NDK_BUILD): $$(which $(NDK_BUILD))"
	@if [ -z "$$(which $(WGET))" ]; then                                   \
	  echo "FATAL: install $(WGET) or make sure it's in PATH" 1>&2;        \
	  exit 1;                                                              \
	fi
	@echo "Using $(WGET): $$(which $(WGET))"

$(INPUT):
	$(WGET) -q $(BASEURL)/$(VERSION)/$(INPUT)

$(INPUT).asc:
	$(WGET) -q $(BASEURL)/$(VERSION)/$(INPUT).asc

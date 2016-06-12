#!/bin/sh

NCPU=1
ARCH_LIST="armeabi x86 mips armeabi-v7a"

build() {

	ARCH=$1

	case $ARCH in
		x86) TOOLCHAIN=i686-linux-android;;
		mips) TOOLCHAIN=mipsel-linux-android;;
		*) TOOLCHAIN=arm-linux-androideabi;;
	esac

	make clean
	./setCrossEnvironment-$ARCH.sh make -j$NCPU || exit 1
	rm -rf android/$ARCH
	mkdir -p android/$ARCH
	env LDFLAGS=-pie ./setCrossEnvironment-$ARCH.sh sh -c '$STRIP upnpc-static' || exit 1
	mv -f upnpc-static android/$ARCH/upnpc || exit 1
}

for ARCH in $ARCH_LIST; do
	build $ARCH || exit 1
done

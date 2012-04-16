#!/bin/bash
#---------------------------------------------------------------------------------
# Check Parameters
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install sh4 binutils
#---------------------------------------------------------------------------------
mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
	CFLAGS=$cflags LDFLAGS=$ldflags ../../binutils-$BINUTILS_VER/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-shared --disable-debug \
	--disable-werror \
	--enable-poison-system-directories \
	--enable-plugins --enable-lto \
	--with-gnu-as --with-gcc --with-gnu-ld --disable-dependency-tracking \
	--disable-werror $CROSS_PARAMS \
	|| { echo "Error configuing sh4 binutils"; exit 1; }
	touch configured-binutils
fi

if [ ! -f built-binutils ]
then
	$MAKE || { echo "Error building sh4 binutils"; exit 1; }
	touch built-binutils
fi

if [ ! -f installed-binutils ]
then
	$MAKE install || { echo "Error installing sh4 binutils"; exit 1; }
	touch installed-binutils
fi

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
cd $BUILDDIR
mkdir -p $target/gcc-stage1
cd $target/gcc-stage1

if [ ! -f configured-gcc ]
then
	CFLAGS="$cflags" LDFLAGS="$ldflags" CFLAGS_FOR_TARGET="-m3 -mrenesas -O2" LDFLAGS_FOR_TARGET="" ../../gcc-$GCC_VER/configure \
	--enable-languages=c \
	--enable-lto $plugin_ld \
	--with-gcc --with-gnu-ld --with-gnu-as \
	--disable-nls --disable-shared --enable-threads --disable-multilib \
	--disable-win32-registry \
	--disable-libstdcxx-pch \
	--target=$target \
	--with-newlib \
	--without-headers \
	--prefix=$prefix\
	--disable-dependency-tracking \
	$CROSS_PARAMS \
	|| { echo "Error configuring gcc stage 1"; exit 1; }
	touch configured-gcc
fi

if [ ! -f built-gcc-stage1 ]
then
	$MAKE all-gcc || { echo "Error building gcc stage1"; exit 1; }
	touch built-gcc-stage1
fi

if [ ! -f installed-gcc-stage1 ]
then
	$MAKE install-gcc || { echo "Error installing gcc stage1"; exit 1; }
	touch installed-gcc-stage1
	rm -fr $INSTALLDIR/devkitSH4/$target/sys-include
fi

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
cd $BUILDDIR
mkdir -p $target/newlib
cd $target/newlib

unset CFLAGS
unset LDFLAGS

if [ ! -f configured-newlib ]
then
	../../newlib-$NEWLIB_VER/configure \
	--target=$target \
	--prefix=$prefix \
	--enable-newlib-mb \
	--disable-newlib-supplied-syscalls \
	|| { echo "Error configuring newlib"; exit 1; }
	touch configured-newlib
fi

if [ ! -f built-newlib ]
then
	$MAKE || { echo "Error building newlib"; exit 1; }
	touch built-newlib
fi
if [ ! -f installed-newlib ]
then
	$MAKE install || { echo "Error installing newlib"; exit 1; }
	touch installed-newlib
fi


#---------------------------------------------------------------------------------
# build and install the final compiler
#---------------------------------------------------------------------------------
cd $BUILDDIR
mkdir -p $target/gcc-stage2
cd $target/gcc-stage2

if [ ! -f configured-gcc ]
then
	CFLAGS="$cflags" LDFLAGS="$ldflags" CFLAGS_FOR_TARGET="-m3 -mrenesas -O2" LDFLAGS_FOR_TARGET="" ../../gcc-$GCC_VER/configure \
	--enable-languages=c \
	--enable-lto $plugin_ld \
	--with-gcc --with-gnu-ld --with-gnu-as \
	--disable-nls --disable-shared --enable-threads --disable-multilib \
	--disable-win32-registry \
	--disable-libstdcxx-pch \
	--target=$target \
	--with-newlib \
	--prefix=$prefix\
	--enable-poison-system-directories \
	--disable-dependency-tracking \
	--with-pkgversion="devkitSH4 release 1" \
	$CROSS_PARAMS \
	|| { echo "Error configuring gcc stage 2"; exit 1; }
	touch configured-gcc
fi

if [ ! -f built-gcc-stage2 ]
then
	$MAKE all || { echo "Error building gcc stage2"; exit 1; }
	touch built-gcc-stage2
fi

if [ ! -f installed-gcc-stage2 ]
then
	$MAKE install || { echo "Error installing gcc stage2"; exit 1; }
	touch installed-gcc-stage2
fi

#---------------------------------------------------------------------------------
# build and install the debugger
#---------------------------------------------------------------------------------
cd $BUILDDIR
mkdir -p $target/gdb
cd $target/gdb

if [ ! -f configured-gdb ]
then
	CFLAGS="$cflags" LDFLAGS="$ldflags" ../../gdb-$GDB_VER/configure \
	--disable-nls --prefix=$prefix --target=$target --disable-werror --disable-dependency-tracking\
	$CROSS_PARAMS || { echo "Error configuring gdb"; exit 1; }
	touch configured-gdb
fi

if [ ! -f built-gdb ]
then
	$MAKE || { echo "Error building gdb"; exit 1; }
	touch built-gdb
fi

if [ ! -f installed-gdb ]
then
	$MAKE install || { echo "Error installing gdb"; exit 1; }
	touch installed-gdb
fi



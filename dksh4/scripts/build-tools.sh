#!/bin/bash

cd $BUILDDIR

for archive in $hostarchives
do
	archive=`basename $archive`
	dir=$(echo $archive | sed -e 's/\(.*\)\.tar\.bz2/\1/' )
	cd $BUILDDIR/$dir
	if [ ! -f configured ]; then
		CXXFLAGS=$cflags CFLAGS=$cflags LDFLAGS=$ldflags ./configure --prefix=$toolsprefix --disable-dependency-tracking $CROSS_PARAMS || { echo "error configuring $archive"; exit 1; }
		touch configured
	fi
	if [ ! -f built ]; then
		$MAKE || { echo "error building $archive"; exit 1; }
		touch built
	fi
	if [ ! -f installed ]; then
		$MAKE install || { echo "error installing $archive"; exit 1; }
		touch installed
	fi
done

cd $BUILDDIR/elf2d01-$ELF2D01_VER
if [ ! -f installed ]
then
	echo "Building & installing elf2d01"
	CXXFLAGS=$cflags CFLAGS=$cflags LDFLAGS=$ldflags ./configure --prefix=$toolsprefix --disable-dependency-tracking $CROSS_PARAMS || { echo "elf2d01 configure failed"; exit 1; }
	$MAKE || { echo "elf2d01 build failed"; exit 1; }
	$MAKE install || { echo "elf2d01 install failed"; exit 1; }
	touch installed
fi

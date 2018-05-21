#!/bin/bash

cd $BUILDDIR/libdataplus-$LIBDATAPLUS_VER
if [ ! -f installed ]
then
	echo "Building & installing libdataplus"
	$MAKE || { echo "libdataplus build failed"; exit 1; }
	$MAKE install || { echo "libdataplus install failed"; exit 1; }
	touch installed
fi





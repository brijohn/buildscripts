#!/bin/bash

export DEVKITPRO=$TOOLPATH
export DEVKITSH4=$DEVKITPRO/devkitSH4

#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cp -v $BUILDSCRIPTDIR/dksh4/rules/* $prefix

#---------------------------------------------------------------------------------
# Install and build the exword crt
#---------------------------------------------------------------------------------

echo "installing linkscripts ..."
cp -v $BUILDSCRIPTDIR/dksh4/crtls/* $prefix/$target/lib/
cd $prefix/$target/lib/
$MAKE CRT=exword

cd $BUILDDIR/libdataplus-$LIBDATAPLUS_VER
if [ ! -f installed ]
then
	echo "Building & installing libdataplus"
	$MAKE || { echo "libdataplus build failed"; exit 1; }
	$MAKE install || { echo "libdataplus install failed"; exit 1; }
	touch installed
fi





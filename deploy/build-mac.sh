#!/bin/bash

QT_VERSION=4.7.3
QT_FOLDER=Qt-$QT_VERSION
QT_TARBALL=qt-everywhere-opensource-src-$QT_VERSION.tar.gz

# Tip: change this to local/shared mirror
QT_URL=http://get.qt.nokia.com/qt/source/$QT_TARBALL

COMPILE_JOBS=4

# Step 1: Download Qt source tarball
# Note: only if it does not exist yet in the current directory

[ -f $QT_TARBALL ] || echo "Downloading Qt $QT_VERSION from Nokia. Please wait..."
[ -f $QT_TARBALL ] || curl -C - -O -S $QT_URL

# Step 2: Extract Qt source

[ -d $QT_FOLDER ] && rm -rf $QT_FOLDER
echo "Extracting Qt $QT_VERSION source tarball..."
echo
tar xzf $QT_TARBALL
mv qt-everywhere-opensource-src-$QT_VERSION Qt-$QT_VERSION

# Step 3: Apply patches.

cd $QT_FOLDER
echo "Patching Qt..."
patch < ../allow-static-qtwebkit.patch
cd ..

# Step 4: Build Qt

cd $QT_FOLDER
echo "Building Qt $QT_VERSION. Please wait..."
echo

./configure -opensource -confirm-license -release -static -no-exceptions -no-stl -no-xmlpatterns -no-phonon -no-script -no-scripttools -graphicssystem raster -no-nis -no-dwarf2 -no-dbus -no-iconv -no-qt3support -no-opengl -no-declarative -qt-libpng -qt-libjpeg -no-libmng -no-libtiff -D QT_NO_STYLE_CDE -D QT_NO_STYLE_CLEANLOOKS -D QT_NO_STYLE_MOTIF -D QT_NO_STYLE_PLASTIQUE -cocoa -prefix $PWD -arch x86 -nomake demos -nomake examples -nomake tools

make -j$COMPILE_JOBS
make -j$COMPILE_JOBS
make install -j$COMPILE_JOBS
cd ..

PATH=`pwd`/$QT_FOLDER/bin:$PATH

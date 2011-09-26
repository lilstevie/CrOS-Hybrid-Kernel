#!/bin/bash
# Build script for Asus Transformer Ubuntu uImage kernel
mv .git MOOSE

WORK=`pwd`
DATE=$(date +%m%d)
CONFIG="tf101_gnulinux"
toolchain="../arm-2009q3"
uImage=uImage=$(ls arch/arm/boot/zImage)

cd ..
if [ ! -d "$toolchain" ]; then
        tarball="arm-2009q3-67-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2"
        if [ ! -f "$tarball" ]; then
                wget http://www.codesourcery.com/public/gnu_toolchain/arm-none-linux-gnueabi/"$tarball"
        fi
        tar -xjf "$tarball"
fi

cd $WORK
rm "$DATE"_stdlog_"$CONFIG".log
rm "$DATE"_errlog_"$CONFIG".log
make clean mrproper
make ARCH=arm tf101_gnulinux_defconfig
make uImage -j$(grep processor /proc/cpuinfo | wc -l) CROSS_COMPILE=$toolchain/bin/arm-none-linux-gnueabi- \
        ARCH=arm HOSTCFLAGS="-g -O3" LOCALVERSION="" \
	1> "$DATE"_stdlog_"$CONFIG".log 2> "$DATE"_errlog_"$CONFIG".log
mv MOOSE .git

if [ "$uImage" != "" ]; then
        echo "Kernel: arch/arm/boot/zImage is ready"
        echo "Build complete."
else
        echo "Build failure check "$DATE"_errlog_"$CONFIG".log"
fi


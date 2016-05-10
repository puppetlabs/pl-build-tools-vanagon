#!/bin/bash  -x

# This script should be able to generate a sysroot that we use for
# cross-compiling anything debian-releated. To execute, you should just be able
# to edit the constant below. In the end, you'll have a tar.gz file that is a
# sysroot that needs to be placed on buildsources.

ARCH=armhf
SHORTARCH=arm
VERSION=8
DISTRO=jessie
TRIPLE=arm-linux-gnueabihf
export LANG=C


if [ -z "$1" ] ; then
    apt-get update
    apt-get install qemu-user-static debootstrap binfmt-support

    mkdir -p debian-${VERSION}-${ARCH}-sysroot
    debootstrap --arch=${ARCH} --foreign ${DISTRO} debian-${VERSION}-${ARCH}-sysroot

    cp /usr/bin/qemu-${SHORTARCH}-static debian-${VERSION}-${ARCH}-sysroot/usr/bin/
    cp /etc/resolv.conf debian-${VERSION}-${ARCH}-sysroot/etc
    cp sysroot debian-${VERSION}-${ARCH}-sysroot
    chroot debian-${VERSION}-${ARCH}-sysroot /bin/bash ./"${0}" chroot
    tar czf debian-${VERSION}-${ARCH}-sysroot.tar.gz --owner=0 --group=0 debian-${VERSION}-${ARCH}-sysroot
fi

if [ "$1"  ==  "chroot" ] ; then

    # Inside the chroot session:
    /debootstrap/debootstrap --second-stage

    echo "deb http://httpredir.debian.org/debian ${DISTRO} main contrib" >> /etc/apt/sources.list
    echo "deb http://httpredir.debian.org/debian ${DISTRO}-updates main contrib" >> /etc/apt.sources.list
    echo "deb http://security.debian.org/debian-${VERSION}-security ${DISTRO}/updates main contrib" >> /etc/apt/sources.list

    apt-get update

    echo debian-${VERSION}-${ARCH} > /etc/hostname
    hostname debian-${VERSION}-${ARCH}


    apt-get -y install libc6-dev libncurses5-dev libbz2-dev zlib1g-dev curl libcurl4-openssl-dev libreadline-dev libbz2-dev

    # Clean up links
    pushd /usr/lib/${TRIPLE}
    rm libz.so
    ln -s ../../../lib/${TRIPLE}/libz.so.1.2.8 libz.so
    rm libutil.so
    ln -s ../../../lib/${TRIPLE}/libutil.so.1 libutil.so
    rm libusb-0.1.so.4
    ln -s ../../../lib/${TRIPLE}/libusb-0.1.so.4 libusb-0.1.so.4
    rm libtinfo.so
    ln -s ../../../lib/${TRIPLE}/libtinfo.so.5 libtinfo.so
    rm libthread_db.so
    ln -s ../../../lib/${TRIPLE}/libthread_db.so.1 libthread_db.so
    rm librt.so
    ln -s ../../../lib/${TRIPLE}/librt.so.1 librt.so
    rm libresolv.so
    ln -s ../../../lib/${TRIPLE}/libresolv.so.2 libresolv.so
    rm libnss_nis.so
    ln -s ../../../lib/${TRIPLE}/libnss_nis.so.2 libnss_nis.so
    rm libnss_nisplus.so
    ln -s ../../../lib/${TRIPLE}/libnss_nisplus.so.2 libnss_nisplus.so
    rm libnss_hesiod.so
    ln -s ../../../lib/${TRIPLE}/libnss_hesiod.so.2 libnss_hesiod.so
    rm libnss_files.so
    ln -s ../../../lib/${TRIPLE}/libnss_files.so.2 libnss_files.so
    rm libnss_dns.so
    ln -s ../../../lib/${TRIPLE}/libnss_dns.so.2 libnss_dns.so
    rm libnss_compat.so
    ln -s ../../../lib/${TRIPLE}/libnss_compat.so.2 libnss_compat.so
    rm libnsl.so
    ln -s ../../../lib/${TRIPLE}/libnsl.so.1 libnsl.so
    rm libm.so
    ln -s ../../../lib/${TRIPLE}/libm.so.6 libm.so
    rm libdl.so
    ln -s ../../../lib/${TRIPLE}/libdl.so.2 libdl.so
    rm libcrypt.so
    ln -s ../../../lib/${TRIPLE}/libcrypt.so.1 libcrypt.so
    rm libcidn.so
    ln -s ../../../lib/${TRIPLE}/libcidn.so.1 libcidn.so
    rm libbz2.so
    ln -s ../../../lib/${TRIPLE}/libbz2.so.1.0 libbz2.so
    rm libBrokenLocale.so
    ln -s ../../../lib/${TRIPLE}/libBrokenLocale.so.1 libBrokenLocale.so
    rm libanl.so
    ln -s ../../../lib/${TRIPLE}/libanl.so.1 libanl.so
    rm libreadline.so
    ln -s ../../../lib/${TRIPLE}/libreadline.so.6 libreadline.so
    rm -f libbz2.so
    ln -s ../../../lib/${TRIPLE}/libbz2.so.1 libbz2.so
    rm libhistory.so
    ln -s ../../../lib/${TRIPLE}/libhistory.so.6
    rm libBrokenLocale.so
    ln -s ../../../lib/${TRIPLE}/libBrokenLocale.so.1 libBrokenLocale.so
    popd

    # link in the proper headers
    pushd /usr/include
    ln -s  ${TRIPLE}/* .
    popd

    # Clean up stuff we're not going to need/use
    pushd /
    rm -rf ./usr/games  ./usr/local  ./usr/sbin  ./usr/share  ./usr/src ./usr/lib/man-db ./usr/lib/systemd  ./usr/lib/ssl
    find / -maxdepth 1 | grep -v usr  | grep -v lib | xargs rm -rf
    rm -rf /usr/bin
    popd
fi

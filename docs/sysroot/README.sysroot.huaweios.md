# Overview

This document describes how to (re)create the sysroot tarball for the huaweios-6-powerpc platform, which is what Huawei's CloudEngine (CE) enterprise network switches run. Conveniently, Huawei CE switches run an instance of Debian 7 in an LXC container, so our target is essentially just Debian Jessie for powerpc.

For our builds we cross-compile most of our packages on a debian-7-x86_64 pooler system, but the sysroot must be created from a native powerpc environment. Debian has some nice tools for building minimal OS environments with debootstrap, so we'll use that to create the sysroot instead of having to extract it from a running CE switch.

# Creating a minimal Debian 7 powerpc OS rootfs with debootstrap

Much of this process was derived from this guide:

https://olimex.wordpress.com/2014/07/21/how-to-create-bare-minimum-debian-wheezy-rootfs-from-scratch/

and replacing "wheezy" with "jessie". This guide has been tested using a debian-7-x86_64 pooler system, but it should work on any recent Ubuntu or Debian system.

All of the commands in this guide should be run as root unless otherwise noted.

## Prerequisite packages on the build host

```
apt-get install qemu-user-static debootstrap binfmt-support rsync
```

## Create the jessie chroot

In this guide we'll use "debian-powerpc-rootfs" as the name of the directory we'll generating the powerpc rootfs in.

```
mkdir debian-powerpc-rootfs
debootstrap --arch=powerpc --foreign jessie debian-powerpc-rootfs
```

Copy the QEMU ppc binary and your DNS resolv.conf into the rootfs:

```
cp /usr/bin/qemu-ppc-static debian-powerpc-rootfs/usr/bin/
cp /etc/resolv.conf debian-powerpc-rootfs/etc
```

Now you should be able to chroot into the rootfs and run commands such as ls, cp, etc:

```
chroot debian-powerpc-rootfs
```

From within the chroot session:

```
export distro=jessie
export LANG=C

/debootstrap/debootstrap --second-stage
```

Edit /etc/apt/sources.list and make it look like this:

```
deb http://httpredir.debian.org/debian jessie main contrib
deb http://httpredir.debian.org/debian jessie-updates main contrib
deb http://security.debian.org/debian-security jessie/updates main contrib
```

```
apt-get update
apt-get install locales dialog
dpkg-reconfigure locales
```

Enable all of the "en.US" locales and select en_US as the default locale.

```
echo debianppc > /etc/hostname
hostname debianppc
```

Now exit the chroot and chroot back in to make sure the hostname change worked. All good? Great, now install some important libraries we want to have in the sysroot:

```
apt-get install libc6-dev libncurses5-dev libbz2-dev zlib1g-dev curl libcurl4-openssl-dev libreadline-dev
```

# Create a snapshot of just the parts of the rootfs we care about

```
mkdir -p huaweios-6-powerpc-sysroot/usr
rsync -avg debian-powerpc-rootfs/lib huaweios-6-powerpc-sysroot/
rsync -avg debian-powerpc-rootfs/usr/lib huaweios-6-powerpc-sysroot/usr/
rsync -avg debian-powerpc-rootfs/usr/include huaweios-6-powerpc-sysroot/usr/
```

# Prune the library directories

```
rm -rf huaweios-6-powerpc-sysroot/usr/lib/ssl
rm -rf huaweios-6-powerpc-sysroot/usr/lib/man
rm -rf huaweios-6-powerpc-sysroot/usr/lib/mandb
```

# Convert the absolute library symlinks to relative ones

```
cd huaweios-6-powerpc-sysroot/usr/lib/powerpc-linux-gnu

rm libz.so
ln -s ../../../lib/powerpc-linux-gnu/libz.so.1.2.8 libz.so
rm libutil.so
ln -s ../../../lib/powerpc-linux-gnu/libutil.so.1 libutil.so
rm libusb-0.1.so.4
ln -s ../../../lib/powerpc-linux-gnu/libusb-0.1.so.4 libusb-0.1.so.4
rm libtinfo.so
ln -s ../../../lib/powerpc-linux-gnu/libtinfo.so.5 libtinfo.so
rm libthread_db.so
ln -s ../../../lib/powerpc-linux-gnu/libthread_db.so.1 libthread_db.so
rm librt.so
ln -s ../../../lib/powerpc-linux-gnu/librt.so.1 librt.so
rm libresolv.so
ln -s ../../../lib/powerpc-linux-gnu/libresolv.so.2 libresolv.so
rm libnss_nis.so
ln -s ../../../lib/powerpc-linux-gnu/libnss_nis.so.2 libnss_nis.so
rm libnss_nisplus.so
ln -s ../../../lib/powerpc-linux-gnu/libnss_nisplus.so.2 libnss_nisplus.so
rm libnss_hesiod.so
ln -s ../../../lib/powerpc-linux-gnu/libnss_hesiod.so.2 libnss_hesiod.so
rm libnss_files.so
ln -s ../../../lib/powerpc-linux-gnu/libnss_files.so.2 libnss_files.so
rm libnss_dns.so
ln -s ../../../lib/powerpc-linux-gnu/libnss_dns.so.2 libnss_dns.so
rm libnss_compat.so
ln -s ../../../lib/powerpc-linux-gnu/libnss_compat.so.2 libnss_compat.so
rm libnsl.so
ln -s ../../../lib/powerpc-linux-gnu/libnsl.so.1 libnsl.so
rm libm.so
ln -s ../../../lib/powerpc-linux-gnu/libm.so.6 libm.so
rm libdl.so
ln -s ../../../lib/powerpc-linux-gnu/libdl.so.2 libdl.so
rm libcrypt.so
ln -s ../../../lib/powerpc-linux-gnu/libcrypt.so.1 libcrypt.so
rm libcidn.so
ln -s ../../../lib/powerpc-linux-gnu/libcidn.so.1 libcidn.so
rm libbz2.so
ln -s ../../../lib/powerpc-linux-gnu/libbz2.so.1.0 libbz2.so
rm libBrokenLocale.so
ln -s ../../../lib/powerpc-linux-gnu/libBrokenLocale.so.1 libBrokenLocale.so
rm libanl.so
ln -s ../../../lib/powerpc-linux-gnu/libanl.so.1 libanl.so
rm libreadline.so
ln -s ../../../lib/powerpc-linux-gnu/libreadline.so.6 libreadline.so
rm libhistory.so
ln -s ../../../lib/powerpc-linux-gnu/libhistory.so.6

cd ../../..
```

For some reason Debian treats their libraries on powerpc as if it were a multiarch install, putting them not in /lib but in /lib/powerpc-linux-gnu/. Rather than cluttering our build configs with additional linker paths, let's just copy the libs into /lib in the sysroot and aim for simplicity at the expense of some extra disk space used by the sysroot.

```
cp -a lib/powerpc-linux-gnu/* lib/
cd ..
```

# Create the sysroot tarball

```
tar cvzf huaweios-6-powerpc-sysroot.tar.gz --owner=0 --group=0 huaweios-6-powerpc-sysroot
```

Then copy this over to pl-build-tools under /opt/build-tools/HuaweiOS/6/.

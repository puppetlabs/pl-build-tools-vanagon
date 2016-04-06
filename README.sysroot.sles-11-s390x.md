# Overview

This document describes how to (re)create the sysroot tarball for the sles-11-x390x platform. s390x is an architecture used by IBM zLinux servers. For our builds we cross-compile most of our packages on a sles-11-x86_64 pooler system, but the sysroot must be created from a native s390x environment. Since we don't have access to this platform on our pooler infrastructure, this document assumes you have access to a remote zLinux server running SLES 11 SP4.

# Package customization

All of the commands in this guide should be run as root.

First install the libaries we need for building gcc and our various dependencies:

```
zypper in zlib-devel libbz2-devel libcurl-devel readline-devel
```

Then we can remove a bunch of unneeded junk. The SLES 11 s390x environment we have access to has 32-bit multilib packages installed, which we don't need. The purpose of this is to try to get rid of unneeded library files, even though we'll still be manually prunning the libdirs in a later step.

```
zypper rm aspell autofs boost-license cups-libs emacs emacs-info freetype2 git-core glibc-32bit glibc-devel-32bit gstreamer libFLAC8 libfortran3 libicu libncurses6 libpixman-1-0 libqt4 libsmbclient0 libtiff libvorbis mozilla-xulrunner192 nautilus orbit2 pango perl python python-base qt3 ruby sssd subversion tcl xorg-x11-libX11 xorg-x11-libXau zsh 
```

This final zypper rm command ends up removing the zypper package, so you won't be able to make any further changes with it after this point:

```
zypper rm libxml2 libxslt openssl
```

# Create the sysroot snapshot

```
mkdir -p sles-11-s390x-sysroot/usr
rsync -avg /lib64 sles-11-s390x-sysroot/
rsync -avg /usr/lib64 sles-11-s390x-sysroot/usr/
rsync -avg /usr/include sles-11-s390x-sysroot/usr/
```

# Prune the library directories

There's still a ton of uneeded files and directories to get rid of:

```
rm -rf sles-11-s390x-sysroot/lib64/a*
rm -rf sles-11-s390x-sysroot/lib64/d*
rm -rf sles-11-s390x-sysroot/lib64/k*
rm -rf sles-11-s390x-sysroot/lib64/libdevmapper*
rm -rf sles-11-s390x-sysroot/lib64/m*
rm -rf sles-11-s390x-sysroot/lib64/s*
rm -rf sles-11-s390x-sysroot/lib64/x*

rm -rf sles-11-s390x-sysroot/usr/lib64/a*
rm -rf sles-11-s390x-sysroot/usr/lib64/b*
rm -rf sles-11-s390x-sysroot/usr/lib64/coreutils*
rm -rf sles-11-s390x-sysroot/usr/lib64/crash*
rm -rf sles-11-s390x-sysroot/usr/lib64/cups*
rm -rf sles-11-s390x-sysroot/usr/lib64/e*
rm -rf sles-11-s390x-sysroot/usr/lib64/g*
rm -rf sles-11-s390x-sysroot/usr/lib64/h*
rm -rf sles-11-s390x-sysroot/usr/lib64/k*
rm -rf sles-11-s390x-sysroot/usr/lib64/libblas*
rm -rf sles-11-s390x-sysroot/usr/lib64/liblapack*
rm -rf sles-11-s390x-sysroot/usr/lib64/m*
rm -rf sles-11-s390x-sysroot/usr/lib64/o*
rm -rf sles-11-s390x-sysroot/usr/lib64/pkcs*
rm -rf sles-11-s390x-sysroot/usr/lib64/q*
rm -rf sles-11-s390x-sysroot/usr/lib64/r*
rm -rf sles-11-s390x-sysroot/usr/lib64/s*
rm -rf sles-11-s390x-sysroot/usr/lib64/w*
rm -rf sles-11-s390x-sysroot/usr/lib64/x*
rm -rf sles-11-s390x-sysroot/usr/lib64/Y*
```

# Convert the absolute library symlinks to relative ones

```
cd sles-11-s390x-sysroot/usr/lib64

rm libaio.so
ln -s ../../lib64/libaio.so.1 libaio.so
rm libanl.so
ln -s ../../lib64/libanl.so.1 libanl.so
rm libBrokenLocale.so
ln -s ../../lib64/libBrokenLocale.so.1 libBrokenLocale.so
rm libbz2.so
ln -s ../../lib64/libbz2.so.1.0.5 libbz2.so
rm libcidn.so
ln -s ../../lib64/libcidn.so.1 libcidn.so
rm libcrypt.so
ln -s ../../lib64/libcrypt.so.1 libcrypt.so
rm libdl.so
ln -s ../../lib64/libdl.so.2 libdl.so
rm libm.so
ln -s ../../lib64/libm.so.6 libm.so
rm libnet.so
ln -s ../../lib64/libnet.so.0.0.0 libnet.so
rm libnsl.so
ln -s ../../lib64/libnsl.so.1 libnsl.so
rm libnss_compat.so
ln -s ../../lib64/libnss_compat.so.2 libnss_compat.so
rm libnss_dns.so
ln -s ../../lib64/libnss_dns.so.2 libnss_dns.so
rm libnss_files.so
ln -s ../../lib64/libnss_files.so.2 libnss_files.so
rm libnss_hesiod.so
ln -s ../../lib64/libnss_hesiod.so.2 libnss_hesiod.so
rm libnss_nisplus.so
ln -s ../../lib64/libnss_nisplus.so.2 libnss_nisplus.so
rm libnss_nis.so
ln -s ../../lib64/libnss_nis.so.2 libnss_nis.so
rm libresolv.so
ln -s ../../lib64/libresolv.so.2 libresolv.so
rm librt.so
ln -s ../../lib64/librt.so.1 librt.so
rm libsysfs.so
ln -s ../../lib64/libsysfs.so.2 libsysfs.so
rm libthread_db.so
ln -s ../../lib64/libthread_db.so.1 libthread_db.so
rm libutil.so
ln -s ../../lib64/libutil.so.1 libutil.so
rm libz.so
ln -s ../../lib64/libz.so.1 libz.so

cd ../../..
```

# Get rid of symlinks to directories

With RPM, symlinks to directories have to be explicitly created in the specfile. We're not creating a separate RPM package for the sysroot, and just want to bundle it into our gcc build. So rather than muck around with a custom specifle (that we'd have to do for the other RPM-based s390x platforms), just convert the symlinks into directories. Yes it is a waste of disk space, but it's by a trivial factor.

```
rm sles-11-s390x-sysroot/usr/include/asm
cp -a sles-11-s390x-sysroot/usr/include/asm-s390 sles-11-s390x-sysroot/usr/include/asm
rm sles-11-s390x-sysroot/usr/include/c++/4.3/s390x-suse-linux/32
mkdir -p sles-11-s390x-sysroot/usr/include/c++/4.3/s390x-suse-linux/32
cp -a sles-11-s390x-sysroot/usr/include/c++/4.3/s390x-suse-linux/bits sles-11-s390x-sysroot/usr/include/c++/4.3/s390x-suse-linux/32
```

# lib vs. lib64 workaround

s390x is a 64-bit platform and keeps those libs in /lib64 and /usr/lib64. But when building gcc, you'll run into errors finding libraries if you use "lib64" in the sysroot, but also when using a sysroot that stored the libraries in "lib" instead. A *temporary* workaround to this is to just have both directories. This is ripe for a refactoring.

```
cp sles-11-s390x-sysroot/lib64 sles-11-s390x-sysroot/lib
cp -a sles-11-s390x-sysroot/usr/lib64 sles-11-s390x-sysroot/usr/lib
```

# Create the sysroot tarball

```
tar cvzf sles-11-s390x-sysroot.tar.gz --owner=0 --group=0 sles-11-s390x-sysroot
```

Then copy this over to pl-build-tools under /opt/build-tools/sles/11/

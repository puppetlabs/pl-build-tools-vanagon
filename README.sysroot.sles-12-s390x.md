# Overview

This document describes how to (re)create the sysroot tarball for the sles-12-x390x platform. s390x is an architecture used by IBM zLinux servers. For our builds we cross-compile most of our packages on a sles-12-x86_64 pooler system, but the sysroot must be created from a native s390x environment. Since we don't have access to this platform on our pooler infrastructure, this document assumes you have access to a remote zLinux server running SLES 12 SP1.

# Package customization

All of the commands in this guide should be run as root.

First we remove a bunch of unneeded junk. The SLES 12 s390x environment we have access to has 32-bit multilib packages installed, which we don't need. The purpose of this is to try to get rid of unneeded library files, even though we'll still be manually prunning the libdirs in a later step.

```
zypper rm aspell autofs boost-license cups-libs emacs emacs-info freetype2 git-core glibc-32bit glibc-devel-32bit gstreamer libFLAC8 libfortran3 libicu libjack0 libnettle4 libp11-kit0 libpixman-1-0 libqt4 libsmbclient0 libtiff libv4l libvisual libvorbis libwicked-0-6 libyaml-0-2 lua mozilla-xulrunner192 nautilus orbit2 p11-kit p7zip pango perl ppp qt3 ruby sssd subversion tcl vlock xorg-x11-libX11 xorg-x11-libXau zsh 
```

Then install the libaries we do need for building gcc and our various dependencies:

```
zypper in zlib-devel libbz2-devel readline-devel e2fsprogs-devel
```

This final zypper rm command ends up removing the zypper package, so you won't be able to make any further changes with it after this point:

```
zypper rm libxml2-2 libxslt1 openssl
```

# Create the sysroot snapshot

```
mkdir -p sles-12-s390x-sysroot/usr
rsync -avg /lib64 sles-12-s390x-sysroot/
rsync -avg /usr/lib64 sles-12-s390x-sysroot/usr/
rsync -avg /usr/include sles-12-s390x-sysroot/usr/
```

# Prune the library directories

There's still a ton of uneeded files and directories to get rid of:

```
rm -rf sles-12-s390x-sysroot/lib64/a*
rm -rf sles-12-s390x-sysroot/lib64/d*
rm -rf sles-12-s390x-sysroot/lib64/e*
rm -rf sles-12-s390x-sysroot/lib64/k*
rm -rf sles-12-s390x-sysroot/lib64/libdevmapper*
rm -rf sles-12-s390x-sysroot/lib64/libfuse*
rm -rf sles-12-s390x-sysroot/lib64/m*
rm -rf sles-12-s390x-sysroot/lib64/s*
rm -rf sles-12-s390x-sysroot/lib64/x*

rm -rf sles-12-s390x-sysroot/usr/lib64/a*
rm -rf sles-12-s390x-sysroot/usr/lib64/b*
rm -rf sles-12-s390x-sysroot/usr/lib64/coreutils*
rm -rf sles-12-s390x-sysroot/usr/lib64/crash*
rm -rf sles-12-s390x-sysroot/usr/lib64/cups*
rm -rf sles-12-s390x-sysroot/usr/lib64/d*
rm -rf sles-12-s390x-sysroot/usr/lib64/e*
rm -rf sles-12-s390x-sysroot/usr/lib64/g*
rm -rf sles-12-s390x-sysroot/usr/lib64/h*
rm -rf sles-12-s390x-sysroot/usr/lib64/k*
rm -rf sles-12-s390x-sysroot/usr/lib64/ldb*
rm -rf sles-12-s390x-sysroot/usr/lib64/ldscripts*
rm -rf sles-12-s390x-sysroot/usr/lib64/libblas*
rm -rf sles-12-s390x-sysroot/usr/lib64/libdevmapper*
rm -rf sles-12-s390x-sysroot/usr/lib64/libgfortran*
rm -rf sles-12-s390x-sysroot/usr/lib64/libgphoto2*
rm -rf sles-12-s390x-sysroot/usr/lib64/liblapack*
rm -rf sles-12-s390x-sysroot/usr/lib64/liblvm2*
rm -rf sles-12-s390x-sysroot/usr/lib64/m*
rm -rf sles-12-s390x-sysroot/usr/lib64/o*
rm -rf sles-12-s390x-sysroot/usr/lib64/pkcs*
rm -rf sles-12-s390x-sysroot/usr/lib64/plymouth*
rm -rf sles-12-s390x-sysroot/usr/lib64/python*
rm -rf sles-12-s390x-sysroot/usr/lib64/q*
rm -rf sles-12-s390x-sysroot/usr/lib64/r*
rm -rf sles-12-s390x-sysroot/usr/lib64/s*
rm -rf sles-12-s390x-sysroot/usr/lib64/t*
rm -rf sles-12-s390x-sysroot/usr/lib64/w*
rm -rf sles-12-s390x-sysroot/usr/lib64/x*
rm -rf sles-12-s390x-sysroot/usr/lib64/Y*
```

# Convert the absolute library symlinks to relative ones

```
cd sles-12-s390x-sysroot/lib64
rm libcom_err.so.2
ln -s ../usr/lib64/libcom_err.so.2
rm libcom_err.so.2.1
ln -s ../usr/lib64/libcom_err.so.2.1
rm libe2p.so.2
ln -s ../usr/lib64/libe2p.so.2
rm libe2p.so.2.3
ln -s ../usr/lib64/libe2p.so.2.3
rm libext2fs.so.2
ln -s ../usr/lib64/libext2fs.so.2
rm libext2fs.so.2.4
ln -s ../usr/lib64/libext2fs.so.2.4
rm libkmod.so.2
ln -s ../usr/lib64/libkmod.so.2
rm libkmod.so.2.2.7
ln -s ../usr/lib64/libkmod.so.2.2.7
rm libss.so.2
ln -s ../usr/lib64/libss.so.2
rm libss.so.2.0
ln -s ../usr/lib64/libss.so.2.0
cd ../..

cd sles-12-s390x-sysroot/usr/lib64
rm libBrokenLocale.so
ln -s ../../lib64/libBrokenLocale.so.1 libBrokenLocale.so
rm libanl.so
ln -s ../../lib64/libanl.so.1 libanl.so
rm libcidn.so
ln -s ../../lib64/libcidn.so.1 libcidn.so
rm libcrypt.so
ln -s ../../lib64/libcrypt.so.1 libcrypt.so
rm libdl.so
ln -s ../../lib64/libdl.so.2 libdl.so
rm libhistory.so
ln -s ../../lib64/libhistory.so.6.2
rm libm.so
ln -s ../../lib64/libm.so.6 libm.so
rm libnsl.so
ln -s ../../lib64/libnsl.so.1 libnsl.so
rm libnss_compat.so
ln -s ../../lib64/libnss_compat.so.2 libnss_compat.so
rm libnss_db.so
ln -s ../../lib64/libnss_db.so.2 libnss_db.so
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
rm libowcrypt.so
ln -s ../../lib64/libowcrypt.so.1 libowcrypt.so
rm libreadline.so
ln -s ../../lib64/libreadline.so.6.2 libreadline.so
rm libresolv.so
ln -s ../../lib64/libresolv.so.2 libresolv.so
rm librt.so
ln -s ../../lib64/librt.so.1 librt.so
rm libthread_db.so
ln -s ../../lib64/libthread_db.so.1 libthread_db.so
rm libtinfo.so
ln -s ../../lib64/libtinfo.so.5 libtinfo.so
rm libutil.so
ln -s ../../lib64/libutil.so.1 libutil.so
rm libz.so
ln -s ../../lib64/libz.so.1.2.8 libz.so

cd ncurses6
rm libtinfo.so
ln -s ../../../lib64/libtinfo.so.6 libtinfo.so

cd ../../../..
```

# Get rid of symlinks to directories

With RPM, symlinks to directories have to be explicitly created in the specfile. We're not creating a separate RPM package for the sysroot, and just want to bundle it into our gcc build. So rather than muck around with a custom specifle (that we'd have to do for the other RPM-based s390x platforms), just convert the symlinks into directories. Yes it is a waste of disk space, but it's by a trivial factor.

```
rm sles-12-s390x-sysroot/usr/include/asm
cp -a sles-12-s390x-sysroot/usr/include/asm-s390 sles-12-s390x-sysroot/usr/include/asm
rm sles-12-s390x-sysroot/usr/include/python
cp -a sles-12-s390x-sysroot/usr/include/python2.7 sles-12-s390x-sysroot/usr/include/python
rm sles-12-s390x-sysroot/usr/include/c++/4.8/s390x-suse-linux/32
mkdir -p sles-12-s390x-sysroot/usr/include/c++/4.8/s390x-suse-linux/32
cp -a sles-12-s390x-sysroot/usr/include/c++/4.8/s390x-suse-linux/bits sles-12-s390x-sysroot/usr/include/c++/4.8/s390x-suse-linux/32
cp -a sles-12-s390x-sysroot/usr/include/c++/4.8/s390x-suse-linux/ext sles-12-s390x-sysroot/usr/include/c++/4.8/s390x-suse-linux/32
```

# lib vs. lib64 workaround

s390x is a 64-bit platform and keeps those libs in /lib64 and /usr/lib64. But when building gcc, you'll run into errors finding libraries if you use "lib64" in the sysroot, but also when using a sysroot that stored the libraries in "lib" instead. A *temporary* workaround to this is to just have both directories. This is ripe for a refactoring.

```
cp -a sles-12-s390x-sysroot/lib64 sles-12-s390x-sysroot/lib
cp -a sles-12-s390x-sysroot/usr/lib64 sles-12-s390x-sysroot/usr/lib
```

# Create the sysroot tarball

```
tar cvzf sles-12-s390x-sysroot.tar.gz --owner=0 --group=0 sles-12-s390x-sysroot
```

Then copy this over to pl-build-tools under /opt/build-tools/sles/12/

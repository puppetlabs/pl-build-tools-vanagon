#!/bin/bash
#
# This script generates a sysroot tarball for the sles-12-s390x platform.
# s390x is an architecture used by IBM zLinux servers. For our builds we
# cross-compile most of our packages on a sles-12-x86_64 pooler system,
# but the sysroot must be created from a native s390x environment.
# Therefore, you must run this script as root on a zLinux server running
# SLES 12 SP1.

SYSROOTDIR="sles-12-s390x-sysroot"

# First we remove a bunch of unneeded junk. The SLES 12 s390x environment
# we have access to has a ton of 32-bit multilib packages installed, which
# we don't want. The purpose of this is to try to get rid of unneeded
# library files, even though we'll still be pruning the libdirs in a later
# step.
echo "Removing unneeded packages..."
zypper rm -y autofs boost-license cups-libs freetype2 git-core glibc-32bit glibc-devel-32bit gstreamer libFLAC8 libicu libjack0 libnettle4 libp11-kit0 libpixman-1-0 libqt4 libsmbclient0 libtiff libv4l libvisual libvorbis libwicked-0-6 libyaml-0-2 lua nautilus p11-kit p7zip pango perl ppp ruby subversion tcl vlock xorg-x11-libX11 xorg-x11-libXau zsh 

echo "Installing critical libraries we need for building gcc and our various dependencies..."
zypper in -y zlib-devel libbz2-devel readline-devel e2fsprogs-devel

# You won't be able to make any further package changes using zypper after this point.
echo "Removing a final few packages (including zypper)..."
zypper rm -y libxml2-2 libxslt1 openssl

# Create a sysroot working area we can make further modifications to
echo "Creating $SYSROOTDIR and syncing sysroot directories under it..."
rm -rf $SYSROOTDIR
mkdir -p $SYSROOTDIR/usr
rsync --archive /lib64 $SYSROOTDIR/
rsync --archive /usr/lib64 $SYSROOTDIR/usr/
rsync --archive /usr/include $SYSROOTDIR/usr/

echo "Pruning sysroot libdirs of unneeded files and directories..."
rm -rf $SYSROOTDIR/lib64/a*
rm -rf $SYSROOTDIR/lib64/d*
rm -rf $SYSROOTDIR/lib64/e*
rm -rf $SYSROOTDIR/lib64/k*
rm -rf $SYSROOTDIR/lib64/libdevmapper*
rm -rf $SYSROOTDIR/lib64/libfuse*
rm -rf $SYSROOTDIR/lib64/m*
rm -rf $SYSROOTDIR/lib64/s*
rm -rf $SYSROOTDIR/lib64/x*

rm -rf $SYSROOTDIR/usr/lib64/a*
rm -rf $SYSROOTDIR/usr/lib64/b*
rm -rf $SYSROOTDIR/usr/lib64/coreutils*
rm -rf $SYSROOTDIR/usr/lib64/crash*
rm -rf $SYSROOTDIR/usr/lib64/cups*
rm -rf $SYSROOTDIR/usr/lib64/d*
rm -rf $SYSROOTDIR/usr/lib64/e*
rm -rf $SYSROOTDIR/usr/lib64/g*
rm -rf $SYSROOTDIR/usr/lib64/h*
rm -rf $SYSROOTDIR/usr/lib64/k*
rm -rf $SYSROOTDIR/usr/lib64/ldb*
rm -rf $SYSROOTDIR/usr/lib64/ldscripts*
rm -rf $SYSROOTDIR/usr/lib64/libblas*
rm -rf $SYSROOTDIR/usr/lib64/libdevmapper*
rm -rf $SYSROOTDIR/usr/lib64/libgfortran*
rm -rf $SYSROOTDIR/usr/lib64/libgphoto2*
rm -rf $SYSROOTDIR/usr/lib64/liblapack*
rm -rf $SYSROOTDIR/usr/lib64/liblvm2*
rm -rf $SYSROOTDIR/usr/lib64/libpcsclite*
rm -rf $SYSROOTDIR/usr/lib64/m*
rm -rf $SYSROOTDIR/usr/lib64/o*
rm -rf $SYSROOTDIR/usr/lib64/pkcs*
rm -rf $SYSROOTDIR/usr/lib64/plymouth*
rm -rf $SYSROOTDIR/usr/lib64/python*
rm -rf $SYSROOTDIR/usr/lib64/q*
rm -rf $SYSROOTDIR/usr/lib64/r*
rm -rf $SYSROOTDIR/usr/lib64/s*
rm -rf $SYSROOTDIR/usr/lib64/t*
rm -rf $SYSROOTDIR/usr/lib64/w*
rm -rf $SYSROOTDIR/usr/lib64/x*
rm -rf $SYSROOTDIR/usr/lib64/Y*

# Since we're relocating the sysroot, we can't have absolute symlinks
echo "Converting absolute library symlinks to relative ones..."
pushd $SYSROOTDIR/lib64
find . -maxdepth 1 -lname '/*' |
while read link ; do
  echo "Converting $link from absolute to relative..."
  target=`readlink $link`
  reltarget=`echo $target | sed 's|/usr/lib64|../usr/lib64|g'`
  rm $link
  ln -sf $reltarget $link
done
popd

pushd $SYSROOTDIR/usr/lib64
find . -maxdepth 1 -lname '/*' |
while read link ; do
  echo "Converting $link from absolute to relative..."
  target=`readlink $link`
  reltarget=`echo $target | sed 's|/lib64|../../lib64|g'`
  rm $link
  ln -sf $reltarget $link
done
popd

pushd $SYSROOTDIR/usr/lib64/ncurses6
find . -maxdepth 1 -lname '/*' |
while read link ; do
  echo "Converting $link from absolute to relative..."
  target=`readlink $link`
  reltarget=`echo $target | sed 's|/lib64|../../../lib64|g'`
  rm $link
  ln -sf $reltarget $link
done
popd

# RPM on SLES doesn't scoop up sylinks to directories, they must be added
# via specfile entries. Since we're adding the sysroot to the pl-gcc RPM,
# convert the few symlinks to dirs manually to avoid having to fiddle with
# the specfile. Note: using the rsync --copy-dirs option results in a
# recursive mess for the '32' directory.
echo "Converting directory symlinks to actual directories..."
rm $SYSROOTDIR/usr/include/asm
cp -a $SYSROOTDIR/usr/include/asm-s390 $SYSROOTDIR/usr/include/asm
rm $SYSROOTDIR/usr/include/python
cp -a $SYSROOTDIR/usr/include/python2.7 $SYSROOTDIR/usr/include/python
rm $SYSROOTDIR/usr/include/c++/4.8/s390x-suse-linux/32
mkdir -p $SYSROOTDIR/usr/include/c++/4.8/s390x-suse-linux/32
cp -a $SYSROOTDIR/usr/include/c++/4.8/s390x-suse-linux/bits $SYSROOTDIR/usr/include/c++/4.8/s390x-suse-linux/32
cp -a $SYSROOTDIR/usr/include/c++/4.8/s390x-suse-linux/ext $SYSROOTDIR/usr/include/c++/4.8/s390x-suse-linux/32

# s390x is a 64-bit platform and keeps those libs in /lib64 and /usr/lib64.
# But when building gcc, you'll run into errors finding libraries if you
# use "lib64" in the sysroot, but also when using a sysroot that stored the
# libraries in "lib" instead. A workaround to this is to just have both
# directories.
echo "Duplicating libdirs so both 'lib' and 'lib64' are available during compiles..."
cp -a $SYSROOTDIR/lib64 $SYSROOTDIR/lib
cp -a $SYSROOTDIR/usr/lib64 $SYSROOTDIR/usr/lib

echo "Generating the sysroot tarball..."
if [ -e $SYSROOTDIR.tar.gz ]; then
	rm $SYSROOTDIR.tar.gz
fi
tar --create --gzip --file $SYSROOTDIR.tar.gz --owner=0 --group=0 $SYSROOTDIR

echo "Done. Now copy $SYSROOTDIR.tar.gz over to buildsources."

#!/bin/bash
#
# This script generates a sysroot tarball for the sles-11-s390x platform.
# s390x is an architecture used by IBM zLinux servers. For our builds we
# cross-compile most of our packages on a sles-11-x86_64 pooler system,
# but the sysroot must be created from a native s390x environment.
# Therefore, you must run this script as root on a zLinux server running
# SLES 11 SP4.

sysrootdir="sles-11-s390x-sysroot"

# First we remove a bunch of unneeded junk. The SLES 11 s390x environment
# we have access to has a ton of 32-bit multilib packages installed, which
# we don't want. The purpose of this is to try to get rid of unneeded
# library files, even though we'll still be pruning the libdirs in a later
# step.
echo "Removing unneeded packages..."
zypper rm -y aspell autofs boost-license cups-libs emacs emacs-info freetype2 git-core glibc-32bit glibc-devel-32bit gstreamer libFLAC8 libicu libncurses6 libpixman-1-0 libqt4 libsmbclient0 libtiff libvorbis mozilla-xulrunner192 nautilus orbit2 pango perl qt3 ruby sssd subversion tcl xorg-x11-libX11 xorg-x11-libXau zsh

echo "Installing critical libraries we need for building gcc and our various dependencies..."
zypper in -y zlib-devel libbz2-devel libcurl-devel readline-devel e2fsprogs-devel

# You won't be able to make any further package changes using zypper after this point.
echo "Removing a final few packages (including zypper)..."
zypper rm -y libxml2 libxslt openssl

# Create a sysroot working area we can make further modifications to
echo "Creating $sysrootdir and syncing sysroot directories under it..."
rm -rf $sysrootdir
mkdir -p $sysrootdir/usr
rsync --archive /lib64 $sysrootdir/
rsync --archive /usr/lib64 $sysrootdir/usr/
rsync --archive --copy-dirlinks /usr/include $sysrootdir/usr/

echo "Pruning sysroot libdirs of unneeded files and directories..."
rm -r $sysrootdir/lib64/{a,d,k,libdevmapper,m,s,x}*
rm -r $sysrootdir/usr/lib64/{a,b,coreutils,crash,cups,e,g,h,k,ldscripts,libblas,libgfortran,libgphoto2,liblapack,m,o,pkcs,python,q,r,s,w,x,Y}*

# Since we're relocating the sysroot, we can't have absolute symlinks
echo "Converting absolute library symlinks to relative ones..."
pushd $sysrootdir/usr/lib64
find . -maxdepth 1 -lname '/*' |
while read -r link ; do
  echo "Converting $link from absolute to relative..."
  target=$(readlink "$link")
  # shellcheck disable=SC2001
  reltarget=$(echo "$target" | sed 's|/lib64|../../lib64|g')
  rm "$link"
  ln -sf "$reltarget" "$link"
done
popd

pushd $sysrootdir/usr/lib64/ncurses6
find . -maxdepth 1 -lname '/*' |
while read -r link ; do
  echo "Converting $link from absolute to relative..."
  target=$(readlink "$link")
  # shellcheck disable=SC2001
  reltarget=$(echo "$target" | sed 's|/lib64|../../../lib64|g')
  rm "$link"
  ln -sf "$reltarget" "$link"
done
popd

# s390x is a 64-bit platform and keeps those libs in /lib64 and /usr/lib64.
# But when building gcc, you'll run into errors finding libraries if you
# use "lib64" in the sysroot, but also when using a sysroot that stored the
# libraries in "lib" instead. A workaround to this is to just have both
# directories.
echo "Duplicating libdirs so both 'lib' and 'lib64' are available during compiles..."
cp -a $sysrootdir/lib64 $sysrootdir/lib
cp -a $sysrootdir/usr/lib64 $sysrootdir/usr/lib

echo "Generating the sysroot tarball..."
if [ -e $sysrootdir.tar.gz ]; then
	rm $sysrootdir.tar.gz
fi
tar --create --gzip --file $sysrootdir.tar.gz --owner=0 --group=0 $sysrootdir

echo "Done. Now copy $sysrootdir.tar.gz over to buildsources."

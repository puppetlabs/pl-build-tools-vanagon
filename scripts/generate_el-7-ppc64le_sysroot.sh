#!/bin/bash
#
# This script generates a sysroot tarball for the el-7-ppc64le (aka
# Power 8) platform. For our builds we cross-compile most of our packages
# on a redhat-7-x86_64 pooler system, but the sysroot must be created
# from a native Power8 environment. Therefore, you must run this script
# as root on a Power8 server running RHEL 7.2.

sysrootdir="el-7-ppc64le-sysroot"

# First we remove a bunch of unneeded junk. The purpose of this is to try
# to get rid of unneeded library files and minmize the size of the sysroot,
# even though we'll still be pruning the libdirs in a later step.
#
# Note: we cannot remove libxml2-python, as it is in the dependency chain for
# subscription-manager, which we need to keep the yum repos enabled for this
# platform. 
echo "Removing unneeded packages..."
yum remove -y autofs cups-libs git-core libtiff libxslt mysql-libs opencryptoki-libs pango plymouth-core-libs python-lxml sssd-client samba-common systemtap-runtime

echo "Installing critical libraries we need for building gcc and our various dependencies..."
yum install --assumeyes rsync zlib-devel bzip2-devel libblkid-devel libcurl-devel libselinux-devel readline-devel e2fsprogs-devel xz-devel

# Create a sysroot working area we can make further modifications to
echo "Creating $sysrootdir and syncing sysroot directories under it..."
rm -rf $sysrootdir
mkdir -p $sysrootdir/usr
rsync --archive /usr/lib64 $sysrootdir/usr/
rsync --archive --copy-dirlinks /usr/include $sysrootdir/usr/

echo "Pruning sysroot libdirs of unneeded files and directories..."
# I always try to delete libnss* and libkrb*, but they're actually needed by libcurl, so don't do that:
rm -r $sysrootdir/usr/lib64/{a,cracklib,d,e,f,g,k,libasound,libau,libavahi,libdev,libgio,libgnutls,liblvm,libmoz,libpython,librpm,libslang,libsoup,libsystemd,libX,libxcb,libxml,lua,m,NetworkManager,n,o,p,r,s,t,X11,x}*

# Since we're relocating the sysroot, we can't have absolute symlinks
echo "Converting absolute library symlinks to relative ones..."
pushd $sysrootdir/usr/lib64 || exit
find . -maxdepth 1 -lname '/*' |
while read -r link ; do
  echo "Converting $link from absolute to relative..."
  target=$(readlink "$link")
  # shellcheck disable=SC2001
  reltarget=$(echo "$target" | sed 's|/lib64|../../lib64|g')
  rm "$link"
  ln -sf "$reltarget" "$link"
done
popd || exit

# On RHEL 7, /lib64 is a symlink to /usr/lib64. But we need to avoid
# including any symlinks to directories to avoid packaging errors. So
# convert any symlinks from ../../lib64/ to point to their targets, which are
# in the current directory anyway.
echo "Converting problematic library symlinks to local ones..."
pushd $sysrootdir/usr/lib64 || exit
find . -maxdepth 1 -lname '../../lib64/*' |
while read -r link ; do
  echo "Converting $link..."
  target=$(readlink "$link")
  # shellcheck disable=SC2001
  reltarget=$(echo "$target" | sed 's|../../lib64/||g')
  rm "$link"
  ln -sf "$reltarget" "./$link"
done
popd || exit

# ppc64le is a 64-bit platform and keeps those libs in /lib64 and /usr/lib64.
# But when building gcc, you'll run into errors finding libraries if you
# use "lib64" in the sysroot, but also when using a sysroot that stored the
# libraries in "lib" instead. A workaround to this is to just have both
# directories.
echo "Duplicating libdirs so both 'lib' and 'lib64' are available during compiles..."
cp -a $sysrootdir/usr/lib64 $sysrootdir/lib64
cp -a $sysrootdir/lib64 $sysrootdir/lib
cp -a $sysrootdir/usr/lib64 $sysrootdir/usr/lib

echo "Generating the sysroot tarball..."
if [ -e $sysrootdir.tar.gz ]; then
  rm $sysrootdir.tar.gz
fi
tar --create --gzip --file $sysrootdir.tar.gz --owner=0 --group=0 $sysrootdir

echo "Done. Now copy $sysrootdir.tar.gz over to Artifactory."

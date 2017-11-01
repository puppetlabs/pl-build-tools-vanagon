#!/bin/bash
#
# This script generates a sysroot tarball for the el-7-s390x platform.
# s390x is an architecture used by IBM on z-series servers. For our builds we
# cross-compile most of our packages on a redhat-7-x86_64 pooler system,
# but the sysroot must be created from a native s390x environment.
# Therefore, you must run this script as root on a zLinux server running
# RHEL 7.2.

sysrootdir="el-7-s390x-sysroot"

# First we remove a bunch of unneeded junk. The purpose of this is to try
# to get rid of unneeded library files and minmize the size of the sysroot,
# even though we'll still be pruning the libdirs in a later step.
echo "Removing unneeded packages..."
yum remove -y autofs cups-libs git-core libtiff libxml2-python libxslt mysql-libs opencryptoki-libs pango plymouth-core-libs python-lxml sssd-client samba-common systemtap-runtime

echo "Installing critical libraries we need for building gcc and our various dependencies..."
yum install --assumeyes zlib-devel bzip2-devel libcurl-devel libselinux-devel readline-devel e2fsprogs-devel xz-devel

# You won't be able to make any further package changes using yum after
# this point. We vendor our own libxml2 and don't want a copy in our sysroot.
echo "Force removing libxml2 (which breaks yum)..."
rpm -e --nodeps libxml2

# Create a sysroot working area we can make further modifications to
echo "Creating $sysrootdir and syncing sysroot directories under it..."
rm -rf $sysrootdir
mkdir -p $sysrootdir/usr
rsync --archive /usr/lib64 $sysrootdir/usr/
rsync --archive --copy-dirlinks /usr/include $sysrootdir/usr/

echo "Pruning sysroot libdirs of unneeded files and directories..."
rm -r $sysrootdir/usr/lib64/{a,cifs,colord,cracklib,d,e,f,g,k,ldb,libasound,libdev,libgphoto,liblvm,libmoz,libnssckbi,libpython,libslang,libX,lua,m,NetworkManager,n,o,p,r,s,t,X11,x}*

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

# On RHEL 7, /lib64 is a symlink to /usr/lib64. But we need to avoid
# including any symlinks to directories to avoid packaging errors. So
# convert any symlinks from ../../lib64/ to point to their targets, which are
# in the current directory anyway.
echo "Converting problematic library symlinks to local ones..."
pushd $sysrootdir/usr/lib64
find . -maxdepth 1 -lname '../../lib64/*' |
while read -r link ; do
  echo "Converting $link..."
  target=$(readlink "$link")
  # shellcheck disable=SC2001
  reltarget=$(echo "$target" | sed 's|../../lib64/||g')
  rm "$link"
  ln -sf "$reltarget" "./$link"
done
popd

# s390x is a 64-bit platform and keeps those libs in /lib64 and /usr/lib64.
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

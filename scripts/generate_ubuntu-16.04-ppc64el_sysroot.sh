#!/bin/bash
#
# This script generates a sysroot tarball for the ubuntu-16.04-ppc64el
# platform (aka Power8). For our builds we cross-compile most of our
# packages on an ubuntu-16.04-x86_64 pooler system, but the sysroot must
# be created from a native Power8 environment. Therefore, you must run
# this script as root on a Power8 server running Ubuntu 16.04.

triple="powerpc64le-linux-gnu"
# Note that ppc64el (the Debian package arch) is different from
# the gcc host triple. We name the sysroot package based on the
# package arch:
sysrootdir="ubuntu-16.04-ppc64el-sysroot"

echo "Installing critical libraries we need for building gcc and our various dependencies..."
apt --assume-yes install e2fslibs-dev libblkid-dev libc6-dev libncurses5-dev libbz2-dev zlib1g-dev curl libcurl4-openssl-dev libreadline-dev libbz2-dev

# Next we remove a bunch of unneeded junk. The purpose of this is to try
# to get rid of unneeded library files and minmize the size of the sysroot,
# even though we'll still be pruning the libdirs in a later step.
echo "Removing unneeded packages..."
apt --assume-yes purge libgeoip1 libglib2.0-0 libpcap0.8 libpipeline1 libplymouth4 libsasl2-modules libxml2 manpages-dev openssl
apt --assume-yes autoremove

# Create a sysroot working area we can make further modifications to
echo "Creating $sysrootdir and syncing sysroot directories under it..."
rm -rf $sysrootdir
mkdir -p $sysrootdir/lib
mkdir -p $sysrootdir/usr/lib
rsync --archive /lib/$triple $sysrootdir/lib/
rsync --archive /usr/lib/$triple $sysrootdir/usr/lib/
rsync --archive --copy-dirlinks /usr/include $sysrootdir/usr/

echo "Pruning sysroot libdirs of unneeded files and directories..."
rm -r $sysrootdir/lib/$triple/{device,libdevmapper,security}*
rm -r $sysrootdir/usr/lib/$triple/{audit,gconv,krb,openssl,perl}*

# Since we're relocating the sysroot, we can't have absolute symlinks
echo "Converting absolute library symlinks to relative ones..."
pushd $sysrootdir/usr/lib/$triple || exit
find . -maxdepth 1 -lname '/*' |
while read -r link ; do
  echo "Converting $link from absolute to relative..."
  target=$(readlink "$link")
  # shellcheck disable=SC2001
  reltarget=$(echo "$target" | sed 's|/lib/powerpc64le-linux-gnu|../../../lib|g')
  rm "$link"
  ln -sf "$reltarget" "$link"
done
popd || exit

# We duplicate the Debian multilib libraries into lib/ in the sysroot due
# to the fact that leatherman does not yet fully support Debian-style
# multilib path searching:
cp -a $sysrootdir/lib/$triple/* $sysrootdir/lib/
# Likewise, an extra step is needed here to consolidate header files to avoid
# the same problems with multilib path searching:
rsync --archive --copy-dirlinks $sysrootdir/usr/include/$triple/ $sysrootdir/usr/include/

echo "Generating the sysroot tarball..."
if [ -e $sysrootdir.tar.gz ]; then
  rm $sysrootdir.tar.gz
fi
tar --create --gzip --file $sysrootdir.tar.gz --owner=0 --group=0 $sysrootdir

echo "Done. Now copy $sysrootdir.tar.gz over to Artifactory."

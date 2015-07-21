platform "solaris-10-i386" do |plat|
  plat.servicedir "/var/svc/manifest"
  plat.defaultdir "/lib/svc/method"
  plat.servicetype "smf"
  plat.vcloud_name "solaris-10-x86_64"
  plat.tar "/usr/sfw/bin/gtar"
  plat.patch "/usr/bin/gpatch"
  plat.num_cores "/usr/bin/kstat cpu_info | /opt/csw/bin/ggrep -E '[[:space:]]+core_id[[:space:]]' | wc -l"

  plat.provision_with 'echo "# Write the noask file to a temporary directory
# please see man -s 4 admin for details about this file:
# http://www.opensolarisforum.org/man/man4/admin.html
#
# The key thing we don\'t want to prompt for are conflicting files.
# The other nocheck settings are mostly defensive to prevent prompts
# We _do_ want to check for available free space and abort if there is
# not enough
mail=
# Overwrite already installed instances
instance=overwrite
# Do not bother checking for partially installed packages
partial=nocheck
# Do not bother checking the runlevel
runlevel=nocheck
# Do not bother checking package dependencies (We take care of this)
idepend=nocheck
rdepend=nocheck
# DO check for available free space and abort if there isn\'t enough
space=quit
# Do not check for setuid files.
setuid=nocheck
# Do not check if files conflict with other packages
conflict=nocheck
# We have no action scripts.  Do not check for them.
action=nocheck
# Install to the default base directory.
basedir=default" > vanagon-noask;
  pkgadd -n -a vanagon-noask -G -d http://get.opencsw.org/now all;
  /opt/csw/bin/pkgutil -y -i curl rsync gmake pkgconfig ggrep;
  ln -sf /opt/csw/bin/rsync /usr/bin/rsync;
  ntpdate pool.ntp.org'
end

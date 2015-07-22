platform "solaris-11-i386" do |plat|
  plat.servicedir "/lib/svc/manifest"
  plat.defaultdir "/lib/svc/method"
  plat.servicetype "smf"
  plat.vcloud_name "solaris-11-x86_64"
  plat.install_build_dependencies_with "pkg install ", " || [[ $? -eq 4 ]]"

  plat.provision_with 'rm -rf /opt/puppetlabs /var/log/puppetlabs /etc/puppetlabs *; echo "# Write the noask file to a temporary directory
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
  pkgadd -G -n -a vanagon-noask -d http://get.opencsw.org/now all ||:;
  /opt/csw/bin/pkgutil -y -i CSWpkgconfig'
end

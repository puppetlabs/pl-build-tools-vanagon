platform "aix-61-ppc" do |plat|
  # These probably aren't right, but we haven't gotten to building any daemons yet.
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.make "gmake"
  plat.tar "/opt/freeware/bin/tar"
  plat.rpmbuild "/usr/bin/rpm"

  plat.install_build_dependencies_with "#"
  # To use vanagon, mktemp is needed, so just leave this line in.
  plat.aix_package 'http://int-resources.corp.puppetlabs.net/AIX_MIRROR', 'mktemp-1.7-1.aix5.1.ppc.rpm'

  # If you are boostraping GCC, you'll need this line. If you're not, leave it commented.
  #plat.aix_package 'http://pl-build-tools.delivery.puppetlabs.net/aix/6.1/ppc', 'gcc-aix-boostrap-4.6.4-1.aix6.1.ppc.rpm'

end

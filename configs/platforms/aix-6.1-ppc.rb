platform "aix-6.1-ppc" do |plat|
  # Because AIX 7.1 is binary compatible with AIX 6.1, if you need a 7.1
  # package, just build it using the 6.1 platform definition.

  # These probably aren't right, but we haven't gotten to building any daemons yet.
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.make "gmake"
  plat.tar "/opt/freeware/bin/tar"
  plat.rpmbuild "/usr/bin/rpm"

  plat.install_build_dependencies_with "echo Please ensure the following packages are installed:"
  # To use vanagon, mktemp is needed, so just leave this line in.
  plat.aix_package 'http://int-resources.corp.puppetlabs.net/AIX_MIRROR', 'mktemp-1.7-1.aix5.1.ppc.rpm'

  # If you are boostraping GCC, you'll need this line. If you're not, leave it commented.
  #plat.aix_package 'http://pl-build-tools.delivery.puppetlabs.net/aix/6.1/ppc', 'gcc-aix-boostrap-4.6.4-1.aix6.1.ppc.rpm'

end

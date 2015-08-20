platform "aix-7.1-ppc" do |plat|
  # These probably aren't right, but we haven't gotten to building any daemons yet.
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.make "gmake"
  plat.tar "/opt/freeware/bin/tar"
  plat.rpmbuild "/usr/bin/rpm"
  plat.patch "/opt/freeware/bin/patch"

  plat.provision_with "rm -rf /opt/pl-build-tools; rm -rf /var/tmp/tmp.* /var/tmp/*root-root /var/tmp/rpm*"

  plat.install_build_dependencies_with "rpm -Uvh --replacepkgs "

  # To use vanagon, mktemp is needed, so just leave this line in.
  plat.aix_package 'http://int-resources.corp.puppetlabs.net/AIX_MIRROR', 'mktemp-1.7-1.aix5.1.ppc.rpm'

end

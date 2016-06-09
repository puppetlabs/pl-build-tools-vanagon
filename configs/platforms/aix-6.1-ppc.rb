platform "aix-6.1-ppc" do |plat|
  plat.servicetype "aix"

  plat.make "gmake"
  plat.tar "/opt/freeware/bin/tar"
  plat.rpmbuild "/usr/bin/rpm"
  plat.patch "/opt/freeware/bin/patch"

  # Basic vanagon operations require mktemp, rsync, coreutils, make, tar and sed so leave this in there
  plat.provision_with "rpm -Uvh --replacepkgs http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/mktemp-1.7-1.aix5.1.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/rsync-3.0.6-1.aix5.3.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/coreutils-5.2.1-2.aix5.1.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/sed-4.1.1-1.aix5.1.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/make-3.80-1.aix5.1.ppc.rpm http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/tar-1.22-1.aix6.1.ppc.rpm"

  # This is how we clean up our last build since we don't have a pooler image
  plat.provision_with "rm -rf /opt/pl-build-tools; rm -rf /var/tmp/tmp.* /var/tmp/*root-root /var/tmp/rpm* /root/*.jam"

  plat.install_build_dependencies_with "rpm -Uvh --replacepkgs "
  plat.build_host ["pe-aix-61-builder.delivery.puppetlabs.net"]
end

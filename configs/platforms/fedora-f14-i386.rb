# We use this platform to generate packages to build AIO for Arista EOS
platform "fedora-f14-i386" do |plat|
  plat.servicetype "sysv"

  plat.provision_with "yum install -y --nogpgcheck autoconf automake createrepo rsync gcc make rpm-build rpm-libs yum-utils"
  plat.add_build_repository "http://pl-build-tools-staging.delivery.puppetlabs.net/yum/fedora/f14/i386/pl-build-tools-staging-fedora-f14.repo"
  plat.install_build_dependencies_with "yum install -y --nogpgcheck"
  plat.vmpooler_template "fedora-14-i386"
end

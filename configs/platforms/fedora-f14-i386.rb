# We use this platform to generate packages to build AIO for Arista EOS
platform "fedora-f14-i386" do |plat|
  plat.servicedir "/etc/rc.d/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.provision_with "yum install -y --nogpgcheck autoconf automake createrepo rsync gcc make rpm-build rpm-libs yum-utils"
  plat.yum_repo "http://pl-build-tools.delivery.puppetlabs.net/yum/fedora/14/i386/pl-build-tools-fedora-14.repo"
  plat.install_build_dependencies_with "yum install -y --nogpgcheck"
  plat.vcloud_name "fedora-14-i386"
end

platform "el-4-x86_64" do |plat|
  plat.servicedir "/etc/rc.d/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"
  plat.tar "/opt/pl-build-tools-staging/bin/tar"

  plat.add_build_repository "http://pl-build-tools-staging.delivery.puppetlabs.net/yum/el/4/x86_64/pl-build-tools-staging-el-4.repo"
  plat.provision_with "yum install -y autoconf automake createrepo rsync gcc make rpm-build rpm-libs yum-utils; yum update -y pkgconfig"
  # Installing libstdc++-devel needs to be a seperate transaction for it to
  # pull in 64-bit headers, why? I am not sure. I assume it's because in 2004
  # multilib was even more terrible than it is today.
  plat.provision_with "yum install -y libstdc++-devel"

  plat.install_build_dependencies_with "yum install -y"
  plat.vmpooler_template "centos-4-x86_64"
end

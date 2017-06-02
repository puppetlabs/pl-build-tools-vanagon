platform "el-7-aarch64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"
  
  plat.add_build_repository "http://pl-build-tools.delivery.puppetlabs.net/yum/el/7/aarch64/pl-build-tools-aarch64.repo"
  plat.provision_with "yum install -y autoconf automake rsync gcc make rpmdevtools rpm-libs"
  plat.install_build_dependencies_with "yum install -y"
  plat.vmpooler_template "centos-7-aarch64"
end


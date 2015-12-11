platform "el-5-i386" do |plat|
  plat.servicedir "/etc/rc.d/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.yum_repo "http://pl-build-tools.delivery.puppetlabs.net/yum/el/5/i386/pl-build-tools-release-5-1.noarch.rpm"
  plat.provision_with "yum install -y --nogpgcheck autoconf automake createrepo rsync gcc make rpmdevtools rpm-libs yum-utils rpm-sign rpm-build"
  plat.install_build_dependencies_with "yum install -y --nogpgcheck "
  plat.vmpooler_template "centos-5-i386"
end

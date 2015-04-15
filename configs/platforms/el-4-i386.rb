platform "el-4-i386" do |plat|
  plat.servicedir "/etc/rc.d/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.yum_repo  "http://pl-build-tools.delivery.puppetlabs.net/yum/el/4/i386/pl-build-tools-el-4.repo"
  plat.provision_with "yum install -y autoconf automake createrepo rsync gcc make rpm-build rpm-libs yum-utils; yum update -y pkgconfig"
  plat.install_build_dependencies_with "yum install -y"
  plat.vcloud_name "centos-4-i386"
end

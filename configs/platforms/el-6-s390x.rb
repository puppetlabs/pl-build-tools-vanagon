platform "el-6-s390x" do |plat|
  plat.servicedir "/etc/rc.d/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.yum_repo "http://pl-build-tools.delivery.puppetlabs.net/yum/el/6/s390x/pl-build-tools-release-6-1.noarch.rpm"
  plat.yum_repo "http://pl-build-tools.delivery.puppetlabs.net/yum/el/6/x86_64/pl-build-tools-release-6-1.noarch.rpm"
  plat.provision_with "yum install --assumeyes autoconf automake createrepo rsync gcc make rpmdevtools rpm-libs yum-utils rpm-sign"
  plat.install_build_dependencies_with "yum install --assumeyes"
  plat.cross_compiled true
  plat.vmpooler_template "redhat-6-x86_64"
end

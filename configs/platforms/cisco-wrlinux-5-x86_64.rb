platform "cisco-wrlinux-5-x86_64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"
  # Remove these -dev packages that can interfere with our gcc bootstrapping
  plat.provision_with "rpm -e libgmp-dev libmpc-dev libmpfr-dev"
  plat.yum_repo "http://pl-build-tools-staging.delivery.puppetlabs.net/yum/cisco-wrlinux/5/pl-build-tools-staging-cisco-wrlinux-5.repo"
  plat.install_build_dependencies_with "yum install -y"
  plat.vmpooler_template "cisco-wrlinux-5-x86_64"
end

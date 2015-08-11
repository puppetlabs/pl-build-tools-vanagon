platform "cisco-wrlinux-5-x86_64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"
  # Remove these -dev packages that can interfere with our gcc bootstrapping
  plat.provision_with "rpm -e libgmp-dev libmpc-dev libmpfr-dev"
  # NXOS doesn't have any yum repos enabled by default, so this is a no-op:
  plat.install_build_dependencies_with "echo Please ensure the following packages are installed:"
  plat.vcloud_name "cisco-wrlinux-5-x86_64"
end

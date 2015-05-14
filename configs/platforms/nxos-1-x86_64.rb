platform "nxos-1-x86_64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"
  # Remove these -dev packages that can interfere with our gcc bootstrapping
  plat.provision_with "rpm -e libgmp-dev libmpc-dev libmpfr-dev"
  plat.docker_image "nxos_base_image"
  plat.ssh_port 2222
end

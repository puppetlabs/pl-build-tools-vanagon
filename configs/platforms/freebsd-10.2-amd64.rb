platform "freebsd-10.2-amd64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/default"
  plat.servicetype "sysv"

 # plat.provision_with "grep fdesc /etc/fstab || echo fdesc /dev/fd   fdescfs   rw  0 0 >> /etc/fstab"
  plat.provision_with "rm -rf /tmp/workdir"
  plat.provision_with "pkg install -y rsync git gmake coreutils; [ $? == 70 ] && true"
  plat.install_build_dependencies_with "pkg install -y"
  #plat.build_host "fb1"
end

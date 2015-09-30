platform "cisco-wrlinux-7-x86_64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"
  # The development environment provided by Cisco includes the build dependencies
  # such as autoconf automake createrepo rsync gcc make rpm-build rpm-libs yum-utils
  # curl the repo because the OS image doesn't include any yum repos by default - thus initial vanagon yum install would fail
  # Remove these -dev packages that can interfere with our gcc bootstrapping
  plat.provision_with "rpm -e --quiet libgmp-dev libmpc-dev libmpfr-dev; curl -o /etc/yum/repos.d/pl-build-tools-cisco-wrlinux-7.repo http://pl-build-tools.delivery.puppetlabs.net/yum/cisco-wrlinux/7/pl-build-tools-cisco-wrlinux-7.repo"
  plat.install_build_dependencies_with "yum install -y"
  plat.vcloud_name "cisco-wrlinux-7-x86_64"
end

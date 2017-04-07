platform "fedora-f22-x86_64" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

  plat.provision_with "dnf install -y autoconf automake rsync gcc make rpmdevtools rpm-libs"
  plat.add_build_repository "http://pl-build-tools-staging.delivery.puppetlabs.net/yum/pl-build-tools-staging-release-#{plat.get_os_name}-22.noarch.rpm"
  plat.install_build_dependencies_with "dnf install -y"
  plat.vmpooler_template "fedora-22-x86_64"
end

platform "fedora-f23-i386" do |plat|
  plat.servicedir "/usr/lib/systemd/system"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

  plat.provision_with "/usr/bin/dnf install -y --best --allowerasing autoconf automake rsync gcc make rpmdevtools rpm-libs"
  plat.add_build_repository "http://pl-build-tools-staging.delivery.puppetlabs.net/yum/pl-build-tools-staging-release-#{plat.get_os_name}-23.noarch.rpm"
  plat.install_build_dependencies_with "/usr/bin/dnf install -y --best --allowerasing"
  plat.vmpooler_template "fedora-23-i386"
end

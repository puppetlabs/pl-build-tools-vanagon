platform "sles-12-s390" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "systemd"

#  plat.zypper_repo "http://pl-build-tools.delivery.puppetlabs.net/yum/sles/12/x86_64/pl-build-tools-sles-12-x86_64.repo"
  plat.provision_with "rpm -e --force --nodeps pl-gcc"
  plat.provision_with "rpm -e pl-gcc pl-boost pl-yaml-cpp pl-cmake || true"
  plat.provision_with "zypper -n --no-gpg-checks install -y aaa_base autoconf automake rsync gcc make rpm-build"
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
#  plat.vmpooler_template "sles-12-x86_64"
end

platform "sles-10-i386" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/sysconfig"
  plat.servicetype "sysv"

  plat.add_build_repository "http://pl-build-tools-staging.delivery.puppetlabs.net/yum/sles/10/i386/pl-build-tools-staging-sles-10-i386.repo"
  plat.provision_with "zypper -n --no-gpg-checks install -y aaa_base autoconf automake rsync gcc make"
  plat.install_build_dependencies_with "zypper -n --no-gpg-checks install -y"
  plat.vmpooler_template "sles-10-i386"
end

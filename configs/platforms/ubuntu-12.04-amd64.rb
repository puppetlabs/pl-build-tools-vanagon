platform "ubuntu-12.04-amd64" do |plat|
  plat.servicedir "/etc/init.d"
  plat.defaultdir "/etc/default"
  plat.servicetype "sysv"
  plat.codename "precise"

  plat.add_build_repository "http://pl-build-tools-staging.delivery.puppetlabs.net/debian/pl-build-tools-staging-release-#{plat.get_codename}.deb"
  plat.provision_with "export DEBIAN_FRONTEND=noninteractive; apt-get update -qq; apt-get install -qy --no-install-recommends build-essential devscripts make quilt pkg-config debhelper rsync fakeroot"
  plat.install_build_dependencies_with "DEBIAN_FRONTEND=noninteractive; apt-get install -qy --no-install-recommends "
  plat.vmpooler_template "ubuntu-1204-x86_64"
  plat.output_dir File.join("deb", plat.get_codename)
end

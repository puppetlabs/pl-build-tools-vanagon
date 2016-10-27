project "pl-binutils" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  if platform.is_cross_compiled_linux?
    proj.name "pl-binutils-#{platform.architecture}"
    # We need to set noarch here - otherwise the generated packages
    # will specify the target arch and not be installable
    proj.noarch
  end

  proj.description "Puppet Labs Binutils"
  proj.version "2.26"
  proj.release "4"
  proj.license "GPLv3+"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  if platform.is_solaris? && platform.os_version == "10"
    proj.version "2.27"
    proj.release "2"
  end

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "binutils"
  proj.target_repo ""
end

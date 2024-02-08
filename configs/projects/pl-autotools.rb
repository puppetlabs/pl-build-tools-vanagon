project "pl-autotools" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.provides "pl-autoconf", "2.72"

  proj.description "Puppet Labs Autotools"
  proj.version "1.16"
  proj.license "GPLv3+"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "m4"
  proj.component "autoconf"
  proj.component "automake"
  proj.target_repo ""
end

project "pl-make" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs Make"
  proj.version "4.1"
  proj.license "GPLv2"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.requires 'pl-gcc'

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "make"
  proj.target_repo ""

end

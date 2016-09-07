project "pl-cmake" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs cmake"
  proj.version "3.5.2"
  proj.release "4"
  proj.license "BSD"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "toolchain"
  proj.component "cmake"
  proj.target_repo ""
end

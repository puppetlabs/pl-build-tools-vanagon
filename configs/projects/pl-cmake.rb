project "pl-cmake" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs cmake"
  if platform.name =~ /fedora-f24|debian-8-armel/
    proj.version "3.5.2"
    proj.release "5"
  else
    proj.version "3.2.3"
    proj.release "17"
  end
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

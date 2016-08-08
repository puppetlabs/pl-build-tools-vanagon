project "pl-boost" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs boost"
  if platform.architecture =~ /arm/
    proj.version "1.61.0"
    proj.release "4"
  else
    proj.version "1.58.0"
    proj.release "6"
  end

  proj.description "Puppet Inc boost"
  proj.license "Boost and MIT and Python"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  if platform.is_cross_compiled_linux?
    proj.name "pl-boost-#{platform.architecture}"
    proj.noarch
  else
    proj.requires "pl-gcc"
  end

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "boost"
  proj.target_repo ""
end

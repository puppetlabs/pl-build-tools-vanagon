project "pl-boost" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs boost"
  if proj.get_platform.is_solaris?
    proj.version "1.57.0"
  else
    proj.version "1.58.0"
  end
  proj.license "Boost and MIT and Python"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.requires 'pl-gcc'

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")


  proj.component "boost"
  proj.target_repo ""

  proj.directory proj.prefix
end

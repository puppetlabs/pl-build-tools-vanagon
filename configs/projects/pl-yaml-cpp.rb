project "pl-yaml-cpp" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Yaml CPP"
  if platform.architecture =~ /arm/ || platform.name =~ /fedora-f24/
    proj.version "0.5.3"
    proj.release "1"
  else
    proj.version "0.5.3"
    proj.release "1"
  end
  proj.license "MIT"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  if platform.is_cross_compiled?
    proj.name "pl-yaml-cpp-#{platform.architecture}"
    proj.noarch
  else
    proj.requires "pl-gcc"
    proj.requires "pl-cmake"
    proj.requires "pl-boost"
  end

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "yaml-cpp"
  proj.target_repo ""
end

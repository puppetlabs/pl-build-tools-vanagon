project "pl-yaml-cpp" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Yaml CPP"
  proj.version "0.5.1"
  proj.license "MIT"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  if platform.name =~ /solaris-11/
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

  # On windows, we aren't yet building the cmake dependency. As a result,
  # we need to ensure anything that uses cmake also has access to the toolchain file.
  # This will prove a challenge for puppet-agent
  if platform.is_windows?
    proj.component "toolchain"
  end

  proj.target_repo ""

end

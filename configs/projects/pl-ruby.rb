project "pl-ruby" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs Ruby used for cross-compiling"

  proj.license "2 Clause BSD"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"
  proj.version "2.1.6"
  proj.release "4"

  # Platform specific - these flags do not work on AIX
  unless platform.is_aix?
    proj.setting(:cflags, "-I#{proj.includedir}")
    proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")
  end

  proj.component "ruby"
  proj.target_repo ""
end

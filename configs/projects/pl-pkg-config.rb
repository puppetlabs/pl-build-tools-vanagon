project "pl-pkg-config" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs Pkg-config"
  proj.version "0.28"
  proj.release "2"
  proj.license "GPLv2+"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "pkg-config"
  proj.target_repo ""

  #proj.register_rewrite_rule 'http', proj.buildsources_url
end

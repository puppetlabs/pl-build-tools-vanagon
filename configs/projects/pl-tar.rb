project "pl-tar" do |proj|
  # Project level settings our components will care about
  instance_eval File.read('configs/projects/pl-build-tools.rb')

  proj.description "Puppet Labs Gnu Tar"
  proj.version "1.28"
  proj.release "2"
  proj.license "GPLv3"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "tar"
  proj.target_repo ""

  proj.register_rewrite_rule 'http', 'http://buildsources.delivery.puppetlabs.net'

end

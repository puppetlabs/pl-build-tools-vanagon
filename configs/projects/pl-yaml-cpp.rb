project "pl-yaml-cpp" do |proj|
  # Project level settings our components will care about
  proj.setting(:prefix, "/opt/pl-build-tools")
  proj.setting(:sysconfdir, "/etc/pl-build-tools")
  proj.setting(:logdir, "/var/log/pl-build-tools")
  proj.setting(:piddir, "/var/run/pl-build-tools")
  proj.setting(:bindir, File.join(proj.prefix, "bin"))
  proj.setting(:libdir, File.join(proj.prefix, "lib"))
  proj.setting(:includedir, File.join(proj.prefix, "include"))
  proj.setting(:datadir, File.join(proj.prefix, "share"))
  proj.setting(:mandir, File.join(proj.datadir, "man"))

  proj.description "Puppet Labs boost"
  proj.version "0.5.1"
  proj.license "Boost and MIT and Python"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  proj.requires 'pl-gcc'
  proj.requires 'pl-cmake'
  proj.requires 'pl-boost'

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "yaml-cpp"
  proj.target_repo ""

  proj.directory proj.prefix
end

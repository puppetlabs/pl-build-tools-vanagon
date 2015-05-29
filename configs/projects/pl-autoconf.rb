project "pl-autoconf" do |proj|
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

  proj.description "Puppet Labs Autoconf"
  proj.version "2.69"
  proj.license "GPLv3+"
  proj.vendor "Puppet Labs <info@puppetlabs.com>"
  proj.homepage "https://www.puppetlabs.com"

  # Platform specific
  proj.setting(:cflags, "-I#{proj.includedir}")
  proj.setting(:ldflags, "-L#{proj.libdir} -Wl,-rpath=#{proj.libdir}")

  proj.component "m4"
  proj.component "autoconf"
  proj.target_repo ""


  proj.directory proj.prefix
end

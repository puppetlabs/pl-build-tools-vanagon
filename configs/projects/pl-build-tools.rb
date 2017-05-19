# Contains all common project settings in one place
platform = proj.get_platform

# platform_triple
if platform.is_solaris?
  if platform.architecture == 'i386'
    platform_triple = "#{platform.architecture}-pc-solaris2.#{platform.os_version}"
  else
    platform_triple = "#{platform.architecture}-sun-solaris2.#{platform.os_version}"
  end
elsif platform.architecture == "s390x" && platform.is_rpm?
  platform_triple = "s390x-linux-gnu"
elsif platform.architecture == "powerpc" && platform.is_deb?
  platform_triple = "powerpc-linux-gnu"
elsif platform.architecture == "ppc64el" && platform.is_deb?
  # Note that the platform.architecture is the Debian packaging arch,
  # which differs from the platform triple used when compiling:
  platform_triple = "powerpc64le-linux-gnu"
elsif platform.architecture == "ppc64le" && platform.is_rpm?
  platform_triple = "ppc64le-redhat-linux"
elsif platform.architecture == "armhf"
  platform_triple = "arm-linux-gnueabihf"
elsif platform.architecture == "armel"
  platform_triple = "arm-linux-gnueabi"
elsif platform.is_windows?
  if platform.architecture == "x64"
    platform_triple = "x86_64-unknown-mingw32"
  else
    platform_triple = "i686-unknown-mingw32"
  end
  host = "--host #{platform_triple}"
end

proj.setting(:host, host)

# Project-level settings our components will care about
proj.setting(:platform_triple, platform_triple)
if platform.is_windows?
  proj.setting(:basedir, "C:/tools/pl-build-tools")
  proj.setting(:prefix, "C:/tools/pl-build-tools")
else
  proj.setting(:basedir, "/opt/pl-build-tools")
  if platform_triple.nil?
    proj.setting(:prefix, "/opt/pl-build-tools")
  else
    proj.setting(:prefix, "/opt/pl-build-tools/#{platform_triple}")
  end
end
proj.setting(:sysconfdir, "/etc/pl-build-tools")
proj.setting(:logdir, "/var/log/pl-build-tools")
proj.setting(:piddir, "/var/run/pl-build-tools")
proj.setting(:bindir, File.join(proj.prefix, "bin"))
if platform.architecture == "s390x"
  proj.setting(:libdir, File.join(proj.prefix, "lib64"))
else
  proj.setting(:libdir, File.join(proj.prefix, "lib"))
end
proj.setting(:includedir, File.join(proj.prefix, "include"))
proj.setting(:datadir, File.join(proj.prefix, "share"))
proj.setting(:mandir, File.join(proj.datadir, "man"))

# proj.identifier
if platform.is_solaris?
  proj.identifier "puppetlabs.com"
end

proj.directory proj.basedir

# Here we rewrite public http urls to use our internal source host instead.
# Something like https://www.openssl.org/source/openssl-1.0.0r.tar.gz gets
# rewritten as
# http://buildsources.delivery.puppetlabs.net/openssl-1.0.0r.tar.gz
proj.register_rewrite_rule 'http', 'http://buildsources.delivery.puppetlabs.net'

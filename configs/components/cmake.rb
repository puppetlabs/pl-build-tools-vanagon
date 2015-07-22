component "cmake" do |pkg, settings, platform|
  pkg.version "3.2.3"
  pkg.md5sum "d51c92bf66b1e9d4fe2b7aaedd51377c"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  # This is pretty horrible.  But so is package management on OSX.
  if platform.is_osx?
    pkg.build_requires "pl-gcc-4.8.2"
  elsif platform.name =~ /solaris-10/
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWarc.pkg.gz'
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWgnu-idn.pkg.gz'
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWgpch.pkg.gz'
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWgtar.pkg.gz'
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWhea.pkg.gz'
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWlibm.pkg.gz'
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWwgetu.pkg.gz'
    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWxcu4.pkg.gz'

    pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-gcc-4.8.2.i386.pkg.gz'
  else
    pkg.build_requires "pl-gcc"
    pkg.build_requires "make"

    case
    when platform.is_nxos?
      pkg.build_requires "ncurses-dev"
    when platform.is_rpm?
      pkg.build_requires "ncurses-devel"
    when platform.is_deb?
      pkg.build_requires "libncurses5-dev"
    end
  end

  if platform.is_aix? or platform.is_osx? or platform.is_solaris?
    pkg.environment "LDFLAGS" => "$${LDFLAGS}"
  else
    pkg.environment "LDFLAGS" => "-Wl,-rpath=#{settings[:bindir]}/lib,-rpath=#{settings[:bindir]}/lib64,--enable-new-dtags"
  end

  # Different toolchains for different target platforms.
  if platform.is_osx?
    toolchain="pl-build-toolchain-darwin"
  else
    toolchain="pl-build-toolchain"
  end

  pkg.environment "PATH" => "$$PATH:/usr/local/bin"
  pkg.environment "CC"   => "#{settings[:bindir]}/gcc"
  pkg.environment "CXX"  => "#{settings[:bindir]}/g++"
  pkg.environment "MAKE" => platform.make

  # Initialize an empty configure_command string
  configure_command  = ""

  configure_command << " ./configure --prefix=#{settings[:prefix]} --docdir=share/doc"

  # Even though only system curl is available on the build host,
  # the build on OSX bombs without this.
  if platform.is_osx?
    configure_command << " --system-curl"
  end

  pkg.configure do
    configure_command
  end

  pkg.build do
    [
      "./configure --prefix=#{settings[:prefix]} --docdir=share/doc",
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
      "chmod 644 #{settings[:prefix]}/pl-build-toolchain.cmake"
    ]
  end

  pkg.install do
    [
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      # Here we replace all files with spaces in them with underscores because solaris 10 absolutely can't have files in packages with spaces
      %Q[find #{settings[:basedir]} -type f | grep ' ' | while read sfile; do mv "$$sfile" "$${sfile// /_}"; done]
    ]
  end
end

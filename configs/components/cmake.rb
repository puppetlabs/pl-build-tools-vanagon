component "cmake" do |pkg, settings, platform|
  pkg.version "3.2.3"
  pkg.md5sum "d51c92bf66b1e9d4fe2b7aaedd51377c"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  # This is pretty horrible.  But so is package management on OSX.
  if platform.is_osx?
    pkg.build_requires "pl-gcc-4.8.2"
  elsif platform.is_solaris?
    if platform.os_version == "10"
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-gcc-4.8.2.i386.pkg.gz'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-binutils-2.25.i386.pkg.gz'
    elsif platform.os_version == "11"
      pkg.build_requires 'pl-binutils'
      pkg.build_requires 'pl-gcc'
    end

    pkg.apply_patch 'resources/patches/cmake/use-g++-as-linker-solaris.patch'
  elsif platform.is_aix?
    pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/#{platform.os_version}/ppc/pl-gcc-5.2.0-1.aix#{platform.os_version}.ppc.rpm"
    pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/make-3.80-1.aix5.1.ppc.rpm"
  else
    pkg.build_requires "pl-gcc"
    pkg.build_requires "make"

    case
    when platform.is_cisco_wrlinux?
      pkg.build_requires "ncurses-dev"
    when platform.is_rpm?
      pkg.build_requires "ncurses-devel"
    when platform.is_deb?
      pkg.build_requires "libncurses5-dev"
    end
  end

  if platform.name =~ /sles-12/
    pkg.apply_patch 'resources/patches/cmake/avoid-select-sles-12.patch'
  end

  if platform.name =~ /el-4/
    pkg.build_requires "pl-tar"
  end

  pkg.build_requires 'toolchain'

  if platform.is_aix? or platform.is_osx?
    pkg.environment "LDFLAGS" => "$${LDFLAGS}"
    pkg.environment "CC"   => "#{settings[:bindir]}/gcc"
    pkg.environment "CXX"  => "#{settings[:bindir]}/g++"
  elsif platform.is_solaris?
    pkg.environment "LDFLAGS"  => "-Wl,-rpath=#{settings[:basedir]}/lib"
    pkg.environment "CXXFLAGS" => "-Wl,-rpath=#{settings[:basedir]}/lib -static-libstdc++ -static-libgcc"
    pkg.environment "CFLAGS" => "-Wl,-rpath=#{settings[:basedir]}/lib -static-libgcc"
    pkg.environment "CC" => "#{settings[:basedir]}/bin/#{settings[:platform_triple]}-gcc"
    pkg.environment "CXX" => "#{settings[:basedir]}/bin/#{settings[:platform_triple]}-g++"
  else
    pkg.environment "LDFLAGS" => "-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:prefix]}/lib64,--enable-new-dtags"
    pkg.environment "CC"   => "#{settings[:bindir]}/gcc"
    pkg.environment "CXX"  => "#{settings[:bindir]}/g++"
  end

  pkg.environment "PATH" => "$$PATH:/usr/local/bin"
  pkg.environment "MAKE" => platform.make

  # Even though only system curl is available on the build host,
  # the build on OSX bombs without this.
  if platform.is_osx?
    extra_flags = " --system-curl"
  end

  pkg.configure do
    "./configure --prefix=#{settings[:prefix]} --docdir=share/doc #{extra_flags}"
  end

  pkg.build do
    [
      "./configure --prefix=#{settings[:prefix]} --docdir=share/doc",
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
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

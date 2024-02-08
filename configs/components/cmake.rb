component 'cmake' do |pkg, settings, platform|
  cmake_full_version = settings[:cmake_version]

  pkg.version cmake_full_version
  pkg.md5sum settings[:cmake_source_md5sum]
  pkg.url settings[:cmake_download_url]
  pkg.mirror "#{settings[:buildsources_url]}/#{settings[:cmake_tarball_name]}"

  pl_build_tools = 'http://pl-build-tools.delivery.puppetlabs.net'
  os_mirror = 'http://osmirror.delivery.puppetlabs.net'
  base_path = '/usr/local/bin:/usr/bin:/bin'

  pkg.build_requires 'toolchain'

  case
  when platform.is_aix?
    pkg.build_requires "#{pl_build_tools}/aix/#{platform.os_version}/ppc/pl-gcc-5.2.0-1.aix#{platform.os_version}.ppc.rpm"
    pkg.build_requires "#{os_mirror}/AIX_MIRROR/make-3.80-1.aix5.1.ppc.rpm"
    pkg.environment('CC', "#{settings[:bindir]}/gcc")
    pkg.environment('CXX',"#{settings[:bindir]}/g++")
    pkg.environment('PATH', base_path)

  when platform.is_solaris? && platform.os_version == '10'
    pkg.apply_patch 'resources/patches/cmake/use-g++-as-linker-solaris.patch'
    pkg.build_requires "#{pl_build_tools}/solaris/10/pl-gcc-4.8.2-8.i386.pkg.gz"
    pkg.build_requires "#{pl_build_tools}/solaris/10/pl-binutils-2.27-1.i386.pkg.gz"
    pkg.environment('LDFLAGS', "-Wl,-rpath=#{settings[:basedir]}/lib")
    pkg.environment('CXXFLAGS', "-Wl,-rpath=#{settings[:basedir]}/lib -static-libstdc++ -static-libgcc")
    pkg.environment('CFLAGS', "-Wl,-rpath=#{settings[:basedir]}/lib -static-libgcc")
    pkg.environment('CC', "#{settings[:basedir]}/bin/#{settings[:platform_triple]}-gcc")
    pkg.environment('CXX', "#{settings[:basedir]}/bin/#{settings[:platform_triple]}-g++")
    pkg.environment('PATH', "#{base_path}:/opt/csw/bin")

  when platform.is_sles? && platform.os_version == '11'
    pkg.build_requires 'pl-gcc8'
    pkg.build_requires 'make'
    pkg.build_requires 'ncurses-devel'
    pkg.build_requires 'openssl-devel'
    pkg.environment('CC', "#{settings[:basedir]}/bin/gcc")
    pkg.environment('CXX', "#{settings[:basedir]}/bin/g++")

    pkg.environment('LDFLAGS', "-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:prefix]}/lib64,--enable-new-dtags")
    pkg.environment('PATH', base_path)

  when platform.is_solaris? && platform.os_version == '11'
    pkg.apply_patch 'resources/patches/cmake/use-g++-as-linker-solaris.patch'
    pkg.build_requires 'pl-binutils'
    pkg.build_requires 'pl-gcc'
    pkg.environment('LDFLAGS', "-Wl,-rpath=#{settings[:basedir]}/lib")
    pkg.environment('CXXFLAGS', "-Wl,-rpath=#{settings[:basedir]}/lib -static-libstdc++ -static-libgcc")
    pkg.environment('CFLAGS', "-Wl,-rpath=#{settings[:basedir]}/lib -static-libgcc")
    pkg.environment('CC', "#{settings[:basedir]}/bin/#{settings[:platform_triple]}-gcc")
    pkg.environment('CXX', "#{settings[:basedir]}/bin/#{settings[:platform_triple]}-g++")
    pkg.environment('PATH', "#{base_path}:/opt/csw/bin")

  when platform.is_cisco_wrlinux?
    pkg.build_requires 'pl-gcc'
    pkg.build_requires 'make'
    pkg.build_requires 'ncurses-dev'
    pkg.build_requires 'openssl-dev'
    pkg.environment('LDFLAGS', "-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:prefix]}/lib64,--enable-new-dtags")
    pkg.environment('CC', "#{settings[:bindir]}/gcc")
    pkg.environment('CXX', "#{settings[:bindir]}/g++")
    pkg.environment('PATH', base_path)

  when platform.is_rpm?
    pkg.build_requires 'gcc-c++'
    pkg.build_requires 'make'
    pkg.build_requires 'ncurses-devel'
    pkg.build_requires 'openssl-devel'
    pkg.environment('LDFLAGS', "-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:prefix]}/lib64,--enable-new-dtags")
    pkg.environment('PATH', base_path)

  when platform.is_deb?
    pkg.build_requires 'make'
    pkg.build_requires 'libncurses5-dev'
    pkg.build_requires 'openssl-dev'
    pkg.environment('LDFLAGS', "-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:prefix]}/lib64,--enable-new-dtags")
    pkg.environment('PATH', base_path)
  end

  pkg.configure do
    "./configure --prefix=#{settings[:prefix]} --docdir=share/doc"
  end

  pkg.build do
    "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
  end

  pkg.install do
    [
      "#{platform[:make]} install",
      # Replace all files with spaces in them with underscores because solaris 10
      # can't have files with spaces in packages:
      %Q[find #{settings[:basedir]} -type f | grep ' ' | while read sfile; do mv "$$sfile" "$${sfile// /_}"; done]
    ]
  end
end

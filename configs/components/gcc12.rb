# See: https://gcc.gnu.org/install/prerequisites.html

component 'gcc12' do |pkg, settings, platform|
  gcc_version = settings[:gcc_version]

  # Source-Related Metadata
  pkg.md5sum 'd7644b494246450468464ffc2c2b19c3'

  pkg.url "http://ftp.gnu.org/gnu/gcc/gcc-#{gcc_version}/gcc-#{gcc_version}.tar.gz"

  # Package Dependency Metadata
  if platform.is_linux?
    pkg.requires 'binutils'
  end

  if platform.is_deb? || platform.is_cisco_wrlinux?
    pkg.requires 'libc6-dev'
  end

  if platform.is_solaris? && platform.os_version == "11"
    pkg.requires "pl-binutils-#{platform.architecture}"
  end
  # Build Requirements
  # TODO: TESTING
  # In the future we may want to enable the test suite for GCC. If we do we'll
  # need dejagnu, expect and tcl. Those packages should be available on all RPM
  # systems (other than AIX and SLES10)
  if platform.is_rpm?
    pkg.build_requires 'gcc'
    pkg.build_requires 'binutils'
    pkg.build_requires 'gzip'
    pkg.build_requires 'bzip2'
    pkg.build_requires 'make'
    pkg.build_requires 'tar'

    case
    when platform.is_cisco_wrlinux?
      pkg.build_requires 'g++'
      pkg.build_requires 'libstdc++-dev'
      pkg.build_requires 'libc6-dev'
    when %w[ppc64le aarch64 ppc64].include?(platform.architecture)
      pkg.build_requires "pl-binutils-#{platform.architecture}"
      pkg.build_requires 'sysroot'
      pkg.build_requires 'libstdc++-devel'
      pkg.build_requires 'gcc-c++'
    else
      pkg.build_requires 'libstdc++-devel'
      pkg.build_requires 'gcc-c++'
    end
  elsif platform.is_cross_compiled_linux?
    pkg.build_requires "pl-binutils-#{platform.architecture}"
    pkg.build_requires 'sysroot'
  elsif platform.is_solaris?
    if platform.os_version == '10'
      pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-binutils-2.27-1.#{platform.architecture}.pkg.gz"
    elsif platform.os_version == '11'
      pkg.build_requires "pl-binutils-#{platform.architecture}"
    end
    if platform.architecture.downcase == 'sparc'
      pkg.build_requires 'sysroot'
    end
  end

  # Build-time Configuration
  if platform.is_cross_compiled_linux?
    # Without this, libstdc++ and libssp get built with a dependency on
    # libgcc_s, but with no way to find it.
    pkg.environment('LDFLAGS_FOR_TARGET', '-Wl,-rpath=/opt/puppetlabs/puppet/lib')
    # Do not use fPIC with the cross-compiler.
    pkg.environment('CFLAGS', '$${CFLAGS}')
    pkg.environment('CXXFLAGS', '$${CXXFLAGS}')
  elsif platform.is_solaris?
    # Solaris needs an augmented path to find binutils correctly and to setup CC and CXX
    pkg.environment('PATH', "#{File.join(settings[:basedir], 'bin')}:#{settings[:bindir]}:" \
                            "/usr/ccs/bin:/usr/sfw/bin:$$PATH")
    pkg.environment('CC', '/usr/sfw/bin/gcc')
    pkg.environment('CXX', '/usr/sfw/bin/g++')

    # Without this, libstdc++ and libssp get built with a dependency on
    # libgcc_s, but with no way to find it.
    pkg.environment('LDFLAGS_FOR_TARGET', '-Wl,-rpath=/opt/puppetlabs/puppet/lib')

    # Adding -fPIC to the cross-compiler produces a cross-compiler that can't
    # build executables. They all core dump and segfault. Do not use fPIC with
    # the cross-compiler.
    if platform.architecture == 'sparc'
      pkg.environment('CFLAGS', '$${CFLAGS}')
      pkg.environment('CXXFLAGS', '$${CXXFLAGS}')
    else
      pkg.environment('CFLAGS', '$${CFLAGS} -fPIC')
      pkg.environment('CXXFLAGS', '$${CXXFLAGS} -fPIC')
      pkg.environment('CFLAGS_FOR_TARGET', '-fPIC')
    end
  else
    # We set -fPIC to ensure that our 64 bit builds can correctly link and compile.
    # We enable it on both 32-bit and 64-bit builds for consistency.
    pkg.environment('CFLAGS', '$${CFLAGS} -fPIC')
    pkg.environment('CXXFLAGS','$${CXXFLAGS} -fPIC')
    pkg.environment('CFLAGS_FOR_TARGET', '-fPIC')

    # Without this, libstdc++ and libssp get built with a dependency on
    # libgcc_s, but with no way to find it.
    pkg.environment('LDFLAGS_FOR_TARGET', '-Wl,-rpath=/opt/puppetlabs/puppet/lib')
  end


  configure_steps = ''

  # We've abstracted the configure command a bit because of the difference in
  # flags needed for ARM vs x86 and x86_64 vs AIX/ppc
  configure_steps << " ../gcc-#{gcc_version}/configure \
    --prefix=#{settings[:basedir]} \
    --disable-nls \
    --enable-languages=c,c++ \
    --disable-libgcj "

  # On the ARM Debian builds, you actually need multilib, so we'll exclude this
  # exclude flag on ARM.
  unless platform.architecture =~ /arm/i || platform.is_solaris?
    configure_steps << ' --disable-multilib'
  end

  # The arm flags were taken from the Debian GCC compile options. (gcc -v)
  # The fpu, float, flags are all to ensure the proper floating point
  # type (which is hard) on ARM.
  # The other flags are to instruct GCC on the proper target to look at in
  # libgcc when linking.
  if platform.architecture =~ /arm/i
    configure_steps << ' --with-arch-directory=arm \ '
    if platform.architecture == 'armhf'
      configure_steps << ' --with-fpu=vfp --with-float=hard \ '
    else
      configure_steps << '--with-arch=armv4t --with-float=soft  \ '
    end
  end

  if platform.is_cross_compiled_linux?
    configure_steps << " --target=#{settings[:platform_triple]} \
      --with-sysroot=#{settings[:prefix]}/sysroot"
  end

  if platform.is_solaris?
    configure_steps << " --target=#{settings[:platform_triple]} \
      --with-gnu-as \
      --with-as=#{settings[:bindir]}/as \
      --with-gnu-ld \
      --with-ld=#{settings[:bindir]}/ld"

      if platform.architecture.downcase == 'sparc'
        configure_steps << " --with-sysroot=#{settings[:prefix]}/sysroot"
      end
  end

  # Build Commands
  pkg.configure do
    [
      "ln -s ../gmp-#{settings[:gmp_version]} gmp",
      "ln -s ../mpc-#{settings[:mpc_version]} mpc",
      "ln -s ../mpfr-#{settings[:mpfr_version]} mpfr",
      'mkdir -p ../obj-gcc-build-dir',
      'cd ../obj-gcc-build-dir',
      configure_steps
    ]
  end


  pkg.build do
    [
      'cd ../obj-gcc-build-dir',
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    [
      'cd ../obj-gcc-build-dir',
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
    ]
  end
end

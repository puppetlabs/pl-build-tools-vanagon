component "gcc" do |pkg, settings, platform|
  pkg.version "6.1.0"
  pkg.md5sum "8d04cbdfddcfad775fdbc5e112af2690"
  pkg.url "http://ftp.gnu.org/gnu/gcc/gcc-#{pkg.get_version}/gcc-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/gcc/aix-inclhack.patch" if platform.is_aix?

  # Package Dependency Metadata
  if platform.is_linux?
    pkg.requires "binutils"
  end

  if platform.is_deb? || platform.is_cisco_wrlinux?
    pkg.requires "libc6-dev"
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
    unless platform.is_aix?
      pkg.build_requires "gcc"
      pkg.build_requires "binutils"
      pkg.build_requires "gzip"
      pkg.build_requires "bzip2"
      pkg.build_requires "make"
      pkg.build_requires "tar"
    end

    case
    when platform.is_aix?
      # not version-specific for AIX
      pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/gawk-3.1.3-1.aix5.1.ppc.rpm"
      pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/gzip-1.2.4a-10.aix5.2.ppc.rpm"
      pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/bzip2-1.0.5-3.aix5.3.ppc.rpm"
      pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/make-3.80-1.aix5.1.ppc.rpm"
      if platform.os_version =~ /6.1|7.1/
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/binutils-2.14-4.aix6.1.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/gcc-4.2.0-3.aix6.1.ppc.rpm"
        pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/6.1/ppc/gcc-aix-bootstrap-4.6.4-1.aix6.1.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/libstdcplusplus-4.2.0-3.aix6.1.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/libstdcplusplus-devel-4.2.0-3.aix6.1.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/gcc-cplusplus-4.2.0-3.aix6.1.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/tar-1.22-1.aix6.1.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/libgcc-4.2.0-3.aix6.1.ppc.rpm"
      else
        # AIX 5.3
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/binutils-2.14-3.aix5.1.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/gcc-4.2.0-3.aix5.3.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/gcc-cplusplus-4.2.0-3.aix5.3.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/libstdcplusplus-4.2.0-3.aix5.3.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/libstdcplusplus-devel-4.2.0-3.aix5.3.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/tar-1.14-2.aix5.1.ppc.rpm"
        pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/libgcc-4.2.0-3.aix5.3.ppc.rpm"
        pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/5.3/ppc/gcc-aix-bootstrap-4.6.4-1.aix5.3.ppc.rpm"
        # AIX 5.3 gcc464 is currently a tarball that should be built into an rpm
      end
    when platform.is_cisco_wrlinux?
      pkg.build_requires "g++"
      pkg.build_requires "libstdc++-dev"
      pkg.build_requires "libc6-dev"
    when platform.architecture == "s390x"
      # The s390x platforms we support are all RPM-based (SLES and RHEL)
      pkg.build_requires "pl-binutils-#{platform.architecture}"
      pkg.build_requires "sysroot"
      pkg.build_requires "libstdc++-devel"
      pkg.build_requires "gcc-c++"
    else
      pkg.build_requires "libstdc++-devel"
      pkg.build_requires "gcc-c++"
    end
  elsif platform.is_cross_compiled_linux?
    pkg.build_requires "pl-binutils-#{platform.architecture}"
    pkg.build_requires "sysroot"
  elsif platform.is_solaris?
    if platform.os_version == '10'
      pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-binutils-2.25.#{platform.architecture}.pkg.gz"
    elsif platform.os_version == '11'
      pkg.build_requires "pl-binutils-#{platform.architecture}"
    end
    if platform.architecture.downcase == 'sparc'
      pkg.build_requires "sysroot"
    end
  end

  if platform.name =~ /el-4/
    pkg.build_requires "pl-tar"
  end

  # Build-time Configuration
  if platform.is_aix?
    # AIX can't use the exact flags that linux does, but we should still
    # attempt to honor any flags passed via environment variables.
    pkg.environment "CFLAGS"   => "$${CFLAGS}"
    pkg.environment "CXXFLAGS" => "$${CXXFLAGS}"
  elsif platform.is_cross_compiled_linux?
    # Without this, libstdc++ and libssp get built with a dependency on
    # libgcc_s, but with no way to find it.
    pkg.environment "LDFLAGS_FOR_TARGET" => "-Wl,-rpath=/opt/puppetlabs/puppet/lib"
    # Do not use fPIC with the cross-compiler.
    pkg.environment "CFLAGS" => "$${CFLAGS}"
  elsif platform.architecture == "s390x"
    # Do not use fPIC with the cross-compiler.
    pkg.environment "CFLAGS" => "$${CFLAGS}"
    pkg.environment "CXXFLAGS" => "$${CXXFLAGS}"
  elsif platform.is_solaris?
    # Solaris needs an augmented path to find binutils correctly and to setup CC and CXX
    pkg.environment "PATH"  => "#{File.join(settings[:basedir], 'bin')}:#{settings[:bindir]}:/usr/ccs/bin:/usr/sfw/bin:$$PATH"
    pkg.environment "CC"    => "/usr/sfw/bin/gcc"
    pkg.environment "CXX"   => "/usr/sfw/bin/g++"

    # Without this, libstdc++ and libssp get built with a dependency on
    # libgcc_s, but with no way to find it.
    pkg.environment "LDFLAGS_FOR_TARGET" => "-Wl,-rpath=/opt/puppetlabs/puppet/lib"

    # Adding -fPIC to the cross-compiler produces a cross-compiler that can't
    # build executables. They all core dump and segfault. Do not use fPIC with
    # the cross-compiler.
    if platform.architecture == "sparc"
      pkg.environment "CFLAGS" => "$${CFLAGS}"
      pkg.environment "CXXFLAGS" => "$${CXXFLAGS}"
    else
      pkg.environment "CFLAGS" => "$${CFLAGS} -fPIC"
      pkg.environment "CXXFLAGS" => "$${CXXFLAGS} -fPIC"
      pkg.environment "CFLAGS_FOR_TARGET" => "-fPIC"
    end
  else
    # We set -fPIC to ensure that our 64 bit builds can correctly link and compile.
    # We enable it on both 32-bit and 64-bit builds for consistency.
    pkg.environment "CFLAGS" => "$${CFLAGS} -fPIC"
    pkg.environment "CXXFLAGS" => "$${CXXFLAGS} -fPIC"
    pkg.environment "CFLAGS_FOR_TARGET" => "-fPIC"

    # Without this, libstdc++ and libssp get built with a dependency on
    # libgcc_s, but with no way to find it.
    pkg.environment "LDFLAGS_FOR_TARGET" => "-Wl,-rpath=/opt/puppetlabs/puppet/lib"
  end

  # Initialize an empty configure_command string
  configure_command = ""

  # We've abstracted the configure command a bit because of the difference in
  # flags needed for ARM vs x86 and x86_64 vs AIX/ppc
  configure_command << " ../gcc-#{pkg.get_version}/configure \
    --prefix=#{settings[:basedir]} \
    --disable-nls \
    --enable-languages=c,c++ \
    --disable-libgcj "

  # We used to run with --disable-shared on several platforms (or attempt to).
  # After a logic issue was discovered, and more discussion was had we've
  # elected to always build shared and copy over the components required into
  # the agent via the runtime component. See RE-7315 for more info.
  #
  # TODO: what impact does this have with client-tools?

  #  Some notes on AIX.
  #    AIX ships with gcc-4.2.4. We want 4.8.2 or higher. To get to 4.8.2 you
  #    need to build something in the 4.6 series as an intermediate GCC I have
  #    built gcc-4.6.4. Thus far, I've used that 4.6.4 build as my
  #    bootstrapping GCC to build 4.8.2. There is an rpm at
  #    http://pl-build-tools.delivery.puppetlabs.net/aix/6.1/ppc/ for
  #    booststrapping GCC.
  if platform.is_aix?
    configure_command << "export CC=/opt/gcc464/bin/gcc; export CXX=/opt/gcc464/bin/g++; "
    # AIX needs higher ulimit parameters to build GCC
    configure_command << " ulimit -s 2560000; ulimit -d 2048575; "
    configure_command << " chsec -f /etc/security/limits -s default -a stack=2560000;"
    configure_command << " chsec -f /etc/security/limits -s default -a data=2560000;"
  end

  # On the ARM Debian builds, you actually need multilib, so we'll exclude this
  # exclude flag on ARM.
  unless platform.architecture =~ /arm/i or platform.is_solaris?
    configure_command << " --disable-multilib"
  end

  # The arm flags were taken from the Debian GCC compile options. (gcc -v)
  # The fpu, float, flags are all to ensure the proper floating point
  # type (which is hard) on ARM.
  # The other flags are to instruct GCC on the proper target to look at in
  # libgcc when linking.
  if platform.architecture =~ /arm/i
    configure_command << " --with-fpu=vfp \
      --with-arch-directory=arm \
      --with-float=hard \ "
  end

  # The target powerpc-ibm-aix6.1.0.0 is used on AIX 6.1, AIX 7.1 - even by
  # IBM in the way they compile GCC in their Linux Toolbox for AIX. Most of the
  # configure options used on AIX were directly pilfered from their
  # configuration of gcc.
  # On AIX 5.3 it's powerpc-ibm-aix5.3.0.0
  if platform.is_aix?
    if platform.os_version == '5.3'
      target_platform = "powerpc-ibm-aix5.3.0.0"
    elsif platform.os_version == '6.1'
      target_platform = "powerpc-ibm-aix6.1.0.0"
    else
      target_platform = "powerpc-ibm-aix7.1.0.0"
    end
    configure_command << " --with-as=/usr/bin/as \
    --with-ld=/usr/bin/ld \
    --enable-threads \
    --enable-version-specific-runtime-libs \
    --host=#{target_platform} \
    --target=#{target_platform} \
    --build=#{target_platform} \
    --disable-libjava-multilib"
  end

  if platform.is_cross_compiled_linux?
    configure_command << " --target=#{settings[:platform_triple]} \
      --with-sysroot=#{settings[:prefix]}/sysroot"
  end

  if platform.is_solaris?
    configure_command << " --target=#{settings[:platform_triple]} \
      --with-gnu-as \
      --with-as=#{settings[:bindir]}/as \
      --without-gnu-ld \
      --with-ld=/usr/ccs/bin/ld -v"

      if platform.architecture.downcase == 'sparc'
        configure_command << " --with-sysroot=#{settings[:prefix]}/sysroot"
      end
  end

  # Build Commands
  pkg.configure do
    [
      #TODO figure out a better way to find the version number than hard-code it
      'ln -s ../gmp-4.3.2 gmp',
      'ln -s ../mpc-1.0.3 mpc',
      'ln -s ../mpfr-2.4.2 mpfr',
      'mkdir -p ../obj-gcc-build-dir',
      'cd ../obj-gcc-build-dir',
      configure_command,
    ]
  end

  pkg.build do
    [
      "cd ../obj-gcc-build-dir",
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    [
      "cd ../obj-gcc-build-dir",
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
    ]
  end
end

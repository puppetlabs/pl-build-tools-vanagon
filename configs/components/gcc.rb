component "gcc" do |pkg, settings, platform|
  pkg.version "4.8.2"
  pkg.md5sum "deca88241c1135e2ff9fa5486ab5957b"
  pkg.url "http://buildsources.delivery.puppetlabs.net/gcc-#{pkg.get_version}.tar.gz"

  # The 10.10 versioning breaks some stuff.
  pkg.apply_patch "resources/patches/gcc/patch-10.10.diff" if platform.is_osx?

  pkg.requires "binutils"

  if platform.is_deb?
    pkg.requires "libc6-dev"
  end

  if platform.is_rpm?
    pkg.build_requires "gcc"
    pkg.build_requires "binutils"
    pkg.build_requires "gzip"
    pkg.build_requires "bzip2"
    pkg.build_requires "make"
    pkg.build_requires "tar"

    case
    when platform.is_aix?
      pkg.requires "glibc-devel"
      pkg.build_requires "mktemp"
      pkg.build_requires "gawk"
      pkg.build_requires "libstdc++-devel"
      pkg.build_requires "gcc-c++"
      pkg.build_requires "glibc-devel"
    when platform.is_nxos?
      pkg.requires "libc6-dev"
      pkg.build_requires "g++"
      pkg.build_requires "libstdc++-dev"
      pkg.build_requires "libc6-dev"
    else
      pkg.build_requires "libstdc++-devel"
      pkg.build_requires "gcc-c++"
    end
  end

  ##  TESTING
  # In the future we may want to enable the test suite for GCC. If we do we'll
  # need dejagnu, expect and tcl. Those packages should be available on all RPM
  # systems (other than AIX and SLES10)

  pkg.configure do
    [
      #TODO figure out a better way to find the version number than hard-code it
      "ln -s ../gmp-4.3.2 gmp",
      "ln -s ../mpc-0.8.1 mpc",
      "ln -s ../mpfr-2.4.2 mpfr"
    ]
  end

  # Initialize an empty configure_command string
  configure_command = ""

  # We set -fPIC to ensure that our 64 bit builds can correctly link and compile.
  # We enable it on both 32-bit and 64-bit builds for consistency.
  env_setup =  %Q{export CFLAGS="${CFLAGS} -fPIC"; \
export CXXFLAGS="${CXXFLAGS} -fPIC";\
export CFLAGS_FOR_TARGET="-fPIC"  }


  #  Some notes on AIX.
  #    AIX ships with gcc-4.2.4. We want 4.8.2 or higher. To get to 4.8.2 you
  #    need to build something in the 4.6 series as an intermediate GCC I have
  #    built gcc-4.6.4. Thus far, I've used that 4.6.4 build as my
  #    bootstrapping GCC to build 4.8.2. There is an rpm at
  #    http://pl-build-tools.delivery.puppetlabs.net/aix/6.1/ppc/ for
  #    booststrapping GCC. Uncomment the boostrapping line in the aix platform
  #    definition and uncomment the CC and CXX exports below to enable
  #    boostrapping of GCC mode.
  if platform.is_aix?
    ## If you're bootstrapping GCC 4.8.2 using the 4.6.4 rpm, you'll need to uncomment this
    #configure_command << "export CC=/opt/gcc464/bin/gcc; export CXX=/opt/gcc464/bin/g++; "

    # AIX needs higher ulimit parameters to build GCC
    configure_command << " ulimit -s 1280000; ulimit -d 1048575; "
  end

  # We've abstracted the configure command a bit because of the difference in
  # flags needed for ARM vs x86 and x86_64 vs AIX/ppc
  configure_command << " ../gcc-#{pkg.get_version}/configure \
   --prefix=#{settings[:prefix]} \
   --disable-nls \
   --enable-languages=c,c++ \
   --disable-libgcj "

  # On the ARM Debian builds, you actually need multilib, so we'll exclude this
  # exclude flag on ARM.
  unless platform.architecture =~ /arm/i
    configure_command << " --disable-multilib"
  end


   # AIX compilation will fail with this option. I think it's because linking
   # on AIX is basically crazy. OSX also fails with this option.
   unless ( platform.is_aix? or platform.is_osx?)
     configure_command << " --disable-shared"
   end

  # The arm flags were taken from the Debian GCC compile options. (gcc -v)
  # The fpu, float, mode flags are all to ensure the proper floating point
  # type (which is hard) on ARM.
  # The other flags are to instruct GCC on the proper target to look at in
  # libgcc when linking.
  if  platform.architecture =~ /arm/i
    configure_command << " --with-arch=armv7-a \
    --with-fpu=vfpv3-d16 \
    --with-float=hard \
    --with-mode=thumb \
    --build=arm-linux-gnueabihf \
    --host=arm-linux-gnueabihf \
    --target=arm-linux-gnueabihf"
  end

  # The target powerpc-ibm-aix6.1.0.0 is used on AIX 6.1 and AIX 7.1 - even by
  # IBM in the way they compile GCC in their Linux Toolbox for AIX. Most of the
  # configure options used on AIX were directly pilfered from their
  # configuration of gcc.
  if platform.is_aix?
    configure_command << " --with-as=/usr/bin/as \
    --with-ld=/usr/bin/ld \
    --enable-threads \
    --enable-version-specific-runtime-libs \
    --host=powerpc-ibm-aix6.1.0.0 \
    --target=powerpc-ibm-aix6.1.0.0 \
    --build=powerpc-ibm-aix6.1.0.0 \
    --disable-libjava-multilib"


    # AIX can't use the exact flags that linux does, but we should still
    # attempt to honor any flags passed via environment variables.
    env_setup = %Q{export CFLAGS="${CFLAGS}"; export CXXFLAGS="${CXXFLAGS}" }
  end

  # bootstrap-debug  has to be explicitly passed to configure to suppress 
  # the bootstrap comparison failures under the more recent clang compilers.
  if platform.is_osx?
    configure_command << " --with-build-config=bootstrap-debug"
  end
  

  pkg.build do
    [
      env_setup,
      'rm -rf ../obj-gcc-build-dir',
      'mkdir ../obj-gcc-build-dir',
      'cd ../obj-gcc-build-dir',
      configure_command,
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    [ "cd ../obj-gcc-build-dir",
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"
    ]
  end
end

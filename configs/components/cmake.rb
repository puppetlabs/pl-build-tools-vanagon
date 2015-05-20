component "cmake" do |pkg, settings, platform|
  pkg.version "3.2.2"
  pkg.md5sum "2da57308071ea98b10253a87d2419281"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  # This is pretty horrible.  But so is package management on OSX.
  if platform.is_osx?
    pkg.build_requires "pl-gcc-4.8.2"
  else
    pkg.build_requires "pl-gcc"
    pkg.build_requires "make"
    if platform.is_deb?
      pkg.build_requires "libncurses5-dev"
    else
      pkg.build_requires "ncurses-devel"
    end
  end

  if platform.is_aix? or platform.is_osx?
    ldflags='LDFLAGS="${LDFLAGS}"'
  else
    ldflags="LDFLAGS=-Wl,-rpath=#{settings[:bindir]}/lib,-rpath=#{settings[:bindir]}/lib64,--enable-new-dtags"
  end

  # Different toolchains for different target platforms.
  if platform.is_osx?
    toolchain="pl-build-toolchain-darwin"
  else
    toolchain="pl-build-toolchain"
  end

  # Initialize an empty env_setup string
  env_setup = ""

  env_setup << %Q{export PATH=$$PATH:/usr/local/bin; \
  export CC=#{settings[:bindir]}/gcc; export CXX=#{settings[:bindir]}/g++; \
  export #{ldflags}}

  # Initialize an empty configure_command string
  configure_command  = ""

  configure_command << " ./configure --prefix=#{settings[:prefix]} --docdir=share/doc"

  # Even though only system curl is available on the build host,
  # the build on OSX bombs without this.
  if platform.is_osx?
    configure_command << " --system-curl"
  end

  pkg.configure do
    [
      env_setup,
      configure_command
    ]
  end

  pkg.build do
    [ 
      env_setup,
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
      "cd #{settings[:prefix]}; curl -O  http://buildsources.delivery.puppetlabs.net/#{toolchain}.cmake",
      "chmod 644 #{settings[:prefix]}/#{toolchain}.cmake"
    ]
  end

  pkg.install do
    [
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
    ]
  end

end

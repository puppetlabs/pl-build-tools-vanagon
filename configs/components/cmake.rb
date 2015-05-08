component "cmake" do |pkg, settings, platform|
  pkg.version "3.2.2"
  pkg.md5sum "2da57308071ea98b10253a87d2419281"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  if platform.is_deb?
    pkg.build_requires "libncurses5-dev"
  else
    pkg.build_requires "ncurses-devel"
  end
  pkg.build_requires "pl-gcc"
  pkg.build_requires "make"

  if platform.is_aix?
    ldflags='LDFLAGS="${LDFLAGS}"'
  else
    ldflags="LDFLAGS=-Wl,-rpath=#{settings[:bindir]}/lib,-rpath=#{settings[:bindir]}/lib64,--enable-new-dtags"
  end


  pkg.build do
    [ "export CC=#{settings[:bindir]}/gcc",
      "export CXX=#{settings[:bindir]}/g++",
      "export #{ldflags}",
      "./configure --prefix=#{settings[:prefix]} --docdir=share/doc",
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
      "cd #{settings[:prefix]}; curl -O  http://buildsources.delivery.puppetlabs.net/pl-build-toolchain.cmake",
      "chmod 644 #{settings[:prefix]}/pl-build-toolchain.cmake"
    ]
  end

  pkg.install do
    [
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
    ]
  end

end

component "cmake" do |pkg, settings, platform|
  pkg.version "3.1.0"
  pkg.md5sum "188eb7dc9b1b82b363bc51c0d3f1d461"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  if platform.is_deb?
    pkg.build_requires "debhelper"
    pkg.build_requires "build-essential"
    pkg.build_requires "libncurses5-dev"
  else
    pkg.build_requires "ncurses-devel"
  end
  pkg.build_requires "pl-gcc"
  pkg.build_requires "make"

  pkg.configure do
    [
      "mkdir _doc",
      "find Source Utilities -type f -iname copy\* | while read f ; do \
        fname=$$(basename $$f) ;\
        dir=$$(dirname $$f) ; \
        dname=$$(basename $dir) ; \
        cp -p $$f _doc/$${fname}_$${dname} ; \
      done"
    ]
  end

  pkg.build do
    [ "export CC=#{settings[:bindir]}/gcc", "export CXX=#{settings[:bindir]}/g++",
      "export LDFLAGS=-Wl,-rpath=#{settings[:bindir]}/lib,-rpath=#{settings[:bindir]}/lib64,--enable-new-dtags",
      "rm -rf build", "mkdir build", "cd build",
        "../bootstrap  --prefix=#{settings[:prefix]} \
                     --datadir=/share/cmake \
                     --docdir=/share/doc/cmake-#{pkg.get_version} \
                     --mandir=/share/man \
                     --parallel=`/usr/bin/getconf _NPROCESSORS_ONLN`",
                     "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
      "cd #{settings[:prefix]}; wget http://buildsources.delivery.puppetlabs.net/pl-build-toolchain.cmake",
      "chmod 644 #{settings[:prefix]}/pl-build-toolchain.cmake"]
  end

  pkg.install do
    [ "cd build",
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -rf #{settings[:datadir]}/doc/cmake-#{pkg.get_version}",
      "rm -rf #{settings[:mandir]}",
      "export CC=#{settings[:bindir]}/gcc", "export CXX=#{settings[:bindir]}/g++",
      "export LDFLAGS=-Wl,-rpath=#{settings[:bindir]}/lib,-rpath=#{settings[:bindir]}/lib64,--enable-new-dtags",
      "unset DISPLAY",
      "bin/ctest -V -E ModuleNotices -E CMake.HTML -E CTestTestUpload -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

end

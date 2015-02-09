component "yaml-cpp" do |pkg, settings, platform|
  pkg.version "0.5.1"
  pkg.md5sum "0fa47a5ed8fedefab766592785c85ee7"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  pkg.build_requires "pl-gcc"
  pkg.build_requires "make"
  pkg.build_requires "pl-cmake"
  pkg.build_requires "pl-boost"

  pkg.configure do
    [ "sed -i 's/\r//' license.txt"  ]
  end

  pkg.build do
    [ "rm -rf build-shared",
      "mkdir build-shared",
      "cd build-shared",
      "#{settings[:prefix]}/bin/cmake \
    -DCMAKE_TOOLCHAIN_FILE=#{settings[:prefix]}/pl-build-toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=#{settings[:prefix]} \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DYAML_CPP_BUILD_TOOLS=0 \
    -DBUILD_SHARED_LIBS=ON \
    .. ",
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
      "cd ../",
      "rm -rf build-static",
      "mkdir build-static",
      "cd build-static", "#{settings[:prefix]}/bin/cmake \
    -DCMAKE_TOOLCHAIN_FILE=#{settings[:prefix]}/pl-build-toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=#{settings[:prefix]} \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DYAML_CPP_BUILD_TOOLS=0 \
    -DBUILD_SHARED_LIBS=OFF \
    ..",
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    [ "cd build-shared",
      "#{platform[:make]} install",
      "cd ../build-static",
      "#{platform[:make]} install"
    ]
  end

end

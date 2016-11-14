component "yaml-cpp" do |pkg, settings, platform|

  pkg.version "0.5.3"
  pkg.md5sum "9a60a3051c2ef01980c78a2d6be40ed9"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  # Package Dependency Metadata

  # Build Requirements
  if platform.is_cross_compiled_linux?
    pkg.build_requires "pl-binutils-#{platform.architecture}"
    pkg.build_requires "pl-gcc-#{platform.architecture}"
    pkg.build_requires "pl-boost-#{platform.architecture}"
    pkg.build_requires "pl-cmake"
  elsif platform.is_solaris?
    if platform.os_version == "10"
      pkg.build_requires "http://pl-build-tools-staging.delivery.puppetlabs.net/solaris/10/pl-gcc-6.1.0-2.#{platform.architecture}.pkg.gz"
      pkg.build_requires "http://pl-build-tools-staging.delivery.puppetlabs.net/solaris/10/pl-binutils-2.27-1.#{platform.architecture}.pkg.gz"
      pkg.build_requires "http://pl-build-tools-staging.delivery.puppetlabs.net/solaris/10/pl-boost-1.61.0-3.#{platform.architecture}.pkg.gz"
      pkg.build_requires "http://pl-build-tools-staging.delivery.puppetlabs.net/solaris/10/pl-cmake-3.5.2-1.i386.pkg.gz"
    elsif platform.os_version == "11"
      pkg.build_requires "pl-binutils-#{platform.architecture}"
      pkg.build_requires "pl-gcc-#{platform.architecture}"
      pkg.build_requires "pl-boost-#{platform.architecture}"
      pkg.build_requires "pl-cmake"
    end
  elsif platform.is_windows?
    pkg.build_requires "pl-boost-#{platform.architecture}"
    pkg.build_requires "pl-toolchain-#{platform.architecture}"
    pkg.build_requires "cmake"
  elsif platform.is_aix?
    pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/#{platform.os_version}/ppc/pl-gcc-5.2.0-1.aix#{platform.os_version}.ppc.rpm"
    pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/#{platform.os_version}/ppc/pl-boost-1.58.0-1.aix#{platform.os_version}.ppc.rpm"
    pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/#{platform.os_version}/ppc/pl-cmake-3.2.3-2.aix#{platform.os_version}.ppc.rpm"
  else
    pkg.build_requires "pl-gcc"
    pkg.build_requires "make"
    pkg.build_requires "pl-cmake"
    pkg.build_requires "pl-boost"

    if platform.name =~ /el-4/
      pkg.build_requires "pl-tar"
    end
  end

  # Build-time Configuration
  cmake = "#{settings[:bindir]}/cmake"
  addtl_flags = ""

  if platform.is_cross_compiled_linux?
    # We're using the x86_64 version of cmake
    cmake = "#{settings[:basedir]}/bin/cmake"
  elsif platform.is_solaris?
    # We always use the i386 build of cmake, even on sparc
    cmake = "#{settings[:basedir]}/i386-pc-solaris2.#{platform.os_version}/bin/cmake"
    pkg.environment "PATH" => "$$PATH:/opt/csw/bin"
  elsif platform.is_windows?
    arch = platform.architecture == 'x64' ? "64" : "32"
    pkg.environment "PATH" => "C:/tools/mingw#{arch}/bin:$$PATH"
    pkg.environment "CYGWIN" => "nodosfilewarning"
    pkg.environment "LIB" => "C:/tools/mingw#{arch}/lib"
    pkg.environment "INCLUDE" => "C:/tools/mingw#{arch}/include"
    pkg.environment "CC" => "C:/tools/mingw#{arch}/bin/gcc"
    pkg.environment "CXX" => "C:/tools/mingw#{arch}/bin/g++"

    cmake = "C:/ProgramData/chocolatey/bin/cmake.exe"
    special_prefix = platform.convert_to_windows_path(settings[:prefix])
    special_path = "PATH=C:/tools/mingw#{arch}/bin:C:/Windows/system32:C:/Windows:C:/Windows/System32/Wbem:C:/Windows/System32/WindowsPowerShell/v1.0:C:/pstools"
    addtl_flags = "-G \"MinGW Makefiles\""
  end

  if platform.is_solaris? && platform.os_version == "10"
    pkg.environment "PATH" => "$$PATH:/opt/csw/bin"
  end

  # Build Commands
  pkg.build do
    [ "rm -rf build-shared",
      "mkdir build-shared",
      "cd build-shared",
      "#{special_path ? special_path : ''} \
      \"#{cmake}\" \
      #{addtl_flags} \
    -DCMAKE_TOOLCHAIN_FILE=#{special_prefix ? special_prefix : settings[:prefix]}/pl-build-toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=#{special_prefix ? special_prefix : settings[:prefix]} \
    -DCMAKE_VERBOSE_MAKEFILE=ON \
    -DYAML_CPP_BUILD_TOOLS=0 \
    -DBUILD_SHARED_LIBS=ON \
    .. ",
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)",
      "cd ../",
      "rm -rf build-static",
      "mkdir build-static",
      "cd build-static",
      "#{special_path ? special_path : ''} \
      \"#{cmake}\" \
      #{addtl_flags} \
    -DCMAKE_TOOLCHAIN_FILE=#{special_prefix ? special_prefix : settings[:prefix]}/pl-build-toolchain.cmake \
    -DCMAKE_INSTALL_PREFIX=#{special_prefix ? special_prefix : settings[:prefix]} \
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

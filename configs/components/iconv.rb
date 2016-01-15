component "iconv" do |pkg, settings, platform|

  pkg.version "1.14"
  pkg.md5sum "e34509b1623cec449dfeb73d7ce9c6c6"
  pkg.url "http://buildsources.delivery.puppetlabs.net/libiconv-#{pkg.get_version}.tar.gz"

  # Define a general prefix for most platforms, which we will redefine
  # for Windows platforms until we've built stronger Windows functions
  # for handling scenarios like this.
  installation_prefix=settings[:prefix]
  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
    platform.make = "/usr/bin/make"

    pkg.environment "PATH" => "C:/tools/mingw#{arch}/bin:$$PATH"
    pkg.environment "CYGWIN" => "nodosfilewarning winsymlinks:native"
    pkg.environment "LIB" => "C:/tools/mingw#{arch}/lib"
    pkg.environment "INCLUDE" => "C:/tools/mingw#{arch}/include"
    pkg.environment "CC" => "C:/tools/mingw#{arch}/bin/gcc"
    pkg.environment "CXX" => "C:/tools/mingw#{arch}/bin/g++"
    pkg.environment "MAKE" => "/usr/bin/make"
    pkg.environment "RANLIB" => "/usr/bin/ranlib"

    # And now coerce the installation prefix for Windows builds
    installation_prefix = platform.convert_to_windows_path(settings[:prefix])
  end

  pkg.configure do
    [" ./configure --prefix=#{installation_prefix} #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end

end

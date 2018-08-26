component "libffi" do |pkg, settings, platform|

  pkg.version "3.0.13"
  pkg.md5sum "45f3b6dbc9ee7c7dfbbbc5feba571529" # 3.0.13
  pkg.url "http://sourceware.org/pub/libffi/libffi-#{pkg.get_version}.tar.gz"
  #pkg.mirror "#{settings[:buildsources_url]}/libffi-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/libffi/0001-Includes-should-go-in-includedir-not-libdir.patch"

  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
    pkg.environment "PATH" => "$$PATH:C:/tools/mingw#{arch}/bin"
    pkg.environment "CYGWIN" => "nodosfilewarning winsymlinks:native"
    pkg.environment "LIB" => "C:/tools/mingw#{arch}/lib"
    pkg.environment "INCLUDE" => "C:/tools/mingw#{arch}/include"
    pkg.environment "CC" => "C:/tools/mingw#{arch}/bin/gcc"
    pkg.environment "CXX" => "C:/tools/mingw#{arch}/bin/g++"
    platform.make = "/usr/bin/make"
  end

  pkg.configure do
    [ "./configure --prefix=#{settings[:prefix]} #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end

end

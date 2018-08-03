component "gdbm" do |pkg, settings, platform|

  pkg.version "1.10"
  pkg.md5sum "88770493c2559dc80b561293e39d3570"
  pkg.mirror "#{settings[:buildsources_url]}/gdbm-#{pkg.get_version}.tar.gz"
  pkg.url "https://ftp.gnu.org/gnu/gdbm/gdbm-#{pkg.get_version}.tar.gz"


  prefix = settings[:prefix]
  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
  
    pkg.apply_patch "resources/patches/gdbm/0001-Mingw-port-of-gdbm-1.10.patch"

    pkg.environment "PATH" => "C:/tools/mingw#{arch}/bin:$$PATH"
    pkg.environment "CYGWIN" => "nodosfilewarning winsymlinks:native"
    pkg.environment "LIB" => "C:/tools/mingw#{arch}/lib"
    pkg.environment "INCLUDE" => "C:/tools/mingw#{arch}/include"
    pkg.environment "CC" => "C:/tools/mingw#{arch}/bin/gcc"
    pkg.environment "CXX" => "C:/tools/mingw#{arch}/bin/g++"

    prefix = platform.convert_to_windows_path(settings[:prefix])
  end

  pkg.configure do
    [" ./configure --prefix=#{prefix} #{settings[:host]} --enable-shared -enable-static --enable-libgdbm-compat"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end

end

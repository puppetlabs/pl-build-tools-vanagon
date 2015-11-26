component "libffi" do |pkg, settings, platform|

  pkg.version "3.0.12"  # Note - knapsack uses 3.0.12 but am trying this with 3.2.1 first.
  pkg.md5sum "da984c6756170d50f47925bb333cda71"
  pkg.url "http://buildsources.delivery.puppetlabs.net/libffi-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/libffi/0001-Includes-should-go-in-includedir-not-libdir.patch"

  if platform.is_windows?
    opts = ""
    arch = "64"
    if platform.architecture == 'x86'
      opts = "-x86"
      arch = "32"
    end
    pkg.build_requires "mingw-w#{arch}"
    pkg.build_requires "gow"

    pkg.environment "PATH" => "#{platform.drive_root}/tools/mingw#{arch}/bin:$$PATH:#{platform.drive_root}/tools/gow/bin"
    pkg.environment "CYGWIN" => "nodosfilewarning"
    pkg.environment "LIB" => "#{platform.drive_root}/tools/mingw#{arch}/lib"
    pkg.environment "INCLUDE" => "#{platform.drive_root}/tools/mingw#{arch}/include"
    pkg.environment "CC" => "#{platform.drive_root}/tools/mingw#{arch}/bin/gcc"
    pkg.environment "CXX" => "#{platform.drive_root}/tools/mingw#{arch}/bin/g++"
    
    pkg.environment "MAKE" => "#{platform.drive_root}/tools/gow/bin/make"
    platform.make = "#{platform.drive_root}/tools/gow/bin/make"
    puts "Make is #{platform.make}"
  end

  pkg.configure do
    [ "./configure --build=x86_64-w64-mingw32 --host=x86_64-w64-mingw32 --prefix=#{settings[:prefix]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end

end

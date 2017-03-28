component "iconv" do |pkg, settings, platform|
  pkg.version "1.14"
  pkg.md5sum "e34509b1623cec449dfeb73d7ce9c6c6"
  pkg.url "http://ftp.gnu.org/gnu/lib#{pkg.get_name}/lib#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
    pkg.environment("PATH", "/cygdrive/C/tools/mingw#{arch}/bin:$(PATH)")
    pkg.environment("CYGWIN", "nodosfilewarning winsymlinks:native")

    pkg.apply_patch "resources/patches/iconv/use-windows-paths.patch"
  end

  pkg.configure do
    [" ./configure --prefix=#{settings[:prefix]} #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end

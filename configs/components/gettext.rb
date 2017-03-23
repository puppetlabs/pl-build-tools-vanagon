component "gettext" do |pkg, settings, platform|
  pkg.version "0.19.8.1"
  pkg.md5sum "97e034cf8ce5ba73a28ff6c3c0638092"
  pkg.url "http://ftp.gnu.org/gnu/#{pkg.get_name}/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"
    pkg.environment("PATH", "/cygdrive/C/tools/mingw#{arch}/bin:$(PATH)")
    pkg.environment("CYGWIN", "nodosfilewarning winsymlinks:native")

    pkg.build_requires "pl-iconv-#{platform.architecture}"
  end

  pkg.configure do
    [" ./configure --prefix=#{settings[:prefix]} #{settings[:host]}"]
  end

  pkg.build do
    ["#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    [
      "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install",
      "rm -rf #{settings[:basedir]}/share/info"
    ]
  end
end

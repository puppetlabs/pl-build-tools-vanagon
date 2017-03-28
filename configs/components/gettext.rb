component "gettext" do |pkg, settings, platform|
  pkg.version "0.19.8.1"

  if platform.is_windows?
    # Compilation requires building iconv (that works) and a bunch of patches to gettext.
    # For now, punt and use a pre-built package.
    if platform.architecture == "x64"
      arch = "64"
      pkg.md5sum "f877ebff42736535415b4ddb9c631b86"
    else
      arch = "32"
      pkg.md5sum "bced59a375aef8d325b746f0dfbe8f48"
    end

    pkg.url "https://github.com/mlocati/gettext-iconv-windows/releases/download/v#{pkg.get_version}-v1.14/#{pkg.get_name}#{pkg.get_version}-iconv1.14-shared-#{arch}.zip"

    pkg.environment("PATH", "/cygdrive/c/tools/mingw#{arch}/bin:$(PATH):/cygdrive/c/ProgramData/chocolatey/tools")
    pkg.environment("CYGWIN", "nodosfilewarning winsymlinks:native")

    # Building gettext from source on Windows requires iconv.
    #pkg.build_requires "pl-iconv-#{platform.architecture}"

    pkg.build do
      ":"
    end

    pkg.install do
      "cp -r * #{settings[:prefix]}"
    end
  else
    pkg.md5sum "97e034cf8ce5ba73a28ff6c3c0638092"
    pkg.url "http://ftp.gnu.org/gnu/#{pkg.get_name}/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

    pkg.configure do
      ["./configure --prefix=#{settings[:prefix]} #{settings[:host]}"]
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
end

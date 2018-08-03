component "zlib" do |pkg, settings, platform|
  # Source-Related Metadata
  pkg.version "1.2.8"
  pkg.md5sum "44d667c142d7cda120332623eab69f40"
  pkg.mirror "#{settings[:buildsources_url]}/zlib-#{pkg.get_version}.tar.gz"
  pkg.url "http://zlib.net/fossils/zlib-#{pkg.get_version}.tar.gz"

  # Package Dependency Metadata

  # Build Requirements

  # Build-time Configuration
  # Set a default Makefile to avoid repeated use of the ternary operator
  # later on when we try to build this.
  makefile = "Makefile"

  if platform.is_windows?
    arch = platform.architecture == "x64" ? "64" : "32"

    pkg.environment "PATH" => "C:/tools/mingw#{arch}/bin:$$PATH"
    pkg.environment "CYGWIN" => "nodosfilewarning"
    pkg.environment "LIB" => "C:/tools/mingw#{arch}/lib"
    pkg.environment "INCLUDE" => "C:/tools/mingw#{arch}/include"
    pkg.environment "CC" => "C:/tools/mingw#{arch}/bin/gcc"
    pkg.environment "CXX" => "C:/tools/mingw#{arch}/bin/g++"

    pkg.environment 'BINARY_PATH' => "#{settings[:prefix]}/bin"
    pkg.environment 'INCLUDE_PATH' => "#{settings[:prefix]}/include"
    pkg.environment 'LIBRARY_PATH' => "#{settings[:prefix]}/lib"

    # Use a different Makefile if this is a Windows compile
    makefile = "win32/Makefile.gcc"
  end

  # Build Commands
  pkg.configure do
    if platform.is_windows?
      # We're not calling `configure` for Windows because we're using a pre-populated
      # Makefile (so there's nothing to generate with `configure`). Instead of
      # passing an empty value to the `configure step` we're using the shell 'null'
      # operator here because the `configure` step throws a shoe if there's nothing
      # at all defined for it.
      ": nothing to configure for Windows"
    else
      "./configure --prefix=#{settings[:prefix]}"
    end
  end

  pkg.build do
    "#{platform[:make]} -f #{makefile} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
  end

  pkg.install do
    "#{platform[:make]} -f #{makefile} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install SHARED_MODE=1"
  end
end

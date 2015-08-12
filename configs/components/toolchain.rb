component "toolchain" do |pkg, settings, platform|
  if platform.is_linux?
    pkg.version "2015.07.13"
    pkg.md5sum "3fa1dcf0d8a4bd9635111bc0451b51f5"
    pkg.url "file://files/linux-toolchain.cmake.txt"
  elsif platform.is_aix?
    pkg.version "2015.05.11"
    pkg.md5sum "0c256056b814a75a25d3fc16266db057"
    pkg.url "file://files/aix-61-ppc-toolchain.cmake.txt"
  elsif platform.is_solaris?
    if platform.os_version == "10"
      pkg.url "file://files/solaris-10-toolchains.tar.gz"
      pkg.md5sum "dfb2880781e45baa2c702c5a8bd8f5d6"
      pkg.version '2015-08-12'
    else
      fail "Need to define a toolchain file for #{platform.name} first"
    end
  else
    fail "Need to define a toolchain file for #{platform.name} first"
  end
  filename = pkg.get_url.split('/').last
  # We still need to add support for OS X and Solaris 11/{i386,sparc}.
  if platform.is_solaris?
    pkg.install_file "solaris-10-i386-toolchain.cmake.txt", "#{settings[:basedir]}/i386-pc-solaris2.10/pl-build-toolchain.cmake"
    pkg.install_file "solaris-10-sparc-toolchain.cmake.txt", "#{settings[:basedir]}/sparc-sun-solaris2.10/pl-build-toolchain.cmake"

    pkg.install do
      [
        # We update ownership here to make sure that solaris will put the toolchains in the package
        "chown root:root #{settings[:basedir]}/i386-pc-solaris2.10/pl-build-toolchain.cmake",
        "chown root:root #{settings[:basedir]}/sparc-sun-solaris2.10/pl-build-toolchain.cmake",
      ]
    end
  else
    pkg.install_file filename, "#{settings[:prefix]}/pl-build-toolchain.cmake"
  end
end

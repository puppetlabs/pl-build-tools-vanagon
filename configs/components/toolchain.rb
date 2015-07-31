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
      pkg.md5sum "fc69eaa223d158956e63d22558a14cb1"
      pkg.version '2015-07-31'
    else
      fail "Need to define a toolchain file for #{platform.name} first"
    end
  else
    fail "Need to define a toolchain file for #{platform.name} first"
  end
  filename = pkg.get_url.split('/').last
  # We still need to add support for OS X and Solaris 11/{i386,sparc}.
  if platform.is_solaris?
    pkg.install do
      [
        "mkdir -p #{settings[:basedir]}/{i386-pc,sparc-sun}-solaris2.10",
        "cp -p solaris-10-i386-toolchain.cmake.txt #{settings[:basedir]}/i386-pc-solaris2.10/pl-build-toolchain.cmake",
        "chmod 644 #{settings[:basedir]}/i386-pc-solaris2.10/pl-build-toolchain.cmake",
        "cp -p solaris-10-sparc-toolchain.cmake.txt #{settings[:basedir]}/sparc-sun-solaris2.10/pl-build-toolchain.cmake",
        "chmod 644 #{settings[:basedir]}/sparc-sun-solaris2.10/pl-build-toolchain.cmake",
      ]
    end
  else
    pkg.install do
      [
        "mkdir -p #{settings[:basedir]}",
        "cp -pr #{filename} #{settings[:prefix]}/pl-build-toolchain.cmake",
        "chmod 644 #{settings[:prefix]}/pl-build-toolchain.cmake",
      ]
    end
  end
end

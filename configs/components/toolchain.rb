component "toolchain" do |pkg, settings, platform|
  if platform.is_linux?
    pkg.version "2015.07.13"
    pkg.md5sum "90bfc55e78dbf184ccb8ae9d50c0ca9f"
    pkg.url "file://files/linux-toolchain.cmake.txt"
  elsif platform.is_aix?
    pkg.version "2015.05.11"
    pkg.md5sum "0c256056b814a75a25d3fc16266db057"
    pkg.url "file://files/aix-61-ppc-toolchain.cmake.txt"
    pkg.environment "PATH" => "/opt/freeware/bin:#{settings[:basedir]}/bin:$$PATH"
  elsif platform.is_solaris?
    if platform.os_version == "10"
      pkg.url "file://files/solaris-10-toolchains.tar.gz"
      pkg.md5sum "dfb2880781e45baa2c702c5a8bd8f5d6"
      pkg.version '2015-08-12'
    elsif platform.os_version == "11"
      pkg.add_source "file://files/solaris-11-i386-toolchain.cmake.txt", sum: "189b7abcc50e4915d521db2fd4f30a9e"
      pkg.add_source "file://files/solaris-11-sparc-toolchain.cmake.txt", sum: "3c3cd0e958471844346b7193e2feab0d"
    else
      fail "Need to define a toolchain file for #{platform.name} first"
    end
  else
    fail "Need to define a toolchain file for #{platform.name} first"
  end
  filename = pkg.get_url.split('/').last
  # We still need to add support for OS X
  if platform.is_solaris?
    pkg.install_file "solaris-#{platform.os_version}-i386-toolchain.cmake.txt", "#{settings[:basedir]}/i386-pc-solaris2.#{platform.os_version}/pl-build-toolchain.cmake"
    pkg.install_file "solaris-#{platform.os_version}-sparc-toolchain.cmake.txt", "#{settings[:basedir]}/sparc-sun-solaris2.#{platform.os_version}/pl-build-toolchain.cmake"

    pkg.install do
      [
        # We update ownership here to make sure that solaris will put the toolchains in the package
        "chown root:root #{settings[:basedir]}/i386-pc-solaris2.#{platform.os_version}/pl-build-toolchain.cmake",
        "chown root:root #{settings[:basedir]}/sparc-sun-solaris2.#{platform.os_version}/pl-build-toolchain.cmake",
      ]
    end
  else
    pkg.install_file filename, "#{settings[:prefix]}/pl-build-toolchain.cmake"
  end
end

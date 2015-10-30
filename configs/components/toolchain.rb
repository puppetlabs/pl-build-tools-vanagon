component "toolchain" do |pkg, settings, platform|
  if platform.is_linux?
    pkg.version "2015.10.01"
    pkg.md5sum "3b607682a02e7811d730261326d2f02c"
    pkg.url "file://files/linux-toolchain.cmake.txt"
  elsif platform.is_aix?
    pkg.version "2015.10.01"
    pkg.md5sum "07bd7c98f0e2ac90c0282a5a98bd3b4c"
    # Despite the name, this toolchain applies to all aix versions
    pkg.url "file://files/aix-61-ppc-toolchain.cmake.txt"
  elsif platform.is_solaris?
    if platform.os_version == "10"
      pkg.add_source "file://files/solaris-10-i386-toolchain.cmake.txt", sum: "5197cb02f5d1a099125a80a6d4333308"
      pkg.add_source "file://files/solaris-10-sparc-toolchain.cmake.txt", sum: "479b3c7ff43926b7bd8b82aeb9cc7636"
    elsif platform.os_version == "11"
      pkg.add_source "file://files/solaris-11-i386-toolchain.cmake.txt", sum: "75686df5820423db0110c8396aeab4da"
      pkg.add_source "file://files/solaris-11-sparc-toolchain.cmake.txt", sum: "43d6e9878b94d59c78053f6b959884ce"
    else
      fail "Need to define a toolchain file for #{platform.name} first"
    end
  else
    fail "Need to define a toolchain file for #{platform.name} first"
  end
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
    filename = pkg.get_url.split('/').last
    pkg.install_file filename, "#{settings[:prefix]}/pl-build-toolchain.cmake"
  end
end

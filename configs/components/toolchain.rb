component "toolchain" do |pkg, settings, platform|
  if platform.is_linux?
    pkg.version "2016.02.02"
    pkg.md5sum "3b607682a02e7811d730261326d2f02c"
    pkg.url "file://files/linux-toolchain.cmake.txt"
    if platform.name =~ /debian-8-amd64/
      # Add toolchain file for huaweios, which builds on debian-8-amd64
      pkg.add_source "file://files/huaweios-toolchain.cmake.txt", sum: "f4f890cbe0a6da83a510acb4a11d85ad"
    end
  elsif platform.is_aix?
    pkg.version "2015.10.01"
    pkg.md5sum "07bd7c98f0e2ac90c0282a5a98bd3b4c"
    # Despite the name, this toolchain applies to all aix versions
    pkg.url "file://files/aix-61-ppc-toolchain.cmake.txt"
  elsif platform.is_windows?
    pkg.version "2015.11.23"
    if platform.architecture == "x64"
      pkg.md5sum "fea8f450c347cd3a3ab7e307a177510d"
      pkg.url "file://files/windows-x64-toolchain.cmake.txt"
    elsif platform.architecture == "x86"
      pkg.md5sum "15d9619ffd19dbe0991b01f3c6217b93"
      pkg.url "file://files/windows-x86-toolchain.cmake.txt"
    else
      fail "Need to define a toolchain file for #{platform.name} first"
    end
  elsif platform.is_solaris?
    pkg.version "2015.10.01"
    if platform.os_version == "10"
      pkg.add_source "file://files/solaris-10-i386-toolchain.cmake.txt", sum: "4ea64aac45e2e1a52bbf75b5e95acf2b"
      pkg.add_source "file://files/solaris-10-sparc-toolchain.cmake.txt", sum: "e5e679389baaeaa2656750c6481312dc"
    elsif platform.os_version == "11"
      pkg.add_source "file://files/solaris-11-i386-toolchain.cmake.txt", sum: "406e7febf6b83f9102980ae52055c4e2"
      pkg.add_source "file://files/solaris-11-sparc-toolchain.cmake.txt", sum: "4a16423fda546c4d50006179b9f013e7"
    else
      fail "Need to define a toolchain file for #{platform.name} first"
    end
  else
    fail "Need to define a toolchain file for #{platform.name} first"
  end

  if platform.name =~ /el-4/
    pkg.build_requires "pl-tar"
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
    if platform.name =~ /debian-8-amd64/
      # Install toolchain file for huaweios, which builds on debian-8-amd64
      pkg.install_file "huaweios-toolchain.cmake.txt", "#{settings[:basedir]}/powerpc-unknown-linux-gnu/pl-build-toolchain.cmake"
    end
  end
end

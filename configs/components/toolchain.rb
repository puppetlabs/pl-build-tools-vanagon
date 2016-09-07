component "toolchain" do |pkg, settings, platform|
  if platform.is_linux?
    pkg.version "2016.05.03"
    pkg.url "file://files/cmake/linux-toolchain.cmake"
    if platform.name =~ /debian-8-amd64/
      # Add toolchain file for huaweios, which builds on debian-8-amd64
      pkg.add_source "file://files/cmake/huaweios-toolchain.cmake"
      pkg.add_source "file://files/cmake/debian-8-armhf-toolchain.cmake"
      pkg.add_source "file://files/cmake/debian-8-armel-toolchain.cmake"
    elsif platform.name =~ /el-\d-x86_64|sles-\d\d-x86_64/
      # Toolchain file for rhel and sles running on IBM z-series, which
      # builds on x86_64
      pkg.add_source "file://files/cmake/rhel-sles-s390x-toolchain.cmake"
    elsif platform.name =~ /ubuntu-16\.04-amd64/
      # Toolchain file for Ubuntu 16.04 running on IBM Power8 hardware,
      # which builds on amd64
      pkg.add_source "file://files/cmake/ubuntu-powerpc64le-toolchain.cmake"
    end
  elsif platform.is_aix?
    pkg.version "2015.10.01"
    # Despite the name, this toolchain applies to all aix versions
    pkg.url "file://files/cmake/aix-61-ppc-toolchain.cmake"
  elsif platform.is_windows?
    pkg.version "2015.11.23"
    if platform.architecture == "x64"
      pkg.url "file://files/cmake/windows-x64-toolchain.cmake"
    elsif platform.architecture == "x86"
      pkg.url "file://files/cmake/windows-x86-toolchain.cmake"
    else
      fail "Need to define a toolchain file for #{platform.name} first"
    end
  elsif platform.is_solaris?
    pkg.version "2015.10.01"
    if platform.os_version == "10"
      pkg.add_source "file://files/cmake/solaris-10-i386-toolchain.cmake"
      pkg.add_source "file://files/cmake/solaris-10-sparc-toolchain.cmake"
    elsif platform.os_version == "11"
      pkg.add_source "file://files/cmake/solaris-11-i386-toolchain.cmake"
      pkg.add_source "file://files/cmake/solaris-11-sparc-toolchain.cmake"
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
    pkg.install_file "solaris-#{platform.os_version}-i386-toolchain.cmake", "#{settings[:basedir]}/i386-pc-solaris2.#{platform.os_version}/pl-build-toolchain.cmake"
    pkg.install_file "solaris-#{platform.os_version}-sparc-toolchain.cmake", "#{settings[:basedir]}/sparc-sun-solaris2.#{platform.os_version}/pl-build-toolchain.cmake"

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
      # Install toolchain file for huaweios and debian-8-armhf, which builds on debian-8-amd64
      pkg.install_file "huaweios-toolchain.cmake", "#{settings[:basedir]}/powerpc-linux-gnu/pl-build-toolchain.cmake"
      pkg.install_file "debian-8-armhf-toolchain.cmake", "#{settings[:basedir]}/arm-linux-gnueabihf/pl-build-toolchain.cmake"
      pkg.install_file "debian-8-armel-toolchain.cmake", "#{settings[:basedir]}/arm-linux-gnueabi/pl-build-toolchain.cmake"
    elsif platform.name =~ /el-\d-x86_64|sles-\d\d-x86_64/
      # Install toolchain file used by the s390x rhel and sles platfoms, which are built on x86_64
      pkg.install_file "rhel-sles-s390x-toolchain.cmake", "#{settings[:basedir]}/s390x-linux-gnu/pl-build-toolchain.cmake"
	elsif platform.name =~ /ubuntu-16\.04-amd64/
      # Install toolchain file used by the Power8 ubuntu platfom, which is built on amd64
      pkg.install_file "ubuntu-powerpc64le-toolchain.cmake", "#{settings[:basedir]}/powerpc64le-linux-gnu/pl-build-toolchain.cmake"
    end
  end
end

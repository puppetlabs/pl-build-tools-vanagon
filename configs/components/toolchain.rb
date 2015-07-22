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
    pkg.url "file://files/#{platform.name}-toolchain.cmake.txt"
    case platform.name
    when 'solaris-10-i386'
      pkg.version '2015-07-22'
      pkg.md5sum '15a8fe018b1130886ba3d4a612b2b1be'
    else
      fail "Need to define a toolchain file for #{platform.name} first"
    end
  else
    fail "Need to define a toolchain file for #{platform.name} first"
  end
  filename = pkg.get_url.split('/').last
  # We still need to add support for OS X and Solaris {10,11}/{i386,sparc}.
  pkg.install do
    [
      "mkdir -p #{settings[:prefix]}",
      "cp -pr #{filename} #{settings[:prefix]}/pl-build-toolchain.cmake"
    ]
  end
end

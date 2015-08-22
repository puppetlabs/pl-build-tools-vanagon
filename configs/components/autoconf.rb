component "autoconf" do |pkg, settings, platform|
  pkg.version "2.69"
  pkg.md5sum "82d05e03b93e45f5a39b828dc9c6c29b"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  if platform.is_aix?
     pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/#{platform.os_version}/ppc/pl-gcc-4.8.2-1.aix#{platform.os_version}.ppc.rpm"
     pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/make-3.80-1.aix5.1.ppc.rpm"
  else
    pkg.build_requires "gcc"
    pkg.build_requires "make"
  end
  if platform.is_deb?
    pkg.build_requires "g++"
  end
  if platform.is_rpm?
    pkg.build_requires "gcc-c++"
  end
  pkg.build_requires "m4"

  pkg.configure do
    [
      "PATH=#{settings[:prefix]}/bin:$$PATH ./configure --prefix=#{settings[:prefix]}"
    ]
  end

  pkg.build do
    [
      "PATH=#{settings[:prefix]}/bin:$$PATH #{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    [
      "PATH=#{settings[:prefix]}/bin:$$PATH #{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"
    ]
  end

end

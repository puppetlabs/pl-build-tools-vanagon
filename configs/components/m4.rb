component "m4" do |pkg, settings, platform|
  pkg.version "1.4.17"
  pkg.md5sum "a5e9954b1dae036762f7b13673a2cf76"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  pkg.build_requires "gcc"
  if platform.is_deb?
    pkg.build_requires "g++"
  end
  if platform.is_rpm?
    pkg.build_requires "gcc-c++"
  end
  pkg.build_requires "make"

  pkg.configure do
    [ "./configure --prefix=#{settings[:prefix]}" ]
  end

  pkg.build do
    [
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    [
      "#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"
    ]
  end

end

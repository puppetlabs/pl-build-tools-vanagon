component "ruby" do |pkg, settings, platform|
  pkg.version "2.5.9"
  pkg.sha56sum "f5894e05f532b748c3347894a5efa42066fd11cc8d261d4d9788ff71da00be68"
  pkg.url "https://cache.ruby-lang.org/pub/ruby/2.5/ruby-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/ruby-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/ruby/libyaml_cve-2014-9130.patch"

  # This is needed for date_core to correctly compile on solaris 10. Breaks gem installations.
  pkg.environment "PATH" => "/usr/sfw/bin:/usr/ccs/bin:$$PATH"

  if platform.is_cross_compiled_linux?
    pkg.build_requires "pl-binutils-#{platform.architecture}"
    pkg.build_requires "pl-gcc-#{platform.architecture}"
  end

  # Ensure ruby is built with zlib support
  if platform.is_deb?
    pkg.build_requires "zlib1g-dev"
  elsif platform.is_rpm?
    pkg.build_requires "zlib-devel"
  end

  # Here we set --enable-bundled-libyaml to ensure that the libyaml included in
  # ruby is used, even if the build system has a copy of libyaml available
  pkg.configure do
    ["./configure \
        --prefix=#{settings[:basedir]} \
        --with-opt-dir=#{settings[:basedir]} \
        --enable-shared \
        --enable-bundled-libyaml \
        --disable-install-doc \
        --disable-install-rdoc"]
  end

  pkg.build do
    "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
  end

  pkg.install do
    "#{platform[:make]} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"
  end
end


component "ruby" do |pkg, settings, platform|
  pkg.version "2.1.6"
  pkg.md5sum "6e5564364be085c45576787b48eeb75f"
  pkg.url "http://buildsources.delivery.puppetlabs.net/ruby-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/ruby/libyaml_cve-2014-9130.patch"
  pkg.apply_patch "resources/patches/ruby/CVE-2015-4020.patch"

  # This is needed for date_core to correctly compile on solaris 10. Breaks gem installations.
  pkg.apply_patch "resources/patches/ruby/fix-date-compilation.patch" if platform.is_solaris?
  pkg.environment "PATH" => "/usr/sfw/bin:/usr/ccs/bin:$$PATH"

  if platform.name =~ /el-4/
    pkg.build_requires "pl-tar"
  end

  if platform.is_deb?
    pkg.build_requires "zlib1g-dev"
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


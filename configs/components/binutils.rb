component "binutils" do |pkg, settings, platform|
  pkg.version "2.25"
  pkg.md5sum "ab6719fd7434caf07433ec834db8ad4f"
  pkg.url "http://buildsources.delivery.puppetlabs.net/binutils-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-common.h.patch"
  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-ldlang.c.patch"

  if platform.is_solaris?
    pkg.environment "PATH" => "#{settings[:bindir]}:/usr/ccs/bin:/usr/sfw/bin:/opt/csw/bin:$$PATH"
    target = "--target=#{settings[:platform_triple]}"
  else
    pkg.environment "PATH" => "#{settings[:bindir]}:$$PATH"
    target = ""
  end

  pkg.configure do
    "./configure \
      --prefix=#{settings[:basedir]} \
      #{target} \
      --disable-nls \
      -v"
  end

  pkg.build do
    "#{platform[:make]}"
  end

  # If we don't remove the info files this package conflicts with gcc builds
  pkg.install do
    ["#{platform[:make]} install",
     "rm -rf #{settings[:basedir]}/share/info"]
  end
end

component "binutils" do |pkg, settings, platform|
  pkg.version "2.25"
  pkg.md5sum "ab6719fd7434caf07433ec834db8ad4f"
  pkg.url "http://buildsources.delivery.puppetlabs.net/binutils-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-common.h.patch"
  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-ldlang.c.patch"

  pkg.environment "PATH" => "#{settings[:bindir]}:$$PATH"

  pkg.configure do
    "./configure \
      --prefix=#{settings[:prefix]} \
      --disable-nls \
      -v"
  end

  pkg.build do
    "#{platform[:make]}"
  end

  # If we don't remove the info files this package conflicts with gcc builds
  pkg.install do
    ["#{platform[:make]} install",
     "rm -rf #{settings[:prefix]}/share/info"]
  end
end

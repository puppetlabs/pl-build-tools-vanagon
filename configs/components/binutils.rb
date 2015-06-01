component "binutils" do |pkg, settings, platform|
  pkg.version "2.25"
  pkg.md5sum "ab6719fd7434caf07433ec834db8ad4f"
  pkg.url "http://buildsources.delivery.puppetlabs.net/binutils-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-common.h.patch"
  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-ldlang.c.patch"

  env = "PATH=#{settings[:bindir]}:$$PATH"

  pkg.configure do
    "#{env} ./configure \
      --prefix=#{settings[:prefix]} \
      --disable-nls \
      -v"
  end

  pkg.build do
    "#{env} #{platform[:make]}"
  end

  pkg.install do
    "#{env} #{platform[:make]} install"
  end
end

component "binutils" do |pkg, settings, platform|
  pkg.version "2.26"
  pkg.md5sum "d66e2b663757cbf5d4b060feb4ef6b4b"
  pkg.url "http://buildsources.delivery.puppetlabs.net/binutils-#{pkg.get_version}.tar.gz"


  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-common.h.patch"
  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-ldlang.c.patch"

  if platform.is_solaris?
    pkg.environment "PATH" => "#{settings[:bindir]}:/usr/ccs/bin:/usr/sfw/bin:/opt/csw/bin:$$PATH"
    target = "--target=#{settings[:platform_triple]}"
  elsif platform.is_aix?
    if platform.os_version =~ /6.1|7.1/
      pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/gcc-4.2.0-3.aix6.1.ppc.rpm"
      pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/libgcc-4.2.0-3.aix6.1.ppc.rpm"
    else
      pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/gcc-4.2.0-3.aix5.3.ppc.rpm"
      pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/libgcc-4.2.0-3.aix5.3.ppc.rpm"
    end
  else
    pkg.environment "PATH" => "#{settings[:bindir]}:$$PATH"
    target = ""
  end

  if platform.name =~ /el-4/
    pkg.build_requires "pl-tar"
  end

  if platform.is_huaweios?
    target = "--target=#{settings[:platform_triple]}"
  end

  pkg.configure do
    if platform.is_huaweios?
      # --with-sysroot is an undocumented configure option in binutils
      # but necessary to avoid "ld: this linker was not configured to
      # use sysroots" when doing subsequent builds (e.g, pl-gcc)
      additional_flags = "--with-sysroot=#{File.join(settings[:prefix], 'sysroot')}"
    end
    "./configure \
      --prefix=#{settings[:basedir]} \
      #{target} \
      --disable-nls \
      #{additional_flags} \
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

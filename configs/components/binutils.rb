component "binutils" do |pkg, settings, platform|
  pkg.version "2.25"
  pkg.md5sum "ab6719fd7434caf07433ec834db8ad4f"
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

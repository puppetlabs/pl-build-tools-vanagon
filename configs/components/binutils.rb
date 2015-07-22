component "binutils" do |pkg, settings, platform|
  pkg.version "2.25"
  pkg.md5sum "ab6719fd7434caf07433ec834db8ad4f"
  pkg.url "http://buildsources.delivery.puppetlabs.net/binutils-#{pkg.get_version}.tar.gz"

  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-common.h.patch"
  pkg.apply_patch "resources/patches/binutils/binutils-2.23.2-ldlang.c.patch"

  if platform.is_solaris?
    pkg.environment "PATH" => "#{settings[:bindir]}:/usr/ccs/bin:/opt/csw/bin:$$PATH"
    target = "--target=#{settings[:platform_triple]}"
    if platform.os_version == '10'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWarc.pkg.gz'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWgnu-idn.pkg.gz'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWgpch.pkg.gz'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWgtar.pkg.gz'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWhea.pkg.gz'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWlibm.pkg.gz'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWwgetu.pkg.gz'
      pkg.build_requires 'http://pl-build-tools.delivery.puppetlabs.net/solaris/10/depends/SUNWxcu4.pkg.gz'
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
     "rm -rf #{settings[:prefix]}/share/info"]
  end
end

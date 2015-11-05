component "make" do |pkg, settings, platform|
  pkg.version "4.1"
  pkg.md5sum "654f9117957e6fa6a1c49a8f08270ec9"
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  if platform.is_aix?
     pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/#{platform.os_version}/ppc/pl-gcc-4.8.2-1.aix#{platform.os_version}.ppc.rpm"
     pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/make-3.80-1.aix5.1.ppc.rpm"
  else
    pkg.build_requires "gcc"
    pkg.build_requires "gcc-c++"
    pkg.build_requires "make"
  end

  if platform.name =~ /el-4/
    pkg.build_requires "pl-tar"
  end

  pkg.configure do
    [ "./configure --prefix=#{settings[:prefix]}" ]
  end

  pkg.build do
    [ platform[:make] ]
  end

  pkg.install do
    [ "#{platform[:make]} install" ]
  end

end

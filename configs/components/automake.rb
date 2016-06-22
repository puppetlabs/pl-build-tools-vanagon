component "automake" do |pkg, settings, platform|
  pkg.version "1.15"
  pkg.md5sum "716946a105ca228ab545fc37a70df3a3"
  pkg.url "http://ftp.gnu.org/gnu/automake/#{pkg.get_name}-#{pkg.get_version}.tar.gz"

  if platform.is_aix?
    pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/aix/#{platform.os_version}/ppc/pl-gcc-5.2.0-1.aix#{platform.os_version}.ppc.rpm"
    pkg.build_requires "http://osmirror.delivery.puppetlabs.net/AIX_MIRROR/make-3.80-1.aix5.1.ppc.rpm"
    pkg.environment "CC" => "/opt/pl-build-tools/bin/gcc"
  elsif platform.is_solaris?
    if platform.os_version == '10'
      pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-binutils-2.25.#{platform.architecture}.pkg.gz"
      pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-gcc-4.8.2.#{platform.architecture}.pkg.gz"
    elsif platform.os_version == '11'
      pkg.build_requires "pl-gcc-#{platform.architecture}"
      pkg.build_requires "pl-binutils-#{platform.architecture}"
    end
    pkg.environment "PATH" => "#{settings[:basedir]}/bin:/usr/ccs/bin:/usr/sfw/bin:$$PATH"
    pkg.build_requires "make"
  else
    pkg.build_requires "gcc"
    pkg.build_requires "make"
  end

  if platform.name =~ /el-4/
    pkg.build_requires "pl-tar"
  end

  pkg.build_requires "m4"
  pkg.build_requires "autoconf"

  pkg.configure do
    [
      "PATH=#{settings[:prefix]}/bin:$$PATH ./configure --prefix=#{settings[:prefix]}"
    ]
  end

  pkg.build do
    [
      "PATH=#{settings[:prefix]}/bin:$$PATH #{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    [
      "PATH=#{settings[:prefix]}/bin:$$PATH #{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"
    ]
  end

end
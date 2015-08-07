component "boost" do |pkg, settings, platform|
  pkg.version "1.58.0"
  pkg.md5sum "5a5d5614d9a07672e1ab2a250b5defc5"
  # Apparently boost doesn't use dots to version they use underscores....arg
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}_#{pkg.get_version.gsub('.','_')}.tar.gz"

  # This is pretty horrible.  But so is package management on OSX.
  if platform.is_osx?
    pkg.build_requires "pl-gcc-4.8.2"
    gpp = "#{settings[:bindir]}/g++"
  elsif platform.is_solaris?
    pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-gcc-4.8.2.#{platform.architecture}.pkg.gz"
    pkg.build_requires "http://pl-build-tools.delivery.puppetlabs.net/solaris/10/pl-binutils-2.25.#{platform.architecture}.pkg.gz"

    pkg.environment "PATH" => "#{settings[:basedir]}/bin:/usr/ccs/bin:/usr/sfw/bin:$$PATH"
    linkflags = "-Wl,-rpath=#{settings[:libdir]}"
    b2flags = "define=_XOPEN_SOURCE=600"
    cflags = "-std=c++11 -fPIC"
    gpp = "#{settings[:basedir]}/bin/#{settings[:platform_triple]}-g++"
  else
    pkg.build_requires "pl-gcc"
    case platform.name
    when /el|fedora/
      pkg.build_requires 'bzip2-devel'
      pkg.build_requires 'zlib-devel'
    when /sles-10|aix/
      pkg.build_requires 'bzip2'
      pkg.build_requires 'zlib-devel'
    when /sles-(11|12)/
      pkg.build_requires 'libbz2-devel'
      pkg.build_requires 'zlib-devel'
    when /debian|ubuntu|Cumulus/i
      pkg.build_requires 'libbz2-dev'
      pkg.build_requires 'zlib1g-dev'
    end


    pkg.environment "PATH" => "#{settings[:bindir]}:$$PATH"
    linkflags = "-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:libdir]}64"
    b2flags = ""
    cflags = "-fPIC"
    gpp = "#{settings[:bindir]}/g++"
  end

  if platform.is_osx?
    userconfigjam = %Q{using darwin : : #{gpp};}
  else
    userconfigjam = %Q{using gcc : 4.8.2 : #{gpp} : <linkflags>"#{linkflags}" <cflags>"#{cflags}" <cxxflags>"#{cflags}" ;}
  end

  pkg.build do
    [
      %Q{echo #{userconfigjam} > ~/user-config.jam},
      "cd tools/build",
      "./bootstrap.sh --with-toolset=gcc",
      "./b2 install -d+2 --prefix=#{settings[:prefix]} toolset=gcc --debug-configuration"
    ]
  end

  pkg.install do
    [ "#{settings[:prefix]}/bin/b2 \
    -d+2 \
    #{b2flags} \
    --debug-configuration \
    --build-dir=. \
    --prefix=#{settings[:prefix]} \
    --with-atomic \
    --with-chrono \
    --with-container \
    --with-context \
    --with-coroutine \
    --with-date_time \
    --with-exception \
    --with-filesystem \
    --with-graph \
    --with-graph_parallel \
    --with-iostreams \
    --with-locale \
    --with-log \
    --with-math \
    --with-program_options \
    --with-random \
    --with-regex \
    --with-serialization \
    --with-signals \
    --with-system \
    --with-test \
    --with-thread \
    --with-timer \
    --with-wave \
    install",
    "chmod 0644 #{settings[:includedir]}/boost/graph/vf2_sub_graph_iso.hpp",
    "chmod 0644 #{settings[:includedir]}/boost/thread/v2/shared_mutex.hpp"
    ]
  end

end

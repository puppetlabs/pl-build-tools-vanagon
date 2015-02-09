component "boost" do |pkg, settings, platform|
  pkg.version "1.55.0"
  pkg.md5sum "93780777cfbf999a600f62883bd54b17"
  # Apparently boost doesn't use dots to version they use underscores....arg
  pkg.url "http://buildsources.delivery.puppetlabs.net/#{pkg.get_name}_#{pkg.get_version.gsub('.','_')}.tar.gz"

  pkg.build_requires "pl-gcc"

  pkg.build do
    [ %Q{echo 'using gcc : 4.8.2 : #{settings[:bindir]}/g++ : <linkflags>"-Wl,-rpath=#{settings[:libdir]},-rpath=#{settings[:libdir]}64" <cflags>"-fPIC" <cxxflags>"-fPIC" ;' > tools/build/v2/user-config.jam}, "cd tools/build/v2", "PATH=#{settings[:bindir]}:$$PATH" , "./bootstrap.sh --with-toolset=gcc", "./b2 install -d+2 --prefix=#{settings[:prefix]} toolset=gcc --debug-configuration" ]
  end

  pkg.install do
    [ "#{settings[:prefix]}/bin/b2 \
    -d+2 \
    --debug-configuration \
    --build-dir=. \
    --prefix=#{settings[:prefix]} \
    --with-filesystem \
    --with-log \
    --with-program_options \
    --with-regex \
    --with-system \
    --with-thread \
    --with-locale \
    install",
    "chmod 0644 #{settings[:includedir]}/boost/graph/vf2_sub_graph_iso.hpp",
    "chmod 0644 #{settings[:includedir]}/boost/thread/v2/shared_mutex.hpp"
    ]
  end

end

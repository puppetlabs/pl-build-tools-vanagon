component 'curl' do |pkg, settings, platform|
  pkg.version '7.55.1'
  pkg.md5sum '3b832160a8c9c40075fd71191960307c'
  pkg.url "https://curl.haxx.se/download/curl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/curl-#{pkg.get_version}.tar.gz"

  make = platform[:make]
  prefix = settings[:prefix]

  if platform.is_windows?
    pkg.build_requires "pl-zlib-#{platform.architecture}"
    pkg.build_requires "pl-openssl-#{platform.architecture}"
    pkg.requires "pl-zlib-#{platform.architecture}"
    pkg.requires "pl-openssl-#{platform.architecture}"

    arch = platform.architecture == "x64" ? "64" : "32"
    pkg.environment "PATH" => "#{platform.drive_root}/tools/mingw#{arch}/bin:$$PATH"
    pkg.environment "CYGWIN" => "nodosfilewarning winsymlinks:native"
    pkg.environment "CC" => "#{platform.drive_root}/tools/mingw#{arch}/bin/gcc"
    pkg.environment "CXX" => "#{platform.drive_root}/tools/mingw#{arch}/bin/g++"

    make = "/usr/bin/make"
    prefix = platform.convert_to_windows_path(settings[:prefix])
  else
    pkg.build_requires "pl-openssl"
    pkg.requires "pl-openssl"
  end

  pkg.configure do
    ["LDFLAGS='#{settings[:ldflags]}' \
     ./configure --prefix=#{prefix} \
        --with-ssl=#{prefix} \
        --enable-threaded-resolver \
        --disable-ldap \
        --disable-ldaps \
        #{settings[:host]}"]
  end

  pkg.build do
    ["#{make} -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{make} -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end

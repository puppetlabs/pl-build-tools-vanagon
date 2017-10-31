component "openssl" do |pkg, settings, platform|
  pkg.version "1.0.2l"
  pkg.md5sum "f85123cd390e864dfbe517e7616e6566"
  pkg.url "https://openssl.org/source/openssl-#{pkg.get_version}.tar.gz"
  pkg.mirror "#{settings[:buildsources_url]}/openssl-#{pkg.get_version}.tar.gz"

  if platform.is_windows?
    pkg.apply_patch 'resources/patches/openssl/openssl-1.0.0l-use-gcc-instead-of-makedepend.patch'
    pkg.apply_patch 'resources/patches/openssl/openssl-mingw-do-not-build-applink.patch'
  end

  make = platform[:make]
  prefix = settings[:prefix]

  if platform.is_windows?
    target = platform.architecture == "x64" ? "mingw64" : "mingw"

    arch = platform.architecture == "x64" ? "64" : "32"
    pkg.environment "PATH" => "#{platform.drive_root}/tools/mingw#{arch}/bin:$$PATH"
    pkg.environment "CYGWIN" => "nodosfilewarning winsymlinks:native"
    pkg.environment "CC" => "#{platform.drive_root}/tools/mingw#{arch}/bin/gcc"
    pkg.environment "CXX" => "#{platform.drive_root}/tools/mingw#{arch}/bin/g++"

    make = "/usr/bin/make"
    pkg.environment "MAKE" => make
    prefix = platform.convert_to_windows_path(settings[:prefix])
    cflags = settings[:cflags]
    ldflags = settings[:ldflags]
  end

  pkg.configure do
    [# OpenSSL Configure doesn't honor CFLAGS or LDFLAGS as environment variables.
    # Instead, those should be passed to Configure at the end of its options, as
    # any unrecognized options are passed straight through to ${CC}. Defining
    # --libdir ensures that we avoid the multilib (lib/ vs. lib64/) problem,
    # since configure uses the existence of a lib64 directory to determine
    # if it should install its own libs into a multilib dir. Yay OpenSSL!
    "./Configure \
      --prefix=#{prefix} \
      --libdir=lib \
      --openssldir=#{prefix}/ssl \
      shared \
      no-asm \
      #{target} \
      no-camellia \
      enable-seed \
      enable-tlsext \
      enable-rfc3779 \
      enable-cms \
      no-md2 \
      no-mdc2 \
      no-rc5 \
      no-ec2m \
      no-gost \
      no-srp \
      no-ssl2 \
      no-ssl3 \
      #{cflags}"]
  end

  pkg.build do
    ["#{make} depend",
    "#{make}"]
  end

  install_prefix = "INSTALL_PREFIX=/" unless platform.is_windows?

  pkg.install do
    ["#{make} #{install_prefix} install"]
  end

  pkg.install_file "LICENSE", "#{settings[:prefix]}/share/doc/openssl-#{pkg.get_version}/LICENSE"
end

component 'rust' do |pkg, settings, platform|
  pkg.version '1.13.0'
  if platform.is_osx?
    pkg.md5sum '1cf07bc82270878bd55c7caf3784025a'
    pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-apple-darwin.tar.gz"
  elsif platform.is_windows?
    pkg.environment 'CYGWIN' => settings[:cygwin]

    if platform.architecture == 'x64'
      pkg.md5sum '145e5de69587e303cfd6d8a10a82651b'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-pc-windows-gnu.tar.gz"
    else
      pkg.md5sum 'f1ea0be6e96d7a190d7b7682b52f4d18'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-i686-pc-windows-gnu.tar.gz"
    end
  elsif platform.is_linux?
    if platform.architecture =~ /x86_64|amd64/
      pkg.md5sum '6ebf143bb4ab6cf8047335159659c263'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-unknown-linux-gnu.tar.gz"
    elsif platform.architecture == 'i386'
      pkg.md5sum '70163aa78a7bbb78873fbb9d3149aa66'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-i686-unknown-linux-gnu.tar.gz"
    end
  end

  pkg.install do
    if platform.is_windows?
      # install.sh fails when doing a final check because of $(uname -s)
      [ "./install.sh --prefix=#{settings[:prefix]} --without=rust-docs || true",
        "chmod -R 755 $$(cygpath -u #{settings[:prefix]})/lib"
      ]
    else
      [ "./install.sh --prefix=#{settings[:prefix]} --without=rust-docs" ]
    end
  end

end

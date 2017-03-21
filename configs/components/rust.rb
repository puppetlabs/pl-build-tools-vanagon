component 'rust' do |pkg, settings, platform|
  pkg.version '1.16.0'
  if platform.is_macos?
    pkg.md5sum '747267e1c774419bac2215cf1db9ccfc'
    pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-apple-darwin.tar.gz"
  elsif platform.is_windows?
    pkg.environment('CYGWIN', settings[:cygwin])

    if platform.architecture == 'x64'
      pkg.md5sum '607c17d9622e2cb52a11a36686682a4b'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-pc-windows-gnu.tar.gz"
    else
      pkg.md5sum '7f7753a268407909346735f51d85cdba'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-i686-pc-windows-gnu.tar.gz"
    end
  elsif platform.is_linux?
    if platform.architecture =~ /x86_64|amd64/
      pkg.md5sum '8b6f78dc023063c8790cf80df9b154bf'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-unknown-linux-gnu.tar.gz"
    elsif platform.architecture == 'i386'
      pkg.md5sum '24cd47aafcaf358670ffe8b7700e25ec'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-i686-unknown-linux-gnu.tar.gz"
    end
  end

  pkg.install do
    if platform.is_windows?
      # install.sh fails when doing a final check because of $(uname -s)
      [ "./install.sh --prefix=#{settings[:prefix]} --without=rust-docs || true",
        "chmod -R 755 $(cygpath -u #{settings[:prefix]})/lib"
      ]
    else
      [ "./install.sh --prefix=#{settings[:prefix]} --without=rust-docs" ]
    end
  end

end

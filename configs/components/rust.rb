component 'rust' do |pkg, settings, platform|
  pkg.version '1.15.1'
  if platform.is_macos?
    pkg.md5sum '5bb5b8bcf43cafe9e85fd7746a281ce1'
    pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-apple-darwin.tar.gz"
  elsif platform.is_windows?
    pkg.environment('CYGWIN', settings[:cygwin])

    if platform.architecture == 'x64'
      pkg.md5sum '8711e8d6672051296a186e9494444a30'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-pc-windows-gnu.tar.gz"
    else
      pkg.md5sum '0aad70fd0bdd7f6d2061ca85cdce6bd6'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-i686-pc-windows-gnu.tar.gz"
    end
  elsif platform.is_linux?
    if platform.architecture =~ /x86_64|amd64/
      pkg.md5sum '0223554f067afc96413f0c0324608bbd'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-unknown-linux-gnu.tar.gz"
    elsif platform.architecture == 'i386'
      pkg.md5sum '3a5df5c50ea1d8b47356f0336597d169'
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

component 'rust' do |pkg, settings, platform|
  pkg.version '1.18.0'
  if platform.is_macos?
    pkg.md5sum '13f9bf22bc7b1e07521b7746099b3609'
    pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-apple-darwin.tar.gz"
  elsif platform.is_windows?
    pkg.environment('CYGWIN', settings[:cygwin])

    if platform.architecture == 'x64'
      pkg.md5sum 'ad322ef324bdaab03794d1dd8d86ec09'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-pc-windows-gnu.tar.gz"
    else
      pkg.md5sum '2a75180bb0bf05b32409341f72d7ecfe'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-i686-pc-windows-gnu.tar.gz"
    end
  elsif platform.is_linux?
    if platform.architecture =~ /x86_64|amd64/
      pkg.md5sum '410920537501fd07bc508f28b04eb03d'
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-unknown-linux-gnu.tar.gz"
    elsif platform.architecture == 'i386'
      pkg.md5sum '835d68e97b7e050130b5223163fa146c'
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

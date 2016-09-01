component "rust" do |pkg, settings, platform|
  pkg.version "1.11.0"
  if platform.is_osx?
    pkg.md5sum "17f25202a374f9d78c57b8b3084f27c6"
    pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-apple-darwin.tar.gz"
  elsif platform.is_windows?
    pkg.environment "CYGWIN" => settings[:cygwin]

    if platform.architecture == "x64"
      pkg.md5sum "afe63483a978e5591291fce5ce180a31"
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-pc-windows-gnu.tar.gz"
    else
      pkg.md5sum "a89022a05f09b9270293f0c5e6ab4b0f"
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-i686-pc-windows-gnu.tar.gz"
    end
  elsif platform.is_linux?
    if platform.architecture =~ /x86_64|amd64/
      pkg.md5sum "c1108ea98745cfc8d1d659398c9bbc51"
      pkg.url "https://static.rust-lang.org/dist/rust-#{pkg.get_version}-x86_64-unknown-linux-gnu.tar.gz"
    elsif platform.architecture == "i386"
      pkg.md5sum "d000cd7ac7674bc86c0bb6815684d561"
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

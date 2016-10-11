component "tar" do |pkg, settings, platform|
  # Source-Related Metadata
  pkg.version "1.28"
  pkg.url "http://ftp.gnu.org/gnu/tar/tar-1.28.tar.gz"
  pkg.md5sum "6ea3dbea1f2b0409b234048e021a9fd7"

  # Package Depdendency Metadata

  # Build Requirements

  # Build-time Configuration
  if platform.name =~ /el-4/
    platform.tar = '/bin/tar'
  end

  # We run configure as root, which tar does not like
  pkg.environment "FORCE_UNSAFE_CONFIGURE" => "1"

  # Build Commands
  pkg.configure do
    "./configure --prefix=#{settings[:basedir]}"
  end

  pkg.build do
    "#{platform[:make]}"
  end

  pkg.install do
    [
      "#{platform[:make]} install",
      "rm -rf #{settings[:basedir]}/share/info"
    ]
  end
end

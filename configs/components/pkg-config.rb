component "pkg-config" do |pkg, settings, platform|
  pkg.version "0.28"
  pkg.url "http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz"
  pkg.md5sum "aa3c86e67551adc3ac865160e34a2a0d"

  if platform.is_solaris?
    pkg.environment "PATH" => "#{settings[:bindir]}:/usr/ccs/bin:/usr/sfw/bin:/opt/csw/bin:$$PATH"
  else
    pkg.environment "PATH" => "#{settings[:bindir]}:$$PATH"
  end

  pkg.configure do
    "./configure --prefix=#{settings[:basedir]} --with-internal-glib"
  end

  pkg.build do
    "#{platform[:make]}"
  end

  pkg.install do
    "#{platform[:make]} install"
  end
end
